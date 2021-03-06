//
//  UIImage+Mask.m
//  ToC
//
//  Created by ringtdblai on 2016/10/14.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "UIImage+Mask.h"


@implementation UIImage (Mask)

+ (UIImage *)maskImage:(UIImage *)image withMaskImage:(UIImage *)maskImage {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGImageRef maskImageRef = [maskImage CGImage];
    
    // create a bitmap graphics context the size of the image
    CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    
    
    if (mainViewContentContext==NULL)
        return NULL;
    
    CGFloat ratio = 0;
    
    ratio = maskImage.size.width/ image.size.width;
    
    if(ratio * image.size.height < maskImage.size.height) {
        ratio = maskImage.size.height/ image.size.height;
    }
    
    CGRect rect1  = {{0, 0}, {maskImage.size.width, maskImage.size.height}};
    CGRect rect2  = {{-((image.size.width*ratio)-maskImage.size.width)/2 , -((image.size.height*ratio)-maskImage.size.height)/2}, {image.size.width*ratio, image.size.height*ratio}};
    
    
    CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);
    CGContextDrawImage(mainViewContentContext, rect2, image.CGImage);
    
    
    // Create CGImageRef of the main view bitmap content, and then
    // release that bitmap context
    CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *theImage = [UIImage imageWithCGImage:newImage];
    
    CGImageRelease(newImage);
    
    // return the image
    return theImage;
}

+ (UIImage *)mergeImageWithBottomImage:(UIImage *)bottomImage
                              topImage:(UIImage *)topImage
                            drawInRect:(CGRect)rect
{
    CGSize size = bottomImage.size;
    
    UIGraphicsBeginImageContext(size);
    
    [bottomImage drawInRect:CGRectMake(0,0,size.width, size.height)];
    [topImage drawInRect:rect];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return finalImage;
}

+ (UIImage *)mergeImageWithBottomImage:(UIImage *)bottomImage
                              topImage:(UIImage *)topImage
                          topTransform:(CGAffineTransform)transform
                            drawInRect:(CGRect)rect
                             watermark:(UIImage *)watermark
{
    CGSize size = bottomImage.size;
    
    UIGraphicsBeginImageContext(size);
    
    [bottomImage drawInRect:CGRectMake(0,0,size.width, size.height)];
    
    if (watermark) {
        CGFloat ratio = watermark.size.height /  watermark.size.width ;
        CGFloat watermarkWidth = size.width * 0.5;
        CGFloat watermarkHeight = watermarkWidth * ratio;
        CGRect watermarkRect = CGRectMake(size.width - watermarkWidth, size.height - watermarkHeight, watermarkWidth, watermarkHeight);
        
        [watermark drawInRect:watermarkRect];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    float xTranslation = CGRectGetMidX(rect);
    float yTranslation = CGRectGetMidY(rect);
    
    CGContextTranslateCTM(context, xTranslation, yTranslation);
    CGContextConcatCTM(context, transform);
    CGContextTranslateCTM(context, -xTranslation, -yTranslation);
    [topImage drawInRect:rect];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return finalImage;
}
@end
