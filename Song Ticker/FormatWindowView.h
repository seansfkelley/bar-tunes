//
//  FormatWindowHandler.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class AppDelegate;

#import <Foundation/Foundation.h>
#import "MAAttachedWindow.h"
#import "AppDelegate.h"

@interface FormatWindowView : NSView <NSWindowDelegate> {
    MAAttachedWindow *formatWindow;
    IBOutlet NSTextField *formatTextField;
    
    IBOutlet NSButton *albumButton;
    IBOutlet NSButton *artistButton;
    IBOutlet NSButton *numberButton;
    IBOutlet NSButton *songButton;
}

@property AppDelegate *appDelegate;
@property NSView *anchor;

- (IBAction) bringFormatWindowToFront:(id)sender;
- (void) closeWindowWithoutSettingString:(id)sender;
- (IBAction) closeWindowAndSetFormatString:(id)sender;

- (IBAction) insertAlbumTag:(id)sender;
- (IBAction) insertArtistTag:(id)sender;
- (IBAction) insertNumberTag:(id)sender;
- (IBAction) insertSongTag:(id)sender;

@end
