//
//  AppDelegate.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void) awakeFromNib {
    itunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    
    scrollText = [[ScrollingTextView alloc] init];
    
    NSStatusItem* statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setHighlightMode:YES];
    [statusItem setView:scrollText];
    [statusItem setMenu:statusMenu];
    
    [scrollText setStatusItem:statusItem];
    
    formatString = @"%artist — %song";
    
    if ([itunes playerState] == iTunesEPlSPlaying) {
        [scrollText setState:PLAY];
        [self setDisplayStringFromiTunesState];
    } else if ([itunes playerState] == iTunesEPlSPaused) {
        [scrollText setState:PAUSE];
        [self setDisplayStringFromiTunesState];
    } else {
        [scrollText setState:STOP];
        [scrollText clear];
    }
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(iTunesPlayerInfoNotification:)
                                                            name:@"com.apple.iTunes.playerInfo"
                                                          object:nil];
}

- (IBAction) quitApplication:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

- (IBAction) bringFormatWindowToFront:(id)sender{
    [NSApp activateIgnoringOtherApps:YES];
    [formatWindow makeKeyAndOrderFront:nil];
    [formatField setObjectValue:formatString];
}

- (IBAction) closeWindowAndSetFormatString:(id)sender {
    formatString = [formatField objectValue];
    [formatWindow close];
    [self setDisplayStringFromiTunesState];
}

- (void) printNotification:(NSNotification*)note {
    NSString *object = [note object];
    NSString *name = [note name];
    NSDictionary *userInfo = [note userInfo];
    NSLog(@"<%p>%s: object: %@ name: %@ userInfo: %@", self, __PRETTY_FUNCTION__, object, name, userInfo);
}

- (void) iTunesPlayerInfoNotification:(NSNotification*)note {
    [self printNotification:note];
    NSDictionary *userInfo = [note userInfo];
    NSString *state = [userInfo objectForKey:@"Player State"];
    
    if ([state isEqualToString:@"Playing"]) {
        [scrollText setState:PLAY];
        [self setDisplayStringFromiTunesState];
    } else if ([state isEqualToString:@"Paused"]) {
        [scrollText setState:PAUSE];
        [self setDisplayStringFromiTunesState];
    } else if ([state isEqualToString:@"Stopped"]) {
        [scrollText setState:STOP];
        [scrollText clear];
    } else {
        [self printNotification:note];
    }
}

- (void) setDisplayStringFromiTunesState {
    iTunesTrack *track = [itunes currentTrack];
    // Could also be done with a string -> SEL dictionary...
    NSString *displayString = [formatString 
                     stringByReplacingOccurrencesOfString:@"%artist" withString:[track artist]];
    displayString = [displayString 
                     stringByReplacingOccurrencesOfString:@"%album" withString:[track album]];
    displayString = [displayString 
                     stringByReplacingOccurrencesOfString:@"%song" withString:[track name]];
    displayString = [displayString 
                     stringByReplacingOccurrencesOfString:@"%number" withString:[NSString stringWithFormat:@"%d", [track trackNumber]]];
    
    [scrollText setText:displayString];
}

@end
