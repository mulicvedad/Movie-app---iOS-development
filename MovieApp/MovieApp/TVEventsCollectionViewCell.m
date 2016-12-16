#import "TVEventsCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Movie.h"
#import "TVShow.h"
#import "TheMovieDBConstants.h"
#import <KeychainItemWrapper.h>
#import "DataProviderService.h"
#import "DatabaseManager.h"

#define FontSize10 10
#define FontSize16 16

@interface TVEventsCollectionViewCell(){
    CAGradientLayer *_myGradientLayer;
    NSUInteger _indexPathRowNumber;
}

@end

static NSString * const MovieDateFormat=@"dd MMMM yyyy";
static NSString * const TVshowDateFormat=@"yyyy";
static NSString * const DefaultImageName=@"black_image";
static NSString * const PlaceholderImageName=@"poster-placeholder-new-medium";
static NSString * const TVShowReleaseDatePrefix=@"Tv Series ";
static CGFloat const StartPointX=0.5f;
static CGFloat const StartPointY=0.25f;
static CGFloat const EndPointX=0.5f;
static CGFloat const EndPointY=0.75f;
static NSString *FavoritesSelectedImageName=@"favorites-selected";
static NSString *FavoritesNormalImageName=@"favorites";

static NSString *WatchlistSelectedImageName=@"watchlist-selected";
static NSString *WatchlistNormalImageName=@"watchlist";



@interface TVEventsCollectionViewCell (){
    id<AddTVEventToCollectionDelegate> _delegate;
}

@end

@implementation TVEventsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
    
}

-(void)configure{
    _myGradientLayer=[[CAGradientLayer alloc]init];
    
    _myGradientLayer.frame = self.frame;
    _myGradientLayer.startPoint = CGPointMake(StartPointX,StartPointY);
    _myGradientLayer.endPoint = CGPointMake(EndPointX, EndPointY);
    _myGradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],
                               (id)[[UIColor blackColor] CGColor],
                               nil] ;

    [self.viewForGradient.layer insertSublayer:_myGradientLayer atIndex:0];
    [self.ratingLabel setFont:[MovieAppConfiguration getPreferredFontWithSize:FontSize10 isBold:NO]];
    [self.releaseDateLabel setFont:[MovieAppConfiguration getPreferredFontWithSize:FontSize10 isBold:NO]];
    [self.genreLabel setFont:[MovieAppConfiguration getPreferredFontWithSize:FontSize10 isBold:NO]];
    //self.viewForGradient.layer.shouldRasterize = YES;
    //self.viewForGradient.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    UITapGestureRecognizer *favoritesTapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAddToFavoritesImageView:)];
    UITapGestureRecognizer *watchlistTapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAddToWatchlistImageView:)];
    [self.addToFavoritesImageView addGestureRecognizer:favoritesTapGestureRecognizer];
    [self.addToWatchlistImageView addGestureRecognizer:watchlistTapGestureRecognizer];
}

+(UIEdgeInsets)cellInsets{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

+(CGFloat)cellHeight{
    return 254;
}

+(NSString *)cellIdentifier{
    return [self cellViewClassName];
}

+(NSString *)cellViewClassName{
    return @"TVEventsCollectionViewCell";
    
}

-(void)setupWithTvEvent:(TVEvent *)tvEvent indexPathRow:(NSUInteger)row callbackDelegate:(id<AddTVEventToCollectionDelegate>)delegate{
    BOOL isMovie=([tvEvent isKindOfClass:[Movie class]]) ? YES : NO;
    _delegate=delegate;
    _indexPathRowNumber=row;
    self.titleLabel.text=[tvEvent.title uppercaseString];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    NSString *dateString;
    [dateFormatter setDateFormat:isMovie ? MovieDateFormat : TVshowDateFormat];
    if(isMovie){
        dateString=[dateFormatter stringFromDate:tvEvent.releaseDate];
    }
    else{
        dateString=[[TVShowReleaseDatePrefix stringByAppendingString:[dateFormatter stringFromDate:tvEvent.releaseDate]] stringByAppendingString:@" -"];
    }
    self.releaseDateLabel.text=dateString;
    
    NSString *genresRepresentation=EmptyString;
    NSUInteger numberOfGenres=[tvEvent.genreIDs count];
    for(int i=0;i<numberOfGenres;i++){
        NSUInteger genreID=[(NSNumber *)tvEvent.genreIDs[i] unsignedIntegerValue];
        NSString *genreName=[tvEvent getGenreNameForId:genreID];
        
        if(i==numberOfGenres-1){
            genresRepresentation=[genresRepresentation stringByAppendingString:genreName];
        }
        else{
            genresRepresentation=[genresRepresentation stringByAppendingString:genreName ];
            genresRepresentation=[genresRepresentation  stringByAppendingString:@", "];
        }
    }
    
    self.genreLabel.text =  genresRepresentation;
    self.ratingLabel.text=[NSString stringWithFormat:@"%.1f", tvEvent.voteAverage];
    
    
    self.addToFavoritesImageView.image=[UIImage imageNamed:tvEvent.isInFavorites ? FavoritesSelectedImageName : FavoritesNormalImageName];
    self.addToWatchlistImageView.image=[UIImage imageNamed:tvEvent.isInWatchlist ? WatchlistSelectedImageName : WatchlistNormalImageName];
    
    /*KeychainItemWrapper *myKeyChain=[[KeychainItemWrapper alloc] initWithIdentifier:KeyChainItemWrapperIdentifier accessGroup:nil];
    NSString *username=[myKeyChain objectForKey:(id)kSecAttrAccount];
     if(!username || [username length]==0){
     self.addToFavoritesImageView.hidden=YES;
     self.addToWatchlistImageView.hidden=YES;
     }
     else{
     self.addToFavoritesImageView.hidden=NO;
     self.addToWatchlistImageView.hidden=NO;
     }*/
   
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _myGradientLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
}

-(void)didTapAddToWatchlistImageView:(UIImageView *)sender{
    [_delegate addTVEventToCollection:SideMenuOptionWatchlist indexPathRow:_indexPathRowNumber];
}

-(void)didTapAddToFavoritesImageView:(UIImageView *)sender{
    [_delegate addTVEventToCollection:SideMenuOptionFavorites indexPathRow:_indexPathRowNumber];
}
@end
