//
//  DisplayController.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/28/12.
//
//

#import <Foundation/Foundation.h>
#import "DisplayModel.h"

@interface DisplayController : NSObject {
    DisplayModel *model;
}

- (IBAction) toggleShowIcons:(id)sender;
- (IBAction) toggleShowPauseText:(id)sender;

@end
