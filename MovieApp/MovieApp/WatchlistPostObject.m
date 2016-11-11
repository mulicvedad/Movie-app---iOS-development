
#import "WatchlistPostObject.h"

@implementation WatchlistPostObject
-(id)initWithMediaID:(NSUInteger)mediaId mediaType:(MediaType)mediaType status:(BOOL)status{
    self=[super init];
    self.mediaID=mediaId;
    self.mediaType=mediaType==MovieType ? MovieMediaType : TVMediaType;
    self.status=status;
    return self;
}
+(NSDictionary *)propertiesMapping{
    return @{@"media_id":@"mediaID",
             @"media_type":@"mediaType",
             @"watchlist":@"status"
             };
}
@end
