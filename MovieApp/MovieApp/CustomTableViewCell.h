#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, readonly) CGFloat height;

+ (CGFloat)cellHeight;
+ (NSString *)cellIdentifier;
+(NSString *)cellViewClassName;

@end
