//
//  LibpinyinBackend.h
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import <Foundation/Foundation.h>

#include <pinyin.h>


@interface LibpinyinBackend : NSObject

+ (id)sharedInstance;

- (pinyin_instance_t *)allocPinyinInstance;
- (void)freePinyinInstance:(pinyin_instance_t *) instance;

@end

