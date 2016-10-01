//
//  Movie.h
//  MovieApp
//
//  Created by user on 22/09/16.
//  Copyright © 2016 internshipABH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic) NSInteger id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *original_title;
@property (nonatomic, strong) NSString *poster_path;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSDate *release_date;
@property (nonatomic, strong) NSArray *genre_ids;
@property (nonatomic, strong) NSString *original_language;
@property (nonatomic) float  vote_average;


@end
