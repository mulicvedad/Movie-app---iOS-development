#import <Foundation/Foundation.h>
#import "SelectedIndexChangeDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface SortByTableViewDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *sortByControlTableView;

-(void)configureWithCriteriaForSorting:(NSArray *)criteria selectionHandlerDelegate:(id<SelectedIndexChangeDelegate>)delegate;
-(NSUInteger)getSelectedIndex;
-(void)setIsFilterBy:(BOOL)filter;

@end
