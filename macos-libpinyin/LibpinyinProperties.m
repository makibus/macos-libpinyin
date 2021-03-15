//
//  LibpinyinProperties.m
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import "LibpinyinProperties.h"

@implementation LibpinyinProperties {
    LibpinyinConfig *m_config;

    BOOL m_mode_chinese;
    BOOL m_mode_full;
    BOOL m_mode_full_punct;
    BOOL m_mode_simp;
}

- (void)toggleModeChinese {
    m_mode_chinese = !m_mode_chinese;
}
- (void)toggleModeFull {
    m_mode_full = !m_mode_full;
}
- (void)toggleModeFullPunct {
    m_mode_full_punct = !m_mode_full_punct;
}
- (void)toggleModeSimp {
    m_mode_simp = !m_mode_simp;
}

- (void)reset {
    // TODO: get value from config
}

- (BOOL)modeChinese { return m_mode_chinese; }
- (BOOL)modeFull { return m_mode_full; }
- (BOOL)modeFullPunct { return m_mode_full_punct; }
- (BOOL)modeSimp { return m_mode_simp; }

- (id)initWithConfig:(LibpinyinConfig *)config {
    m_config = config;

    // TODO: get values from config

    return self;
}

@end
