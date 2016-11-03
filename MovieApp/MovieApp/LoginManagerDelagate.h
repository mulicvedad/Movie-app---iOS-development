#import <Foundation/Foundation.h>

@protocol LoginManagerDelegate <NSObject>

@required
-(void)loginSucceededWithSessionID:(NSString *)sessionID;
-(void)loginFailedWithError:(NSError *)error;

@end
