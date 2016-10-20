//
//  GifAnimation+ExportGIF.m
//  ToC
//
//  Created by ringtdblai on 2016/10/20.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "GifAnimation+ExportGIF.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

// Third Party
#import <FLAnimatedImage.h>
#import <SDWebImageManager.h>

#import "SDWebImage+Swizzle.h"

#import "FaceManager.h"
#import "UIImage+Mask.h"

@implementation GifAnimation (ExportGIF)

- (RACSignal *)exportGIFSignal
{
    @weakify(self);
    return [[self getAnimatedImageSignal]
            flattenMap:^RACStream *(FLAnimatedImage *image) {
                @strongify(self);
                return [self exportGifWithAnimatedImage:image];
            }];
}

- (CGRect)rectAtIndex:(NSUInteger)index
{
    NSArray *positionArray = (NSArray *)self.position;
    NSArray *boundsArray = (NSArray *)self.bounds;
    
    if (!positionArray || ![positionArray isKindOfClass:[NSArray class]] ||
        !boundsArray || ![boundsArray isKindOfClass:[NSArray class]]) {
        return CGRectZero;
    }
    
    if (index >= [positionArray count] || index >= [boundsArray count]) {
        return CGRectZero;
    }
    
    CGRect bounds =  CGRectFromString(boundsArray[index]);
    CGPoint position = CGPointFromString(positionArray[index]);
    
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);
    
    CGFloat minX = position.x - width / 2;
    CGFloat minY = position.y - height / 2;
    
    return CGRectMake(minX, minY, width, height);
}

- (CGAffineTransform)transformAtIndex:(NSUInteger)index
{
    NSArray *rotationArray = (NSArray *)self.rotation;
    
    if (!rotationArray || ![rotationArray isKindOfClass:[NSArray class]]) {
        return CGAffineTransformIdentity;
    }
    
    if (index >= [rotationArray count]) {
        return CGAffineTransformIdentity;
    }
    
    CGFloat angle = [rotationArray[index] floatValue];
    CGFloat radius = M_PI * angle / 180.0f;
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(radius);
    
    return transform;
}

- (NSArray *)generateFrameImagesWithData:(NSData *)gifData
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)gifData,
                                                               (__bridge CFDictionaryRef)@{(NSString *)kCGImageSourceShouldCache: @NO});
    
    NSMutableArray *array = [NSMutableArray array];
    
    
    size_t imageCount = CGImageSourceGetCount(imageSource);
    for (size_t i = 0; i < imageCount; i++) {
        @autoreleasepool {
            CGImageRef frameImageRef = CGImageSourceCreateImageAtIndex(imageSource, i, NULL);
            if (frameImageRef) {
                UIImage *frameImage = [UIImage imageWithCGImage:frameImageRef];
                [array addObject:frameImage];
                CFRelease(frameImageRef);
            } else {
                [array addObject:[NSNull null]];
            }
        }
    }
    
    return array;
}

- (RACSignal *)getAnimatedImageSignal
{
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.imageURL];
    
    if (cachedImage && [cachedImage isKindOfClass:[FLAnimatedImage class]]) {
        FLAnimatedImage *animatedImage = (FLAnimatedImage *)cachedImage;
        
        return [RACSignal return:animatedImage];
    } else {
        @weakify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            
            @strongify(self);
            [manager downloadImageWithURL:[NSURL URLWithString:self.imageURL]
                                  options:0
                                 progress:nil
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
             {
                 if (error) {
                     [subscriber sendError:error];
                 } else {
                     [subscriber sendNext:image];
                     [subscriber sendCompleted];
                 }
             }];
            return nil;
        }];
    }
}

- (RACSignal *)exportGifWithAnimatedImage:(FLAnimatedImage *)animatedImage
{
    NSString *fileName = [self.imageURL.lastPathComponent stringByDeletingPathExtension];
    NSString *pathString = [NSString stringWithFormat:@"masked_%@.gif",fileName];
    NSString *stickerPath = [NSTemporaryDirectory() stringByAppendingPathComponent:pathString];
    NSURL *outputURL = [NSURL fileURLWithPath:stickerPath];
    
    
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        @strongify(self);
        if (![animatedImage isKindOfClass:[FLAnimatedImage class]]) {
            NSError *error = [self errorWithDescription:@"Wrong image format"];
            [subscriber sendError:error];
            return nil;
        }
        
        if ([[NSFileManager defaultManager]fileExistsAtPath:outputURL.path])
        {
            [[NSFileManager defaultManager]removeItemAtPath:outputURL.path error:nil];
        }
        
        CGImageDestinationRef destination = CGImageDestinationCreateWithURL((CFURLRef)outputURL,
                                                                            kUTTypeGIF,
                                                                            animatedImage.frameCount,
                                                                            NULL);
        
        NSArray *frameImages = [self generateFrameImagesWithData:animatedImage.data];
        
        UIImage *watermark = [UIImage imageNamed:@"watermark"];
        
        for (NSUInteger i= 0; i < animatedImage.frameCount; i++) {
            NSNumber *delayTimeNumber = [animatedImage.delayTimesForIndexes objectForKey:@(i)];
            if (delayTimeNumber) {
                NSTimeInterval delayTime = [delayTimeNumber floatValue];
                UIImage *image = frameImages[i];
                UIImage *faceImage = [FaceManager sharedManager].maskedImage;
                CGRect rect = [self rectAtIndex:i];
                CGAffineTransform rotationTransform = [self transformAtIndex:i];
                UIImage *finalImage = [UIImage mergeImageWithBottomImage:image
                                                                topImage:faceImage
                                                            topTransform:rotationTransform
                                                              drawInRect:rect
                                                               watermark:watermark];
                
                NSDictionary *delayTimeProperty = @{(NSString *)kCGImagePropertyGIFDelayTime : @(delayTime)};
                NSDictionary *frameProperties = @{(NSString *)kCGImagePropertyGIFDictionary : delayTimeProperty};
                
                CGImageDestinationAddImage(destination, finalImage.CGImage, (CFDictionaryRef)frameProperties);
                
            }
        }
        
        NSDictionary *loopProperty = @{(NSString *)kCGImagePropertyGIFLoopCount : @0};
        NSDictionary *gifProperties = @{(NSString *)kCGImagePropertyGIFDictionary : loopProperty};
        
        CGImageDestinationSetProperties(destination, (CFDictionaryRef)gifProperties);
        
        CGImageDestinationFinalize(destination);
        CFRelease(destination);
        
        [subscriber sendNext:outputURL];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (NSError *)errorWithDescription:(NSString *)descrtption
{
    return [[NSError alloc] initWithDomain:@"GifAnimation+ExportGIF"
                                      code:-1
                                  userInfo:@{NSLocalizedDescriptionKey:descrtption}];
}

@end
