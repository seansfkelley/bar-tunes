//
//  AppDelegate.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize itunes;

- (void) awakeFromNib {
    itunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    
    [tokenField setTokenizingCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@""]];
    
    scrollText = [[ScrollingTextView alloc] init];
    
    NSStatusItem* statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setHighlightMode:YES];
    [statusItem setView:scrollText];
    [statusItem setMenu:statusMenu];
    
    [scrollText setStatusItem:statusItem];
    
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

- (IBAction) closeWindowAndSetFormatString:(id)sender {
    NSLog(@"%@", [tokenField objectValue]);
    [formatWindow close];
}

- (IBAction) quitApplication:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

- (IBAction) bringFormatWindowToFront:(id)sender{
    [NSApp activateIgnoringOtherApps:YES];
    [formatWindow makeKeyAndOrderFront:nil];
    // Initialize token field.
}

- (void) setDisplayStringFromiTunesState {
    iTunesTrack *track = [itunes currentTrack];
    [scrollText setText:[NSString stringWithFormat:@"%@ — %@", [track artist], [track name]]];
}

- (void) printNotification:(NSNotification*)note {
    NSString *object = [note object];
    NSString *name = [note name];
    NSDictionary *userInfo = [note userInfo];
    NSLog(@"<%p>%s: object: %@ name: %@ userInfo: %@", self, __PRETTY_FUNCTION__, object, name, userInfo);
}

- (void) openItunes{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"openitunes" ofType:@"scpt"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSDictionary* errors = [NSDictionary dictionary];
    NSAppleScript* appleScript = [[NSAppleScript alloc] initWithContentsOfURL:url error:&errors];
    [appleScript executeAndReturnError:nil];
}

- (void) iTunesPlayerInfoNotification:(NSNotification*)note {
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

@end
