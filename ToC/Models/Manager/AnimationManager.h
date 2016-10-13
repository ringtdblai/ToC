//
//  AnimationManager.h
//  ToC
//
//  Created by ringtdblai on 2016/10/12.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationManager : NSObject

@property (nonatomic, strong, readonly) NSArray *cAnimations;
@property (nonatomic, strong, readonly) NSArray *tAnimations;
@property (nonatomic, strong, readonly) NSArray *bothAnimations;

+ (instancetype)sharedManager;

@end
