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

@property (weak) IBOutlet NSPopUpButtonCell *m_initLanguage;
@property (weak) IBOutlet NSPopUpButton *m_initFull;
@property (weak) IBOutlet NSPopUpButton *m_initFullPunct;

@property (weak) IBOutlet NSPopUpButton *m_numberOfCandidates;

@property (weak) IBOutlet NSButton *m_dynamicAdjust;
@property (weak) IBOutlet NSButtonCell *m_rememberEveryInput;
@property (weak) IBOutlet NSButtonCell *m_showSuggestions;
@property (weak) IBOutlet NSPopUpButton *m_sortCandidates;

@property (weak) IBOutlet NSPopUpButton *m_pinyinMode;
@property (weak) IBOutlet NSPopUpButton *m_doublePinyinSchema;

@property (weak) IBOutlet NSButtonCell *m_incompletePinyin;

@property (weak) IBOutlet NSButtonCell *m_commaPeriodFlipPage;
@property (weak) IBOutlet NSButtonCell *m_minusEqualFlipPage;
@property (weak) IBOutlet NSButtonCell *m_shiftSelectCandidate;
@property (weak) IBOutlet NSButtonCell *m_autoCommit;

@property (weak) IBOutlet NSButton *m_correctPinyin;
@property (weak) IBOutlet NSButton *m_correctPinyinGNNG;
@property (weak) IBOutlet NSButton *m_correctPinyinMGNG;
@property (weak) IBOutlet NSButton *m_correctPinyinUEIUI;
@property (weak) IBOutlet NSButton *m_correctPinyinUENUN;
@property (weak) IBOutlet NSButton *m_correctPinyinONONG;
@property (weak) IBOutlet NSButton *m_correctPinyinVU;
@property (weak) IBOutlet NSButton *m_correctPinyinUEVE;
@property (weak) IBOutlet NSButton *m_correctPinyinIOUIU;

@property (weak) IBOutlet NSButton *m_fuzzySyllable;
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
    [self initConfigs];
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
    [m_config setPageSize:1];
}
- (IBAction)numberOfCandidates2:(id)sender {
    [m_config setPageSize:2];
}
- (IBAction)numberOfCandidates3:(id)sender {
    [m_config setPageSize:3];
}
- (IBAction)numberOfCandidates4:(id)sender {
    [m_config setPageSize:4];
}
- (IBAction)numberOfCandidates5:(id)sender {
    [m_config setPageSize:5];
}
- (IBAction)numberOfCandidates6:(id)sender {
    [m_config setPageSize:6];
}
- (IBAction)numberOfCandidates7:(id)sender {
    [m_config setPageSize:7];
}
- (IBAction)numberOfCandidates8:(id)sender {
    [m_config setPageSize:8];
}
- (IBAction)numberOfCandidates9:(id)sender {
    [m_config setPageSize:9];
}
- (IBAction)numberOfCandidates10:(id)sender {
    [m_config setPageSize:10];
}

- (IBAction)dynamicAdjust:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setFuzzyOption:DYNAMIC_ADJUST];
    } else {
        [m_config removeFuzzyOption:DYNAMIC_ADJUST];
    }
}
- (IBAction)rememberEveryInput:(id)sender {
    NSButton *cell = sender;
    [m_config setRememberEveryInput:[cell intValue]];
}
- (IBAction)showSuggestions:(id)sender {
    NSButton *cell = sender;
    [m_config setShowSuggestion:[cell intValue]];
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
    if ([cell intValue]) {
        [m_config setFuzzyOption:PINYIN_INCOMPLETE | ZHUYIN_INCOMPLETE];
    } else {
        [m_config removeFuzzyOption:PINYIN_INCOMPLETE | ZHUYIN_INCOMPLETE];
    }
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
    if ([cell intValue]) {
        [m_config setCorrectOption:PINYIN_CORRECT_ALL];
    } else {
        [m_config removeCorrectOption:PINYIN_CORRECT_ALL];
    }
    [self resetCorrectStates];
}
- (IBAction)correctPinyinGNNG:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setCorrectOption:PINYIN_CORRECT_GN_NG];
    } else {
        [m_config removeCorrectOption:PINYIN_CORRECT_GN_NG];
    }
}
- (IBAction)correctPinyinMGNG:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setCorrectOption:PINYIN_CORRECT_MG_NG];
    } else {
        [m_config removeCorrectOption:PINYIN_CORRECT_MG_NG];
    }
}
- (IBAction)correctPinyinUEIUI:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setCorrectOption:PINYIN_CORRECT_UEI_UI];
    } else {
        [m_config removeCorrectOption:PINYIN_CORRECT_UEI_UI];
    }
}
- (IBAction)correctPinyinUENEN:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setCorrectOption:PINYIN_CORRECT_UEN_UN];
    } else {
        [m_config removeCorrectOption:PINYIN_CORRECT_UEN_UN];
    }
}
- (IBAction)correctPinyinONONG:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setCorrectOption:PINYIN_CORRECT_ON_ONG];
    } else {
        [m_config removeCorrectOption:PINYIN_CORRECT_ON_ONG];
    }
}
- (IBAction)correctPinyinVU:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setCorrectOption:PINYIN_CORRECT_V_U];
    } else {
        [m_config removeCorrectOption:PINYIN_CORRECT_V_U];
    }
}
- (IBAction)correctPinyinUEVE:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setCorrectOption:PINYIN_CORRECT_UE_VE];
    } else {
        [m_config removeCorrectOption:PINYIN_CORRECT_UE_VE];
    }
}
- (IBAction)correctPinyinIOUIU:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setCorrectOption:PINYIN_CORRECT_IOU_IU];
    } else {
        [m_config removeCorrectOption:PINYIN_CORRECT_IOU_IU];
    }
}

- (IBAction)fuzzySyllable:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setFuzzyOption:PINYIN_AMB_ALL];
    } else {
        [m_config removeFuzzyOption:PINYIN_AMB_ALL];
    }
    [self resetFuzzyStates];
}
- (IBAction)fuzzySyllableCCH:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setFuzzyOption:PINYIN_AMB_C_CH];
    } else {
        [m_config removeFuzzyOption:PINYIN_AMB_C_CH];
    }
}
- (IBAction)fuzzySyllableZZH:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setFuzzyOption:PINYIN_AMB_Z_ZH];
    } else {
        [m_config removeFuzzyOption:PINYIN_AMB_Z_ZH];
    }
}
- (IBAction)fuzzySyllableSSH:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setFuzzyOption:PINYIN_AMB_S_SH];
    } else {
        [m_config removeFuzzyOption:PINYIN_AMB_S_SH];
    }
}
- (IBAction)fuzzySyllableLN:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setFuzzyOption:PINYIN_AMB_L_N];
    } else {
        [m_config removeFuzzyOption:PINYIN_AMB_L_N];
    }
}
- (IBAction)fuzzySyllableFH:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setFuzzyOption:PINYIN_AMB_F_H];
    } else {
        [m_config removeFuzzyOption:PINYIN_AMB_F_H];
    }
}
- (IBAction)fuzzySyllableLR:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setFuzzyOption:PINYIN_AMB_L_R];
    } else {
        [m_config removeFuzzyOption:PINYIN_AMB_L_R];
    }
}
- (IBAction)fuzzySyllableGK:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setFuzzyOption:PINYIN_AMB_G_K];
    } else {
        [m_config removeFuzzyOption:PINYIN_AMB_G_K];
    }
}
- (IBAction)fuzzySyllableANANG:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setFuzzyOption:PINYIN_AMB_AN_ANG];
    } else {
        [m_config removeFuzzyOption:PINYIN_AMB_AN_ANG];
    }
}
- (IBAction)fuzzySyllableENENG:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setFuzzyOption:PINYIN_AMB_EN_ENG];
    } else {
        [m_config removeFuzzyOption:PINYIN_AMB_EN_ENG];
    }
}
- (IBAction)fuzzySyllableINING:(id)sender {
    NSButton *cell = sender;
    if ([cell intValue]) {
        [m_config setFuzzyOption:PINYIN_AMB_IN_ING];
    } else {
        [m_config removeFuzzyOption:PINYIN_AMB_IN_ING];
    }
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


- (void)initConfigs {
    // General
    [_m_initLanguage selectItemAtIndex:[m_config initChinese] ? 0 : 1];
    [_m_initFull selectItemAtIndex:[m_config initFull] ? 0 : 1];
    [_m_initFullPunct selectItemAtIndex:[m_config initFullPunct] ? 0 : 1];

    [_m_numberOfCandidates selectItemAtIndex:[m_config pageSize] - 1];
    
    [_m_dynamicAdjust setState:([m_config fuzzyOption] & DYNAMIC_ADJUST) ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_rememberEveryInput setState:[m_config rememberEveryInput] ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_showSuggestions setState:[m_config showSuggestion] ? NSControlStateValueOn : NSControlStateValueOff];

    [_m_sortCandidates selectItemAtIndex:[m_config sortOption] - 1];

    // Pinyin
    [_m_pinyinMode selectItemAtIndex:[m_config doublePinyin] ? 1 : 0];
    // TODO: [_m_doublePinyinSchema selectItemAtIndex:0];
    [_m_incompletePinyin setState:([m_config fuzzyOption] & (PINYIN_INCOMPLETE | ZHUYIN_INCOMPLETE)) ? NSControlStateValueOn : NSControlStateValueOff];

    [_m_commaPeriodFlipPage setState:[m_config commaPeriodPage] ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_minusEqualFlipPage setState:[m_config minusEqualPage] ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_autoCommit setState:[m_config autoCommit] ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_shiftSelectCandidate setState:[m_config shiftSelectCandidate] ? NSControlStateValueOn : NSControlStateValueOff];

    [self resetCorrectStates];

    // Fuzzy
    [self resetFuzzyStates];

    // Dict
    // TODO
}

- (void)resetCorrectStates {
    NSUInteger correctOption = [m_config correctOption];
    [_m_correctPinyinGNNG setState:(correctOption & PINYIN_CORRECT_GN_NG) ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_correctPinyinMGNG setState:(correctOption & PINYIN_CORRECT_MG_NG) ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_correctPinyinUEIUI setState:(correctOption & PINYIN_CORRECT_UEI_UI) ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_correctPinyinUENUN setState:(correctOption & PINYIN_CORRECT_UEN_UN) ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_correctPinyinONONG setState:(correctOption & PINYIN_CORRECT_ON_ONG) ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_correctPinyinUEVE setState:(correctOption & PINYIN_CORRECT_UE_VE) ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_correctPinyinIOUIU setState:(correctOption & PINYIN_CORRECT_IOU_IU) ? NSControlStateValueOn : NSControlStateValueOff];
    if (correctOption) {
        [_m_correctPinyin setState: NSControlStateValueOn];

        // Set each options
        [_m_correctPinyinVU setEnabled:YES];
        [_m_correctPinyinGNNG setEnabled:YES];
        [_m_correctPinyinMGNG setEnabled:YES];
        [_m_correctPinyinUEIUI setEnabled:YES];
        [_m_correctPinyinUENUN setEnabled:YES];
        [_m_correctPinyinONONG setEnabled:YES];
        [_m_correctPinyinUEVE setEnabled:YES];
        [_m_correctPinyinIOUIU setEnabled:YES];
    } else {
        [_m_correctPinyin setState:NSControlStateValueOff];

        // Set each options
        [_m_correctPinyinVU setEnabled:NO];
        [_m_correctPinyinGNNG setEnabled:NO];
        [_m_correctPinyinMGNG setEnabled:NO];
        [_m_correctPinyinUEIUI setEnabled:NO];
        [_m_correctPinyinUENUN setEnabled:NO];
        [_m_correctPinyinONONG setEnabled:NO];
        [_m_correctPinyinUEVE setEnabled:NO];
        [_m_correctPinyinIOUIU setEnabled:NO];
    }
}

- (void)resetFuzzyStates {
    NSUInteger fuzzyOption = [m_config fuzzyOption];
    [_m_fuzzySyllableFH setState:(fuzzyOption | PINYIN_AMB_F_H) ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_fuzzySyllableGK setState:(fuzzyOption | PINYIN_AMB_G_K) ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_fuzzySyllableLN setState:(fuzzyOption | PINYIN_AMB_L_N) ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_fuzzySyllableLR setState:(fuzzyOption | PINYIN_AMB_L_R) ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_fuzzySyllableCCH setState:(fuzzyOption | PINYIN_AMB_C_CH) ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_fuzzySyllableSSH setState:(fuzzyOption | PINYIN_AMB_S_SH) ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_fuzzySyllableZZH setState:(fuzzyOption | PINYIN_AMB_Z_ZH) ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_fuzzySyllableANANG setState:(fuzzyOption | PINYIN_AMB_AN_ANG) ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_fuzzySyllableENENG setState:(fuzzyOption | PINYIN_AMB_EN_ENG) ? NSControlStateValueOn : NSControlStateValueOff];
    [_m_fuzzySyllableINING setState:(fuzzyOption | PINYIN_AMB_IN_ING) ? NSControlStateValueOn : NSControlStateValueOff];
    if (fuzzyOption & PINYIN_AMB_ALL) {
        [_m_fuzzySyllable setState: NSControlStateValueOn];

        // Set each options
        [_m_fuzzySyllableFH setEnabled:YES];
        [_m_fuzzySyllableGK setEnabled:YES];
        [_m_fuzzySyllableLN setEnabled:YES];
        [_m_fuzzySyllableLR setEnabled:YES];
        [_m_fuzzySyllableCCH setEnabled:YES];
        [_m_fuzzySyllableSSH setEnabled:YES];
        [_m_fuzzySyllableZZH setEnabled:YES];
        [_m_fuzzySyllableANANG setEnabled:YES];
        [_m_fuzzySyllableENENG setEnabled:YES];
        [_m_fuzzySyllableINING setEnabled:YES];
    } else {
        [_m_fuzzySyllable setState:NSControlStateValueOff];

        // Set each options
        [_m_fuzzySyllableFH setEnabled:NO];
        [_m_fuzzySyllableGK setEnabled:NO];
        [_m_fuzzySyllableLN setEnabled:NO];
        [_m_fuzzySyllableLR setEnabled:NO];
        [_m_fuzzySyllableCCH setEnabled:NO];
        [_m_fuzzySyllableSSH setEnabled:NO];
        [_m_fuzzySyllableZZH setEnabled:NO];
        [_m_fuzzySyllableANANG setEnabled:NO];
        [_m_fuzzySyllableENENG setEnabled:NO];
        [_m_fuzzySyllableINING setEnabled:NO];
    }
}

@end
