#import "TrailerTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <KeychainItemWrapper.h>
#import "DatabaseManager.h"

#define FontSize18 18
#define FontSize12 12
static NSString * const YearDateFormat=@"yyyy";//placeholder375x260
static NSString * const WideImagePlaceholder=@"yyyy";
static CGFloat const DefaultHeightWidthRatio=1.689;
static CGFloat const StartPointX=0.5;
static CGFloat const StartPointY=0.5;
static CGFloat const EndPointX=0.5;
static CGFloat const EndPointY=1.0;

static NSString *FavoritesSelectedImageName=@"favorites-selected";
static NSString *FavoritesNormalImageName=@"favorites";

static NSString *WatchlistSelectedImageName=@"watchlist-selected";
static NSString *WatchlistNormalImageName=@"watchlist";

@interface TrailerTableViewCell(){
    id<ShowTrailerDelegate, AddTVEventToCollectionDelegate> _delegate;
}

@end

@implementation TrailerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setGradientLayer];
    [self configure];
}

-(void)configure{
    UITapGestureRecognizer *favoritesTapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAddToFavoritesImageView:)];
    UITapGestureRecognizer *watchlistTapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAddToWatchlistImageView:)];
    [self.favoritesImageView addGestureRecognizer:favoritesTapGestureRecognizer];
    [self.watchlistImageView addGestureRecognizer:watchlistTapGestureRecognizer];
}
-(void)setupCellWithTitle:(NSString *)originalTitle imageUrl:(NSURL *)imageUrl releaseYear:(NSString *)releaseYear{
    releaseYear=(releaseYear) ? releaseYear : @"Year not found";
    originalTitle=(originalTitle) ? originalTitle : @"Title not found";
    if(imageUrl){
        [self.trailerImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:WideImagePlaceholder]];
    }
    else{
        self.trailerImageView.image=[UIImage imageNamed:WideImagePlaceholder];
    }
    
    NSMutableAttributedString *titleAttributedString=[[NSMutableAttributedString alloc] initWithString:originalTitle attributes:@{NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize18 isBold:YES], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSMutableAttributedString *yearAttributedString=[[NSMutableAttributedString alloc] initWithString:
                                                     [[@" (" stringByAppendingString:releaseYear] stringByAppendingString:@")" ] attributes:@{NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize12 isBold:NO], NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor]}];

    [titleAttributedString appendAttributedString:yearAttributedString];
    self.titleLabel.attributedText=titleAttributedString;
    

}

-(void)setupWithTVEvent:(TVEvent *)tvEvent{
    
    if(tvEvent.backdropPath){
        NSString *imageUrlPath=[BaseImageUrlForWidth500 stringByAppendingString:tvEvent.backdropPath ];
        UIImage *uiImage=[[DatabaseManager sharedDatabaseManager] getUIImageFromImageDbWithID:imageUrlPath];
        
        if(uiImage){
            self.trailerImageView.image=uiImage;
        }
        else if([MovieAppConfiguration isConnectedToInternet]){
            [self.trailerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlPath] placeholderImage:[UIImage  imageNamed:WideImagePlaceholder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [[DatabaseManager sharedDatabaseManager] addUIImage:image toImageDbWithID:imageUrlPath];
                
            }];
        }
        else{
            [self.trailerImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:WideImagePlaceholder]];
            
        }
    }
    else{
        [self.trailerImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:WideImagePlaceholder]];
    }


    NSString *releaseYear;
    NSString *originalTitle;
    releaseYear=([tvEvent getReleaseYear]) ? [tvEvent getReleaseYear] : @"Year not found";
    originalTitle=(tvEvent.title) ? tvEvent.title : @"Title not found";
    
    NSMutableAttributedString *titleAttributedString=[[NSMutableAttributedString alloc] initWithString:originalTitle attributes:@{NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize18 isBold:YES], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSMutableAttributedString *yearAttributedString=[[NSMutableAttributedString alloc] initWithString:
                                                     [[@" (" stringByAppendingString:releaseYear] stringByAppendingString:@")" ] attributes:@{NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize12 isBold:NO], NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor]}];
    
    [titleAttributedString appendAttributedString:yearAttributedString];
    self.titleLabel.attributedText=titleAttributedString;
    
    self.favoritesImageView.image=[UIImage imageNamed:tvEvent.isInFavorites ? FavoritesSelectedImageName : FavoritesNormalImageName];
    self.watchlistImageView.image=[UIImage imageNamed:tvEvent.isInWatchlist ? WatchlistSelectedImageName : WatchlistNormalImageName];
    
    KeychainItemWrapper *myKeyChain=[[KeychainItemWrapper alloc] initWithIdentifier:KeyChainItemWrapperIdentifier accessGroup:nil];
    NSString *username=[myKeyChain objectForKey:(id)kSecAttrAccount];
    if(!username || [username length]==0){
        self.favoritesImageView.hidden=YES;
        self.watchlistImageView.hidden=YES;
    }
    else{
        self.favoritesImageView.hidden=NO;
        self.watchlistImageView.hidden=NO;
    }
    
    

}

-(void)setGradientLayer{
    _myGradientLayer=[[CAGradientLayer alloc]init];

    _myGradientLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.width/DefaultHeightWidthRatio);
    
    _myGradientLayer.startPoint = CGPointMake(StartPointX,StartPointY);
    _myGradientLayer.endPoint = CGPointMake(EndPointX, EndPointY);
    _myGradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],
                               (id)[[UIColor blackColor] CGColor],
                               (id)[[UIColor blackColor] CGColor],
                               nil];
    [self.viewForGradient.layer addSublayer:_myGradientLayer];
    self.viewForGradient.layer.masksToBounds = YES;

}

-(void)layoutSubviews{
    [super layoutSubviews];
    _myGradientLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.width/DefaultHeightWidthRatio);
}

+(NSString *)cellIdentifier{
    return [TrailerTableViewCell cellIClassName];
}
+(NSString *)cellIClassName{
    return @"TrailerTableViewCell";
}

-(void)setDelegate:(id<ShowTrailerDelegate, AddTVEventToCollectionDelegate>)delegate{
    _delegate=delegate;
}
- (IBAction)showTrailer:(UIButton *)sender {
    [_delegate showTrailer];
}

-(void)didTapAddToWatchlistImageView:(UIImageView *)sender{
    [_delegate addTVEventWithID:0 toCollection:SideMenuOptionWatchlist];
}

-(void)didTapAddToFavoritesImageView:(UIImageView *)sender{
    [_delegate addTVEventWithID:0 toCollection:SideMenuOptionFavorites];
}
@end
