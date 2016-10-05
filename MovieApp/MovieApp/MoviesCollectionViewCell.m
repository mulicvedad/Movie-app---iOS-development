#import "MoviesCollectionViewCell.h"

#define START_POINT_X 0.5
#define START_POINT_Y 0.25
#define END_POINT_X 0.5
#define END_POINT_Y 1.0

@implementation MoviesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CAGradientLayer *_myGradientLayer=[[CAGradientLayer alloc]init];
    
    _myGradientLayer.frame = self.frame;
    _myGradientLayer.startPoint = CGPointMake(START_POINT_X,START_POINT_Y);
    _myGradientLayer.endPoint = CGPointMake(END_POINT_X, END_POINT_Y);
    _myGradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],
                               (id)[[UIColor blackColor] CGColor],
                               nil];
    [self.viewForGradient.layer insertSublayer:_myGradientLayer atIndex:0];
}

+(UIEdgeInsets)cellInsets{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

+(CGFloat)cellHeight{
    return 254;
}

+(NSString *)cellIdentifier{
    return @"collectionCell";
}

+(NSUInteger)numberOfStarsFromRating:(float)popularity;{
    if(popularity<=2){
        return 1;
    }
    else if(popularity>2 && popularity<=4){
        return 2;
    }
    else if(popularity>4 && popularity<=6){
        return 3;
    }
    else if(popularity>6 && popularity<=8)
        return 4;
    else{
        return 5;
    }
}

@end
