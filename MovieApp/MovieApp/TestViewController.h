#import <UIKit/UIKit.h>
#import "StudentMaster.h"
#import "StudentBachelor.h"
#import <Realm/RLMRealm.h>

@interface TestViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *numberOfPersons;
@property (weak, nonatomic) IBOutlet UILabel *numberOfBachelors;
@property (weak, nonatomic) IBOutlet UILabel *numberOfMasters;

@end
