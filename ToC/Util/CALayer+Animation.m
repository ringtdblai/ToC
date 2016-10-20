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

+ (instancetype)layerWithAnimation:(GifAnimation *)animation
                         scaleSize:(CGSize)scaleSize
{
    CALayer *layer = [self layer];
    
    if (layer) {
        UIImage *maskedImage = [FaceManager sharedManager].maskedImage;
        
        layer.contents = (__bridge id)(maskedImage.CGImage);
        layer.fillMode = kCAGravityResizeAspectFill;
        
        CGSize animationSize = CGSizeMake(animation.width, animation.height);
        
        NSMutableDictionary *animationData = [[NSMutableDictionary alloc] init];
        
        if ([animation.rotation isKindOfClass:[NSArray class]]) {
            [animationData setObject:animation.rotation forKey:@"rotation"];
        }
        
        if ([animation.position isKindOfClass:[NSArray class]]) {
            [animationData setObject:animation.position forKey:@"position"];
        }
        
        if ([animation.bounds isKindOfClass:[NSArray class]]) {
            [animationData setObject:animation.bounds forKey:@"bounds"];
        }
        
        [layer applyAnimationWithDictionary:animationData
                                   duration:animation.duration
                                     scaleSize:scaleSize
                              animationSize:animationSize];
    }
    
    return layer;
}

- (void)applyAnimationWithDictionary:(NSDictionary *)dict
                            duration:(NSTimeInterval)duration
                           scaleSize:(CGSize)scaleSize
                       animationSize:(CGSize)animationSize
{
    CGFloat scaleX = scaleSize.width / animationSize.width;
    CGFloat scaleY = scaleSize.height / animationSize.height;
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    
    NSMutableArray *animations = [NSMutableArray array];
    
    for (NSString *key in [dict allKeys]) {
        CAKeyframeAnimation *animation;
        CAAnimationGroup *group;
        if ([key isEqualToString:@"position"]) {
             group = [self positionAnimationValues:dict[key]
                                                scaleX:scaleX
                                                scaleY:scaleY
                                         animationSize:animationSize];
        } else if ([key isEqualToString:@"bounds"]){
            animation = [self boundsAnimationValues:dict[key]
                                             scaleX:scaleX
                                             scaleY:scaleY];
        } else if ([key isEqualToString:@"rotation"]){
            animation = [self rotateAnimationValues:dict[key]
                                             scaleX:scaleX
                                             scaleY:scaleY];
        }

        
        if (animation) {
            [animations addObject:animation];
        }
        
        if (group) {
            [animations addObject:group];
        }
    }
    
    group.animations = animations;
    group.duration = duration;
    group.repeatCount = INFINITY;
    group.removedOnCompletion = YES;
    group.beginTime = 0;
    group.autoreverses = NO;
    group.fillMode = kCAFillModeRemoved;
    
    [self addAnimation:group forKey:@"group"];
}

- (CAAnimationGroup *)positionAnimationValues:(NSArray *)array
                                       scaleX:(CGFloat)scaleX
                                       scaleY:(CGFloat)scaleY
                                animationSize:(CGSize)animationSize
{
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    CAAnimationGroup* group = [CAAnimationGroup animation];

    
    CAKeyframeAnimation* frameAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CAKeyframeAnimation* alphaAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];

    NSMutableArray *frameValues = [NSMutableArray array];
    NSMutableArray *alphaValues = [NSMutableArray array];

    CGPoint lastPoint = CGPointMake(1000, 1000);
    
    for (NSString *string in array) {
        CGPoint point = CGPointFromString(string);
        
        if (point.x <= animationSize.width && point.y <= animationSize.height) {
            CGPoint scalePoint = CGPointMake(point.x * scaleX, point.y * scaleY);
            [frameValues addObject:[NSValue valueWithCGPoint:scalePoint]];
            [alphaValues addObject:@1];
            lastPoint = point;
        } else {
            [frameValues addObject:[NSValue valueWithCGPoint:lastPoint]];
            [alphaValues addObject:@0];
        }
    }
    
    frameAnim.values = frameValues;
    frameAnim.calculationMode = kCAAnimationDiscrete;

    alphaAnim.values = alphaValues;
    frameAnim.calculationMode = kCAAnimationDiscrete;

    group.animations = @[frameAnim, alphaAnim];
    
    return group;
}

- (CAKeyframeAnimation *)boundsAnimationValues:(NSArray *)array
                                        scaleX:(CGFloat)scaleX
                                        scaleY:(CGFloat)scaleY
{
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    CAKeyframeAnimation* frameAnim = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSString *string in array) {
        CGRect bounds = CGRectFromString(string);
        CGRect scaleBounds = CGRectMake(0, 0, CGRectGetWidth(bounds) * scaleX, CGRectGetHeight(bounds) * scaleY);
        [values addObject:[NSValue valueWithCGRect:scaleBounds]];
    }
    
    frameAnim.values = values;
    frameAnim.calculationMode = kCAAnimationLinear;
    
    
    return frameAnim;
}

- (CAKeyframeAnimation *)rotateAnimationValues:(NSArray *)array
                                        scaleX:(CGFloat)scaleX
                                        scaleY:(CGFloat)scaleY
{
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    CAKeyframeAnimation* frameAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSString *string in array) {
        
        [values addObject:@(M_PI * [string floatValue]/180.0f)];
    }
    
    frameAnim.values = values;
    frameAnim.calculationMode = kCAAnimationLinear;
    
    
    return frameAnim;
}


@end
