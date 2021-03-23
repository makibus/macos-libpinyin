//
//  MacOSLibpinyinController.m
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import "MacOSLibpinyinController.h"
#import "LibpinyinFullPinyinEditor.h"
#import "AppDelegate.h"

enum EditorMode {
    PINYIN_EDITOR = 0,
    PUNCT_EDITOR,
    RAW_EDITOR,
    ENGLISH_EDITOR,
};

@implementation MacOSLibpinyinController {
    enum EditorMode mode;
    NSMutableArray *editors;
    LibpinyinFullPinyinEditor *_fullpinyinEditor;
    BOOL chineseMode;
    BOOL traditionMode;
    BOOL fullPunct;

    // Language switch
    BOOL hasInputBetweenShift;
    BOOL shiftPressed;
}

- (BOOL)inputText:(NSString*)string client:(id)sender
{
    NSLog(@"MacOS Libpinyin Controller receive: %@", string);
    return NO;
}

- (BOOL)handleEvent:(NSEvent *)event client:(id)sender
{
    if (![editors count]) {
        NSLog(@"No editor can handle this %lu", [editors count]);
        return NO;
    }
    LibpinyinConfig *config = [LibpinyinConfig sharedConfig];
    if (chineseMode != [config initChinese]) chineseMode = [config initChinese];
    if (fullPunct != [config initFullPunct]) fullPunct = [config initFullPunct];
    if (traditionMode != ![config initSimpChinese]) traditionMode = ![config initSimpChinese];

    int keyCode;
    int keyValue;
    BOOL handled = NO;
    if (chineseMode) {
        // Handle with Pinyin or other editors
        NSUInteger currentEditorIndex;
        switch ([event type]) {
            case NSEventTypeFlagsChanged:
                // Mode switch checking
                if (shiftPressed && !hasInputBetweenShift) {
                    if (!([event modifierFlags] & NSEventModifierFlagShift)) {
                        // Shift Released without key, switch mode
                        shiftPressed = NO;
                        [config setInitChinese:NO];
                        chineseMode = NO;
                    }
                }
                if ([event modifierFlags] & NSEventModifierFlagShift) {
                    // Pressed, begin checking key event
                    shiftPressed = YES;
                    hasInputBetweenShift = NO;
                }
                // TODO: modifier
                NSLog(@"Flags changed: %@", event);
                break;
            case NSEventTypeKeyDown:
                if (shiftPressed) {
                    // Note the event
                    hasInputBetweenShift = YES;
                }
                currentEditorIndex = (NSUInteger)mode;
                // Key down: send key code and value
                NSLog(@"%hu %@ %@", [event keyCode], [event charactersIgnoringModifiers], [event characters]);
                keyCode = [event keyCode];
                keyValue = [[event characters] UTF8String][0];  // TODO: use unmodified?
                handled = [[editors objectAtIndex:currentEditorIndex] processKeyEventWithKeyValue:keyValue keyCode:keyCode modifiers:0];
                [[editors objectAtIndex:currentEditorIndex] refresh:sender underController:self];
                break;
            default:
                break;
        }
    } else {
        // Full English mode
        // Do not handle key event, only wait <Shift> to swtich back to chinese mode
        switch ([event type]) {
            case NSEventTypeFlagsChanged:
                // Mode switch checking
                if (shiftPressed && !hasInputBetweenShift) {
                    if (!([event modifierFlags] & NSEventModifierFlagShift)) {
                        // Shift Released without key, switch mode
                        shiftPressed = NO;
                        [config setInitChinese:YES];
                        chineseMode = YES;
                    }
                }
                if ([event modifierFlags] & NSEventModifierFlagShift) {
                    // Pressed, begin checking key event
                    shiftPressed = YES;
                    hasInputBetweenShift = NO;
                }
                break;
            case NSEventTypeKeyDown:
                if (shiftPressed) {
                    // Note the event
                    hasInputBetweenShift = YES;
                }
                // Do not handle event because the input is english
                handled = NO;
                break;
            default:
                break;
        }
    }
    return handled;
}

- (NSUInteger)recognizedEvents:(id)sender {
  return NSEventMaskFlagsChanged | NSEventMaskKeyDown | NSEventMaskKeyUp;
}

- (void)activateServer:(id)sender
{
    NSLog(@"Server activated for %@", [sender bundleIdentifier]);
}

- (id)initWithServer:(IMKServer*)server delegate:(id)delegate client:(id)inputClient
{
    if (self = [super initWithServer:server delegate:delegate client:inputClient]) {
        NSLog(@"Server init ok for %@", [inputClient bundleIdentifier]);
        editors = [[NSMutableArray alloc] init];
        [self createFullpinyinEditor];
    }

    return self;
}

- (void)deactivateServer:(id)sender
{
    NSLog(@"Server deactivated for %@", [sender bundleIdentifier]);
}

- (void)createFullpinyinEditor {
    LibpinyinConfig *config = [LibpinyinConfig sharedConfig];

    // Init modes
    chineseMode = [config initChinese];
    fullPunct = [config initFullPunct];
    traditionMode = ![config initSimpChinese];

    // LibpinyinFullPinyinEditor
    _fullpinyinEditor = [[LibpinyinFullPinyinEditor alloc] initWithConfig:config];
    [editors addObject:_fullpinyinEditor];
    // TODO: Punct
    // [editors addObject:nil];
    // TODO: Raw
    // [editors addObject:nil];
    // TODO: English
    // [editors addObject:nil];

    // Reset mode
    mode = PINYIN_EDITOR;
}

- (NSMenu *)menu {
    [[AppDelegate getDelegate] updateMenu];
    return [AppDelegate getDelegate].menu;
}

- (IBAction)showPreferences:(id)sender {
    // Passthrough to AppDelegate
    return [[AppDelegate getDelegate] showPreferences:sender];
}

- (IBAction)menuChineseClicked:(id)sender {
    [[AppDelegate getDelegate] menuChineseClicked:sender];
}

- (IBAction)menuFullClicked:(id)sender {
    [[AppDelegate getDelegate] menuFullClicked:sender];
}
- (IBAction)menuFullPunctClicked:(id)sender {
    [[AppDelegate getDelegate] menuFullPunctClicked:sender];
}

@end
