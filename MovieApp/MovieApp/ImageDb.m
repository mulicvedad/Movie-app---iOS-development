#import "ImageDb.h"
#import "Image.h"

@implementation ImageDb

+(NSString *)primaryKey{
    return @"fullUrlPath";
}

+(ImageDb *)imageDbWithImage:(Image *)image baseUrl:(NSString *)baseUrl imageAsData:(NSData *)imageDataOrNil{
    ImageDb *newImageDb=[[ImageDb alloc] init];
    
    newImageDb.fullUrlPath=[baseUrl stringByAppendingString:image.filePath];
    newImageDb.filePath=image.filePath;
    newImageDb.imageData=imageDataOrNil;
    
    return  newImageDb;
}

@end
