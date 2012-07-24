//
//  FormatWindowHandler.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FormatWindowHandler.h"

@implementation FormatWindowHandler

@synthesize appDelegate;
@synthesize anchor;

- (IBAction) bringFormatWindowToFront:(NSMenuItem*)sender{
    NSRect anchorFrame = [[anchor window] frame];
    formatMAWindow = [[MAAttachedWindow alloc] initWithView:self
                                            attachedToPoint:NSMakePoint(anchorFrame.origin.x + anchorFrame.size.width / 2, anchorFrame.origin.y)
                                                     onSide:NSMinYEdge
                                                 atDistance:5.0];
    [formatMAWindow setDelegate:self];
    [NSApp activateIgnoringOtherApps:YES];
    [formatMAWindow makeKeyAndOrderFront:self];
    [formatTextField setObjectValue:[appDelegate formatString]];
}

- (void) closeWindowWithoutSettingString:(id)sender {
    [formatMAWindow orderOut:self];
}

- (IBAction) closeWindowAndSetFormatString:(id)sender {
    [appDelegate setFormatString:[formatTextField objectValue]];
    [formatMAWindow orderOut:self];
}

- (void) windowDidResignKey:(NSNotification *)note {
    [self closeWindowWithoutSettingString:self];
}

@end
