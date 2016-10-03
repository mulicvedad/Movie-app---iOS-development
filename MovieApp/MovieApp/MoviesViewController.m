#import "MoviesViewController.h"
#import "MoviesCollectionViewCell.h"
#import "Movie.h"
#import "MovieDBDownloader.h"
#import "AppDelegate.h"
#import "MovieAppConfiguration.h"

#define BASE_IMAGE_URL @"http://image.tmdb.org/t/p/w185"
#define TOP_RATED_MOVIES_KEY @"top_rated_movies"
#define MOST_POPULAR_MOVIES_KEY @"most_popular_movies"
#define LATEST_MOVIES_KEY @"latest_movies"

@interface MoviesViewController (){
    UISearchBar *searchBar;
    UIBarButtonItem *leftButton;
    UIBarButtonItem *rightButton;
    NSArray *topRatedMovies;
    NSArray *mostPopularMovies;
    NSArray *latestMovies;
    MovieDBDownloader *downloader;
    AppDelegate *myAppDelegate;
    static const NSArray *criterionsForSorting=@[@"most_popular",@"top_rated",@"latest"];
}

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.sortSegmentedControl setSelectedSegmentIndex:2];
    myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [Movie saveArrayOfMovies:myAppDelegate.topRatedMovies forKey:TOP_RATED_MOVIES_KEY];
    
    [_moviesCollectionView registerNib:[UINib nibWithNibName:[MovieAppConfiguration getMoviesCollectionViewCellNibName] bundle:nil]  forCellWithReuseIdentifier:[MovieAppConfiguration getMoviesCollectionViewCellIdentifier]];
    
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
    return [myAppDelegate.topRatedMovies count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MoviesCollectionViewCell *cell = [_moviesCollectionView dequeueReusableCellWithReuseIdentifier:[MoviesCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    
    NSArray *moviesFromDB=[Movie loadArrayOfMoviesForKey:TOP_RATED_MOVIES_KEY];
    Movie *currentMovie=(Movie *)moviesFromDB[indexPath.row];
    
    cell.titleLabel.text=currentMovie.title;
    cell.releaseDateLabel.text=[NSString stringWithFormat:@"%.2f", currentMovie.vote_average];
    cell.durationLabel.text = [NSString stringWithFormat:@"%d",(int)(currentMovie.vote_count)];
    cell.posterImageView.image=[UIImage imageWithData:currentMovie.posterImageData];
    
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

-(void)updateReceiverWithNewData:(NSMutableArray *)customItemsArray info:(NSDictionary *)info{
    NSString *criterionForSorting=[info objectForKey:@"criterion"];
    
    if([criterionForSorting isEqualToString:criterionsForSortingp[TOP_RATED]){
        topRatedMovies=[NSArray arrayWithArray:customItemsArray];
    }
    else if([criterionForSorting isEqualToString:criterionsForSortingp[MOST_POPULAR]){
        mostPopularMovies=[NSArray arrayWithArray:customItemsArray];
    }
    else{
        latestMovies=[NSArray arrayWithArray:customItemsArray];
    }
    
    [self.moviesCollectionView reloadData];
}

- (IBAction)sortByChanged:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex==0){
        
    }
}
@end
