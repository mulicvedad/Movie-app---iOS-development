#import "MoviesViewController.h"

@interface MoviesViewController ()

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   /* trying to load image for when tab bar item is selected 
    
    UITabBar *tabBar = self.navigationController.tabBarController.tabBar;
    UITabBarItem *targetTabBarItem = [[tabBar items] objectAtIndex:1];
    UIImage *selectedIcon = [UIImage imageNamed:@"movies-active"];
    [targetTabBarItem setSelectedImage:selectedIcon];
    
    UIImage *image = targetTabBarItem.image;
    UIImage *selImage = targetTabBarItem.selectedImage;
    */

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
