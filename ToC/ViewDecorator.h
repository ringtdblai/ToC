//
//  ViewDecorator.h
//  Trigger
//
//  Created by Ray Shih on 5/5/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewDecorator : NSObject

+ (UIView *)drawBottomLineInView:(UIView *)view
                      withMargin:(CGFloat)margin;

+ (UIView *)drawTopLineInView:(UIView *)view
                   withMargin:(CGFloat)margin;

+ (UIView *)drawTopLineInView:(UIView *)view
                   withMargin:(CGFloat)margin
                     andColor:(UIColor *)color;

+ (UIView *)drawBottomLineInView:(UIView *)view
                      withMargin:(CGFloat)margin
                        andColor:(UIColor *)color;

+ (UIView *)drawBottomArrowInView:(UIView *)view
                   withLeftMargin:(CGFloat)margin;

+ (UIView *)drawRightLineInView:(UIView *)view
                      withMargin:(CGFloat)margin
                        andColor:(UIColor *)color;

+ (UIView *)drawRightLineInView:(UIView *)view
                      withMargin:(CGFloat)margin;


@end
