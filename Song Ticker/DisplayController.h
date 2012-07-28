//
//  DisplayController.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/28/12.
//
//

#import <Foundation/Foundation.h>
#import "DisplayModel.h"

@interface DisplayController : NSObject

@property DisplayModel *model;

- (IBAction) toggleShowIcons:(id)sender;
- (IBAction) toggleShowPauseText:(id)sender;

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

@end
