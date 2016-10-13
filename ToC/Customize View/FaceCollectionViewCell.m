//
//  FaceCollectionViewCell.m
//  ToC
//
//  Created by LinYiting on 2016/10/13.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "FaceCollectionViewCell.h"
#import <Masonry.h>
#import "WBMaskedImageView.h"

@interface FaceCollectionViewCell()

@property (nonatomic, weak) WBMaskedImageView *imageView;

@end

@implementation FaceCollectionViewCell

- (void)setSelected:(BOOL)selected{
    self.imageView.layer.borderColor = selected ? [UIColor colorWithRed:0.361 green:0.604 blue:0.941 alpha:1.000].CGColor : [UIColor clearColor].CGColor;
    [super setSelected:selected];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.imageView.originalImage = nil;
}

#pragma mark - Setup UI
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    
    [self setupFaceImageView];
}

- (void)setupFaceImageView
{
    WBMaskedImageView *faceImageView = [WBMaskedImageView new];
    [self.contentView addSubview:faceImageView];
    
    [faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).with.offset(15);
        make.right.bottom.equalTo(self.contentView).with.offset(-15);
    }];
    self.imageView = faceImageView;
}

- (void)updateWithPhotoName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];

    UIImage *customImage = [UIImage imageWithContentsOfFile:imagePath];
    self.imageView.originalImage = customImage;
    self.imageView.maskImage = [UIImage imageNamed:@"catOutline"];
}

@end
