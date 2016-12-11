#import "TestViewController.h"
#import "PersonDb.h"

@interface TestViewController (){
    
}

@end
static NSString *numOfPersons=@"Number of persons: ";
static NSString *numOfBchelors=@"Number of bachelors: ";
static NSString *numOfMasters=@"Number of masters: ";
@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self update];
}

-(void)update{
    self.numberOfPersons.text=@"nils";
    self.numberOfBachelors.text=@"nils";
    self.numberOfMasters.text=@"nils";
}
- (IBAction)dodajStudenta:(UIButton *)sender {
    
}
- (IBAction)obrisiStudenta:(UIButton *)sender {
   

}

@end
