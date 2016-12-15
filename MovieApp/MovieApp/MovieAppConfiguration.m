#import "MovieAppConfiguration.h"

NSString * const RegularHelveticaFontName=@"HelveticaNeue";
NSString * const BoldHelveticaFontName=@"HelveticaNeue";
NSString * const YouTubeSiteName=@"YouTube";
NSString * const FilledStarCode= @"\u2605 ";
NSString *KeyChainItemWrapperIdentifier=@"myKeyChainWrapper";
NSString *SessionIDKeyChainKey=@"sessionID";
NSString *UsernameKeyChainKey=@"username";
NSString *FontAwesomeFontName=@"FontAwesome";

NSString *HeartFontAwesomeCode=@"\f004";
NSString *EmptyHeartFontAwesomeCode=@"\uf08a";
NSString *StarFontAwesomeCode=@"\f005";
NSString *EmptyStarFontAwesomeCode=@"\uf006";
NSString *WatchlistFontAwesomeCode=@"\uf02e";
NSString *EmptyWatchlistFontAwesomeCode=@"\uf097";

NSString *TVShowsNotificationsEnabledNSUserDefaultsKey=@"tvShowsNotificationsenabled";
NSString *MoviesNotificationsEnabledNSUserDefaultsKey=@"moviesNotificationsenabled";

NSString *LatestMoviesUserDefaultsKey=@"latestMovies";
NSString *AppGroupSuiteName=@"group.com.atlantbh.internship.MovieApp";
NSString *ShouldOpenMovieUserDefaultsKey=@"shouldOpenTVEvent";
NSString *SelectedMovieUserDefaultsKey=@"selectedMovie";

NSString *PosterPlaceholderSmall=@"poster-placeholder-new-medium";

@implementation MovieAppConfiguration

+(NSURL *)getFeedsSourceUrlPath{
    NSString *sourcePath= [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BoxOfficeAPI"];
    return [NSURL URLWithString:sourcePath];
}

+(NSString *)getApiKey{
    return [TheMovieDBConstants getTheMovieDbAPIKey];
}

+(NSURL *)getApiBaseURL{
    return [NSURL URLWithString:[TheMovieDBConstants getTheMovieDbAPIBaseURLPath]];
}

+(NSString *)getSearchSubpathForMovies{
    return  MovieDiscoverSubpath;
    
}

+(NSString *)getSearchSubpathForTvShows{
    return  TVShowDiscoverSubpath;
}

+(UIColor *)getPrefferedSectionHeadlineColor{
    return [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0];
}


+(UIColor *)getPrefferedYellowColor{
    return [UIColor colorWithRed:248/255.0 green:202/255.0 blue:0/255.0 alpha:1.0];
}

+(UIColor *)getPrefferedYellowColorWithOpacity:(CGFloat)opacity{
    return [UIColor colorWithRed:248/255.0 green:202/255.0 blue:0/255.0 alpha:opacity];
}

+(UIColor *)getPrefferedGreyColor{
    return [UIColor colorWithRed:137/255.0 green:136/255.0 blue:133/255.0 alpha:1.0];
}

+(UIColor *)getPreferredDarkGreyColor{
    return [UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1.0];
}

+(UIColor *)getPrefferedLightGreyColor{
    return [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
}


+(UIColor *)getResultsTableViewBackgroungColor{
    return [UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1.0];
}

+(UIFont *)getPreferredFontWithSize:(CGFloat)fontSize isBold:(BOOL)bold{
    return [UIFont fontWithName:bold ? BoldHelveticaFontName : RegularHelveticaFontName size:fontSize];
}


+(UIColor *)getGradientStartPointColor{
    return [UIColor colorWithRed:124/255.0 green:124/255.0 blue:124/255.0 alpha:0.2];
}

+(UIColor *)getGradientMiddlePointColor{
    return [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:0.68];
}

+(UIColor *)getGradientEndPointColor{
    return [UIColor colorWithRed:15/255.0 green:16/255.0 blue:15/255.0 alpha:1.0];
}

+(UIColor *)getPreferredTextColorForSearchBar{
    return [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0];

}

+(NSArray *)getCriteriaForLikedTVEventsSorting{
    return @[@"Movies",@"TV Shows"];
}

+(NSString *)getStringRepresentationOfSideMenuOption:(SideMenuOption)option{
    NSString *value=@"";
    switch (option) {
        case SideMenuOptionFavorites:
            value=@"Favorites";
            break;
        case SideMenuOptionWatchlist:
            value=@"Watchlist";
            break;
        case SideMenuOptionRatings:
            value=@"Ratings";
            break;
        case SideMenuOptionSettings:
            value=@"Settings";
            break;
        
        default:
            break;
    }
    return value;
}

+(BOOL)isConnectedToInternet{
    return NO;
}



@end
