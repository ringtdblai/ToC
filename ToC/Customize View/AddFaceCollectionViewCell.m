//
//  AddFaceCollectionViewCell.m
//  ToC
//
//  Created by LinYiting on 2016/10/13.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "AddFaceCollectionViewCell.h"
#import <Masonry.h>

@implementation AddFaceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self constructView];
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

#pragma mark - Setup UI
- (void)constructView
{
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"btnAddNameEdit"];
    
    [self.contentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(self.contentView.frame.size.width/3));
        make.top.equalTo(self.contentView).with.offset(20);
        make.centerX.equalTo(self.contentView);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"ADD FACE";
    titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(20);
        make.centerX.equalTo(imageView);
    }];
}


@end
