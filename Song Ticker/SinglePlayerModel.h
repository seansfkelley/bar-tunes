#import <Foundation/Foundation.h>

@interface SinglePlayerModel : NSObject

@property NSString *album;
@property NSString *artist;
@property NSString *name;
@property NSString *trackNumber;
@property PlayerState state;

- (void) copyInfoFrom:(NSDictionary*)info;

@end
