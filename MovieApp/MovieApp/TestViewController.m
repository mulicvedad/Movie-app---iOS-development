#import "TestViewController.h"
#import "PersonDb.h"

@interface TestViewController (){
    
}

@end
static NSString *numOfPersons=@"Number of persons: ";
static NSString *numOfBchelors=@"Number of bachelors: ";
static NSString *numOfMasters=@"Number of masters: ";
static NSInteger counter = 1;
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
    RLMRealm *realm = [RLMRealm defaultRealm];
    PersonDb *person=[[PersonDb alloc] init];
    
    person.id=counter++;
    person.name=@"Neko";
    person.birthDate=[NSDate date];

    //[realm beginWriteTransaction];
    //[realm commitWriteTransaction];
    [self update];
}
- (IBAction)obrisiStudenta:(UIButton *)sender {
    RLMRealm *realm = [RLMRealm defaultRealm];
    //[realm beginWriteTransaction];
    //[realm commitWriteTransaction];
    [self update];

}

@end
