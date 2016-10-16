#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"

@interface FeedTableViewCell : CustomTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *linkTextView;

-(void)setupWithHeadline:(NSString *)pHeadline text:(NSString *)pText sourceUrlPath:(NSString *)pUrlPath;


@end
