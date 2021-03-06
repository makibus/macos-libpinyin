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

@property (strong) IBOutlet NSTextField *candidate_label;

@property (strong) IBOutlet NSTextField *input_pinyin;

@property pinyin_context_t *context;

@property pinyin_instance_t *instance;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    if (!_context) {
        NSString *dataPath = [[NSBundle mainBundle] resourcePath];
                
        const char *dataPathNative = [dataPath UTF8String];
        
        _context = pinyin_init(dataPathNative, "");
    }
    
    if (!_instance) {
        if (_context) {
            _instance = pinyin_alloc_instance(_context);
        } else {
            NSLog(@"Failed to instantiate");
        }
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    if (_instance) {
        pinyin_free_instance(_instance);
    }
    
    if (_context) {
        pinyin_fini(_context);
    }
}

- (IBAction)getCandidates:(id)sender {
    NSLog(@"Getting candidates");
    
    if (_input_pinyin) {
        NSLog(@"Input PINYIN: %@", [_input_pinyin stringValue]);
        
        if ([[_input_pinyin stringValue] length]) {
            NSString *best_match_candidate_text = @"Error";
            if (_instance) {
                NSString *input = [_input_pinyin stringValue];
                pinyin_parse_more_full_pinyins (_instance, [input UTF8String]);

                pinyin_guess_sentence (_instance);

                uint number;

                pinyin_guess_candidates(_instance, 0, SORT_BY_PHRASE_LENGTH_AND_FREQUENCY);

                pinyin_get_n_candidate (_instance, &number);

                NSLog(@"%@ has %d candidates\n", input, number);

                for (uint i = 0; i < 5 && i < number; ++i)
                {
                    lookup_candidate_t * candidate;
                    pinyin_get_candidate(_instance, i, &candidate);

                    const char *display_string;
                    pinyin_get_candidate_string(_instance, candidate, &display_string);
                    
                    NSLog(@"%s\t", display_string);
                    
                    if (i == 0) {
                        best_match_candidate_text = [NSString stringWithUTF8String: display_string];
                    }
                }
            }
            
            if (_candidate_label) {
                NSLog(@"Candidate: %@", [_candidate_label stringValue]);
                [_candidate_label setStringValue: best_match_candidate_text];
            }
        }
        
        
    }
}

@end
