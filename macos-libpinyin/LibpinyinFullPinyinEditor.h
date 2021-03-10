//
//  LibpinyinFullPinyinEditor.h
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import <Foundation/Foundation.h>

#import "LibpinyinConfig.h"
#import "LibpinyinEditor.h"
#import "LibpinyinProperties.h"


@interface LibpinyinFullPinyinEditor : NSObject<LibpinyinEditorProtocol>

- (id)initWithProperties:(LibpinyinProperties *) props andConfig:(LibpinyinConfig *) config;

@end

