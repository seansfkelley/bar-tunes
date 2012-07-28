//
//  DisplayController.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/28/12.
//
//

#import "DisplayController.h"

@implementation DisplayController

- (DisplayController*) initWithModel:(DisplayModel*)m {
    self = [super init];
    model = m;
    return self;
}

- (IBAction) toggleShowIcons:(NSMenuItem*)sender {
    BOOL showIcons = [sender state] != NSOnState;
    [sender setState:showIcons ? NSOnState : NSOffState];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:showIcons forKey:DEFAULTS_KEY_SHOW_ICONS];
    [defaults synchronize];
    [model setShowIcons:showIcons];
}

// Basically c'n'p from toggleShowIcons.
- (IBAction) toggleShowPauseText:(NSMenuItem*)sender {
    BOOL showPauseText = [sender state] != NSOnState;
    [sender setState:showPauseText ? NSOnState : NSOffState];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:showPauseText forKey:DEFAULTS_KEY_SHOW_PAUSE_TEXT];
    [defaults synchronize];
    [model setShowPauseText:showPauseText];
}

@end
