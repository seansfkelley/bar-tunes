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

@interface FormatWindowHandler : NSView <NSWindowDelegate> {
    MAAttachedWindow *formatMAWindow;
    IBOutlet NSTextField *formatTextField;
}

@property AppDelegate *appDelegate;
@property NSView *anchor;

- (IBAction) bringFormatWindowToFront:(id)sender;
- (void) closeWindowWithoutSettingString:(id)sender;
- (IBAction) closeWindowAndSetFormatString:(id)sender;

@end
