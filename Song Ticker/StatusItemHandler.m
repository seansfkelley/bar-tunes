//
//  StatusItemHandler.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatusItemHandler.h"

@implementation StatusItemHandler

- (void) menuWillOpen:(NSMenu*)menu {
    menuVisible = YES;
    [self setNeedsDisplay:YES];
}

- (void) menuDidClose:(NSMenu *)menu {
    menuVisible = NO;
    [[self menu] setDelegate:nil];
    [self setNeedsDisplay:YES];
}

@end
