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
                              topImage:(UIImage *)topImage
                            drawInRect:(CGRect)rect;

+ (UIImage *)mergeImageWithBottomImage:(UIImage *)bottomImage
                              topImage:(UIImage *)topImage
                          topTransform:(CGAffineTransform)transform
                            drawInRect:(CGRect)rect
                             watermark:(UIImage *)watermark;
@end
