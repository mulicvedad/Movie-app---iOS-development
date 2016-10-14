
#import <UIKit/UIKit.h>

@interface SeasonSelectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;
    
@end
