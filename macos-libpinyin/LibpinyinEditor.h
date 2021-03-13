//
//  LibpinyinEditor.h
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import <Foundation/Foundation.h>

#import "LibpinyinProperties.h"
#import "LibpinyinConfig.h"
#import "MacOSLibpinyinController.h"


@protocol EditorProtocol <NSObject>

- (BOOL)processKeyEventWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers;
- (void)pageUp;
- (void)pageDown;
- (void)cursorUp;
- (void)cursorDown;
- (void)update;
- (void)reset;
- (void)candidateClickedAt: (int)index withButton:(int) button andState:(int)state;

- (void)refresh:(id)client underController:(MacOSLibpinyinController *)conrtoller;

@end

#define MAX_PINYIN_LEN 64

@protocol LibpinyinEditorProtocol <EditorProtocol>

/* Public methods from PhoneticEditor */
- (BOOL)processSpaceWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers;
- (BOOL)processFunctionKeyWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers;
- (void)updateLookupTable;
- (void)updateLookupTableFast;
- (BOOL)updateCandidates;
- (BOOL)fillLookupTable;
- (void)commit:(NSString *)str;

/* Protected methods from PhoneticEditor */
- (int)selectCandidateInternal; // (EnhancedCandidate & candidate);
- (BOOL)removeCandidateInternal; // (EnhancedCandidate & candidate);
- (BOOL)selectCandidate:(NSUInteger) i;
- (BOOL)selectCandidateInPage:(NSUInteger) i;

- (void)commitEmpty;

- (NSUInteger)getPinyinCursor;
- (NSUInteger)getLookupCursor;

- (BOOL)insertCharacter:(char)ch;
- (BOOL)removeCharBefore;
- (BOOL)removeCharAfter;
- (BOOL)removeWordBefore;
- (BOOL)removeWordAfter;
- (BOOL)moveCursorLeft;
- (BOOL)moveCursorRight;
- (BOOL)moveCursorLeftByWord;
- (BOOL)moveCursorRightByWord;
- (BOOL)moveCursorToBegin;
- (BOOL)moveCursorToEnd;
- (void)updateAuxiliaryText;
- (void)updatePreeditText;
- (void)updatePinyin;

- (NSUInteger)getCursorLeftByWord;
- (NSUInteger)getCursorRightByWord;

/* Methods from PinyinEditor */
- (BOOL)processPinyinWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers;
- (BOOL)processNumberWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers;
- (BOOL)processPunctWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers;

@end
