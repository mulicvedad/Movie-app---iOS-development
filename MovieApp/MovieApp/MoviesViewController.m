#import "MoviesViewController.h"
#import "MoviesCollectionViewCell.h"
#import "Movie.h"
#import "MovieDBDownloader.h"


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
    
     [_moviesCollectionView registerNib:[UINib nibWithNibName:@"MoviesCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:@"collectionCell"];
    
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
    
    MovieDBDownloader *downloader = [MovieDBDownloader alloc];
    [downloader configure];
    [downloader getdMoviesByCriterion:TOP_RATED returnToHandler:self];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [movies count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
     MoviesCollectionViewCell *cell = [_moviesCollectionView dequeueReusableCellWithReuseIdentifier:[MoviesCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    
    cell.titleLabel.text=((Movie *)movies[indexPath.row]).title;
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth=collectionView.bounds.size.width/2-[MoviesCollectionViewCell cellInsets].left*2 - [MoviesCollectionViewCell cellInsets].right*2;
    
    
    
    return CGSizeMake(cellWidth, [MoviesCollectionViewCell cellHeight]);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return [MoviesCollectionViewCell cellInsets];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

-(void)updateViewWithNewData:(NSMutableArray *)customItemsArray{
    movies=[NSArray arrayWithArray:customItemsArray];
    [self.moviesCollectionView reloadData];
}

@end
