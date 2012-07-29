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
    // Display MVC
    displayModel = [[DisplayModel alloc] init];
    [displayView setModel:displayModel];
    [displayController setModel:displayModel];
    
    // Display other
    [displayView setFormatController:formatController];
    
    // Format MVC
    formatModel = [[FormatStringModel alloc] init];
    [formatView setModel:formatModel];
    [formatController setModel:formatModel];
    [formatController setView:formatView];
    
    // Format other
    [formatView setAnchor:displayView];
    
    // Player MVC
    playerModel = [[PlayerModel alloc] init];
    [playerControlView setModel:playerModel];
    [playerController setModel:playerModel];
    
    // Player other
    [playerModel setItunes:[SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"]];
    [playerModel setSpotify:[SBApplication applicationWithBundleIdentifier:@"com.spotify.client"]];
    [playerModel initialize];
    
    // Set up other models
    [displayController setFormatModel:formatModel];
    [displayController setPlayerModel:playerModel];
    
    // Link up listeners
    [formatModel addObserver:displayController forKeyPath:@"formatString" options:0 context:nil];
    [playerModel addObserver:displayController forKeyPath:@"player" options:NSKeyValueObservingOptionOld context:nil];
    [displayModel addObserver:displayView forKeyPath:@"state" options:NSKeyValueObservingOptionNew |
                                                                      NSKeyValueObservingOptionOld context:nil];
    [displayModel addObserver:displayView forKeyPath:@"text" options:NSKeyValueObservingOptionNew |
                                                                     NSKeyValueObservingOptionOld context:nil];
    
    
    // Initialize display by firing event before we add it to the menu bar.
    [playerModel willChangeValueForKey:@"player"];
    [playerModel didChangeValueForKey:@"player"];
    
    NSStatusBar *systemStatusBar = [NSStatusBar systemStatusBar];
    NSStatusItem *statusItem = nil;
    
    // Undocumented behavior; may not always work. Fallback to standard behavior.
    if ([systemStatusBar respondsToSelector: @selector (_statusItemWithLength:withPriority:)]) {
        statusItem = [systemStatusBar _statusItemWithLength:0 withPriority:0];
        [statusItem setLength:NSVariableStatusItemLength];
    } else {
        statusItem = [systemStatusBar statusItemWithLength:NSVariableStatusItemLength];
    }
    
    [statusItem setHighlightMode:YES];
    [statusItem setView:displayView];
    [statusItem setMenu:playerControlView];
    
    [displayView setStatusItem:statusItem];
}

- (IBAction) quitApplication:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

@end
