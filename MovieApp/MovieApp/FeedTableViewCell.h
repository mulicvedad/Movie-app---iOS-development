//
//  FeedTableViewCell.h
//  MovieApp
//
//  Created by user on 23/09/16.
//  Copyright © 2016 internshipABH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"

@interface FeedTableViewCell : CustomTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelHeadline;
@property (weak, nonatomic) IBOutlet UITextView *textViewText;
@property (weak, nonatomic) IBOutlet UITextView *textViewWebPage;


@end
