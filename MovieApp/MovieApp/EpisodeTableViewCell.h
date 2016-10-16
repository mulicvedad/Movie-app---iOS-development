#import <UIKit/UIKit.h>

@interface EpisodeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *episodeTItleLabel;
@property (weak, nonatomic) IBOutlet UILabel *airDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

-(void)setupWithEpisodeTitle:(NSString *)title airDate:(NSString *)dateAsString rating:(CGFloat)rating ordinalNumber:(NSUInteger)number;
@end
