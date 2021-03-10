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

- (BOOL)readBool:(NSString *)name orDefault:(BOOL)value;
- (NSInteger)readInt:(NSString *)name orDefault:(NSInteger *)value;
- (NSString *)readStirng:(NSString *)name orDefault:(NSString *)value;

- (void)initDefaultValue;

- (BOOL)writeBool:(NSString *)name withValue:(BOOL)value;
- (BOOL)writeInt:(NSString *)name withValue:(NSInteger *)value;
- (BOOL)writeStirng:(NSString *)name withValue:(NSString *)value;

@end
