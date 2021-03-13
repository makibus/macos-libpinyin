//
//  MacOSLibpinyinController.m
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import "MacOSLibpinyinController.h"
#import "LibpinyinFullPinyinEditor.h"

@implementation MacOSLibpinyinController {
    LibpinyinFullPinyinEditor *_fullpinyinEditor;
}

- (BOOL)inputText:(NSString*)string client:(id)sender
{
    NSLog(@"MacOS Libpinyin Controller receive: %@", string);
    return NO;
}

- (BOOL)handleEvent:(NSEvent *)event client:(id)sender
{
    if (_fullpinyinEditor == nil) {
        NSLog(@"No editor can handle this");
        return NO;
    }
    
    
    int keyCode;
    int keyValue;
    BOOL handled = NO;
    switch ([event type]) {
        case NSEventTypeFlagsChanged:
            // TODO: modifier
            NSLog(@"Flags changed: %@", event);
            break;
        case NSEventTypeKeyDown:
            // Key down: send key code and value
            NSLog(@"%hu %@ %@", [event keyCode], [event charactersIgnoringModifiers], [event characters]);
            keyCode = [event keyCode];
            keyValue = [[event characters] UTF8String][0];  // TODO: use unmodified?
            handled = [_fullpinyinEditor processKeyEventWithKeyValue:keyValue keyCode:keyCode modifiers:0];
            [_fullpinyinEditor refresh:sender underController:self];
            break;
        default:
            break;
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
        [self createFullpinyinEditor];
    }

    return self;
}

- (void)deactivateServer:(id)sender
{
    NSLog(@"Server deactivated for %@", [sender bundleIdentifier]);
}

- (void)createFullpinyinEditor {
    // LibpinyinFullPinyinEditor
    _fullpinyinEditor = [[LibpinyinFullPinyinEditor alloc] initWithProperties:[[LibpinyinProperties alloc] init] andConfig:[[LibpinyinConfig alloc] init]];
}

@end
