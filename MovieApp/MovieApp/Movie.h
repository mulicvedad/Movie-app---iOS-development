#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TVEvent.h"

@interface Movie : TVEvent

@property (nonatomic) BOOL hasVideo;

+(NSDictionary *)propertiesMapping;
+(void)initializeGenres:(NSArray *)genresArray;
@end
