//
//  Utils.m
//  macos-libpinyin
//
//  Created by inoki on 3/23/21.
//

#import "Utils.h"

#import <AppKit/NSEvent.h>

int filter_modifier_without_shift(int modifier) {
    return modifier & (NSEventModifierFlagCapsLock | NSEventModifierFlagControl | NSEventModifierFlagOption | NSEventModifierFlagCommand);
}
int filter_modifier(int modifier) {
    return modifier & (NSEventModifierFlagCapsLock | NSEventModifierFlagShift | NSEventModifierFlagControl | NSEventModifierFlagOption | NSEventModifierFlagCommand);
}
