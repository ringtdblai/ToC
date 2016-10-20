//
//  UIButton+BackgroundColor.m
//  Trigger
//
//  Created by ringtdblai on 2015/6/5.
//  Copyright (c) 2015年 MobiusBobs Inc. All rights reserved.
//

#import "UIButton+BackgroundColor.h"
#import "UIImage+Color.h"

@implementation UIButton (BackgroundColor)

- (void)setBackgroundColor:(UIColor *)color
                  forState:(UIControlState)state
{
    [self setBackgroundImage:[UIImage imageWithColor:color]
                    forState:state];
}

@end
