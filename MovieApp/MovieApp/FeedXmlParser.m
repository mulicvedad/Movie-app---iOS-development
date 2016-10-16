#import "FeedXmlParser.h"
#import "NewFeedsItem.h"


@interface FeedXmlParser(){
    NSMutableArray *_items;
    NSMutableData *_responseData;
    
    NSXMLParser *_parser;
    NSMutableArray *_feeds;
    NewFeedsItem *_newItem;
    NSMutableString *_title;
    NSMutableString *_link;
    NSString *_xmlElement;
    NSMutableString *_descripition;
    id<ItemsArrayReceiver> _dataReceiver;
}

@end

@implementation FeedXmlParser
-(void)parseXmlFromData:(NSData *)data returnToHandler:(id<ItemsArrayReceiver>)dataHandler{
    
    _dataReceiver=dataHandler;
    _parser = [[NSXMLParser alloc] initWithData:data];
    [_parser setDelegate:self];
    [_parser setShouldResolveExternalEntities:NO];
    [_parser parse];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    _xmlElement = elementName;
    
    if ([elementName isEqualToString:@"item"]) {
        
        _newItem = [[NewFeedsItem alloc] init];
        _title   = [[NSMutableString alloc] init];
        _link    = [[NSMutableString alloc] init];
        _descripition = [[NSMutableString alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([_xmlElement isEqualToString:@"title"]) {
        [_title appendString:string];
    } else if ([_xmlElement isEqualToString:@"link"]) {
        [_link appendString:string];
    }
    else if ([_xmlElement isEqualToString:@"description"]) {
        [_descripition appendString:string];
    }
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        _newItem.headline=_title;
        _newItem.text=[_descripition stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n"]];
        _newItem.sourceUrlPath=_link;
        if(!_feeds)
        {
            _feeds=[[NSMutableArray alloc] init];
        }
        
        [_feeds addObject:_newItem];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [_dataReceiver updateReceiverWithNewData:_feeds info:nil];
   
}

@end
