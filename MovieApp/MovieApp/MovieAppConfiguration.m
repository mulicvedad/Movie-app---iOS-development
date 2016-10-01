
#import "MovieAppConfiguration.h"

@implementation MovieAppConfiguration

+(NSURL *)getFeedsSourceUrlPath{
    
    return [NSURL URLWithString:@"http://www.boxofficemojo.com/data/rss.php?file=topstories.xml"];
    
}

@end
