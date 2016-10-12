#import <UIKit/UIKit.h>
#import "TVEvent.h"

@interface MovieDetailsViewController : UIViewController

@property (nonatomic, strong) TVEvent *tvEvent;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;

@end
