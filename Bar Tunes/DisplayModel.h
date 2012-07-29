#import <Foundation/Foundation.h>

@interface DisplayModel : NSObject

@property NSString *text;
@property PlayerState state;
@property BOOL showIcons;
@property BOOL showPauseText;
// Transient
@property BOOL menuVisible;

@end
