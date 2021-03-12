//
//  main.m
//  macos-libpinyin
//
//  Created by inoki on 3/6/21.
//

#import <Cocoa/Cocoa.h>
#import <InputMethodKit/InputMethodKit.h>
#import "MacOSLibpinyinController.h"


NSString  *libpinyinConnectionName = @"MacOS_Libpinyin_Connection";
IMKServer *server;
MacOSLibpinyinController *controller;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];

        NSLog(@"Init Controller");

        NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
        server = [[IMKServer alloc] initWithName:libpinyinConnectionName
                                bundleIdentifier:bundleID];
    }
    return NSApplicationMain(argc, argv);
}
