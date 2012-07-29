//
//  DisplayController.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/28/12.
//
//

#import "DisplayController.h"

@implementation DisplayController

@synthesize model;
@synthesize playerModel;
@synthesize formatModel;

- (void) awakeFromNib {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self setShowIcons:[defaults boolForKey:DEFAULTS_KEY_SHOW_ICONS]];
    [self setShowPauseText:[defaults boolForKey:DEFAULTS_KEY_SHOW_PAUSE_TEXT]];
}

- (void) setShowIcons:(BOOL)showIcons {
    [showIconsMenuItem setState:showIcons ? NSOnState : NSOffState];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:showIcons forKey:DEFAULTS_KEY_SHOW_ICONS];
    [defaults synchronize];
    [model setShowIcons:showIcons];
}

- (void) setShowPauseText:(BOOL)showPauseText {
    [showPauseTextMenuItem setState:showPauseText ? NSOnState : NSOffState];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:showPauseText forKey:DEFAULTS_KEY_SHOW_PAUSE_TEXT];
    [defaults synchronize];
    [model setShowPauseText:showPauseText];
}

- (IBAction) toggleShowIcons:(NSMenuItem*)sender {
    [self setShowIcons:[sender state] != NSOnState];
}

- (IBAction) toggleShowPauseText:(NSMenuItem*)sender {
    [self setShowPauseText:[sender state] != NSOnState];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"Updating display model.");
    NSString *displayString = [formatModel formatString];
    displayString = [displayString
                     stringByReplacingOccurrencesOfString:@"%artist" withString:[playerModel artist]];
    displayString = [displayString
                     stringByReplacingOccurrencesOfString:@"%album" withString:[playerModel album]];
    displayString = [displayString
                     stringByReplacingOccurrencesOfString:@"%song" withString:[playerModel name]];
    displayString = [displayString
                     stringByReplacingOccurrencesOfString:@"%number" withString:[NSString stringWithFormat:@"%ld", [playerModel trackNumber]]];
    [model setText:displayString];
    [model setState:[playerModel state]];
}

@end
