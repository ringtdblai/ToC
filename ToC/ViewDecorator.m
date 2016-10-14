//
//  ViewDecorator.m
//  Trigger
//
//  Created by Ray Shih on 5/5/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import "ViewDecorator.h"

#import <Masonry.h>

@implementation ViewDecorator

+ (UIView *)drawBottomLineInView:(UIView *)view
                      withMargin:(CGFloat)margin
{
    return [ViewDecorator drawBottomLineInView:view
                                    withMargin:margin
                                      andColor:[UIColor colorWithWhite:0.000 alpha:0.240]];
}

+ (UIView *)drawTopLineInView:(UIView *)view
                   withMargin:(CGFloat)margin
{
    return [ViewDecorator drawTopLineInView:view
                                 withMargin:margin
                                   andColor:[UIColor colorWithWhite:0.000 alpha:0.240]];
}

+ (UIView *)drawTopLineInView:(UIView *)view
                   withMargin:(CGFloat)margin
                     andColor:(UIColor *)color
{
    UIView *line = [UIView new];
    line.backgroundColor = color;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5f);
        make.top.equalTo(view);
        make.left.equalTo(view).with.offset(margin);
        make.right.equalTo(view).with.offset(-margin);
    }];
    
    return line;
}

+ (UIView *)drawBottomLineInView:(UIView *)view
                      withMargin:(CGFloat)margin
                        andColor:(UIColor *)color
{
    UIView *line = [UIView new];
    line.backgroundColor = color;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5f);
        make.bottom.equalTo(view);
        make.left.equalTo(view).with.offset(margin);
        make.right.equalTo(view).with.offset(-margin);
    }];
    
    return line;
}

+ (UIView *)drawBottomArrowInView:(UIView *)view
                   withLeftMargin:(CGFloat)margin
{
    UIImageView *arrowImage = [UIImageView new];
    arrowImage.image = [UIImage imageNamed:@"triangle"];
    [view addSubview:arrowImage];
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@8);
        make.width.equalTo(@16);
        make.left.equalTo(view).with.offset(margin);
        make.top.equalTo(view.mas_bottom);
    }];
    
    return arrowImage;
}

+ (UIView *)drawRightLineInView:(UIView *)view
                     withMargin:(CGFloat)margin
                       andColor:(UIColor *)color
{
    UIView *line = [UIView new];
    line.backgroundColor = color;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5f);
        make.right.equalTo(view);
        make.top.equalTo(view).with.offset(margin);
        make.bottom.equalTo(view).with.offset(-margin);
    }];
    
    return line;
}


+ (UIView *)drawRightLineInView:(UIView *)view
                     withMargin:(CGFloat)margin
{
    return [ViewDecorator drawRightLineInView:view
                                    withMargin:margin
                                      andColor:[UIColor colorWithWhite:0.000 alpha:0.240]];
}

@end
