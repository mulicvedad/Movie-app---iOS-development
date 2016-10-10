#import <UIKit/UIKit.h>

@interface BasicInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;

+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;
-(void)setupWithReleaseDate:(NSString *)dateString duration:(NSUInteger)duration genres:(NSString *)genresRepresentation;

@end
