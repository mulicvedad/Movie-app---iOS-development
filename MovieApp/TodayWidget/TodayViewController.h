#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *movies;

@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;

@end
