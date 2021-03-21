//
//  MacOSIMEPanel.m
//  macos-ime-panel
//
//  Created by inoki on 3/18/21.
//

#import "MacOSIMEPanel.h"

@implementation MacOSIMEPanelPayload
- (id)init { return self; }
@end

@interface SimpleIMEPanel : NSView {
    BOOL m_hasNextPage;
    BOOL m_hasPrevPage;

    NSAttributedString *m_preeditText;
    NSAttributedString *m_auxiliaryText;
    NSMutableArray *m_candidates;

    NSInteger m_highlighIndex;
}

@property (nonatomic) MacOSIMETheme *theme;

@end

@implementation SimpleIMEPanel

- (void)mouseDown:(NSEvent *)event {
    // TODO: Click to change highlight, click again to choose the candidate
}

- (void)scrollWheel:(NSEvent *)event {
    // TODO: Send flip page message
}

- (void)reset {
    if (m_candidates) {
        [m_candidates removeAllObjects];
    }
    m_preeditText = nil;
    m_auxiliaryText = nil;
    m_highlighIndex = -1;
}

- (void)addCandidateText:(NSAttributedString *)candidateText {
    if (!m_candidates) {
        m_candidates = [[NSMutableArray alloc] init];
    }
    [m_candidates addObject:candidateText];
}

- (void)setPreeditText:(NSAttributedString *)preeditText {
    m_preeditText = preeditText;
}

- (void)setAuxiliaryText:(NSAttributedString *)auxiliaryText {
    m_auxiliaryText = auxiliaryText;
}

- (void)setHighlightIndex:(NSUInteger)index {
    m_highlighIndex = index;
}

-(void)update {
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect
{
    // if (!m_payload)
    //     return;

    [[NSColor clearColor] set];
    NSRectFill([self bounds]);

    // Draw background
    if ([_theme panelBackgroundImage] != nil) {
        NSImage *image = [_theme panelBackgroundImage];
        [image setCapInsets:NSEdgeInsetsMake([_theme panelBackgroundMarginLT].x,
                                             [_theme panelBackgroundMarginLT].y,
                                             [_theme panelBackgroundMarginRB].y,
                                             [_theme panelBackgroundMarginRB].x)];
        // TODO: Set transparency
        [image drawInRect:rect fromRect:NSZeroRect
                operation:NSCompositingOperationSourceOver fraction:1];
    }

    // Draw pager
    NSRect nextRect = rect;
    if ([_theme panelNextPageImage] != nil ) {
        NSImage *image = [_theme panelNextPageImage];
        nextRect.size = [image size];
        nextRect.origin.x = rect.origin.x + rect.size.width - nextRect.size.width;
        nextRect.origin.y = rect.origin.y + [_theme panelContentMarginRB].y;
        if (m_hasNextPage) {
            [image drawInRect:nextRect fromRect:NSZeroRect
                    operation:NSCompositingOperationSourceOver fraction:1];
        } else {
            [image drawInRect:nextRect fromRect:NSZeroRect
                    operation:NSCompositingOperationSourceOver fraction:0.3];
        }
    }
    if ([_theme panelPrevPageImage] != nil) {
        NSImage *image = [_theme panelPrevPageImage];
        NSRect prevRect = rect;
        prevRect.size = [image size];
        prevRect.origin.x = nextRect.origin.x - prevRect.size.width;
        prevRect.origin.y = nextRect.origin.y;
        if (m_hasPrevPage) {
            [image drawInRect:prevRect fromRect:NSZeroRect
                    operation:NSCompositingOperationSourceOver fraction:1];
        } else {
            [image drawInRect:prevRect fromRect:NSZeroRect
                    operation:NSCompositingOperationSourceOver fraction:0.3];
        }
        // TODO: Actions
    }

    // Init normal font attr
    NSMutableDictionary *_attr = [[NSMutableDictionary alloc] init];
    [_attr setObject:[_theme panelNormalColor] forKey:NSForegroundColorAttributeName];
    [_attr setObject:[_theme panelFont] forKey:NSFontAttributeName];

    // TODO: Draw layouts (aux, preedit)
    NSAttributedString *auxTextString = m_auxiliaryText;
    NSRect auxTextRect;
    auxTextRect.origin.x = rect.origin.x + [_theme panelContentMarginLT].x + [_theme panelTextMarginLT].x;
    auxTextRect.origin.y = rect.origin.y + rect.size.height - [_theme panelContentMarginLT].y - [_theme panelTextMarginLT].y - 20;
    auxTextRect.size = [auxTextString size];
    [auxTextString drawInRect:auxTextRect];

    // Draw candidates
    CGFloat fullWidth = rect.origin.x + [_theme panelContentMarginLT].x;
    for (NSUInteger i = 0; i < [m_candidates count]; i++) {
        CGFloat x, y;
        NSRect candidateRect;
        NSMutableAttributedString *candidateString = [m_candidates objectAtIndex:i];
        x = fullWidth + [_theme panelTextMarginLT].x;
        y = rect.origin.y + [_theme panelContentMarginRB].y + [_theme panelTextMarginRB].y;
        candidateRect.origin.x = x;
        candidateRect.origin.y = y;
        candidateRect.size = [candidateString size];
        if (i == m_highlighIndex) {
            if ([_theme panelHighlightImage]) {
                NSRect candidateImageRect = candidateRect;
                candidateImageRect.origin.x = fullWidth;
                candidateImageRect.origin.y = y - [_theme panelTextMarginRB].y;
                candidateImageRect.size.width += ([_theme panelTextMarginLT].x + [_theme panelTextMarginRB].x);
                candidateImageRect.size.height += ([_theme panelTextMarginLT].y + [_theme panelTextMarginRB].y);
                [[_theme panelHighlightImage] drawInRect:candidateImageRect];
            }
        }
        [candidateString drawInRect:candidateRect];
        fullWidth = x + candidateRect.size.width + [_theme panelTextMarginRB].x;
    }
}

@end


@implementation MacOSIMEPanel {
    NSWindow *m_window;
    NSView *m_view;

    MacOSIMEPanelPayload *m_payload;

    // Temp
    NSMutableAttributedString *m_string;

    BOOL m_hasNextPage;
    BOOL m_hasPrevPage;
}

- (id)init {
    _theme = [[MacOSIMETheme alloc] initWithThemeName:@"Default"];
    m_window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0,0,0,0)
                                           styleMask:NSWindowStyleMaskBorderless
                                             backing:NSBackingStoreBuffered
                                               defer:NO];
    [m_window setAlphaValue:1.0];
    [m_window setLevel:NSScreenSaverWindowLevel + 1];
    [m_window setHasShadow:YES];
    [m_window setOpaque:NO];
    m_view = [[SimpleIMEPanel alloc] initWithFrame:[[m_window contentView] frame]];
    [m_window setContentView:m_view];

    m_hasNextPage = NO;
    m_hasPrevPage = NO;

    return self;
}

- (void)hide {
    _visible = NO;
    [m_window orderOut:self];
}

- (void)update:(MacOSIMEPanelPayload *)payload {
    // TODO: do sth with DPI

    // TODO: Prepare auxiliary data, preedit data and candidate
    m_payload = payload;
    SimpleIMEPanel *view = (SimpleIMEPanel *)m_view;
    [view reset];

    // auxiliary text
    NSMutableDictionary *_attr = [[NSMutableDictionary alloc] init];
    [_attr setObject:[_theme panelNormalColor] forKey:NSForegroundColorAttributeName];
    [_attr setObject:[_theme panelFont] forKey:NSFontAttributeName];
    NSAttributedString *auxTextString = [[NSAttributedString alloc] initWithString:[payload auxiliaryText] attributes:_attr];
    [view setAuxiliaryText:auxTextString];
    NSSize auxiliaryTextRect = [auxTextString size];
    auxiliaryTextRect.height += ([_theme panelTextMarginLT].y + [_theme panelTextMarginRB].y);
    auxiliaryTextRect.width += ([_theme panelTextMarginLT].x + [_theme panelTextMarginRB].x);

    NSSize candidateTextRect;
    NSUInteger height = 0;
    CGFloat fullWidth = 0;
    for (NSUInteger i = 0; i < [[payload candidates] count]; i++) {
        NSMutableDictionary *attr = [[NSMutableDictionary alloc] init];
        [attr setObject:[_theme panelNormalColor] forKey:NSForegroundColorAttributeName];
        [attr setObject:[_theme panelFont] forKey:NSFontAttributeName];
        CGFloat x, y;
        NSRect candidateRect;
        NSString *candidateString = [NSString stringWithFormat:@"%lu.%@", (i + 1) % 10, [[payload candidates] objectAtIndex:i]];
        if (i == [payload highlightIndex]) {
            [view setHighlightIndex:i];
            [attr setObject:[_theme panelHighlightCandidateColor] forKey:NSForegroundColorAttributeName];
        }

        NSAttributedString *candidateAttrString = [[NSAttributedString alloc] initWithString:candidateString attributes:attr];
        x = fullWidth + [_theme panelTextMarginLT].x;
        y = ([_theme panelContentMarginRB].y + [_theme panelTextMarginRB].y);
        candidateRect.origin.x = x;
        candidateRect.origin.y = y;
        candidateRect.size = [candidateAttrString size];
        [view addCandidateText:candidateAttrString];
        fullWidth = x + candidateRect.size.width + [_theme panelTextMarginRB].x;
        height = (height > [candidateAttrString size].height ? height : [candidateAttrString size].height);
    }
    candidateTextRect.width = fullWidth;
    candidateTextRect.height = (height + [_theme panelTextMarginRB].y + [_theme panelTextMarginLT].y);

    _size.height = candidateTextRect.height + auxiliaryTextRect.height + [_theme panelContentMarginRB].y + [_theme panelContentMarginLT].y;
    _size.width = (candidateTextRect.width > auxiliaryTextRect.width ? candidateTextRect.width : auxiliaryTextRect.width) + [_theme panelContentMarginRB].x + [_theme panelContentMarginLT].x + ([_theme panelPrevPageMarginLT].x + [[_theme panelPrevPageImage] size].width + [_theme panelPrevPageMarginRB].x + [_theme panelNextPageMarginLT].x + [[_theme panelNextPageImage] size].width + [_theme panelNextPageMarginRB].x);

    if ([[payload candidates] count] > 0) {
        _visible = YES;
    }

    // Update position
    [self updatePosition];

    // Paint and render
    [self paint];
    [self render];
}

- (void)updatePosition {
    if (!_visible) {
        // Do nothing
        return;
    }

    NSRect winRect;
    NSRect cursorRect = [m_payload cursor];
    winRect.origin.x = cursorRect.origin.x + 2;
    winRect.origin.y = cursorRect.origin.y - winRect.size.height - 20;
    winRect.size = _size;

    // Find a screen
    NSRect screenRect = [[NSScreen mainScreen] frame];
    NSArray *screens =[NSScreen screens];
    NSUInteger numOfScreens = [screens count];

    if (numOfScreens > 1) {
        // Find a proper screen with curosr
        BOOL screenFound = NO;
        for (NSUInteger screenIndex = 0; screenIndex < numOfScreens; screenIndex++) {
            NSScreen *screen = [screens objectAtIndex:screenIndex];
            NSRect rect = [screen frame];
            if (NSPointInRect (cursorRect.origin, rect)) {
                screenRect = rect;
                screenFound = YES;
                break;
            }
        }

        // Find a proper screen with mouse position
        HIPoint pos;
        HIGetMousePosition (kHICoordSpaceScreenPixel, NULL, &pos);
        NSPoint mousePosition;
        mousePosition.x = pos.x;
        mousePosition.y = screenRect.size.height - pos.y;

        for (NSUInteger screenIndex = 0; screenIndex < numOfScreens; screenIndex++) {
            NSScreen *screen = [screens objectAtIndex:screenIndex];
            NSRect rect = [screen frame];
            if (NSPointInRect(mousePosition, rect)) {
                screenRect = rect;
                screenFound = YES;
            }
        }

        if (!screenFound) {
            // No proper screen after many tries
            return;
        }
    }

    // Regulate position
    CGFloat minX = NSMinX(screenRect);
    CGFloat maxX = NSMaxX(screenRect);
    CGFloat minY = NSMinY(screenRect);

    if (winRect.origin.x < minX) {
        winRect.origin.x = minX;
    }

    if (winRect.origin.x + winRect.size.width > maxX) {
        winRect.origin.x = maxX - winRect.size.width;
    }

    if (winRect.origin.y < minY) {
        // FIXME: may have bug
        winRect.origin.y = cursorRect.origin.y > minY ?
            cursorRect.origin.y + cursorRect.size.height + 20:
            minY;
    }

    // Update size
    if (winRect.size.width != _size.width || winRect.size.height != _size.height) {
        _size = winRect.size;
    }

    // Set the frame
    [m_window setFrame:winRect display:NO animate:NO];
}

- (void)wheel:(BOOL)isUp {
}

- (bool)hoverAt:(NSPoint)point {
    return YES;
}

- (bool)clickAt:(NSPoint)point {
    return YES;
}

- (void)resize:(NSSize)newSize {
    // TODO
    _size = newSize;
}

/* private methods */
- (void)paint {
    // Set theme
    if (_theme != [(SimpleIMEPanel *)m_view theme]) {
        [(SimpleIMEPanel *)m_view setTheme:_theme];
    }

    // Update to repaint
    [(SimpleIMEPanel *)m_view update];
}

- (void)render {
    // Display and put it in front if necessary
    if (_visible) {
        [m_window display];
        [m_window orderFront:nil];
    }
}

@end
