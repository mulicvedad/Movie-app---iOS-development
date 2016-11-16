#import <UIKit/UIKit.h>
#import "TVEvent.h"
#import "DataProviderService.h"
#import "TVEventsCollectionsStateChangeHandler.h"
#import "AddTVEventToCollectionDelegate.h"

@interface RatingViewController : UIViewController<TVEventsCollectionsStateChangeHandler>
@property (weak, nonatomic) IBOutlet UIStackView *starsStackView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) TVEvent *tvEvent;
-(void)setDelegate:(id<AddTVEventToCollectionDelegate>)delegate;
@end
