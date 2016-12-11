#import "TVShowSeasonDb.h"
#import "TvShowSeason.h"

@implementation TVShowSeasonDb

+(NSString *)primaryKey{
    return @"id";
}

+(TVShowSeasonDb *)seasonDbWithSeason:(TvShowSeason *)season{
    TVShowSeasonDb *newSeasonDb=[[TVShowSeasonDb alloc] init];
    
    newSeasonDb.id=season.id;
    newSeasonDb.airDate=season.airDate;
    newSeasonDb.episodeCount=season.episodeCount;
    newSeasonDb.posterPath=season.posterPath;
    newSeasonDb.seasonNumber=season.seasonNumber;
    
    return newSeasonDb;
}

@end
