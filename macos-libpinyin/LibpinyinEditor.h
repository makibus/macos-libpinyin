//
//  LibpinyinEditor.h
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import <Foundation/Foundation.h>

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

/* Instance */
- (pinyin_instance_t *)getPinyinInstance;
- (NSString *)getText;

@end

@protocol LookupTableProtocol <NSObject>

- (void)setPageSize:(NSUInteger)size;
- (void)setCursorPos:(NSUInteger)pos;
- (NSUInteger)pageSize;
- (NSUInteger)cursorPos;
- (NSUInteger)size;

- (void)clear;
- (void)pageUp;
- (void)pageDown;
- (void)cursorUp;
- (void)cursorDown;

@end

@interface LookupTable : NSObject<LookupTableProtocol> {
    NSUInteger m_size;
    NSUInteger m_pageSize;
    NSUInteger m_pos;
    NSUInteger m_cursor;
    NSUInteger m_pageNumber;
}
@end
