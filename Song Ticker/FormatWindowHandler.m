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

- (void) awakeFromNib {
    // Set text to white; we also have to redo the size and alignment since we're clobbering
    // what we set in the .xib.
    NSMutableParagraphStyle *centerStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [centerStyle setAlignment:NSCenterTextAlignment];
    NSDictionary *buttonTitleAttrs = [[NSMutableDictionary alloc] init];
	[buttonTitleAttrs setValue:[NSFont systemFontOfSize:11.0] forKey:NSFontAttributeName];
	[buttonTitleAttrs setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	[buttonTitleAttrs setValue:centerStyle forKey:NSParagraphStyleAttributeName];
    
    [albumButton  setAttributedTitle:[[NSAttributedString alloc] initWithString:@"%album" attributes:buttonTitleAttrs]];
    [artistButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"%artist" attributes:buttonTitleAttrs]];
    [numberButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"%number" attributes:buttonTitleAttrs]];
    [songButton   setAttributedTitle:[[NSAttributedString alloc] initWithString:@"%song" attributes:buttonTitleAttrs]];
} 

- (IBAction) bringFormatWindowToFront:(id)sender{
    NSRect anchorFrame = [[anchor window] frame];
    formatWindow = [[MAAttachedWindow alloc] initWithView:self
                                            attachedToPoint:NSMakePoint(anchorFrame.origin.x + anchorFrame.size.width / 2, anchorFrame.origin.y)
                                                     onSide:NSMinYEdge
                                                 atDistance:5.0];
    [formatWindow setDelegate:self];
    [NSApp activateIgnoringOtherApps:YES];
    [formatWindow makeKeyAndOrderFront:self];
    [formatTextField setObjectValue:[appDelegate formatString]];
}

- (void) closeWindowWithoutSettingString:(id)sender {
    [formatWindow orderOut:self];
}

- (IBAction) closeWindowAndSetFormatString:(id)sender {
    NSString *formatString = [[formatTextField objectValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // Best-effort check to enforce something probably sensible is being entered.
    if (![formatString isEqualToString:@""] && ([formatString rangeOfString:@"%album"].location != NSNotFound || 
                                                [formatString rangeOfString:@"%artist"].location != NSNotFound || 
                                                [formatString rangeOfString:@"%number"].location != NSNotFound ||
                                                [formatString rangeOfString:@"%song"].location != NSNotFound)) {
        [appDelegate setFormatString:formatString];
    }
    [formatWindow orderOut:self];
}

- (void) windowDidResignKey:(NSNotification *)note {
    [self closeWindowWithoutSettingString:self];
}

- (void) cancelOperation:(id)sender {
    [self closeWindowWithoutSettingString:sender];
}

- (IBAction) insertAlbumTag:(id)sender {
    [formatTextField setStringValue:[[NSString alloc] initWithFormat:@"%@%%album", [formatTextField stringValue]]];    
}

- (IBAction) insertArtistTag:(id)sender {
    [formatTextField setStringValue:[[NSString alloc] initWithFormat:@"%@%%artist", [formatTextField stringValue]]];
}

- (IBAction) insertNumberTag:(id)sender {
    [formatTextField setStringValue:[[NSString alloc] initWithFormat:@"%@%%number", [formatTextField stringValue]]];
}

- (IBAction) insertSongTag:(id)sender {
    [formatTextField setStringValue:[[NSString alloc] initWithFormat:@"%@%%song", [formatTextField stringValue]]];
}

@end
