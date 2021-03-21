//
//  MacOSIMETheme.m
//  macos-ime-panel-inapp
//
//  Created by inoki on 3/18/21.
//

#import "MacOSIMETheme.h"

#define RGBA(r,g,b,a) [NSColor colorWithCalibratedRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f]
#define RGB(r,g,b) [NSColor colorWithCalibratedRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

@implementation MacOSIMETheme

- (id)initWithThemeName:(NSString *)themeName {
    _name = (themeName == nil ? @"Default" : themeName);

    /* InputPanel */
    _panelFont = [NSFont systemFontOfSize:16];
    _panelNormalColor = RGB(0, 0, 0);
    _panelHighlightColor = RGB(0xff, 0xff, 0xff);
    _panelSpacing = 3;
    _panelTextMarginLT = NSMakePoint(5, 5);
    _panelTextMarginRB = NSMakePoint(5, 5);
    _panelContentMarginLT = NSMakePoint(2, 2);
    _panelContentMarginRB = NSMakePoint(2, 2);
    _panelHighlightCandidateColor = RGB(0xff, 0xff, 0xff);
    _panelHighlightBackgroundColor = RGB(0xa5, 0xa5, 0xa5);

    _panelBackgroundImage = [[NSImage alloc] initByReferencingURL:[[NSBundle mainBundle] URLForResource:@"panel" withExtension:@"png"]];
    _panelBackgroundMarginLT = NSMakePoint(2, 2);
    _panelBackgroundMarginRB = NSMakePoint(2, 2);

    _panelHighlightImage = [[NSImage alloc] initByReferencingURL:[[NSBundle mainBundle] URLForResource:@"highlight" withExtension:@"png"]];
    _panelHighlightMarginLT = NSMakePoint(5, 5);
    _panelHighlightMarginRB = NSMakePoint(5, 5);

    _panelPrevPageImage = [[NSImage alloc] initByReferencingURL:[[NSBundle mainBundle] URLForResource:@"prev" withExtension:@"png"]];
    _panelPrevPageMarginLT = NSMakePoint(5, 4);
    _panelPrevPageMarginRB = NSMakePoint(5, 4);

    _panelNextPageImage = [[NSImage alloc] initByReferencingURL:[[NSBundle mainBundle] URLForResource:@"next" withExtension:@"png"]];
    _panelNextPageMarginLT = NSMakePoint(5, 4);
    _panelNextPageMarginRB = NSMakePoint(5, 4);

    return self;
}

@end
