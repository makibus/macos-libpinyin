//
//  LibpinyinConfig.h
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import <Foundation/Foundation.h>
#include <pinyin.h>

typedef enum {
    DISPLAY_STYLE_TRADITIONAL,
    DISPLAY_STYLE_COMPACT,
    DISPLAY_STYLE_COMPATIBILITY
} DisplayStyle;

enum CloudInputSource{
    CLOUD_INPUT_SOURCE_BAIDU,
    CLOUD_INPUT_SOURCE_GOOGLE,
    CLOUD_INPUT_SOURCE_GOOGLE_CN
};

typedef enum {
    PINYIN_PANEL_ORIENTATION_HORIZONTAL = 0,
    PINYIN_PANEL_ORIENTATION_VERTICAL   = 1,
    PINYIN_PANEL_ORIENTATION_SYSTEM     = 2,
} PinyinPanelOrientation;

@interface LibpinyinConfig : NSObject

+ (LibpinyinConfig *)sharedConfig;

- (NSString *)dictionaries;
- (NSString *)luaConverter;
- (pinyin_option_t)option;
- (NSUInteger)orientation;
- (NSUInteger)pageSize;
- (DisplayStyle)displayStyle;
- (BOOL)rememberEveryInput;
- (sort_option_t)sortOption;
- (BOOL)showSuggestion;
- (BOOL)emojiCandidate;
- (BOOL)shiftSelectCandidate;
- (BOOL)minusEqualPage;
- (BOOL)commaPeriodPage;
- (BOOL)autoCommit;
- (BOOL)doublePinyin;
- (DoublePinyinScheme)doublePinyinSchema;
- (BOOL)initChinese;
- (BOOL)initFull;
- (BOOL)initFullPunct;
- (BOOL)initSimpChinese;
- (NSInteger)selectKeys;
- (BOOL)guideKey;
- (BOOL)auxiliarySelectKeyF;
- (BOOL)auxiliarySelectKeyKP;
- (BOOL)enterKey;
- (NSString *)mainSwitch;
- (NSString *)letterSwitch;
- (NSString *)punctSwitch;
- (NSString *)bothSwitch;
- (NSString *)tradSwitch;
- (NSString *)openccConfig;
- (NSUInteger)fuzzyOption;
- (NSUInteger)correctOption;

- (void)setDictionaries:(NSString *)dict;
- (void)setLuaConverter:(NSString *)convertor;
- (void)setOption:(pinyin_option_t)option;
- (void)setOrientation:(NSUInteger)orientation;
- (void)setPageSize:(NSUInteger)size;
- (void)setDisplayStyle:(DisplayStyle)style;
- (void)setRememberEveryInput:(BOOL)rem;
- (void)setSortOption:(sort_option_t)option;
- (void)setShowSuggestion:(BOOL)b;
- (void)setEmojiCandidate:(BOOL)b;
- (void)setShiftSelectCandidate:(BOOL)b;
- (void)setMinusEqualPage:(BOOL)b;
- (void)setCommaPeriodPage:(BOOL)b;
- (void)setAutoCommit:(BOOL)b;
- (void)setDoublePinyin:(BOOL)b;
- (void)setDoublePinyinSchema:(DoublePinyinScheme)schema;
- (void)setInitChinese:(BOOL)init;
- (void)setInitFull:(BOOL)init;
- (void)setInitFullPunct:(BOOL)init;
- (void)setInitSimpChinese:(BOOL)init;
- (void)setSelectKeys:(NSInteger)key;
- (void)setGuideKey:(BOOL)key;
- (void)setAuxiliarySelectKeyF:(BOOL)key;
- (void)setAuxiliarySelectKeyKP:(BOOL)key;
- (void)setEnterKey:(BOOL)key;
- (void)setMainSwitch:(NSString *)main;
- (void)setLetterSwitch:(NSString *)letter;
- (void)setPunctSwitch:(NSString *)punc;
- (void)setBothSwitch:(NSString *)both;
- (void)setTradSwitch:(NSString *)trad;
- (void)setOpenccConfig:(NSString *)opencc;

- (void)setFuzzyOption:(NSUInteger)option;
- (void)removeFuzzyOption:(NSUInteger)option;
- (void)setCorrectOption:(NSUInteger)option;
- (void)removeCorrectOption:(NSUInteger)option;
@end
