#import "TVShowEpisodeDb.h"
#import "TVShowEpisode.h"

@implementation TVShowEpisodeDb

+(NSString *)primaryKey{
    return @"id";
}

+(TVShowEpisodeDb *)episodeDbWithEpisode:(TVShowEpisode *)episode{
    TVShowEpisodeDb *episodeDb=[[TVShowEpisodeDb alloc] init];
    episodeDb.id=episode.id;
    episodeDb.airDate=episode.airDate;
    episodeDb.name=episode.name;
    episodeDb.overview=episode.overview;
    episodeDb.episodeNumber=episode.episodeNumber;
    episodeDb.seasonNumber=episode.seasonNumber;
    episodeDb.voteAverage=episode.voteAverage;
    return episodeDb;
}
@end
