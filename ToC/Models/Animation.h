//
//  Animation.h
//  ToC
//
//  Created by ringtdblai on 2016/10/12.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FLAnimatedImage.h>

@interface Animation : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSURL *gifURL;
@property (nonatomic, strong, readonly) NSDictionary *animationData;
@property (nonatomic, strong, readonly) FLAnimatedImage *gifImage;
@property (nonatomic, assign, readonly) NSTimeInterval duration;

- (instancetype)initWithImageURL:(NSURL *)imageURL;
- (instancetype)initWithData:(NSDictionary *)dataDict;

@end
