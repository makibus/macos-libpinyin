//
//  LibpinyinFullPinyinEditor.h
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import <Foundation/Foundation.h>

#import "LibpinyinConfig.h"
#import "LibpinyinEditor.h"
#import "LibpinyinCandidates.h"
#import "MacOSIMEPanel.h"


@interface LibpinyinFullPinyinEditor : NSObject<LibpinyinEditorProtocol>  {
    NSMutableString *m_buffer;
    NSMutableString *m_text;
    NSUInteger m_pinyin_len;

    LookupTable *m_lookupTable;

    NSMutableString *m_preeditText;
    NSMutableString *m_commitString;

    NSMutableArray *m_candidates;

    NSUInteger m_cursor;

    // Libpinyin backend instance
    pinyin_instance_t *m_instance;

    BOOL m_shouldShowLookupTable;
    BOOL m_shouldPreeditText;
    BOOL m_shouldCommitString;

    LibpinyinConfig *m_config;

    MacOSIMEPanelPayload *m_panelPayload;
}

- (id)initWithConfig:(LibpinyinConfig *) config;

/* Protected methods from PhoneticEditor */
- (enum SelectCandidateAction)selectCandidateInternal:(Candidate *)candidate;
- (BOOL)removeCandidateInternal:(Candidate *)candidate;
- (BOOL)selectCandidate:(NSUInteger)i;
- (BOOL)selectCandidateInPage:(NSUInteger)i;
- (void)setCursorPos:(NSUInteger)i;

@end

