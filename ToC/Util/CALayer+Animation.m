//
//  CALayer+Animation.m
//  ToC
//
//  Created by ringtdblai on 2016/10/14.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "CALayer+Animation.h"
#import "UIImage+Mask.h"
#import "FaceManager.h"

@implementation CALayer (Animation)

+(instancetype)layerWithAnimation:(Animation *)animation
{
    CALayer *layer = [self layer];
    
    if (layer) {
        UIImage *originalImage = [FaceManager sharedManager].selectedFace;
        UIImage *maskImage = [FaceManager sharedManager].maskImage;
        UIImage *maskedImage = [UIImage maskImage:originalImage withMaskImage:maskImage];
        
        layer.contents = (__bridge id)(maskedImage.CGImage);
        layer.fillMode = kCAGravityResizeAspectFill;
        [layer applyAnimationWithDictionary:animation.animationData
                                   duration:animation.duration];
//        [layer addAnimationWith:animation.animationData];
        
    }
    
    return layer;
}

- (void)addAnimationWith:(NSDictionary *)dict
{
    CAKeyframeAnimation *animation= [self positionAnimationValues:dict[@"position"]];
    [self addAnimation:animation forKey:@"frameAnimation"];

}


- (void)applyAnimationWithDictionary:(NSDictionary *)dict
                            duration:(NSTimeInterval)duration
{
    CAAnimationGroup* group = [CAAnimationGroup animation];
    
    NSMutableArray *animations = [NSMutableArray array];
    
    for (NSString *key in [dict allKeys]) {
        CAKeyframeAnimation *animation;
        if ([key isEqualToString:@"position"]) {
             animation = [self positionAnimationValues:dict[key]];
        } else if ([key isEqualToString:@"bounds"]){
            animation = [self boundsAnimationValues:dict[key]];
        }
        
        if (animation) {
            [animations addObject:animation];
        }
    }
    
    group.animations = animations;
    group.duration = duration;
    group.repeatCount = INFINITY;
    group.removedOnCompletion = YES;
    group.beginTime = 0.0001;
    group.autoreverses = NO;
    group.fillMode = kCAFillModeRemoved;
    
    [self addAnimation:group forKey:@"group"];
}

- (CAKeyframeAnimation *)positionAnimationValues:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    CAKeyframeAnimation* frameAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSString *string in array) {
        CGPoint point = CGPointFromString(string);
        [values addObject:[NSValue valueWithCGPoint:point]];
    }
    
    frameAnim.values = values;
    frameAnim.calculationMode = kCAAnimationLinear;

    
    return frameAnim;
}

//- (CAKeyframeAnimation *)positionAnimationValues:(NSArray *)array
//{
//    if (![array isKindOfClass:[NSArray class]]) {
//        return nil;
//    }
//    
//    CAKeyframeAnimation* frameAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    
//    
//    
//    
//    CGMutablePathRef path = CGPathCreateMutable();
//    
//    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGPoint point = CGPointFromString(obj);
//        if (idx == 0) {
//            CGPathMoveToPoint(path,NULL,point.x,point.y);
//        } else {
//            CGPathAddLineToPoint(path,NULL,point.x,point.y);
//        }
//    }];
//    
//    frameAnim.path = path;
//    
//    return frameAnim;
//}

- (CAKeyframeAnimation *)boundsAnimationValues:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    CAKeyframeAnimation* frameAnim = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSString *string in array) {
        CGRect bounds = CGRectFromString(string);
        [values addObject:[NSValue valueWithCGRect:bounds]];
    }
    
    frameAnim.values = values;
    frameAnim.calculationMode = kCAAnimationLinear;
    
    
    return frameAnim;
}

@end
