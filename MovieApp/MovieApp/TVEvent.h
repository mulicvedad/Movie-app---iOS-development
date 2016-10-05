//
//  TVEvent.h
//  MovieApp
//
//  Created by user on 04/10/16.
//  Copyright © 2016 internshipABH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVEvent : NSObject

@property (nonatomic) NSUInteger id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSDate *releaseDate;
@property (nonatomic, strong) NSArray *genreIDs;
@property (nonatomic, strong) NSString *originalLanguage;
@property (nonatomic) float voteAverage;
@property (nonatomic) NSUInteger voteCount;

+(NSDictionary *)propertiesMapping;

@end
