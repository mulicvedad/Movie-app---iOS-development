#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SelectedIndexChangeDelegate.h"

@interface SortByControlTableViewDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *criterions;

-(NSUInteger)getSelectedIndex;
-(void)registerDelegate:(id<SelectedIndexChangeDelegate>)delegate;

@end
