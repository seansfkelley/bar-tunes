//
//  DisplayController.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/28/12.
//
//

#import <Foundation/Foundation.h>
#import "DisplayModel.h"
#import "ScrollingTextView.h"
#import "FormatStringPackage.h"
#import "PlayerModel.h"

@interface DisplayController : NSObject <NSMenuDelegate> {
    IBOutlet NSMenuItem *showIconsMenuItem;
    IBOutlet NSMenuItem *showPauseTextMenuItem;
}

@property DisplayModel *model;
@property ScrollingTextView *view;
@property PlayerModel *playerModel;
@property FormatStringModel *formatModel;

- (void) setShowIcons:(BOOL)showIcons;
- (void) setShowPauseText:(BOOL)showPauseText;

- (IBAction) toggleShowIcons:(id)sender;
- (IBAction) toggleShowPauseText:(id)sender;

// Called when the format string changes or the player info changes.
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

@end
