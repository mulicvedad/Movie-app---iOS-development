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
    
}
@property (nonatomic, assign) id<FeedDataReceiver> delegate;
@end

@implementation FeedDownloader

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
    
    parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error.localizedFailureReason);
}

//implementation of XMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    xmlElement = elementName;
    
    if ([elementName isEqualToString:@"item"]) {
        
        newItem = [[NewFeedsItem alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([xmlElement isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([xmlElement isEqualToString:@"link"]) {
        [link appendString:string];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        newItem.headline=title;
        newItem.text=link;
        newItem.webPage=link;
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
