#import "SideMenuItemTableViewCell.h"
#import <FontAwesome-iOS/NSString+FontAwesome.h>

#define FontSize12 12

static NSString * FavoritesNormalImageName=@"favorites-new";
static NSString * FavoritesSelectedImageName=@"favorites-selected";
static NSString * WatchlistNormalImageName=@"watchlist-new";
static NSString * WatchlistSelectedImageName=@"watchlist-selected";
static NSString * RatingsNormalImageName=@"ratings";
static NSString * RatingsSelectedImageName=@"ratings-selected";
static NSString * SettingsNormalImageName=@"settings";
static NSString * SettingsSelectedImageName=@"settings-selected";
static NSString * LoginNormalImageName=@"login";
static NSString * LoginSelectedImageName=@"login-selected";
static NSString * LogoutNormalImageName=@"logout";
static NSString * LogoutSelectedImageName=@"logout-selected";

static NSString * SideMenuOptionFavoritesText=@"Your favorites";
static NSString * SideMenuOptionWatchlistText=@"Your watchlist";
static NSString * SideMenuOptionRatingsText=@"Your ratings";
static NSString * SideMenuOptionSettingsText=@"Settings";
static NSString * SideMenuOptionLoginText=@"Login";
static NSString * SideMenuOptionLogOutText=@"Logout";


@implementation SideMenuItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.optionNameLabel.font=[MovieAppConfiguration getPreferredFontWithSize:FontSize12 isBold:NO];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

-(void)setupWithOption:(SideMenuOption)option selected:(BOOL)selected{
  
    if(selected){
        self.optionNameLabel.textColor=[MovieAppConfiguration getPrefferedYellowColor];
        self.contentView.backgroundColor=[UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1.0];
    }
    else{
        self.optionNameLabel.textColor=[MovieAppConfiguration getPrefferedLightGreyColor];
    }
    
    self.optionNameLabel.text=[self getDescriptionForOption:option];
    switch (option) {
        case SideMenuOptionFavorites:
            if(selected){
                self.optionImageView.image=[UIImage imageNamed:FavoritesSelectedImageName];
            }
            else{
                self.optionImageView.image=[UIImage imageNamed:FavoritesNormalImageName];
            }
            break;
        case SideMenuOptionWatchlist:
            if(selected){
                self.optionImageView.image=[UIImage imageNamed:WatchlistSelectedImageName];
            }
            else{
                self.optionImageView.image=[UIImage imageNamed:WatchlistNormalImageName];
            }
            break;
        case SideMenuOptionRatings:
            if(selected){
                self.optionImageView.image=[UIImage imageNamed:RatingsSelectedImageName];
            }
            else{
                self.optionImageView.image=[UIImage imageNamed:RatingsNormalImageName];
            }
            break;
        case SideMenuOptionSettings:
            if(selected){
                self.optionImageView.image=[UIImage imageNamed: SettingsSelectedImageName];
            }
            else{
                self.optionImageView.image=[UIImage imageNamed:SettingsNormalImageName];
            }
            break;
        case SideMenuOptionLogin:
            if(selected){
                self.optionImageView.image=[UIImage imageNamed:LoginSelectedImageName];
            }
            else{
                self.optionImageView.image=[UIImage imageNamed:LoginNormalImageName];
            }
            break;
        case SideMenuOptionLogout:
            if(selected){
                self.optionImageView.image=[UIImage imageNamed:LogoutSelectedImageName];
            }
            else{
                self.optionImageView.image=[UIImage imageNamed:LogoutNormalImageName];
            }
            break;
        case SideMenuOptionNone:
            break;

    }
}

-(NSString *)getDescriptionForOption:(SideMenuOption)option{
    switch (option) {
        case SideMenuOptionFavorites:
            return SideMenuOptionFavoritesText;
            break;
        case SideMenuOptionWatchlist:
            return SideMenuOptionWatchlistText;
            break;
        case SideMenuOptionRatings:
            return SideMenuOptionRatingsText;
            break;
        case SideMenuOptionSettings:
            return SideMenuOptionSettingsText;
            break;
        case SideMenuOptionLogin:
            return SideMenuOptionLoginText;
            break;
        case SideMenuOptionLogout:
            return SideMenuOptionLogOutText;
            break;
        default:
            return EmptyString;
    }
}

@end
