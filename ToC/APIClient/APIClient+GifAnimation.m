//
//  APIClient+GifAnimation.m
//  ToC
//
//  Created by LinYiting on 2016/10/20.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "APIClient+GifAnimation.h"

@implementation APIClient (GifAnimation)

- (RACSignal *)getListWithType:(NSString *)type
{
//    NSDictionary *params = @{
//                             @"type": type,
//                             };
    
    return [[self rac_GET:API_ANIMATIONLIST_PATH parameters:nil] logAll];
}

@end
