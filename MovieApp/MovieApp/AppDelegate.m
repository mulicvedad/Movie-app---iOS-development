
#import "AppDelegate.h"
#import "MovieDBDownloader.h"
#import "Movie.h"
#import <UIKit/UIKit.h>

#define BASE_IMAGE_URL @"http://image.tmdb.org/t/p/w185"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    MovieDBDownloader *downloader;
    downloader = [MovieDBDownloader alloc];
    [downloader configure];
    [downloader getdMoviesByCriterion:TOP_RATED returnToHandler:self];
    return YES;
    
}

-(void)updateReceiverWithNewData:(NSMutableArray *)customItemsArray info:(NSDictionary *)info{
    _topRatedMovies=[NSArray arrayWithArray:customItemsArray];
    for(int i=0;i<[_topRatedMovies count];i++){
        NSURLSession *session=[NSURLSession sharedSession];
        __block Movie *currentMovie=(Movie *)_topRatedMovies[i];
        NSURL *imageUrl=[NSURL URLWithString:[BASE_IMAGE_URL stringByAppendingString:currentMovie.poster_path]];
        
        NSURLSessionDataTask *dataTask= [session dataTaskWithURL:imageUrl completionHandler:
                                         ^(NSData *data, NSURLResponse * response, NSError *eror)
                                         {
                                             currentMovie.posterImageData=data;
                                            
                                         } ];
        
        [dataTask resume];
    }
    
}

@end
