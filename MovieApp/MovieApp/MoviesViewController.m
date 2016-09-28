#import "MoviesViewController.h"
#import "MoviesCollectionViewCell.h"

@interface MoviesViewController (){
    UISearchBar *searchBar;
    UIBarButtonItem *leftButton;
    UIBarButtonItem *rightButton;
    NSArray *movies;
}

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     [self.collectionView registerNib:[UINib nibWithNibName:@"MoviesCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:@"collectionCell"];
    
    searchBar = [[UISearchBar alloc] init];
    leftButton = [[UIBarButtonItem alloc]init];
    rightButton = [[UIBarButtonItem alloc]init];
    
    searchBar.placeholder=@"Search";
    
    leftButton.title=@"left";
    leftButton.tintColor=[UIColor whiteColor];
    
    rightButton.title=@"right";
    rightButton.tintColor=[UIColor whiteColor];
    
    self.navigationItem.titleView = searchBar;
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
     MoviesCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    cell.labelTest.text=@"test";
    
    return cell;
    
}

@end
