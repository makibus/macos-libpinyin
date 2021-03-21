//
//  MacOSIMEPanel.h
//  macos-ime-panel
//
//  Created by inoki on 3/18/21.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import <Cocoa/Cocoa.h>

#import "MacOSIMETheme.h"

@interface MacOSIMEPanelPayload : NSObject

@property (nonatomic) NSString *preeditText;
@property (nonatomic) NSString *auxiliaryText;
@property (nonatomic) NSArray *candidates;
@property (nonatomic) NSRect cursor;
@property (nonatomic) NSUInteger highlightIndex;

- (id)init;

@end


@interface MacOSIMEPanel : NSView

/* Init */
- (id)init;

/* Control Visibility */
@property (atomic) BOOL visible;
- (void)hide;

/* Update panel */
// TODO: need pass some informations
- (void)update:(MacOSIMEPanelPayload *)payload;
- (void)updatePosition;

/* Event handler */
- (void)wheel:(BOOL)isUp;
- (bool)hoverAt:(NSPoint)point;
- (bool)clickAt:(NSPoint)point;

/* Window related */
@property (atomic) NSSize size;
- (void)resize:(NSSize)size;

/* Theme */
@property (nonatomic) MacOSIMETheme *theme;

@end
