#import <UIKit/UIKit.h>

@interface ImagesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *posterImageViews;

-(void)setupWithUrls:(NSArray *)urls;
+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

@end
