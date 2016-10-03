//
//  RawDataDowloader.m
//  MovieApp
//
//  Created by user on 02/10/16.
//  Copyright © 2016 internshipABH. All rights reserved.
//

#import "RawDataDowloader.h"


@implementation RawDataDowloader

- (void)downloadDataFromUrl:(NSURL *)sourceUrl
{
    NSURLSession *session=[NSURLSession sharedSession];
    NSData *rawData;
    NSURLSessionDataTask *dataTask= [session dataTaskWithURL:sourceUrl completionHandler:
                                     ^(NSData *data, NSURLResponse * response, NSError *eror)
                                     {
                                         rawData=data;
                                     } ];
    
    [dataTask resume];
    
    
}

@end
