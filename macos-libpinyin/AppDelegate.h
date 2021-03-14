//
//  AppDelegate.h
//  macos-libpinyin
//
//  Created by inoki on 3/6/21.
//

#import <Cocoa/Cocoa.h>
#import "CandidateWindow.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property CandidateWindow *candiWin;
@property (weak) IBOutlet NSMenu *menu;

+ (instancetype)getDelegate;

- (IBAction)showPreferences:(id)sender;
@end

