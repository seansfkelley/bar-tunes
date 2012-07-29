//
//  FormatWindowHandler.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAAttachedWindow.h"
#import "FormatStringModel.h"

@interface FormatStringView : NSView {
    MAAttachedWindow *formatWindow;
    IBOutlet NSTextField *formatTextField;
    
    IBOutlet NSButton *albumButton;
    IBOutlet NSButton *artistButton;
    IBOutlet NSButton *numberButton;
    IBOutlet NSButton *songButton;
}

@property FormatStringModel *model;
@property NSView *anchor;

- (NSString*) formatFieldContents;

- (void) bringFormatWindowToFrontWithDelegate:(id<NSWindowDelegate>)delegate;
- (void) closeWindow:(id)sender;

- (IBAction) insertAlbumTag:(id)sender;
- (IBAction) insertArtistTag:(id)sender;
- (IBAction) insertNumberTag:(id)sender;
- (IBAction) insertSongTag:(id)sender;

@end
