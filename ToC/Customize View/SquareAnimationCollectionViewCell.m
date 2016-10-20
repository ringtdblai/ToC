//
//  SquareAnimationCollectionViewCell.m
//  ToC
//
//  Created by ringtdblai on 2016/10/12.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "SquareAnimationCollectionViewCell.h"

// Third Party
#import <Masonry.h>
#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>
#import "SDWebImage+Swizzle.h"

#import "AnimationView.h"


@interface SquareAnimationCollectionViewCell ()

@property (nonatomic, strong) GifAnimation *animation;

@property (nonatomic, weak) AnimationView *imageView;

@end

@implementation SquareAnimationCollectionViewCell

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
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.imageView.animation = nil;
}
#pragma mark - Setup UI
- (void)constructView
{
    [self setupImageView];
}

- (void)setupImageView
{
    AnimationView *imageView = [AnimationView new];
    
    [self addSubview:imageView];
    
    self.imageView = imageView;
}

#pragma mark - Update
- (void)updateWithAnimation:(GifAnimation *)animation
{
    self.imageView.animation = animation;
}

@end
