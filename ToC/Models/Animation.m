//
//  Animation.m
//  ToC
//
//  Created by ringtdblai on 2016/10/12.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "Animation.h"

@interface Animation ()

@property (nonatomic, strong, readwrite) NSURL *gifURL;

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

@end
