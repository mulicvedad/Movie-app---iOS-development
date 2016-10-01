#import "FeedDownloader.h"
#import "ItemsArrayReceiver.h"

@interface FeedDownloader ()
{
    NSMutableArray *_items;
    NSMutableData *_responseData;
    
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NewFeedsItem *newItem;
    NSMutableString *title;
    NSMutableString *link;
    NSString *xmlElement;
    NSMutableString *descripition;
    
}
@property (nonatomic, assign) id<ItemsArrayReceiver> delegate;
@end

@implementation FeedDownloader

//making connection between our downloader and caller
- (void)downloadNewsFromFeed:(NSURL *)feedUrl andReturnTo:(id)dataHandler
{
    _delegate=dataHandler;
    
    NSURLSession *session=[NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask= [session dataTaskWithURL:feedUrl completionHandler:
                                     ^(NSData *data, NSURLResponse * response, NSError *eror)
                                      {
                                              //here we have our data and it is supposed to be in xml format
                                              parser = [[NSXMLParser alloc] initWithData:data];
                                              [parser setDelegate:self];
                                              [parser setShouldResolveExternalEntities:NO];
                                              [parser parse];
                                      } ];
    
    [dataTask resume];
    

}


//implementation of XMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    xmlElement = elementName;
    
    if ([elementName isEqualToString:@"item"]) {
        
        newItem = [[NewFeedsItem alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        descripition = [[NSMutableString alloc] init];
        
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([xmlElement isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([xmlElement isEqualToString:@"link"]) {
        [link appendString:string];
    }
    else if ([xmlElement isEqualToString:@"description"]) {
        [descripition appendString:string];
    }

    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        newItem.headline=title;
        newItem.text=[descripition stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n"]];
        newItem.sourceUrlPath=link;
        if(!feeds)
        {
            feeds=[[NSMutableArray alloc] init];
            
        }
        
        [feeds addObject:newItem];       
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [_delegate updateViewWithNewData:feeds];
}

@end
