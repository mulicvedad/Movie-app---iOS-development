
#import "MovieAppConfiguration.h"

#define HELVETICA_FONT @"HelveticaNeue"
#define HELVETICA_FONT_BOLD @"HelveticaNeue-Bold"


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

+(UIColor *)getPrefferedYellowColorWithOpacity:(CGFloat)opacity{
    return [UIColor colorWithRed:248/255.0 green:202/255.0 blue:0/255.0 alpha:opacity];
}

+(UIColor *)getPrefferedGreyColor{
    return [UIColor colorWithRed:137/255.0 green:136/255.0 blue:133/255.0 alpha:1.0];
}


+(UIColor *)getResultsTableViewBackgroungColor{
    return [UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1.0];
}

+(UIFont *)getPreferredFontWithSize:(CGFloat)fontSize isBold:(BOOL)bold{
    return [UIFont fontWithName:bold ? HELVETICA_FONT_BOLD : HELVETICA_FONT size:fontSize];
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


@end
