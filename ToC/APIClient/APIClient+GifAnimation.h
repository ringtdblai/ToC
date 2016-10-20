//
//  APIClient+GifAnimation.h
//  ToC
//
//  Created by LinYiting on 2016/10/20.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "APIClient.h"

#define API_ANIMATIONLIST_PATH @"/api/v1/list"

@interface APIClient (GifAnimation)

- (RACSignal *)getListWithType:(NSString *)type;

@end
