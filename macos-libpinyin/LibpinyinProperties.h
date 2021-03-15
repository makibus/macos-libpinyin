//
//  LibpinyinProperties.h
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import <Foundation/Foundation.h>
#import "LibpinyinConfig.h"


@interface LibpinyinProperties : NSObject

- (id)initWithConfig:(LibpinyinConfig *)config;

- (void)toggleModeChinese;
- (void)toggleModeFull;
- (void)toggleModeFullPunct;
- (void)toggleModeSimp;

- (void)reset;

@end

