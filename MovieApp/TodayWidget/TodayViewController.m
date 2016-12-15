#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "MovieWidgetTableViewCell.h"
#import "MainMovieWidgetTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define AF_APP_EXTENSIONS
@interface TodayViewController () <NCWidgetProviding>

@end

static NSString *AppGroupSuiteName=@"group.com.atlantbh.internship.MovieApp";
static NSString *LatestMoviesUserDefaultsKey=@"latestMovies";
static NSString *ShouldOpenMovieUserDefaultsKey=@"shouldOpenTVEvent";
static NSString *SelectedMovieUserDefaultsKey=@"selectedMovie";
static NSString *WidgetBundleIdentifier=@"com.atlantbh.internship.MovieApp.TodayWidget";
static NSString *BaseImageUrlForWidth92=@"http://image.tmdb.org/t/p/w92";
static NSString *PosterPlaceholderImageName=@"movie-poster";

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [self updateMovies];

   // [self.extensionContext setWidgetLargestAvailableDisplayMode:NCWidgetDisplayModeExpanded];
}

-(void)configure{
    [self.moviesTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MovieWidgetTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MovieWidgetTableViewCell class])];
    [self.moviesTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MainMovieWidgetTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MainMovieWidgetTableViewCell class])];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    [self updateMovies];
    if(self.movies.count==0){
        completionHandler(NCUpdateResultFailed);
    }
    else{
        [self.moviesTableView reloadData];
        completionHandler(NCUpdateResultNewData);

    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return 76.0f;
    }
    else{
        return 35.0f;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        MainMovieWidgetTableViewCell *cell=[self.moviesTableView dequeueReusableCellWithIdentifier:NSStringFromClass([MainMovieWidgetTableViewCell class])];
        TVEvent *currentTVEvent=self.movies[indexPath.row];
        [cell setupWithTVEvent:currentTVEvent];
        [cell.posterImageView sd_setImageWithURL:[NSURL URLWithString:[BaseImageUrlForWidth92 stringByAppendingString:currentTVEvent.posterPath]] placeholderImage:[UIImage imageNamed:PosterPlaceholderImageName]];
        return cell;
    }
    else{
        MovieWidgetTableViewCell *cell=[self.moviesTableView dequeueReusableCellWithIdentifier:NSStringFromClass([MovieWidgetTableViewCell class])];
        [cell setupWithTVEvent:self.movies[indexPath.row]];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *std=[[NSUserDefaults standardUserDefaults] initWithSuiteName:AppGroupSuiteName];
    [std setBool:YES forKey:ShouldOpenMovieUserDefaultsKey];
    NSData *movieData=[NSKeyedArchiver archivedDataWithRootObject:self.movies[indexPath.row]];
    [std setObject:movieData forKey:SelectedMovieUserDefaultsKey];
    
    NSURL *url=[NSURL URLWithString:@"com.atlantbh.internship.MovieApp:"];
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        if(success){
            NSLog(@"successfull app launch");
        }
        else{
            NSLog(@"NOT successfull app launch");

        }
    }];
}
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize{
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake(0, 120);
    }
    else
        self.preferredContentSize = CGSizeMake(0, 320);
}

-(void)updateMovies{
    NSUserDefaults *std=[[NSUserDefaults standardUserDefaults] initWithSuiteName:AppGroupSuiteName];
    NSArray *moviesData = [std objectForKey:LatestMoviesUserDefaultsKey];
    NSMutableArray *tmp=[[NSMutableArray alloc] init];
    for(int i=0;i<moviesData.count;i++){
        TVEvent *movie=[NSKeyedUnarchiver unarchiveObjectWithData:moviesData[i]];
        [tmp addObject:movie];
    }
    
    self.movies=tmp;
    
    NCWidgetController *widgetController = [NCWidgetController widgetController];

    if(self.movies.count==0){
       [widgetController setHasContent:NO forWidgetWithBundleIdentifier:WidgetBundleIdentifier];
    }
    else{
       [widgetController setHasContent:YES forWidgetWithBundleIdentifier:WidgetBundleIdentifier];

    }
    
}
@end
