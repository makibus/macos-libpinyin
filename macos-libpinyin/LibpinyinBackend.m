//
//  LibpinyinBackend.m
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import "LibpinyinBackend.h"

#import "LibpinyinConfig.h"

static id _instance;

@implementation LibpinyinBackend {
    /* libpinyin context */
    pinyin_context_t *m_pinyin_context;
}

+ (id)sharedInstance {
    if (_instance == nil) {
        _instance = [[LibpinyinBackend alloc] init];
    }
    return _instance;
}

- (id)init {
    m_pinyin_context = nil;

    return self;
}

- (pinyin_instance_t *)allocPinyinInstance {
    LibpinyinConfig *config = [LibpinyinConfig sharedConfig];
    if (nil == m_pinyin_context) {
        m_pinyin_context = [self initPinyinContext];
    }
    [self setPinyinOptions:config];
    return pinyin_alloc_instance (m_pinyin_context);
}

- (void)freePinyinInstance:(pinyin_instance_t *) instance {
    pinyin_free_instance (instance);
}

- (pinyin_context_t *)initPinyinContext {
    pinyin_context_t * context = nil;
    NSString *dataPath = [[NSBundle mainBundle] resourcePath];
    const char *dataPathNative = [dataPath UTF8String];

    // TODO: Add more dicts from config

    // Load system and user config
    // TODO: Get user dict path
    context = pinyin_init (dataPathNative, "");
    return context;
}

- (BOOL)setPinyinOptions:(LibpinyinConfig *)config {
    if (m_pinyin_context == NULL) return NO;

    DoublePinyinScheme scheme = [config doublePinyinSchema];
    pinyin_set_double_pinyin_scheme (m_pinyin_context, scheme);
    pinyin_option_t options = (pinyin_option_t)([config option] | USE_RESPLIT_TABLE | USE_DIVIDED_TABLE);
    pinyin_set_options (m_pinyin_context, options);
    return YES;
}

@end
