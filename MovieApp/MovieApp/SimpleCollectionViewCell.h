#import <UIKit/UIKit.h>

@interface SimpleCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *seasonNumberLabel;

+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

@end
