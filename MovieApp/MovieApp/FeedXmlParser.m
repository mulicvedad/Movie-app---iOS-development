#import "FeedXmlParser.h"
#import "NewFeedsItem.h"

@interface FeedXmlParser(){
    NSMutableArray *_items;
    NSMutableData *_responseData;
    
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NewFeedsItem *newItem;
    NSMutableString *title;
    NSMutableString *link;
    NSString *xmlElement;
    NSMutableString *descripition;
    id<ItemsArrayReceiver> dataReceiver;
}

@end

@implementation FeedXmlParser
-(void)parseXmlFromData:(NSData *)data returnToHandler:(id<ItemsArrayReceiver>)dataHandler{
    dataReceiver=dataHandler;
    parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}


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
    
    [dataReceiver updateReceiverWithNewData:feeds info:nil];
}

@end
