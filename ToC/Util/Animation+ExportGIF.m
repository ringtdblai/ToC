//
//  Animation+ExportGIF.m
//  ToC
//
//  Created by ringtdblai on 2016/10/17.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "Animation+ExportGIF.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "FaceManager.h"
#import "UIImage+Mask.h"

@implementation Animation (ExportGIF)

- (void)exportGifWithCompletionHandler:(void (^)(NSURL *gifURL))handler
{
    NSString *fileName = [NSString stringWithFormat:@"masked_%@.gif",self.name];
    NSString *stickerPath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    NSURL *outputURL = [NSURL fileURLWithPath:stickerPath];

    if ([[NSFileManager defaultManager]fileExistsAtPath:outputURL.path])
    {
        [[NSFileManager defaultManager]removeItemAtPath:outputURL.path error:nil];
    }
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((CFURLRef)outputURL,
                                                                        kUTTypeGIF,
                                                                        self.gifImage.frameCount,
                                                                        NULL);
    
    NSArray *frameImages = [self generateFrameImages];
    
    UIImage *watermark = [UIImage imageNamed:@"watermark"];
    
    for (NSUInteger i= 0; i < self.gifImage.frameCount; i++) {
        NSNumber *delayTimeNumber = [self.gifImage.delayTimesForIndexes objectForKey:@(i)];
        if (delayTimeNumber) {
            NSTimeInterval delayTime = [delayTimeNumber floatValue];
            UIImage *image = frameImages[i];
            UIImage *faceImage = [FaceManager sharedManager].maskedImage;
            CGRect rect = [self rectAtIndex:i];
            UIImage *finalImage = [UIImage mergeImageWithBottomImage:image
                                                            topImage:faceImage
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
    
    handler(outputURL);
}

- (CGRect)rectAtIndex:(NSUInteger)index
{
    NSArray *positionArray = self.animationData[@"position"];
    NSArray *boundsArray = self.animationData[@"bounds"];
    
    if (!positionArray || !boundsArray) {
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

- (NSArray *)generateFrameImages
{
    
    NSData *gifData = [NSData dataWithContentsOfURL:self.gifURL];

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

- (RACSignal *)exportGifSignal
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self exportGifWithCompletionHandler:^(NSURL *gifURL) {
            [subscriber sendNext:gifURL];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}
@end
