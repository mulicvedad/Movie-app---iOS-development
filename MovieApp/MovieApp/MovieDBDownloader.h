//
//  MovieDBDownloader.h
//  MovieApp
//
//  Created by user on 01/10/16.
//  Copyright © 2016 internshipABH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemsArrayReceiver.h"

typedef enum Criteria
{
    MOST_POPULAR,
    TOP_RATED,
    LATEST
}Criterion;

@interface MovieDBDownloader : NSObject

-(void)configure;
-(void)getdMoviesByCriterion:(Criterion)criterion returnToHandler:(id)delegate;

@end
