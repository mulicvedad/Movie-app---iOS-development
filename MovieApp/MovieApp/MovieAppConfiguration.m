
#import "MovieAppConfiguration.h"

@implementation MovieAppConfiguration

+(NSURL *)getFeedsSourceUrlPath{
    NSString *sourcePath= [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BoxOfficeAPI"];
    return [NSURL URLWithString:sourcePath];
}

+(NSString *)getApiKey{
    return @"0bb62fb7a597e6b58ba06172fbd214f6";
}

+(NSURL *)getApiBaseURL{
    return [NSURL URLWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"TheMovieDBBaseUrl"]];
}

+(NSString *)getSearchSubpathForMovies{
    return  @"/3/discover/movie";

}

+(NSString *)getSearchSubpathForTvShows{
    return  @"/3/discover/tv";
}

+(UIColor *)getPrefferedSectionHeadlineColor{
   return [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0];
}

+(UIColor *)getPrefferedYellowColor{
    return [UIColor colorWithRed:248/255.0 green:202/255.0 blue:0/255.0 alpha:1.0];
}




@end
