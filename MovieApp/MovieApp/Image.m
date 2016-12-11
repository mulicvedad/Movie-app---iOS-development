#import "Image.h"

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
        [imagesMutable addObject:[NSURL URLWithString:[BaseImageUrlForWidth185 stringByAppendingString:image.filePath]]];
        counter++;
    }
    return imagesMutable;
}

+(Image *)imageWithImageDb:(ImageDb *)imageDb{
    Image *newImage=[[Image alloc] init];
    
    newImage.filePath=imageDb.filePath;
    //newImage.aspectRatio=...
    return newImage;
}
+(NSArray *)imagesArrayFromRLMArray:(RLMResults *)results{
    NSMutableArray *newImages=[[NSMutableArray alloc] init];
    
    for(ImageDb *imageDb in results){
        [newImages addObject:[Image imageWithImageDb:imageDb]];
    }
    
    return newImages;
}
@end
