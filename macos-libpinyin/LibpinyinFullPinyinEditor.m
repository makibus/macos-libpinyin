//
//  LibpinyinFullPinyinEditor.m
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import "LibpinyinFullPinyinEditor.h"
#import "LibpinyinConfig.h"
#import "LibpinyinBackend.h"

#include <pinyin.h>

@implementation LibpinyinFullPinyinEditor {
    NSMutableString *m_buffer;
    NSMutableString *m_text;
    NSUInteger m_pinyin_len;
    // (LookupTable)m_lookup_table;
    // (String)m_buffer;

    // Libpinyin backend instance
    pinyin_instance_t *m_instance;
}

- (id)initWithProperties:(LibpinyinProperties *) props andConfig:(LibpinyinConfig *) config {
    m_instance = [[LibpinyinBackend sharedInstance] allocPinyinInstance];
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

    char temp[2];
    temp[0] = ch;
    temp[1] = '\0';
    [m_text insertString:[NSString stringWithUTF8String:temp] atIndex:0];

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

- (NSUInteger)getLookupCursor {
    NSUInteger lookupCursor = [self getPinyinCursor];
    
    NSString *stripped = [m_text copy];

    // FIXME: stripped.find_last_not_of ("'") + 1;
    NSUInteger pos = 1;

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
        // TODO
    }

    // TODO
    /*
    if (G_UNLIKELY (m_text.empty ())) {
        if (DISPLAY_STYLE_TRADITIONAL == m_config.displayStyle () ||
            DISPLAY_STYLE_COMPATIBILITY == m_config.displayStyle ())
            hideAuxiliaryText ();
        if (DISPLAY_STYLE_COMPACT == m_config.displayStyle ())
            hidePreeditText ();
        return;
    }

    m_buffer.clear ();

    gchar * aux_text = NULL;
    pinyin_get_full_pinyin_auxiliary_text (m_instance, m_cursor, &aux_text);
    m_buffer << aux_text;
    g_free(aux_text);

    // append rest text
    const gchar * p = m_text.c_str() + m_pinyin_len;
    m_buffer << p;

    StaticText text (m_buffer);
    if (DISPLAY_STYLE_TRADITIONAL == m_config.displayStyle () ||
        DISPLAY_STYLE_COMPATIBILITY == m_config.displayStyle ())
        Editor::updateAuxiliaryText (text, TRUE);
    if (DISPLAY_STYLE_COMPACT == m_config.displayStyle ())
        Editor::updatePreeditText (text, 0, TRUE);
    */
}

// https://github.com/epico/ibus-libpinyin/blob/master/src/PYPPinyinEditor.cc

- (BOOL)processPinyinWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    // TODO: check modifier
    return [self insertCharacter:(char)keyval];
}

- (BOOL)processNumberWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    return YES;
}

- (BOOL)processPunctWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    return YES;
}

- (BOOL)processKeyEventWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    return YES;
}

- (BOOL)processSpaceWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    return YES;
}

- (BOOL)processFunctionKeyWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    return YES;
}

- (void)updatePreeditText {
    // TODO
}

- (void)updateLookupTable {
    // TODO
}

- (void)updateLookupTableFast {
    // TODO
}

- (void)commit:(const char *)str {
    // TODO
}

@end
