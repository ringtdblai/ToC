//
//  SDImageCache+Swizzle.m
//
//  Created by Herb Brewer on 07.02.15.
//  Copyright (c) 2015 1984pulse. All rights reserved.
//

#import "SDWebImage+Swizzle.h"

#import <UIKit/UIKit.h>
#import <JRSwizzle/JRSwizzle.h>
#import <SDWebImage/UIImage+GIF.h>
#import <SDWebImage/UIImage+MultiFormat.h>
#import <SDWebImage/SDWebImageDecoder.h>
#import <SDWebImage/SDWebImageDownloaderOperation.h>
#import <FLAnimatedImage/FLAnimatedImage.h>
#import <FLAnimatedImage/FLAnimatedImageView.h>

@interface FLAnimatedImage (Swizzle)

- (CGFloat)scale;
- (NSArray *)images;

@end

@implementation FLAnimatedImage (Swizzle)

- (CGFloat)scale {
    return self.posterImage.scale;
}

- (NSArray *)images {
    return nil;
}

@end

@implementation UIImage (Swizzle)

+ (void)swizzle {
    NSError *error = nil;
    [self jr_swizzleClassMethod:@selector(sd_animatedGIFWithData:) withClassMethod:@selector(fl_animatedGIFWithData:) error:&error];
    [self jr_swizzleClassMethod:@selector(decodedImageWithImage:) withClassMethod:@selector(swizzledDecodedImageWithImage:) error:&error];
}

+ (UIImage *)fl_animatedGIFWithData:(NSData *)data {
    return (UIImage *)[[FLAnimatedImage alloc] initWithAnimatedGIFData:data];
}

+ (UIImage *)swizzledDecodedImageWithImage:(UIImage *)image {
    if ([image isKindOfClass:[UIImage class]]) {
        [self swizzledDecodedImageWithImage:image];
    }
    return image;
}

@end

@implementation UIImageView (Swizzle)

+ (void)swizzle {
    NSError *error = nil;
    [self jr_swizzleMethod:@selector(setImage:) withMethod:@selector(swizzledSetImage:) error:&error];
}

- (void)swizzledSetImage:(UIImage *)image {
    if ([image isKindOfClass:[FLAnimatedImage class]]) {
        if ([self isKindOfClass:[FLAnimatedImageView class]]) {
            __weak FLAnimatedImageView *imageView = (FLAnimatedImageView *)self;
            [imageView setAnimatedImage:(FLAnimatedImage *)image];
            return ;
        } else {
            image = ((FLAnimatedImage *)image).posterImage;
        }
    }
    [self swizzledSetImage:image];
}

@end

@interface SDWebImageDownloaderOperation()

- (UIImage *)scaledImageForKey:(NSString *)key image:(UIImage *)image;

@end

@implementation SDWebImageDownloaderOperation (Swizzle)

+ (void)swizzle {
    NSError *error = nil;
    [self jr_swizzleMethod:@selector(scaledImageForKey:image:) withMethod:@selector(swizzledScaledImageForKey:image:) error:&error];
}

- (UIImage *)swizzledScaledImageForKey:(NSString *)key image:(UIImage *)image {
    if ([image isKindOfClass:[UIImage class]]) {
        return SDScaledImageForKey(key, image);
    }
    return image;
}

@end

@interface SDImageCache ()

- (UIImage *)diskImageForKey:(NSString *)key;
- (NSData *)diskImageDataBySearchingAllPathsForKey:(NSString *)key;
- (UIImage *)scaledImageForKey:(NSString *)key image:(UIImage *)image;

@end

@implementation SDImageCache (Swizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzle];
    });
}

+ (void)swizzle {
    [UIImage swizzle];
    [UIImageView swizzle];
    [SDWebImageDownloaderOperation swizzle];
    NSError *error = nil;
    [self jr_swizzleMethod:@selector(diskImageForKey:) withMethod:@selector(swizzledDiskImageForKey:) error:&error];
    [self jr_swizzleMethod:@selector(storeImage:recalculateFromImage:imageData:forKey:toDisk:) withMethod:@selector(swizzledStoreImage:recalculateFromImage:imageData:forKey:toDisk:) error:&error];
}

- (UIImage *)swizzledDiskImageForKey:(NSString *)key {
    NSData *data = [self diskImageDataBySearchingAllPathsForKey:key];
    if (data == nil) {
        return nil;
    }
    UIImage *image = [UIImage sd_imageWithData:data];
    if ([image isKindOfClass:[UIImage class]]) {
        image = [self scaledImageForKey:key image:image];
        if (self.shouldDecompressImages) {
            image = [UIImage decodedImageWithImage:image];
        }
    }
    return image;
}

- (void)swizzledStoreImage:(UIImage *)image recalculateFromImage:(BOOL)recalculate imageData:(NSData *)imageData forKey:(NSString *)key toDisk:(BOOL)toDisk {
    if ([image isKindOfClass:[FLAnimatedImage class]]) {
        if (toDisk) {
            NSData *data = imageData;
            if (image && (recalculate || !data)) {
                FLAnimatedImage *animtedImage = (FLAnimatedImage *)image;
                data = animtedImage.data;
            }
            [self swizzledStoreImage:image recalculateFromImage:NO imageData:data forKey:key toDisk:toDisk];
        }
    } else {
        [self swizzledStoreImage:image recalculateFromImage:recalculate imageData:imageData forKey:key toDisk:toDisk];
    }
}

@end
