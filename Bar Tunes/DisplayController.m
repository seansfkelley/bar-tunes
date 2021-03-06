#import "DisplayController.h"

@implementation DisplayController

@synthesize model;
@synthesize view;
@synthesize playerModel;
@synthesize formatModel;

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

- (void) setUseWideDisplay:(BOOL)useWideDisplay {
    [useWideDisplayMenuItem setState:useWideDisplay ? NSOnState : NSOffState];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:useWideDisplay forKey:DEFAULTS_KEY_USE_WIDE_DISPLAY];
    [defaults synchronize];
    [model setUseWideDisplay:useWideDisplay];
}

- (IBAction) toggleShowIcons:(NSMenuItem*)sender {
    [self setShowIcons:[sender state] != NSOnState];
}

- (IBAction) toggleShowPauseText:(NSMenuItem*)sender {
    [self setShowPauseText:[sender state] != NSOnState];
}

- (IBAction) toggleUseWideDisplay:(NSMenuItem*)sender {
    [self setUseWideDisplay:[sender state] != NSOnState];
}

- (void) menuWillOpen:(NSMenu*)menu {
    [model setMenuVisible:YES];
}

- (void) menuDidClose:(NSMenu *)menu {
    [model setMenuVisible:NO];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSString *displayString = [formatModel formatString];
    displayString = [displayString
                     stringByReplacingOccurrencesOfString:@"%artist" withString:[playerModel artist]];
    displayString = [displayString
                     stringByReplacingOccurrencesOfString:@"%album" withString:[playerModel album]];
    displayString = [displayString
                     stringByReplacingOccurrencesOfString:@"%song" withString:[playerModel name]];
    displayString = [displayString
                     stringByReplacingOccurrencesOfString:@"%number" withString:[playerModel trackNumber]];
    // Fire state event first: if we switch to a paused player, we have paused-text-display off, and
    // the current player is playing, there is a flicker of text if the state (and hence text-hiding)
    // update comes after.
    [model setState:[playerModel state]];
    [model setText:displayString];
}

@end
