#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SideMenuDelegate <NSObject>

@required
-(void)doActionForOption:(SideMenuOption)option;
@optional
-(void)presentSideMenuViewController:(UIViewController *)sideMenuViewController;
-(void)removeSideMenuViewController:(UIViewController *)sideMenuViewControllerOrNil;
@end
