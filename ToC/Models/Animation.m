//
//  Animation.m
//  ToC
//
//  Created by ringtdblai on 2016/10/12.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "Animation.h"

@interface Animation ()

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSURL *gifURL;
@property (nonatomic, strong, readwrite) NSDictionary *animationData;
@property (nonatomic, strong, readwrite) FLAnimatedImage *gifImage;
@property (nonatomic, assign, readwrite) NSTimeInterval duration;

@property (nonatomic, assign, readwrite) CGFloat scaleX;
@property (nonatomic, assign, readwrite) CGFloat scaleY;
@end

@implementation Animation

- (instancetype)initWithImageURL:(NSURL *)imageURL
{
    self = [super init];
    
    if (self) {
        self.gifURL = imageURL;
    }
    
    return self;
}

- (instancetype)initWithData:(NSDictionary *)dataDict
{
    self = [super init];
    
    if (self) {
        self.name = dataDict[@"name"];
        self.animationData = dataDict[@"animation"];
        self.gifURL = [self generateGIFURL];
        self.gifImage = [self generateGIFImage];
        self.duration = [self generateDuration];
        
        CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        self.scaleX = screenWidth / self.gifImage.size.width;
        self.scaleY = screenWidth / self.gifImage.size.height;
        
    }
    
    return self;
}

- (NSURL *)generateGIFURL
{
    if (!self.name || self.name.length == 0) {
        return nil;
    }
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:self.name
                                             withExtension:@"gif"];
    
    return fileURL;

}

- (FLAnimatedImage *)generateGIFImage
{
    NSData *gifData = [NSData dataWithContentsOfURL:self.gifURL];
    FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
    
    return gifImage;
}

- (NSTimeInterval)generateDuration
{
    NSTimeInterval duration = 0;
    
    for (NSNumber *number in [self.gifImage.delayTimesForIndexes allValues]) {
        duration += [number doubleValue];
    }
    
    return duration;
}
@end
