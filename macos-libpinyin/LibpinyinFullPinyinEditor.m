//
//  LibpinyinFullPinyinEditor.m
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import "LibpinyinFullPinyinEditor.h"
#import "LibpinyinConfig.h"
#import "LibpinyinBackend.h"
#import "AppDelegate.h"
#import "Utils.h"

#include <pinyin.h>

#import <InputMethodKit/InputMethodKit.h>
#import <AppKit/NSEvent.h>
#import <Carbon/Carbon.h>

@interface LookupTable : NSObject<LookupTableProtocol> {
    NSUInteger m_size;
    NSUInteger m_pageSize;
    NSUInteger m_pos;
    NSUInteger m_cursor;
    NSUInteger m_pageNumber;
}
@end

@implementation LookupTable

- (id)initWithPageSize:(NSUInteger)size {
    m_pageSize = size;
    m_pos = 0;

    return self;
}

- (void)clear {
    m_size = 0;
    m_pos = 0;
}

- (void)setPageSize:(NSUInteger)size {
    m_pageSize = size;
}

- (void)setCursorPos:(NSUInteger)pos {
    m_pos = pos;
}

- (NSUInteger)pageSize {
    return m_pageSize;
}

- (NSUInteger)cursorPos {
    return m_pos;
}

- (NSUInteger)size {
    return m_size;
}

- (void)pageUp {
    if (m_pos >= m_pageSize) {
        m_pos -= m_pageSize;
    }
    if (m_pos >= m_size) {
        // Normalize position
        m_pos = MAX(m_size, 1) - 1;
    }
}

- (void)pageDown {
    if (m_pos < m_size) {
        m_pos += m_pageSize;
    }
}

- (void)cursorUp {
    if (m_pos >= m_pageSize) {
        m_pos -= 1;
    }
    if (m_pos >= m_size) {
        // Normalize position
        m_pos = MAX(m_size, 1) - 1;
    }
}

- (void)cursorDown {
    if (m_pos < m_size) {
        m_pos += 1;
    }
}

- (void)setSize:(NSUInteger) size {
    m_size = size;
}

@end

@implementation LibpinyinFullPinyinEditor {
    NSMutableString *m_buffer;
    NSMutableString *m_text;
    NSUInteger m_pinyin_len;

    LookupTable *m_lookupTable;

    NSMutableString *m_preeditText;
    NSMutableString *m_commitString;

    NSMutableArray *m_candidates;

    NSUInteger m_cursor;

    // Libpinyin backend instance
    pinyin_instance_t *m_instance;

    BOOL m_shouldShowLookupTable;
    BOOL m_shouldPreeditText;
    BOOL m_shouldCommitString;

    LibpinyinConfig *m_config;

    MacOSIMEPanelPayload *m_panelPayload;

    /* Candidates */
    LibpinyinCandidates *m_libpinyinCandidates;
}

- (id)initWithConfig:(LibpinyinConfig *) config {
    m_config = config;

    m_instance = [[LibpinyinBackend sharedInstance] allocPinyinInstance];
    m_text = [[NSMutableString alloc] init];
    m_buffer = [[NSMutableString alloc] init];
    m_candidates = [[NSMutableArray alloc] init];
    m_preeditText = [[NSMutableString alloc] init];
    m_commitString = [[NSMutableString alloc] init];
    m_shouldShowLookupTable = NO;
    m_shouldPreeditText = NO;
    m_shouldCommitString = NO;

    m_lookupTable = [[LookupTable alloc] initWithPageSize:[m_config pageSize]];

    m_panelPayload = [[MacOSIMEPanelPayload alloc] init];

    m_libpinyinCandidates = [[LibpinyinCandidates alloc] init];

    return self;
}

- (void)dealloc {
    if (m_instance != nil) {
        [[LibpinyinBackend sharedInstance] freePinyinInstance: m_instance];
        m_instance = nil;
    }
}

- (BOOL)insertCharacter:(char)ch {
    // Full
    if ([m_text length] >= MAX_PINYIN_LEN) return YES;

    // i/u/v mode
    if ([m_text length] == 0 && (ch == 'i' || ch == 'u' || ch == 'v')) return FALSE;

    [m_text insertString:[NSString stringWithFormat:@"%c", ch] atIndex:m_cursor];
    m_cursor++;
    NSLog(@"Current pinyin: %@", m_text);

    [self updatePinyin];
    [self update];

    return YES;
}

- (void)updatePinyin {
    if ([m_text length] == 0) {
        m_pinyin_len = 0;
        m_pinyin_len = pinyin_parse_more_full_pinyins(m_instance, "");
        pinyin_guess_sentence(m_instance);
    }

    m_pinyin_len = pinyin_parse_more_full_pinyins(m_instance, [m_text UTF8String]);
    pinyin_guess_sentence(m_instance);
}

- (void)update {
    // Get the position of cursor
    NSUInteger lookupCursor = [self getLookupCursor];
    pinyin_guess_candidates (m_instance, lookupCursor, [m_config sortOption]);

    [self updateLookupTable];
    [self updatePreeditText];
    [self updateAuxiliaryText];
}

- (void)updateLookupTable {
    [m_lookupTable clear];
    [m_candidates removeAllObjects];
    [self updateCandidates];
    [self fillLookupTable];

    // Check the size of lookup table
    if ([m_candidates count] >= 0) {
        [self showLookupTable];
    } else {
        [self hideLookupTable];
    }
}

- (BOOL)updateCandidates {
    // Update libpinyin candidates
    [m_libpinyinCandidates processCandidates:m_candidates inEditor:self];

    return YES;
}

- (BOOL)fillLookupTable {
    [m_lookupTable setSize:[m_candidates count]];
    return YES;
}

- (NSUInteger)getLookupCursor {
    NSUInteger lookupCursor = [self getPinyinCursor];

    NSString *stripped = [m_text copy];

    NSArray *pinyinSections = [stripped componentsSeparatedByString:@"'"];
    NSUInteger pos = 0;
    if ([pinyinSections count] > 0) {
        pos = [pinyinSections[0] length] + 1;
    }

    if (pos < [stripped length]) {
        stripped = [stripped substringWithRange:NSMakeRange(0, pos)];
    }

    if (lookupCursor == [stripped length]) {
        lookupCursor = 0;
    }

    return lookupCursor;
}

- (void)updateAuxiliaryText {
    if ([m_text length] == 0) {
        // Do nothing
        return;
    }

    char *auxText = NULL;
    pinyin_get_full_pinyin_auxiliary_text (m_instance, m_cursor, &auxText);
    NSString *text = [NSString stringWithFormat:@"%@%@", [NSString stringWithUTF8String:auxText], [m_text substringFromIndex:m_pinyin_len]];
    [m_buffer setString:text];
    NSLog(@"Aux text: %@", text);
    // Manually free it because it is derived from libpinyin
    free(auxText);
}

- (BOOL)processPinyinWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    // Check modifier
    if (filter_modifier_without_shift(modifiers)) {
        return [m_text length] ? YES : NO;
    }

    return [self insertCharacter:(char)keyval];
}

- (BOOL)processNumberWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    if ([m_text length] == 0) return NO;

    NSUInteger i = 0;
    switch (keyval) {
        case '0' ... '9':
            i = (keyval >= '1' ? keyval - '1' : 9);
            break;
        default:
            break;
    }

    if (modifiers == 0) {
        // Select candidate in page
        [self selectCandidateInPage:i];
    }

    [self update];
    return YES;
}

- (BOOL)processPunctWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    if ([m_text length] == 0) return NO;
    if (filter_modifier_without_shift(modifiers)) return YES;

    switch (keyval) {
        case 0x27:
            // Apostrophe: insert
            return [self insertCharacter:(char)keyval];
        case 0x2c:
            // Comma
            if ([m_config commaPeriodPage]) {
                [self pageUp];
            }
            break;
        case 0x2d:
            // Minus
            if ([m_config minusEqualPage]) {
                [self pageUp];
            }
            break;
        case 0x2e:
            // Period
            if ([m_config commaPeriodPage]) {
                [self pageDown];
            }
            break;
        case 0x3d:
            // Equal
            if ([m_config commaPeriodPage]) {
                [self pageDown];
            }
            break;
        default:
            break;
    }

    // Auto commit before punction
    if ([m_config autoCommit]) {
        if ([m_lookupTable size]) {
            [self selectCandidate:[m_lookupTable cursorPos]];
        }
        [self commitEmpty];
        return NO;
    }

    return NO;
}

- (BOOL)processKeyEventWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    // Dispatch event with different type
    BOOL ret;
    switch (keyval) {
        case 'a' ... 'z':
            ret = [self processPinyinWithKeyValue:keyval keyCode:keycode modifiers:modifiers];
            break;
        case '0' ... '9':
            ret = [self processNumberWithKeyValue:keyval keyCode:keycode modifiers:modifiers];
            break;
        case ' ':
            ret = [self processSpaceWithKeyValue:keyval keyCode:keycode modifiers:modifiers];
            break;
        case 0x21 ... 0x2f:
        case 0x3a ... 0x40:
        case 0x5b ... 0x60:
        case 0x7b ... 0x7e:
            ret = [self processPunctWithKeyValue:keyval keyCode:keycode modifiers:modifiers];
            break;
        default:
            ret = [self processFunctionKeyWithKeyValue:keyval keyCode:keycode modifiers:modifiers];
            break;
    }

    return ret;
}

- (BOOL)processSpaceWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    if ([m_text length] == 0) {
        // Do nothing
        return NO;
    }

    // Detect modifiers
    if (filter_modifier_without_shift(modifiers)) return YES;

    if ([m_candidates count] != 0) {
        // Commit the current candidate
        [self selectCandidate:[m_lookupTable cursorPos]];
        [self update];
    } else {
        // Commit the raw input
        [self commit:m_text];
    }

    return YES;
}

- (BOOL)processFunctionKeyWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    if ([m_text length] == 0) return NO;

    // Check modifiers
    modifiers = filter_modifier_without_shift(modifiers);
    if (modifiers != 0 && modifiers != NSEventModifierFlagCommand && modifiers != NSEventModifierFlagControl) {
        // Need command OR control
        return YES;
    }

    if (modifiers == 0) {
        switch (keycode) {
            case kVK_Return:
                // Enter: commit raw input
                if ([m_text length] > 0) {
                    [self commit:m_text];
                    return YES;
                }
                // Not yet input, let the OS deal with it
                return NO;
            case kVK_Delete:
                // Backspace: remove the char before
                // Return a false if no character, let the OS deal with the event
                return [self removeCharBefore];
            case kVK_ForwardDelete:
                // Delete: remove the char after
                return [self removeCharAfter];
            case kVK_UpArrow:
                [self cursorUp];
                return YES;
            case kVK_DownArrow:
                [self cursorDown];
                return YES;
            case kVK_LeftArrow:
                [self moveCursorLeft];
                return YES;
            case kVK_RightArrow:
                [self moveCursorRight];
                return YES;
            case kVK_PageUp:
                if ([m_candidates count] > 0) {
                    [self pageUp];
                    return YES;
                }
                // Not yet candidate, let the OS deal with it
                return NO;
            case kVK_PageDown:
                if ([m_candidates count] > 0) {
                    [self pageDown];
                    return YES;
                }
                // Not yet candidate, let the OS deal with it
                return NO;
            case kVK_Escape:
                [self reset];
                return YES;
            default:
                return YES;
        }
    } else if ((modifiers & NSEventModifierFlagControl) || (modifiers & NSEventModifierFlagCommand)) {
        // Ctrl key is pressed
        switch (keyval) {
            case kVK_Delete:
                // Backspace: remove the word before
                [self removeWordBefore];
                return YES;
            case kVK_ForwardDelete:
                // Delete: remove the word after
                [self removeWordAfter];
                return YES;
            case kVK_LeftArrow:
                // Left: move left by word
                [self moveCursorLeftByWord];
                return YES;
            case kVK_RightArrow:
                // Left: move right by word
                [self moveCursorRightByWord];
                return YES;
            default:
                return YES;
        }
    }
    return YES;
}

- (void)updatePreeditText {
    guint num = 0;
    pinyin_get_n_candidate (m_instance, &num);
    /* preedit text = guessed sentence + un-parsed pinyin text */
    if ([m_text length] == 0 || 0 == num) {
        m_shouldPreeditText = NO;
        return;
    }

    /* probe nbest match candidate */
    lookup_candidate_type_t type;
    lookup_candidate_t * candidate = NULL;
    pinyin_get_candidate (m_instance, 0, &candidate);
    pinyin_get_candidate_type (m_instance, candidate, &type);

    if (NBEST_MATCH_CANDIDATE == type) {
        gchar * sentence = NULL;
        pinyin_get_sentence (m_instance, 0, &sentence);
        if (sentence != NULL) {
            NSString *text = [NSString stringWithFormat:@"%@%@", [NSString stringWithUTF8String:sentence], [m_text substringFromIndex:m_pinyin_len]];
            NSLog(@"Preedit text: %@", text);
            [m_preeditText setString:text];
            free(sentence);
            m_shouldPreeditText = YES;
            return;
        }
    }

    m_shouldPreeditText = NO;
}

- (void)updateLookupTableFast {
    // TODO
}

- (void)commit:(NSString *)str {
    [m_commitString setString:str];
    m_shouldCommitString = YES;
}

- (void)refresh:(id)client underController:(MacOSLibpinyinController *)controller {
    if ([m_buffer length] > 0) {
        // Show auxiliray text
        [m_panelPayload setAuxiliaryText:m_buffer];
    }

    if ([m_commitString length] > 0 && m_shouldCommitString) {
        m_shouldCommitString = NO;
        [client insertText:m_commitString replacementRange:NSMakeRange(NSNotFound, NSNotFound)];
        [[AppDelegate getDelegate].panel hide];
        [m_commitString setString:@""];
        [self reset];
        return;
    }

    if ([m_preeditText length] > 0 && m_shouldPreeditText) {
        NSDictionary *preeditAttrs = [controller markForStyle:kTSMHiliteSelectedRawText atRange:NSMakeRange(0, [m_preeditText length])];
        NSAttributedString *preeditAttrString = [[NSAttributedString alloc] initWithString:m_preeditText attributes:preeditAttrs];
        [client setMarkedText:preeditAttrString
                selectionRange:NSMakeRange([m_preeditText length], 0)
                replacementRange:NSMakeRange(NSNotFound, NSNotFound)];
        [m_panelPayload setPreeditText:m_preeditText];
    } else {
        NSDictionary *pinyinAttrs = [controller markForStyle:kTSMHiliteSelectedRawText atRange:NSMakeRange(0, [m_text length])];
        NSAttributedString *pinyinAttrString = [[NSAttributedString alloc] initWithString:m_text attributes:pinyinAttrs];
        [client setMarkedText:pinyinAttrString
                selectionRange:NSMakeRange([m_text length], 0)
                replacementRange:NSMakeRange(NSNotFound, NSNotFound)];
    }

    if ([m_candidates count] > 0 && m_shouldShowLookupTable) {
        NSMutableArray *candidates = [[NSMutableArray alloc] init];
        NSRect cursorRect;
        NSUInteger pos = [m_lookupTable cursorPos];
        NSUInteger pageSize = [m_lookupTable pageSize];
        NSUInteger candidateFrom = pos / pageSize * pageSize;
        NSUInteger pageLength = MIN([m_lookupTable size] - candidateFrom, pageSize);
        [client attributesForCharacterIndex:0 lineHeightRectangle:&cursorRect];
        NSArray *candidatesToDisplay = [m_candidates subarrayWithRange:NSMakeRange(candidateFrom, pageLength)];
        for (NSUInteger i = 0; i < [candidatesToDisplay count]; i++) {
            [candidates addObject:[candidatesToDisplay[i] string]];
        }
        [m_panelPayload setCandidates:candidates];
        [m_panelPayload setHighlightIndex:pos % pageSize];
        [m_panelPayload setCursor:cursorRect];
        [[AppDelegate getDelegate].panel update:m_panelPayload];
    } else {
        [[AppDelegate getDelegate].panel hide];
    }
}

- (NSUInteger)getPinyinCursor {
    // Translate cursor position to pinyin position.
    size_t pinyin_cursor = 0;
    pinyin_get_pinyin_offset (m_instance, m_cursor, &pinyin_cursor);

    return pinyin_cursor;
}

- (BOOL)removeCharBefore {
    if (m_cursor == 0) return NO;

    m_cursor--;
    [m_text deleteCharactersInRange:NSMakeRange(m_cursor, 1)];

    [self updatePinyin];
    [self update];
    return YES;
}

- (BOOL)removeCharAfter {
    if (m_cursor == [m_text length]) return NO;

    [m_text deleteCharactersInRange:NSMakeRange(m_cursor, 1)];

    [self updatePinyin];
    [self update];
    return YES;
}

- (void)commitEmpty {
    m_shouldCommitString = YES;
}

- (NSUInteger)getCursorLeftByWord {
    size_t offset = 0;
    pinyin_get_pinyin_offset (m_instance, m_cursor, &offset);
    size_t cursor = 0;
    pinyin_get_left_pinyin_offset(m_instance, offset, &cursor);
    return cursor;
}

- (NSUInteger)getCursorRightByWord {
    size_t offset = 0;
    pinyin_get_pinyin_offset (m_instance, m_cursor, &offset);
    size_t cursor = 0;
    pinyin_get_right_pinyin_offset(m_instance, offset, &cursor);
    return cursor;
}

- (BOOL)moveCursorLeft {
    if (m_cursor == 0) return NO;
    m_cursor -= 1;
    [self update];
    return YES;
}

- (BOOL)moveCursorLeftByWord {
    if (m_cursor == 0) return NO;
    m_cursor = [self getCursorLeftByWord];
    [self update];
    return YES;
}

- (BOOL)moveCursorRight {
    if (m_cursor == [m_text length]) return NO;
    m_cursor += 1;
    [self update];
    return YES;
}

- (BOOL)moveCursorRightByWord {
    if (m_cursor == [m_text length]) return NO;
    m_cursor = [self getCursorRightByWord];
    [self update];
    return YES;
}

- (BOOL)moveCursorToBegin {
    if (m_cursor == 0) return NO;
    m_cursor = 0;
    [self update];
    return YES;
}

- (BOOL)moveCursorToEnd {
    if (m_cursor == [m_text length]) return NO;
    m_cursor = [m_text length];
    [self update];
    return YES;
}

- (BOOL)removeCandidateInternal:(Candidate *)candidate {
    // TODO
    return NO;
}

- (BOOL)removeWordAfter {
    if (m_cursor == [m_text length]) return NO;

    NSUInteger newCursor = [self getCursorRightByWord];
    [m_text deleteCharactersInRange:NSMakeRange(m_cursor, newCursor - m_cursor)];

    [self updatePinyin];
    [self update];
    return YES;
}

- (BOOL)removeWordBefore {
    if (m_cursor == 0) return NO;

    NSUInteger newCursor = [self getCursorLeftByWord];
    [m_text deleteCharactersInRange:NSMakeRange(newCursor, m_cursor - newCursor)];

    [self updatePinyin];
    [self update];
    return YES;
}

- (BOOL)selectCandidate:(NSUInteger)i {
    if (i >= [m_candidates count]) {
        return NO;
    }

    // Update to check the rest of pinyin
    Candidate *candidate = [m_candidates objectAtIndex:i];

    enum SelectCandidateAction action = [self selectCandidateInternal:candidate];

    if (action & SELECT_CANDIDATE_COMMIT) {
        [self commit:[candidate string]];
    }

    if (action & SELECT_CANDIDATE_UPDATE) {
        [self update];
    }

    return YES;
}

- (BOOL)selectCandidateInPage:(NSUInteger)i {
    NSUInteger pageSize = [m_lookupTable pageSize];
    NSUInteger pos = [m_lookupTable cursorPos];
    if (i >= pageSize) {
        return NO;
    }
    i += (pos / pageSize) * pageSize;   // Offset some pages
    return [self selectCandidate:i];
}

- (enum SelectCandidateAction)selectCandidateInternal:(Candidate *)candidate {
    switch ([candidate candidateType]) {
        case CANDIDATE_NBEST_MATCH:
        case CANDIDATE_NORMAL:
        case CANDIDATE_USER:
            return [m_libpinyinCandidates selectCandidate:candidate inEditor:self];
        default:
            break;
    }
    return SELECT_CANDIDATE_ALREADY_HANDLED;
}

- (void)showLookupTable {
    m_shouldShowLookupTable = YES;
}

- (void)hideLookupTable {
    m_shouldShowLookupTable = NO;
}

- (void)reset {
    m_pinyin_len = 0;
    m_cursor = 0;
    [m_text setString:@""];
    [m_preeditText setString:@""];
    [m_buffer setString:@""];
    [m_candidates removeAllObjects];
    [m_lookupTable clear];
    
    m_shouldPreeditText = NO;
    m_shouldCommitString = NO;
    m_shouldShowLookupTable = NO;
    
    pinyin_reset (m_instance);
}

- (void)candidateClickedAt:(int)index withButton:(int)button andState:(int)state {
    // TODO
}

- (void)cursorDown {
    [m_lookupTable cursorDown];
}

- (void)cursorUp {
    [m_lookupTable cursorUp];
}

- (void)pageDown {
    [m_lookupTable pageDown];
}

- (void)pageUp {
    [m_lookupTable pageUp];
}

- (pinyin_instance_t *)getPinyinInstance {
    return m_instance;
}

- (NSString *)getText {
    return m_text;
}

- (void)setCursorPos:(NSUInteger)i {
    if (i > [m_text length]) i = [m_text length];
    m_cursor = i;
}

@end
