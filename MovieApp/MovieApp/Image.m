#import "Image.h"
#define BASE_IMAGE_URL @"http://image.tmdb.org/t/p/w185"

@implementation Image

+(NSDictionary *)propertiesMapping{
    return @{@"aspect_ratio":@"aspectRatio",
             @"file_path":@"filePath"
             };
}

+(NSArray *)getURLsFromImagesArray:(NSArray *)images{
    NSMutableArray *imagesMutable=[[NSMutableArray alloc]init];
    int counter=0;
    for(Image *image in images){
        if(counter==4){
            break;
        }
        [imagesMutable addObject:[NSURL URLWithString:[BASE_IMAGE_URL stringByAppendingString:image.filePath]]];
        counter++;
    }
    return imagesMutable;
}
@end
