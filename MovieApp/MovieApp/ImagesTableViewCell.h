#import <UIKit/UIKit.h>

@interface ImagesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *posterImageViews;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

-(void)setupWithUrls:(NSArray *)urls;
+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

@end
