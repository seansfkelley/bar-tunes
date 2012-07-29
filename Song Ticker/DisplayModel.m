//
//  DisplayModel.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/28/12.
//
//

#import "DisplayModel.h"

@implementation DisplayModel

@synthesize text;
@synthesize state;
@synthesize showIcons;
@synthesize showPauseText;
@synthesize menuVisible;

- (DisplayModel*) init {
    self = [super init];
    text = @"";
    return self;
}

@end
