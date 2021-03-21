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


@interface LibpinyinFullPinyinEditor : NSObject<LibpinyinEditorProtocol>

- (id)initWithConfig:(LibpinyinConfig *) config;

/* Protected methods from PhoneticEditor */
- (enum SelectCandidateAction)selectCandidateInternal:(Candidate *)candidate;
- (BOOL)removeCandidateInternal:(Candidate *)candidate;
- (BOOL)selectCandidate:(NSUInteger)i;
- (BOOL)selectCandidateInPage:(NSUInteger)i;
- (void)setCursorPos:(NSUInteger)i;

@end

