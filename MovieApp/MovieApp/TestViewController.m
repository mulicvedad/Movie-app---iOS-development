#import "TestViewController.h"

@interface TestViewController ()

@end
static NSString *numOfPersons=@"Number of persons: ";
static NSString *numOfBchelors=@"Number of bachelors: ";
static NSString *numOfMasters=@"Number of masters: ";
static NSInteger counter = 1;
@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
    NSLog(@"LOKACIJA BAZE :%@", [RLMRealm defaultRealm].configuration.fileURL);
}

-(void)configure{
    RLMResults<StudentBachelor *> *resultsBachelor = [StudentBachelor allObjects];
    RLMResults<StudentMaster *> *resultsMaster = [StudentMaster allObjects];

    self.numberOfPersons.text=[numOfPersons stringByAppendingString:[NSString stringWithFormat:@"%lu", resultsBachelor.count + resultsMaster.count]];
    self.numberOfBachelors.text=[numOfBchelors stringByAppendingString:[NSString stringWithFormat:@"%lu", resultsBachelor.count]];
    self.numberOfMasters.text=[numOfMasters stringByAppendingString:[NSString stringWithFormat:@"%lu",resultsMaster.count]];
}
- (IBAction)dodajStudenta:(UIButton *)sender {
    RLMRealm *realm = [RLMRealm defaultRealm];
    PersonDb *person=[[PersonDb alloc] init];
    
    person.id=counter++;
    person.name=@"Neko";
    person.city=@"Rajvosica";
    person.birthDate=[NSDate date];
    
    StudentBachelor *studentBac = [[StudentBachelor alloc] init];
    studentBac.person = person;
    studentBac.yearOfGraduation = 2014;
    studentBac.id=person.id;
    Pet *newPet=[[Pet alloc] init];
    newPet.name=@"pikej";
    [studentBac.pets addObject:newPet];
    newPet = [[Pet alloc] initWithValue:@{@"name":@"pikej2"}];
    [studentBac.pets addObject:newPet];
    [realm beginWriteTransaction];
    [realm addObject:studentBac];
    [realm commitWriteTransaction];
    [self configure];
}
- (IBAction)obrisiStudenta:(UIButton *)sender {
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults<StudentBachelor *> *rezz =  [StudentBachelor allObjects];
    [realm beginWriteTransaction];
    [realm deleteObjects:rezz];
    [realm commitWriteTransaction];
    [self configure];

}

@end
