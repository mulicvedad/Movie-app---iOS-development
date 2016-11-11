#import <UIKit/UIKit.h>
#import "CustomCellIdentityProtocol.h"
#import "ShowDetailsDelegate.h"

@interface FilmographyTableViewCell : UITableViewCell<CustomCellIdentityProtocol>
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

-(void)setupWithTVEventCredits:(NSArray *)credits delegateForSegue:(id<ShowDetailsDelegate>)delegate;

@end
