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

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AppDelegate *app = (__bridge AppDelegate*) context;
    // Change in player state or player info.
    NSString *displayString = [change valueForKey:@"new"];
    if ([displayString class] == [NSNull class]) {
        return;
    }
    NSLog(@"%@", change);
    displayString = [displayString
                     stringByReplacingOccurrencesOfString:@"%artist" withString:[app artist]];
    displayString = [displayString
                     stringByReplacingOccurrencesOfString:@"%album" withString:[app album]];
    displayString = [displayString
                     stringByReplacingOccurrencesOfString:@"%song" withString:[app name]];
    displayString = [displayString
                     stringByReplacingOccurrencesOfString:@"%number" withString:[NSString stringWithFormat:@"%ld", [app trackNumber]]];
    [model setText:displayString];
}

@end
