//
//  LibpinyinCandidates.m
//  macos-libpinyin
//
//  Created by inoki on 3/21/21.
//

#import "LibpinyinCandidates.h"
#import "LibpinyinBackend.h"

@implementation LibpinyinCandidates

- (BOOL)processCandidates:(NSMutableArray *)candidates inEditor:(id)editor {
    pinyin_instance_t *instance = [editor getPinyinInstance];
    guint len = 0;
    pinyin_get_n_candidate (instance, &len);

    for (guint i = 0; i < len; i++) {
        lookup_candidate_t * candidate = NULL;
        pinyin_get_candidate (instance, i, &candidate);

        lookup_candidate_type_t type;
        pinyin_get_candidate_type (instance, candidate, &type);

        const gchar * phrase_string = NULL;
        pinyin_get_candidate_string (instance, candidate, &phrase_string);

        Candidate *enhanced = [[Candidate alloc] init];

        switch (type) {
            case NBEST_MATCH_CANDIDATE:
                [enhanced setCandidateType:CANDIDATE_NBEST_MATCH];
                break;

            case NORMAL_CANDIDATE:
            case ADDON_CANDIDATE:
                [enhanced setCandidateType:CANDIDATE_NORMAL];
                if (pinyin_is_user_candidate (instance, candidate))
                    [enhanced setCandidateType:CANDIDATE_USER];
                break;
            default:
                break;
        }

        [enhanced setCandidateId:i];
        [enhanced setString:[NSString stringWithUTF8String:phrase_string]];

        [candidates addObject:enhanced];
    }

    return YES;
}

- (BOOL)removeCandidate:(Candidate *)enhanced inEditor:(id)editor {
    pinyin_instance_t * instance = [editor getPinyinInstance];

    if ([enhanced candidateType] != CANDIDATE_USER)
        return NO;

    lookup_candidate_t * candidate = NULL;
    guint index = (guint)[enhanced candidateId];
    pinyin_get_candidate (instance, index, &candidate);
    if (pinyin_is_user_candidate (instance, candidate)) {
        pinyin_remove_user_candidate (instance, candidate);
    }

    return YES;
}

- (enum SelectCandidateAction)selectCandidate:(Candidate *)enhanced inEditor:(id)editor {
    pinyin_instance_t * instance = [editor getPinyinInstance];
    if (CANDIDATE_NBEST_MATCH == [enhanced candidateType] ||
            CANDIDATE_NORMAL == [enhanced candidateType] ||
        CANDIDATE_USER == [enhanced candidateType]) {
        return SELECT_CANDIDATE_ALREADY_HANDLED;
    }

    guint len = 0;
    pinyin_get_n_candidate (instance, &len);

    if ([enhanced candidateId] >= len)
        return SELECT_CANDIDATE_ALREADY_HANDLED;

    guint lookup_cursor = (guint)[editor getLookupCursor];

    lookup_candidate_t * candidate = NULL;
    pinyin_get_candidate (instance, (guint)[enhanced candidateId], &candidate);

    gchar * str = NULL;
    if (CANDIDATE_NBEST_MATCH == [enhanced candidateType]) {
        /* because nbest match candidate
           starts from the beginning of user input. */
        pinyin_choose_candidate (instance, 0, candidate);

        guint8 index = 0;
        pinyin_get_candidate_nbest_index(instance, candidate, &index);

        if (index != 0)
            pinyin_train (instance, index);

        pinyin_get_sentence (instance, index, &str);
        // TODO: use config to determine
//        if (m_editor->m_config.rememberEveryInput ())
//            LibPinyinBackEnd::instance ().rememberUserInput (instance, str);
        // [[LibpinyinBackend sharedInstance] modified];
        free (str);

        return SELECT_CANDIDATE_COMMIT;
    }

    lookup_cursor = pinyin_choose_candidate
        (instance, lookup_cursor, candidate);

    pinyin_guess_sentence (instance);

    if (lookup_cursor == [[editor getText] length]) {
        pinyin_get_sentence (instance, 0, &str);
        [enhanced setString:[NSString stringWithUTF8String:str]];
        pinyin_train (instance, 0);

        // TODO: use config to determine
//        if (m_editor->m_config.rememberEveryInput ())
//            LibPinyinBackEnd::instance ().rememberUserInput (instance, str);
        // [[LibpinyinBackend sharedInstance] modified];
        free (str);

        return SELECT_CANDIDATE_MODIFY_IN_PLACE | SELECT_CANDIDATE_COMMIT;
    }

    PinyinKeyPos *pos = NULL;
    pinyin_get_pinyin_key_rest (instance, lookup_cursor, &pos);

    guint16 begin = 0;
    pinyin_get_pinyin_key_rest_positions (instance, pos, &begin, NULL);
    [editor setCursorPos:(NSUInteger)begin];

    return SELECT_CANDIDATE_UPDATE;
}

@end
