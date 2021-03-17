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

- (IBAction)menuChineseClicked:(id)sender;
- (IBAction)menuFullClicked:(id)sender;
- (IBAction)menuFullPunctClicked:(id)sender;

@end

