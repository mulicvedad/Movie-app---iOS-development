#import "TvShowSeason.h"

static NSString * const YearDateFormat=@"yyyy";

@implementation TvShowSeason


+(NSDictionary *)propertiesMapping{
    return @{@"air_date":@"airDate",
             @"episode_count":@"episodeCount",
             @"id":@"id",
             @"poster_path":@"posterPath",
             @"season_number":@"seasonNumber"
             };
}

+(NSString *)getStringOfYearsForSeasons:(NSArray *)seasons{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    NSString *dateString;
    [dateFormatter setDateFormat:YearDateFormat];
    
    NSMutableString *yearsAsString=[NSMutableString stringWithString:@""];
    
    for(int i=(int)[seasons count]-1;i>=0;i--){
        NSDate *currentDate=((TvShowSeason *)seasons[i]).airDate;
        if(currentDate){
            dateString=[dateFormatter stringFromDate:currentDate];
            [yearsAsString appendFormat:@"%@ ",dateString];
        }
        
    }
    return yearsAsString;
}

-(NSString *)getReleaseYear{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    NSString *dateString;
    [dateFormatter setDateFormat:YearDateFormat];
    dateString=[dateFormatter stringFromDate:self.airDate];
    return dateString;
}

+(TvShowSeason *)seasonWithSeasonDb:(TVShowSeasonDb *)seasonDb{
    TvShowSeason *newSeason=[[TvShowSeason alloc] init];
    
    newSeason.id=seasonDb.id;
    newSeason.airDate=seasonDb.airDate;
    newSeason.episodeCount=seasonDb.episodeCount;
    newSeason.posterPath=seasonDb.posterPath;
    newSeason.seasonNumber=seasonDb.seasonNumber;
    
    return newSeason;
}
+(NSArray *)seasonsArrayWithRLMArray:(RLMResults *)results{
    NSMutableArray *newSeasons=[[NSMutableArray alloc] init];
    for(TVShowSeasonDb *seasonDb in results){
        [newSeasons addObject:[TvShowSeason seasonWithSeasonDb:seasonDb]];
    }
    return newSeasons;
}


@end
