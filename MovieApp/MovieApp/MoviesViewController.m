#import "MoviesViewController.h"
#import "MoviesCollectionViewCell.h"
#import "Movie.h"
#import "MovieDBDownloader.h"
#import "MovieAppConfiguration.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define BASE_IMAGE_URL @"http://image.tmdb.org/t/p/w185"
#define CRITERION_KEY @"criterion"
#define FILLED_STAR_CODE @"\u2605"
#define UNFILLED_STAR_CODE @"\u2606"
#define PREFFERED_DATE_FORMAT @"dd MMMM yyyy"

@interface MoviesViewController (){
    UISearchBar *searchBar;
    UIBarButtonItem *leftButton;
    UIBarButtonItem *rightButton;
    NSArray *movies;
    MovieDBDownloader *downloader;
}

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configureView];

    downloader = [[MovieDBDownloader alloc] init];
    [downloader configure];
    [self.sortSegmentedControl setSelectedSegmentIndex:2];
    [self.sortSegmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)configureView{
    
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
    cell.durationLabel.text = @"1h 45min";

    cell.starsLabel.text=@"";
    NSMutableString *stars=[[NSMutableString alloc]init];
    NSUInteger numberOfStars=[self numberOfStarsFromRating:currentMovie.voteAverage];
    
    for(int i=0;i<numberOfStars;i++){
        stars=[[stars stringByAppendingString:FILLED_STAR_CODE] mutableCopy];
    }
    for(int i=0;i<5-numberOfStars;i++){
        stars=[[stars stringByAppendingString:UNFILLED_STAR_CODE] mutableCopy];

    }
    cell.starsLabel.text=stars;
    
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
        [downloader getdMoviesByCriterion:(Criterion)sender.selectedSegmentIndex returnToHandler:self];
}

-(NSUInteger)numberOfStarsFromRating:(float)popularity{
    if(popularity<=2){
        return 1;
    }
    else if(popularity>2 && popularity<=4){
        return 2;
    }
    else if(popularity>4 && popularity<=6){
        return 3;
    }
    else if(popularity>6 && popularity<=8)
        return 4;
    else{
        return 5;
    }
}



@end
