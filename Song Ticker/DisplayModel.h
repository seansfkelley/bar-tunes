//
//  DisplayModel.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/28/12.
//
//

#import <Foundation/Foundation.h>

@interface DisplayModel : NSObject

@property NSString *text;
@property PlayerState state;
@property BOOL showIcons;
@property BOOL showPauseText;

@end
