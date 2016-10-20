//
//  ShareCollectionViewCell.m
//  Pamily
//
//  Created by LinYiting on 2016/9/13.
//  Copyright © 2016年 Pamily. All rights reserved.
//

#import "ShareCollectionViewCell.h"
#import <YYKit.h>

@interface ShareCollectionViewCell()

@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *textLabel;

@end

@implementation ShareCollectionViewCell

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
    self.iconImageView.image = nil;
    self.textLabel.text = nil;
}

- (void)constructView
{
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.width = 50;
    iconImageView.height = 50;
    iconImageView.top = 15;
    iconImageView.centerX = self.contentView.width/2;
    [self.contentView addSubview:iconImageView];
    
    self.iconImageView = iconImageView;
    
    UILabel *textLabel = [UILabel new];
    textLabel.font = [UIFont systemFontOfSize:13];
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.top = iconImageView.bottom + 8;
    textLabel.left = 0;
    textLabel.width = self.contentView.width;
    textLabel.height = 15;
    [self.contentView addSubview:textLabel];
    
    self.textLabel = textLabel;
}

- (void)updateWithData:(NSDictionary *)data
{
    self.iconImageView.image = [UIImage imageNamed:data[@"image"]];
    self.textLabel.text = data[@"text"];
}


@end
