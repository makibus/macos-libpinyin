//
//  main.m
//  macos-libpinyin
//
//  Created by inoki on 3/6/21.
//

#import <Cocoa/Cocoa.h>
#import <InputMethodKit/InputMethodKit.h>
#import "MacOSLibpinyinController.h"
#import "LibpinyinConfig.h"


NSString  *libpinyinConnectionName = @"MacOS_Libpinyin_Connection";
IMKServer *server;
MacOSLibpinyinController *controller;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Pre-init Application Support folders
        NSArray *applicationSupportPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *applicationSupportDirectory = [[applicationSupportPaths firstObject] stringByAppendingPathComponent:
                                                 [[NSBundle mainBundle] bundleIdentifier]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:applicationSupportDirectory]) {
            // Create the folder
            [[NSFileManager defaultManager] createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *userDataDirectory = [applicationSupportDirectory stringByAppendingPathComponent:@"data"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:userDataDirectory]) {
            // Create the folder
            [[NSFileManager defaultManager] createDirectoryAtPath:userDataDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }

        // Pre-init libpinyin config
        [LibpinyinConfig sharedConfig];

        NSLog(@"Init Controller");

        NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
        server = [[IMKServer alloc] initWithName:libpinyinConnectionName
                                bundleIdentifier:bundleID];
    }
    return NSApplicationMain(argc, argv);
}
