#import "TVShowEpisode.h"

static NSString * const DefaultDateFormat=@"dd MMMM yyyy";

@implementation TVShowEpisode

+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"air_date":@"airDate",
             @"name":@"name",
             @"overview":@"overview",
             @"episode_number":@"episodeNumber",
             @"vote_average":@"voteAverage",
             @"season_number":@"seasonNumber"
             };
}

-(NSString *)getFormattedAirDate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    NSString *dateString=@"";
    if(self.airDate){
        [dateFormatter setDateFormat:DefaultDateFormat];
        dateString=[dateFormatter stringFromDate:self.airDate];
    }
    return dateString;
}

+(TVShowEpisode *)episodeWithEpisodeDb:(TVShowEpisodeDb *)episodeDb{
    TVShowEpisode *newEpisode=[[TVShowEpisode alloc] init];
    
    newEpisode.id=episodeDb.id;
    newEpisode.airDate=episodeDb.airDate;
    newEpisode.name=episodeDb.name;
    newEpisode.overview=episodeDb.overview;
    newEpisode.episodeNumber=episodeDb.episodeNumber;
    newEpisode.seasonNumber=episodeDb.seasonNumber;
    newEpisode.voteAverage=episodeDb.voteAverage;
    
    return newEpisode;
}

+(NSArray *)episodesArrayWithRLMArray:(RLMResults *)results{
    NSMutableArray *newEpisodes=[[NSMutableArray alloc] init];
    for(TVShowEpisodeDb *episodeDb in results){
        [newEpisodes addObject:[TVShowEpisode episodeWithEpisodeDb:episodeDb]];
    }
    return newEpisodes;
}

@end
