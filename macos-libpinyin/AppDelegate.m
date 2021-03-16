//
//  AppDelegate.m
//  macos-libpinyin
//
//  Created by inoki on 3/6/21.
//

#import "AppDelegate.h"
#import "LibpinyinConfig.h"
#include <pinyin.h>

@interface AppDelegate () {
    LibpinyinConfig *m_config;
}

@property (strong) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSPopUpButton *m_doublePinyinSchema;

@property (weak) IBOutlet NSButton *m_correctPinyinGNNG;
@property (weak) IBOutlet NSButton *m_correctPinyinMGNG;
@property (weak) IBOutlet NSButton *m_correctPinyinUEIUI;
@property (weak) IBOutlet NSButton *m_correctPinyinUENUN;
@property (weak) IBOutlet NSButton *m_correctPinyinONONG;
@property (weak) IBOutlet NSButton *m_correctPinyinVU;
@property (weak) IBOutlet NSButton *m_correctPinyinUEVE;
@property (weak) IBOutlet NSButton *m_correctPinyinIOUIU;

@property (weak) IBOutlet NSButton *m_fuzzySyllableCCH;
@property (weak) IBOutlet NSButton *m_fuzzySyllableZZH;
@property (weak) IBOutlet NSButton *m_fuzzySyllableSSH;
@property (weak) IBOutlet NSButton *m_fuzzySyllableLN;
@property (weak) IBOutlet NSButton *m_fuzzySyllableFH;
@property (weak) IBOutlet NSButton *m_fuzzySyllableLR;
@property (weak) IBOutlet NSButton *m_fuzzySyllableGK;
@property (weak) IBOutlet NSButton *m_fuzzySyllableANANG;
@property (weak) IBOutlet NSButton *m_fuzzySyllableENENG;
@property (weak) IBOutlet NSButton *m_fuzzySyllableINING;

@property (weak) IBOutlet NSButton *m_dictArt;
@property (weak) IBOutlet NSButton *m_dictCulture;
@property (weak) IBOutlet NSButton *m_dictEconomy;
@property (weak) IBOutlet NSButton *m_dictGeology;
@property (weak) IBOutlet NSButton *m_dictHistory;
@property (weak) IBOutlet NSButton *m_dictLife;
@property (weak) IBOutlet NSButton *m_dictNature;
@property (weak) IBOutlet NSButton *m_dictPeople;
@property (weak) IBOutlet NSButton *m_dictScience;
@property (weak) IBOutlet NSButton *Society;
@property (weak) IBOutlet NSButton *m_dictSport;
@property (weak) IBOutlet NSButton *m_dictTechnology;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    m_config = [LibpinyinConfig sharedConfig];
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

/* Configs */
- (IBAction)initLanguageValueChangedToEN:(id)sender {
    [m_config setInitChinese:NO];
}
- (IBAction)initLanuageValueChangedToCH:(id)sender {
    [m_config setInitChinese:YES];
}
- (IBAction)initFullValueChangedToFull:(id)sender {
    [m_config setInitFull:YES];
}
- (IBAction)initFullValueChangedToHalf:(id)sender {
    [m_config setInitFull:NO];
}
- (IBAction)initFullPuncValueChangedToFull:(id)sender {
    [m_config setInitFullPunct:YES];
}
- (IBAction)initFullPuncValueChangedToHalf:(id)sender {
    [m_config setInitFullPunct:NO];
}

- (IBAction)numberOfCandidates1:(id)sender {
    NSLog(@"Value changed to 1");
}
- (IBAction)numberOfCandidates2:(id)sender {
    NSLog(@"Value changed to 2");
}
- (IBAction)numberOfCandidates3:(id)sender {
    NSLog(@"Value changed to 3");
}
- (IBAction)numberOfCandidates4:(id)sender {
    NSLog(@"Value changed to 4");
}
- (IBAction)numberOfCandidates5:(id)sender {
    NSLog(@"Value changed to 5");
}
- (IBAction)numberOfCandidates6:(id)sender {
    NSLog(@"Value changed to 6");
}
- (IBAction)numberOfCandidates7:(id)sender {
    NSLog(@"Value changed to 7");
}
- (IBAction)numberOfCandidates8:(id)sender {
    NSLog(@"Value changed to 8");
}
- (IBAction)numberOfCandidates9:(id)sender {
    NSLog(@"Value changed to 9");
}
- (IBAction)numberOfCandidates10:(id)sender {
    NSLog(@"Value changed to 10");
}

- (IBAction)dynamicAdjust:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)rememberEveryInput:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)showSuggestions:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}

- (IBAction)sortCandidatesByFrequency:(id)sender {
    [m_config setSortOption:SORT_BY_PHRASE_LENGTH_AND_FREQUENCY];
}
- (IBAction)sortCandidatesByPinyinLength:(id)sender {
    [m_config setSortOption:SORT_BY_PHRASE_LENGTH_AND_PINYIN_LENGTH_AND_FREQUENCY];
}

- (IBAction)useFullpinyin:(id)sender {
    [_m_doublePinyinSchema setEnabled:NO];
    [m_config setDoublePinyin:NO];
}
- (IBAction)useDoublePinyin:(id)sender {
    [_m_doublePinyinSchema setEnabled:YES];
    [m_config setDoublePinyin:YES];
}

- (IBAction)doublePinyinSchemaMSPY:(id)sender {
    [m_config setDoublePinyinSchema:DOUBLE_PINYIN_MS];
}
- (IBAction)doublePinyinSchemaZRM:(id)sender {
    [m_config setDoublePinyinSchema:DOUBLE_PINYIN_ZRM];
}
- (IBAction)doublePinyinSchemaABC:(id)sender {
    [m_config setDoublePinyinSchema:DOUBLE_PINYIN_ABC];
}
- (IBAction)doublePinyinSchemaZGPY:(id)sender {
    [m_config setDoublePinyinSchema:DOUBLE_PINYIN_ZIGUANG];
}
- (IBAction)doublePinyinSchemaPYJJ:(id)sender {
    [m_config setDoublePinyinSchema:DOUBLE_PINYIN_PYJJ];
}
- (IBAction)doublePinyinSchemaXHE:(id)sender {
    [m_config setDoublePinyinSchema:DOUBLE_PINYIN_XHE];
}

- (IBAction)incompletePinyin:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}

- (IBAction)commaPeriodFlipPage:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)minusEqualFlipPage:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)autoCommit:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)shiftSelectCandidate:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}

- (IBAction)correctPinyin:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)correctPinyinGNNG:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)correctPinyinMGNG:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)correctPinyinUEIUI:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)correctPinyinUENEN:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)correctPinyinONONG:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)correctPinyinVU:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)correctPinyinUEVE:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)correctPinyinIOUIU:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}

- (IBAction)fuzzySyllable:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)fuzzySyllableCCH:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)fuzzySyllableZZH:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)fuzzySyllableSSH:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)fuzzySyllableLN:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)fuzzySyllableFH:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)fuzzySyllableLR:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)fuzzySyllableGK:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)fuzzySyllableANANG:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)fuzzySyllableENENG:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)fuzzySyllableINING:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}

- (IBAction)dictArt:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)dictCulture:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)dictEconomy:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)dictGeology:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)dictHistory:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)dictLife:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)dictNature:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)dictPeople:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)dictScience:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)dictSociety:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)dictSport:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}
- (IBAction)dictTechnology:(id)sender {
    NSButton *cell = sender;
    NSLog(@"Value changed to %d", [cell intValue]);
}


@end
