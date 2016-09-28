#import "FeedDownloader.h"

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
@property (nonatomic, assign) id<FeedDataReceiver> delegate;
@end

@implementation FeedDownloader

//making connection between our downloader and caller
- (void)downloadNewsFromFeed:(NSURL *)feedUrl andReturnTo:(id)dataHandler
{
    _delegate=dataHandler;
    _feedURL=feedUrl;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:feedUrl];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

//implementing URLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSData *data = [NSData dataWithData:_responseData];
    
    //here we have our data and it is supposed to be in xml format
    parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if(!feeds)
    {
        feeds = [[NSMutableArray alloc] init];
    }
    else{
        [feeds removeAllObjects];
    }
    
    [feeds addObject:[[NewFeedsItem alloc] initWithHeadline:@"Error" text:error.localizedDescription sourceUrlPath:@""]];
    
    
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
