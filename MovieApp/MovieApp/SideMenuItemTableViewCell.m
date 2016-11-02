#import "SideMenuItemTableViewCell.h"

#define FontSize12 12

static NSString * NormalFavoritesImageName=@"favorites";
static NSString * SelectedFavoritesImageName=@"favorites-selected";
static NSString * NormalWatchlistImageName=@"watchlist";
static NSString * SelectedWatchlistImageName=@"watchlist-selected";
static NSString * NormalRatingsImageName=@"ratings";
static NSString * SelectedRatingsImageName=@"ratings-selected";
static NSString * NormalSettingsImageName=@"options";
static NSString * SelectedSettingsImageName=@"options-selected";
static NSString * SideMenuOptionFavoritesText=@"Your favorites";
static NSString * SideMenuOptionWatchlistText=@"Your watchlist";
static NSString * SideMenuOptionRatingsText=@"Your ratings";
static NSString * SideMenuOptionSettingsText=@"Options";


@implementation SideMenuItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.optionNameLabel.font=[MovieAppConfiguration getPreferredFontWithSize:FontSize12 isBold:NO];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

-(void)setupWithOption:(SideMenuOption)option selected:(BOOL)selected{
    if(selected){
        self.optionNameLabel.textColor=[MovieAppConfiguration getPrefferedYellowColor];
    }
    else{
        self.optionNameLabel.textColor=[MovieAppConfiguration getPrefferedGreyColor];
    }
    self.optionNameLabel.text=[self getDescriptionForOption:option];
    switch (option) {
        case SideMenuOptionFavorites:
            if(selected){
                self.optionImageView.image=[UIImage imageNamed:SelectedFavoritesImageName];
            }
            else{
                self.optionImageView.image=[UIImage imageNamed:NormalFavoritesImageName];
            }
            break;
        case SideMenuOptionWatchlist:
            if(selected){
                self.optionImageView.image=[UIImage imageNamed:SelectedWatchlistImageName];
            }
            else{
                self.optionImageView.image=[UIImage imageNamed:NormalWatchlistImageName];
            }
            break;
        case SideMenuOptionRatings:
            if(selected){
                self.optionImageView.image=[UIImage imageNamed:SelectedRatingsImageName];
            }
            else{
                self.optionImageView.image=[UIImage imageNamed:NormalRatingsImageName];
            }
            break;
        case SideMenuOptionSettings:
            if(selected){
                self.optionImageView.image=[UIImage imageNamed:SelectedRatingsImageName];
            }
            else{
                self.optionImageView.image=[UIImage imageNamed:NormalRatingsImageName];
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
        case SideMenuOptionNone:
            return EmptyString;
    }
}

@end
