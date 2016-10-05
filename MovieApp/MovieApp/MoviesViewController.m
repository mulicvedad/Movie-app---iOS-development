#import "MoviesViewController.h"
#import "MoviesCollectionViewCell.h"
#import "Movie.h"
#import "MovieAppConfiguration.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"

#define BASE_IMAGE_URL @"http://image.tmdb.org/t/p/w185"
#define CRITERION_KEY @"criterion"
#define FILLED_STAR_CODE @"\u2605"
#define UNFILLED_STAR_CODE @"\u2606"
#define PREFFERED_DATE_FORMAT @"dd MMMM yyyy"
#define TEXT_FIELD_PROPERTY_NAME @"_searchField"

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
    [self configureView];

    [self.sortSegmentedControl setSelectedSegmentIndex:2];
    [self.sortSegmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)configureView{
    
    [_moviesCollectionView registerNib:[UINib nibWithNibName:[MovieAppConfiguration getMoviesCollectionViewCellNibName] bundle:nil]  forCellWithReuseIdentifier:[MovieAppConfiguration getMoviesCollectionViewCellIdentifier]];
    searchBar=[[UISearchBar alloc]init];
    searchBar.placeholder=@"Search";
    
    UITextField *txfSearchField = [searchBar valueForKey:TEXT_FIELD_PROPERTY_NAME];
    txfSearchField.backgroundColor = [UIColor darkGrayColor];
    
    self.navigationItem.titleView = searchBar;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return movies ? [movies count] : 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MoviesCollectionViewCell *cell = [_moviesCollectionView dequeueReusableCellWithReuseIdentifier:[MoviesCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    
    Movie *currentMovie=(Movie *)movies[indexPath.row];
    
    cell.titleLabel.text=currentMovie.title;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:PREFFERED_DATE_FORMAT];
    cell.releaseDateLabel.text=[dateFormatter stringFromDate:currentMovie.releaseDate];
    
    //hardcoded for now
    cell.genreLabel.text = @"Mistery, Thriller";
    cell.ratingLabel.text=[NSString stringWithFormat:@"%.1f", currentMovie.voteAverage];
    
    
    
    [cell.posterImageView sd_setImageWithURL:[NSURL URLWithString:[BASE_IMAGE_URL stringByAppendingString:currentMovie.posterPath]]];
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellWidth=collectionView.bounds.size.width/2-2;
 
    return CGSizeMake(cellWidth, [MoviesCollectionViewCell cellHeight]);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return [MoviesCollectionViewCell cellInsets];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2.0;
}

-(void)updateReceiverWithNewData:(NSMutableArray *)customItemsArray info:(NSDictionary *)info{
    movies=customItemsArray;
    [self.moviesCollectionView reloadData];
}

- (IBAction)sortByChanged:(UISegmentedControl *)sender {
        [ [AppDelegate sharedDownloader]  getdMoviesByCriterion:(Criterion)sender.selectedSegmentIndex returnToHandler:self];
}



@end
