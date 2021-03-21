//
//  Candidates.h
//  macos-libpinyin
//
//  Created by inoki on 3/21/21.
//

#ifndef Candidates_h
#define Candidates_h

#import "LibpinyinEditor.h"

enum CandidateType {
    CANDIDATE_INVALID = 0,
    CANDIDATE_NBEST_MATCH,
    /* not included with user candidate */
    CANDIDATE_NORMAL,
    /* both normal candidate and user candidate */
    CANDIDATE_USER,
    CANDIDATE_TRADITIONAL_CHINESE,
    CANDIDATE_LUA_TRIGGER,
    CANDIDATE_LUA_CONVERTER,
    CANDIDATE_SUGGESTION,
    CANDIDATE_CLOUD_INPUT,
    CANDIDATE_EMOJI
};

enum SelectCandidateAction {
    SELECT_CANDIDATE_ALREADY_HANDLED = 0x0,
    /* commit the text without change. */
    SELECT_CANDIDATE_COMMIT = 0x1,
    /* modify the current candidate in place */
    SELECT_CANDIDATE_MODIFY_IN_PLACE = 0x2,
    /* need to call update method in class Editor. */
    SELECT_CANDIDATE_UPDATE = 0x4
};


@interface Candidate : NSObject

@property (nonatomic) enum CandidateType candidateType;
@property (nonatomic) NSUInteger candidateId;
@property (nonatomic) NSString *string;

@end


@protocol Candidates <NSObject>

- (BOOL)processCandidates:(NSMutableArray *)candidates inEditor:(id)editor;
- (enum SelectCandidateAction)selectCandidate:(Candidate *)candidate inEditor:(id)editor;
- (BOOL)removeCandidate:(Candidate *)candidate inEditor:(id)editor;

@end

#endif /* Candidates_h */
