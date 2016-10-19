//
//  UIImage+Mask.h
//  ToC
//
//  Created by ringtdblai on 2016/10/14.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Mask)

+ (UIImage *)maskImage:(UIImage *)image
         withMaskImage:(UIImage *)maskImage;

+ (UIImage *)mergeImageWithBottomImage:(UIImage *)bottomImage
                              TopImage:(UIImage *)topImage
                            drawInRect:(CGRect)rect;
@end
