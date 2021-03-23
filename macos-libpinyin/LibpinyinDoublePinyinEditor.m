//
//  LibpinyinDoublePinyinEditor.m
//  macos-libpinyin
//
//  Created by inoki on 3/23/21.
//

#import "LibpinyinDoublePinyinEditor.h"
#import "Utils.h"

/*
 * c in 'a' ... 'z' => id = c - 'a'
 * c == ';'         => id = 26
 * else             => id = -1
 */
#define ID(c) \
    ((c >= 'a' && c <= 'z') ? c - 'a' : (c == ';' ? 26 : -1))

@implementation LibpinyinDoublePinyinEditor

- (BOOL)insertCharacter:(char)ch {
    // Full
    if ([m_text length] >= MAX_PINYIN_LEN) return YES;

    int characterId = ID(ch);
    if (characterId == - 1) return NO;

    [m_text insertString:[NSString stringWithFormat:@"%c", ch] atIndex:m_cursor];
    m_cursor++;
    NSLog(@"Current pinyin: %@", m_text);

    [self updatePinyin];
    [self update];

    return YES;
}

- (BOOL)processKeyEventWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    if (keyval == ';') {
        if (filter_modifier_without_shift(modifiers) == 0) {
            if ([m_text length] == 0) return NO;
            if ([self insertCharacter:(char)keyval]) return YES;
        }
    }

    return [super processKeyEventWithKeyValue:keyval keyCode:keycode modifiers:modifiers];
}

- (void)updatePinyin {
    if ([m_text length] == 0) {
        m_pinyin_len = 0;
        m_pinyin_len = pinyin_parse_more_double_pinyins(m_instance, "");
        pinyin_guess_sentence(m_instance);
    }

    m_pinyin_len = pinyin_parse_more_double_pinyins(m_instance, [m_text UTF8String]);
    pinyin_guess_sentence(m_instance);
}

- (void)updateAuxiliaryText {
    if ([m_text length] == 0) {
        // Do nothing
        return;
    }

    char *auxText = NULL;
    pinyin_get_double_pinyin_auxiliary_text (m_instance, m_cursor, &auxText);
    NSString *text = [NSString stringWithFormat:@"%@%@", [NSString stringWithUTF8String:auxText], [m_text substringFromIndex:m_pinyin_len]];
    [m_buffer setString:text];
    NSLog(@"Aux text: %@", text);
    // Manually free it because it is derived from libpinyin
    free(auxText);
}

@end
