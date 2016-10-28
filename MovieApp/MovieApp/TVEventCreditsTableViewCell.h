#import <UIKit/UIKit.h>
#import "CrewMember.h"
#import "CastMember.h"

@interface TVEventCreditsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *directorLabelLeft;
@property (weak, nonatomic) IBOutlet UILabel *directrorLabelRight;
@property (weak, nonatomic) IBOutlet UILabel *writersLabelLeft;
@property (weak, nonatomic) IBOutlet UILabel *writersLabelRight;
@property (weak, nonatomic) IBOutlet UILabel *starsLabelLeft;
@property (weak, nonatomic) IBOutlet UILabel *starsLabelRight;


-(void)setupWithDirector:(NSString *)director writers:(NSString *)writers stars:(NSString *)stars;
-(void)setupWithCrew:(NSArray *)crew cast:(NSArray *)cast;
+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

@end
