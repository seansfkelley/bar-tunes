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
