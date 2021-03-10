//
//  LibpinyinConfig.m
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import "LibpinyinConfig.h"


@implementation LibpinyinConfig {
    NSString *m_schema_id;
    NSString *m_dictionaries;
    NSString *m_lua_converter;
    NSString *m_opencc_config;
    pinyin_option_t m_option;
    pinyin_option_t m_option_mask;

    gint m_orientation;
    guint m_page_size;
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
    gint m_select_keys;
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
    guint m_cloud_candidates_number;
    guint m_cloud_request_delay_time;
}



- (void)initDefaultValue {
    m_orientation = PINYIN_PANEL_ORIENTATION_HORIZONTAL;
    m_page_size = 5;
    m_display_style = DISPLAY_STYLE_TRADITIONAL;
    m_remember_every_input = FALSE;
    m_sort_option = SORT_BY_PHRASE_LENGTH_AND_PINYIN_LENGTH_AND_FREQUENCY;
    m_show_suggestion = FALSE;
    m_emoji_candidate = TRUE;

    m_shift_select_candidate = FALSE;
    m_minus_equal_page = TRUE;
    m_comma_period_page = TRUE;
    m_auto_commit = FALSE;

    m_double_pinyin = FALSE;
    m_double_pinyin_schema = DOUBLE_PINYIN_DEFAULT;

    m_init_chinese = TRUE;
    m_init_full = FALSE;
    m_init_full_punct = TRUE;
    m_init_simp_chinese = TRUE;

    m_dictionaries = @"";
    m_lua_converter = @"";
    m_opencc_config = @"s2t.json";

    m_main_switch = @"<Shift>";
    m_letter_switch = @"";
    m_punct_switch = @"<Control>period";
    m_both_switch = @"";
    m_trad_switch = @"<Control><Shift>f";

    m_network_dictionary_start_timestamp = 0;
    m_network_dictionary_end_timestamp = 0;

    m_enable_cloud_input = FALSE;
    m_cloud_candidates_number = 1;
    m_cloud_input_source = CLOUD_INPUT_SOURCE_BAIDU;
    m_cloud_request_delay_time = 600;
}

- (BOOL)readBool:(NSString *)name orDefault:(BOOL)value {
    return YES;
}

- (NSInteger)readInt:(NSString *)name orDefault:(NSInteger *)value {
    return 0;
}

- (NSString *)readStirng:(NSString *)name orDefault:(NSString *)value {
    return @"";
}

- (BOOL)writeBool:(NSString *)name withValue:(BOOL)value {
    return YES;
}

- (BOOL)writeInt:(NSString *)name withValue:(NSInteger *)value {
    return YES;
}

- (BOOL)writeStirng:(NSString *)name withValue:(NSString *)value {
    return YES;
}

@end
