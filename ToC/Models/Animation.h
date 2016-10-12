//
//  Animation.h
//  ToC
//
//  Created by ringtdblai on 2016/10/12.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animation : NSObject

@property (nonatomic, strong, readonly) NSURL *gifURL;

- (instancetype)initWithImageURL:(NSURL *)imageURL;

@end
