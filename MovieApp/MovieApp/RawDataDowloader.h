//
//  RawDataDowloader.h
//  MovieApp
//
//  Created by user on 02/10/16.
//  Copyright © 2016 internshipABH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RawDataDowloader : NSObject
- (NSData *)downloadDataFromUrl:(NSURL *)sourceUrl;

@end
