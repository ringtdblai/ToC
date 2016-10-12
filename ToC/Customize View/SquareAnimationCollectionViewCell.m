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


@interface SquareAnimationCollectionViewCell ()

@property (nonatomic, strong) Animation *animation;

@property (nonatomic, weak) FLAnimatedImageView *imageView;

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
    self.imageView.animatedImage = nil;
    self.imageView.image = nil;
}
#pragma mark - Setup UI
- (void)constructView
{
    [self setupImageView];
}

- (void)setupImageView
{
    FLAnimatedImageView *imageView = [FLAnimatedImageView new];
    
    [self addSubview:imageView];
    
    self.imageView = imageView;
}

#pragma mark - Update
- (void)updateWithAnimation:(Animation *)animation
{
    NSData *gifData = [NSData dataWithContentsOfURL:animation.gifURL];
    FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
    
    self.imageView.animatedImage = gifImage;
}

@end
