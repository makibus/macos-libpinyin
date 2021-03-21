//
//  MacOSIMETheme.h
//  macos-ime-panel-inapp
//
//  Created by inoki on 3/18/21.
//

#import <Foundation/Foundation.h>

#import <Cocoa/Cocoa.h>


@interface MacOSIMETheme : NSObject

- (id)initWithThemeName:(NSString *)themeName;

@property (nonatomic, readonly) NSString *name;

/* InputPanel */
@property (nonatomic, readonly) NSFont *panelFont;
@property (nonatomic, readonly) NSColor *panelNormalColor;
@property (nonatomic, readonly) NSColor *panelHighlightColor;
@property (nonatomic, readonly) NSUInteger panelSpacing;
@property (nonatomic, readonly) NSPoint panelTextMarginLT;
@property (nonatomic, readonly) NSPoint panelTextMarginRB;
@property (nonatomic, readonly) NSPoint panelContentMarginLT;
@property (nonatomic, readonly) NSPoint panelContentMarginRB;
@property (nonatomic, readonly) NSColor *panelHighlightCandidateColor;
@property (nonatomic, readonly) NSColor *panelHighlightBackgroundColor;

@property (nonatomic, readonly) NSImage *panelBackgroundImage;
@property (nonatomic, readonly) NSPoint panelBackgroundMarginLT;
@property (nonatomic, readonly) NSPoint panelBackgroundMarginRB;

@property (nonatomic, readonly) NSImage *panelHighlightImage;
@property (nonatomic, readonly) NSPoint panelHighlightMarginLT;
@property (nonatomic, readonly) NSPoint panelHighlightMarginRB;

@property (nonatomic, readonly) NSImage *panelPrevPageImage;
@property (nonatomic, readonly) NSPoint panelPrevPageMarginLT;
@property (nonatomic, readonly) NSPoint panelPrevPageMarginRB;

@property (nonatomic, readonly) NSImage *panelNextPageImage;
@property (nonatomic, readonly) NSPoint panelNextPageMarginLT;
@property (nonatomic, readonly) NSPoint panelNextPageMarginRB;

@end
