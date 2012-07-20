//
//  AppDelegate.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    scrollText = [[ScrollingTextView alloc] init];
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setView:scrollText];
    [statusItem setHighlightMode:YES];
    
    NSMenuItem *item = [statusMenu insertItemWithTitle:@"Quit" 
                                                action:@selector(quitApplication) 
                                         keyEquivalent:@"" 
                                               atIndex:0];
    [item setTarget:self];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(iTunesPlayerInfoNotification:)
                                                            name:@"com.apple.iTunes.playerInfo"
                                                          object:nil];
}

- (void)quitApplication{
    [[NSApplication sharedApplication] terminate:nil];
}

- (void)openItunes{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"openitunes" ofType:@"scpt"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSDictionary* errors = [NSDictionary dictionary];
    NSAppleScript* appleScript = [[NSAppleScript alloc] initWithContentsOfURL:url error:&errors];
    [appleScript executeAndReturnError:nil];
}

- (void) iTunesPlayerInfoNotification:(NSNotification*) note {
//    NSString *object = [note object];
//    NSString *name = [note name];
//    NSDictionary *userInfo = [note userInfo];
//    NSLog(@"<%p>%s: object: %@ name: %@ userInfo: %@", self, __PRETTY_FUNCTION__, object, name, userInfo);
    
    NSDictionary *userInfo = [note userInfo];
    NSString *state = [userInfo objectForKey:@"Player State"];
    NSString *artist = [userInfo objectForKey:@"Artist"];
    NSString *title = [userInfo objectForKey:@"Name"];
    
    if ([state isEqualToString:@"Playing"]) {
        [scrollText setText:[NSString stringWithFormat:@"Playing: %@ — %@", artist, title]];
    } else if ([state isEqualToString:@"Paused"]) {
        [scrollText setText:[NSString stringWithFormat:@"Paused: %@ — %@", artist, title]];
    } else {
        return;
    }
}

@end
