#import <UIKit/UIKit.h>
#import "TVEvent.h"
#import "ItemsArrayReceiver.h"
#import "SeasonsTableViewCellDelegate.h"
#import "AddTVEventToCollectionDelegate.h"
#import "TVEventsCollectionsStateChangeHandler.h"
#import "GallerySelectionHandler.h"

#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import <Photos/Photos.h>

@interface TVEventDetailsTableViewController : UITableViewController <ItemsArrayReceiver, SeasonsTableViewCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, AddTVEventToCollectionDelegate, TVEventsCollectionsStateChangeHandler, MWPhotoBrowserDelegate, GallerySelectionHandler>

-(void)setMainTvEvent:(TVEvent *)tvEvent dalegate:(id<TVEventsCollectionsStateChangeHandler>)delegate;
-(void)didSelectRateThisTVEvent;
-(void)openGallery;
@end
