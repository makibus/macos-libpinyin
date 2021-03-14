//
//  LibpinyinConfig.m
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import "LibpinyinConfig.h"

static LibpinyinConfig *_config = nil;

NSString *CONFIG_CORRECT_PINYIN            = @"correct-pinyin";
NSString *CONFIG_FUZZY_PINYIN              = @"fuzzy-pinyin";
NSString *CONFIG_ORIENTATION               = @"lookup-table-orientation";
NSString *CONFIG_PAGE_SIZE                 = @"lookup-table-page-size";
NSString *CONFIG_DISPLAY_STYLE             = @"display-style";
NSString *CONFIG_REMEMBER_EVERY_INPUT      = @"remember-every-input";
NSString *CONFIG_SORT_OPTION               = @"sort-candidate-option";
NSString *CONFIG_SHOW_SUGGESTION           = @"show-suggestion";
NSString *CONFIG_EMOJI_CANDIDATE           = @"emoji-candidate";
NSString *CONFIG_SHIFT_SELECT_CANDIDATE    = @"shift-select-candidate";
NSString *CONFIG_MINUS_EQUAL_PAGE          = @"minus-equal-page";
NSString *CONFIG_COMMA_PERIOD_PAGE         = @"comma-period-page";
NSString *CONFIG_AUTO_COMMIT               = @"auto-commit";
NSString *CONFIG_DOUBLE_PINYIN             = @"double-pinyin";
NSString *CONFIG_DOUBLE_PINYIN_SCHEMA      = @"double-pinyin-schema";
NSString *CONFIG_INIT_CHINESE              = @"init-chinese";
NSString *CONFIG_INIT_FULL                 = @"init-full";
NSString *CONFIG_INIT_FULL_PUNCT           = @"init-full-punct";
NSString *CONFIG_INIT_SIMP_CHINESE         = @"init-simplified-chinese";
NSString *CONFIG_DICTIONARIES              = @"dictionaries";
NSString *CONFIG_LUA_CONVERTER             = @"lua-converter";
NSString *CONFIG_OPENCC_CONFIG             = @"opencc-config";
NSString *CONFIG_BOPOMOFO_KEYBOARD_MAPPING = @"bopomofo-keyboard-mapping";
NSString *CONFIG_SELECT_KEYS               = @"select-keys";
NSString *CONFIG_GUIDE_KEY                 = @"guide-key";
NSString *CONFIG_AUXILIARY_SELECT_KEY_F    = @"auxiliary-select-key-f";
NSString *CONFIG_AUXILIARY_SELECT_KEY_KP   = @"auxiliary-select-key-kp";
NSString *CONFIG_ENTER_KEY                 = @"enter-key";
NSString *CONFIG_IMPORT_DICTIONARY         = @"import-dictionary";
NSString *CONFIG_EXPORT_DICTIONARY         = @"export-dictionary";
NSString *CONFIG_CLEAR_USER_DATA           = @"clear-user-data";
/* NSString *CONFIG_CTRL_SWITCH               = @"ctrl-switch"; */
NSString *CONFIG_MAIN_SWITCH               = @"main-switch";
NSString *CONFIG_LETTER_SWITCH             = @"letter-switch";
NSString *CONFIG_PUNCT_SWITCH              = @"punct-switch";
NSString *CONFIG_BOTH_SWITCH               = @"both-switch";
NSString *CONFIG_TRAD_SWITCH               = @"trad-switch";
NSString *CONFIG_NETWORK_DICTIONARY_START_TIMESTAMP = @"network-dictionary-start-timestamp";
NSString *CONFIG_NETWORK_DICTIONARY_END_TIMESTAMP   = @"network-dictionary-end-timestamp";
NSString *CONFIG_INIT_ENABLE_CLOUD_INPUT   = @"enable-cloud-input";
NSString *CONFIG_CLOUD_INPUT_SOURCE        = @"cloud-input-source";
NSString *CONFIG_CLOUD_CANDIDATES_NUMBER   = @"cloud-candidates-number";
NSString *CONFIG_CLOUD_REQUEST_DELAY_TIME  = @"cloud-request-delay-time";

@implementation LibpinyinConfig {
    NSUserDefaults *m_prefs;

    NSString *m_dictionaries;
    NSString *m_lua_converter;
    NSString *m_opencc_config;
    pinyin_option_t m_option;
    pinyin_option_t m_option_mask;

    NSInteger m_orientation;
    NSUInteger m_page_size;
    DisplayStyle m_display_style;
    BOOL m_remember_every_input;
    sort_option_t m_sort_option;
    BOOL m_show_suggestion;
    BOOL m_emoji_candidate;

    BOOL m_shift_select_candidate;
    BOOL m_minus_equal_page;
    BOOL m_comma_period_page;
    BOOL m_auto_commit;

    BOOL m_double_pinyin;
    DoublePinyinScheme m_double_pinyin_schema;

    BOOL m_init_chinese;
    BOOL m_init_full;
    BOOL m_init_full_punct;
    BOOL m_init_simp_chinese;

    ZhuyinScheme m_bopomofo_keyboard_mapping;
    NSInteger m_select_keys;
    BOOL m_guide_key;
    BOOL m_auxiliary_select_key_f;
    BOOL m_auxiliary_select_key_kp;

    BOOL m_enter_key;

    NSString *m_main_switch;
    NSString *m_letter_switch;
    NSString *m_punct_switch;
    NSString *m_both_switch;
    NSString *m_trad_switch;

    gint64 m_network_dictionary_start_timestamp;
    gint64 m_network_dictionary_end_timestamp;

    BOOL m_enable_cloud_input;
    enum CloudInputSource m_cloud_input_source;
    NSUInteger m_cloud_candidates_number;
    NSUInteger m_cloud_request_delay_time;
}


+ (LibpinyinConfig *)sharedConfig {
    if (_config == nil) {
        _config = [[LibpinyinConfig alloc] init];
        // The contents of the registration domain are not written to disk; you need to call this method each time your application starts.
        [_config initDefaultValue];
    }
    return _config;
}

- (id)init {
    m_prefs = [NSUserDefaults standardUserDefaults];
    return self;
}

- (void)initDefaultValue {
    // Read default from resource plist
    NSString *defaultPlist = [[NSBundle mainBundle] pathForResource:@"LibpinyinDefaultConfig" ofType:@"plist"];
    NSDictionary *defaultConfig = [NSDictionary dictionaryWithContentsOfFile:defaultPlist];
    [m_prefs registerDefaults:defaultConfig];
    NSLog(@"Default config set from %@", defaultPlist);

    m_orientation = [self readInt:CONFIG_ORIENTATION orDefault:PINYIN_PANEL_ORIENTATION_HORIZONTAL];
    m_page_size = [self readInt:CONFIG_PAGE_SIZE orDefault:5];
    m_display_style = (DisplayStyle)[self readInt:CONFIG_DISPLAY_STYLE orDefault:DISPLAY_STYLE_TRADITIONAL];
    m_remember_every_input = [self readBool:CONFIG_REMEMBER_EVERY_INPUT orDefault:NO];
    m_sort_option = (sort_option_t)[self readInt:CONFIG_SORT_OPTION orDefault:SORT_BY_PHRASE_LENGTH_AND_PINYIN_LENGTH_AND_FREQUENCY];
    m_show_suggestion = [self readBool:CONFIG_SHOW_SUGGESTION orDefault:NO];
    m_emoji_candidate = [self readBool:CONFIG_EMOJI_CANDIDATE orDefault:YES];

    m_shift_select_candidate = [self readBool:CONFIG_SHIFT_SELECT_CANDIDATE orDefault:NO];
    m_minus_equal_page = [self readBool:CONFIG_MINUS_EQUAL_PAGE orDefault:YES];
    m_comma_period_page = [self readBool:CONFIG_COMMA_PERIOD_PAGE orDefault:YES];
    m_auto_commit = [self readBool:CONFIG_AUTO_COMMIT orDefault:NO];

    m_double_pinyin = [self readBool:CONFIG_DOUBLE_PINYIN orDefault:NO];
    m_double_pinyin_schema = (DoublePinyinScheme)[self readInt:CONFIG_DOUBLE_PINYIN_SCHEMA orDefault:DOUBLE_PINYIN_DEFAULT];

    m_init_chinese = [self readBool:CONFIG_INIT_CHINESE orDefault:YES];
    m_init_full = [self readBool:CONFIG_INIT_FULL orDefault:NO];
    m_init_full_punct = [self readBool:CONFIG_INIT_FULL_PUNCT orDefault:YES];
    m_init_simp_chinese = [self readBool:CONFIG_INIT_SIMP_CHINESE orDefault:YES];

    m_dictionaries = [self readStirng:CONFIG_DICTIONARIES orDefault:@""];
    m_lua_converter = [self readStirng:CONFIG_LUA_CONVERTER orDefault:@""];
    m_opencc_config = [self readStirng:CONFIG_OPENCC_CONFIG orDefault:@"s2t.json"];

    m_main_switch = [self readStirng:CONFIG_MAIN_SWITCH orDefault:@"<Shift>"];
    m_letter_switch = [self readStirng:CONFIG_LETTER_SWITCH orDefault:@"" ];
    m_punct_switch = [self readStirng:CONFIG_PUNCT_SWITCH orDefault:@"<Control>period" ];
    m_both_switch = [self readStirng:CONFIG_BOTH_SWITCH orDefault:@"" ];
    m_trad_switch = [self readStirng:CONFIG_TRAD_SWITCH orDefault:@"<Control><Shift>f" ];

    m_network_dictionary_start_timestamp = 0;
    m_network_dictionary_end_timestamp = 0;

    m_enable_cloud_input = [self readBool:CONFIG_INIT_ENABLE_CLOUD_INPUT orDefault:NO];
    m_cloud_candidates_number = [self readInt:CONFIG_CLOUD_CANDIDATES_NUMBER orDefault:1];
    m_cloud_input_source = (enum CloudInputSource)[self readInt:CONFIG_CLOUD_INPUT_SOURCE orDefault:CLOUD_INPUT_SOURCE_BAIDU];
    m_cloud_request_delay_time = [self readInt:CONFIG_CLOUD_REQUEST_DELAY_TIME orDefault:600];
}

- (BOOL)readBool:(NSString *)name orDefault:(BOOL)value {
    return [m_prefs boolForKey:name];
}

- (NSInteger)readInt:(NSString *)name orDefault:(NSInteger )value {
    NSInteger i = [m_prefs integerForKey:name];
    if (i == 0) {
        i = value;
    }
    return i;
}

- (NSString *)readStirng:(NSString *)name orDefault:(NSString *)value {
    NSString *v = [m_prefs stringForKey:name];
    if (v == nil) {
        v = value;
    }
    return value;
}

- (BOOL)writeBool:(NSString *)name withValue:(BOOL)value {
    [m_prefs setBool:value forKey:name];
    return YES;
}

- (BOOL)writeInt:(NSString *)name withValue:(NSInteger)value {
    [m_prefs setInteger:value forKey:name];
    return YES;
}

- (BOOL)writeStirng:(NSString *)name withValue:(NSString *)value {
    [m_prefs setValue:value forKey:name];
    return YES;
}

/* Read functions */
- (NSString *)dictionaries { return m_dictionaries; }
- (NSString *)luaConverter { return m_lua_converter; }
- (pinyin_option_t)option { return m_option & m_option_mask; }
- (NSUInteger)orientation { return m_orientation; }
- (NSUInteger)pageSize { return m_page_size; }
- (DisplayStyle)displayStyle { return m_display_style; }
- (BOOL)rememberEveryInput { return m_remember_every_input; }
- (sort_option_t)sortOption { return m_sort_option; }
- (BOOL)showSuggestion { return m_show_suggestion; }
- (BOOL)emojiCandidate { return m_emoji_candidate; }
- (BOOL)shiftSelectCandidate { return m_shift_select_candidate; }
- (BOOL)minusEqualPage { return m_minus_equal_page; }
- (BOOL)commaPeriodPage { return m_comma_period_page; }
- (BOOL)autoCommit { return m_auto_commit; }
- (BOOL)doublePinyin { return m_double_pinyin; }
- (DoublePinyinScheme)doublePinyinSchema { return m_double_pinyin_schema; }
- (BOOL)initChinese { return m_init_chinese; }
- (BOOL)initFull { return m_init_full; }
- (BOOL)initFullPunct { return m_init_full_punct; }
- (BOOL)initSimpChinese { return m_init_simp_chinese; }
- (NSInteger)selectKeys { return m_select_keys; }
- (BOOL)guideKey { return m_guide_key; }
- (BOOL)auxiliarySelectKeyF { return m_auxiliary_select_key_f; }
- (BOOL)auxiliarySelectKeyKP { return m_auxiliary_select_key_kp; }
- (BOOL)enterKey { return m_enter_key; }
- (NSString *)mainSwitch { return m_main_switch; }
- (NSString *)letterSwitch { return m_letter_switch; }
- (NSString *)punctSwitch { return m_punct_switch; }
- (NSString *)bothSwitch { return m_both_switch; }
- (NSString *)tradSwitch { return m_trad_switch; }
- (NSString *)openccConfig { return m_opencc_config; }

/* Write functions */
- (void)setDictionaries:(NSString *)dict {
    [self writeStirng:CONFIG_DICTIONARIES withValue:dict];
    m_dictionaries = dict;
}
- (void)setLuaConverter:(NSString *)convertor {
    [self writeStirng:CONFIG_LUA_CONVERTER withValue:convertor];
    m_lua_converter = convertor;
}
- (void)setOption:(pinyin_option_t)option {
    // TODO
    m_option = option;
}
- (void)setOrientation:(NSUInteger)orientation {
    [self writeInt:CONFIG_ORIENTATION withValue:orientation];
    m_orientation = orientation;
}
- (void)setPageSize:(NSUInteger)size {
    [self writeInt:CONFIG_PAGE_SIZE withValue:size];
    m_page_size = size;
}
- (void)setDisplayStyle:(DisplayStyle)style {
    [self writeInt:CONFIG_DISPLAY_STYLE withValue:(NSInteger)style];
    m_display_style = style;
}
- (void)setRememberEveryInput:(BOOL)rem {
    [self writeBool:CONFIG_REMEMBER_EVERY_INPUT withValue:rem];
    m_remember_every_input = rem;
}
- (void)setSortOption:(sort_option_t)option {
    [self writeInt:CONFIG_SORT_OPTION withValue:(NSInteger)option];
    m_sort_option = option;
}
- (void)setShowSuggestion:(BOOL)b {
    [self writeBool:CONFIG_SHOW_SUGGESTION withValue:b];
    m_show_suggestion = b;
}
- (void)setEmojiCandidate:(BOOL)b {
    [self writeBool:CONFIG_EMOJI_CANDIDATE withValue:b];
    m_emoji_candidate = b;
}
- (void)setShiftSelectCandidate:(BOOL)b {
    [self writeBool:CONFIG_SHIFT_SELECT_CANDIDATE withValue:b];
    m_shift_select_candidate = b;
}
- (void)setMinusEqualPage:(BOOL)b {
    [self writeBool:CONFIG_MINUS_EQUAL_PAGE withValue:b];
    m_minus_equal_page = b;
}
- (void)setCommaPeriodPage:(BOOL)b {
    [self writeBool:CONFIG_COMMA_PERIOD_PAGE withValue:b];
    m_comma_period_page = b;
}
- (void)setAutoCommit:(BOOL)b {
    [self writeBool:CONFIG_AUTO_COMMIT withValue:b];
    m_auto_commit = b;
}
- (void)setDoublePinyin:(BOOL)b {
    [self writeBool:CONFIG_DOUBLE_PINYIN withValue:b];
    m_double_pinyin = b;
}
- (void)setDoublePinyinSchema:(DoublePinyinScheme)schema {
    [self writeInt:CONFIG_DOUBLE_PINYIN_SCHEMA withValue:(NSInteger)schema];
    m_double_pinyin_schema = schema;
}
- (void)setInitChinese:(BOOL)init {
    [self writeBool:CONFIG_INIT_CHINESE withValue:init];
    m_init_chinese = init;
}
- (void)setInitFull:(BOOL)init {
    [self writeBool:CONFIG_INIT_FULL withValue:init];
    m_init_full = init;
}
- (void)setInitFullPunct:(BOOL)init {
    [self writeBool:CONFIG_INIT_FULL_PUNCT withValue:init];
    m_init_full_punct = init;
}
- (void)setInitSimpChinese:(BOOL)init {
    [self writeBool:CONFIG_INIT_SIMP_CHINESE withValue:init];
    m_init_simp_chinese = init;
}
- (void)setSelectKeys:(NSInteger)key {
    [self writeInt:CONFIG_SELECT_KEYS withValue:key];
    m_select_keys = key;
}
- (void)setGuideKey:(BOOL)key {
    [self writeBool:CONFIG_GUIDE_KEY withValue:key];
    m_guide_key = key;
}
- (void)setAuxiliarySelectKeyF:(BOOL)key {
    [self writeBool:CONFIG_AUXILIARY_SELECT_KEY_F withValue:key];
    m_auxiliary_select_key_f = key;
}
- (void)setAuxiliarySelectKeyKP:(BOOL)key {
    [self writeBool:CONFIG_AUXILIARY_SELECT_KEY_KP withValue:key];
    m_auxiliary_select_key_kp = key;
}
- (void)setEnterKey:(BOOL)key {
    [self writeBool:CONFIG_ENTER_KEY withValue:key];
    m_enter_key = key;
}
- (void)setMainSwitch:(NSString *)main {
    [self writeStirng:CONFIG_MAIN_SWITCH withValue:main];
    m_main_switch = main;
}
- (void)setLetterSwitch:(NSString *)letter {
    [self writeStirng:CONFIG_LETTER_SWITCH withValue:letter];
    m_letter_switch = letter;
}
- (void)setPunctSwitch:(NSString *)punc {
    [self writeStirng:CONFIG_PUNCT_SWITCH withValue:punc];
    m_punct_switch = punc;
}
- (void)setBothSwitch:(NSString *)both {
    [self writeStirng:CONFIG_BOTH_SWITCH withValue:both];
    m_both_switch = both;
}
- (void)setTradSwitch:(NSString *)trad {
    [self writeStirng:CONFIG_TRAD_SWITCH withValue:trad];
    m_trad_switch = trad;
}
- (void)setOpenccConfig:(NSString *)opencc {
    [self writeStirng:CONFIG_OPENCC_CONFIG withValue:opencc];
    m_opencc_config = opencc;
}

@end
