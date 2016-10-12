
#import <Foundation/Foundation.h>
#import "ItemsArrayReceiver.h"

@interface FeedXmlParser : NSObject <NSXMLParserDelegate>
-(void)parseXmlFromData:(NSData *)data returnToHandler:(id<ItemsArrayReceiver>)dataHandler;
@end
