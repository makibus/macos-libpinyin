//
//  AppDelegate.m
//  macos-libpinyin
//
//  Created by inoki on 3/6/21.
//

#import "AppDelegate.h"
#include <pinyin.h>

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _candiWin = [[CandidateWindow alloc] init];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
}


+ (instancetype)getDelegate
{
    return (AppDelegate *)[NSApp delegate];
}

- (IBAction)showPreferences:(id)sender {
    NSLog(@"Show preference is called");
    [_window makeKeyAndOrderFront:sender];
}
@end
