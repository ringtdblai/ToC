//
//  AnimationView.m
//  ToC
//
//  Created by ringtdblai on 2016/10/14.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "AnimationView.h"

#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>
#import "SDWebImage+Swizzle.h"
#import <UIImageView+WebCache.h>

#import "Animation.h"

#import "CALayer+Animation.h"

@interface AnimationView ()

@property (nonatomic, weak) FLAnimatedImageView *imageView;
@property (nonatomic, weak) CALayer *animationLayer;

@end

@implementation AnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self constructView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    [self updateAnimationLayerWithANimation:self.animation];
}

#pragma mark - Setup UI
- (void)constructView
{
    [self setupImageView];
}

- (void)setupImageView
{
    FLAnimatedImageView *imageView = [FLAnimatedImageView new];
    
    imageView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:imageView];
    
    self.imageView = imageView;
}

- (void)setAnimation:(GifAnimation *)animation
{
    _animation = animation;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:animation.imageURL]];
    [self updateAnimationLayerWithANimation:animation];
}

- (void)updateAnimationLayerWithANimation:(GifAnimation *)animation
{
    if (self.animationLayer) {
        [self.animationLayer removeFromSuperlayer];
    }
    
    CALayer *layer = [CALayer layerWithAnimation:animation scaleSize:self.bounds.size];
    [self.layer addSublayer:layer];
    
    self.animationLayer = layer;
}

@end
