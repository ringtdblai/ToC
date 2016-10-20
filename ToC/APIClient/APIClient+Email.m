//
//  APIClient+Email.m
//  ToC
//
//  Created by LinYiting on 2016/10/20.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "APIClient+Email.h"

@implementation APIClient (Email)

- (RACSignal *)signupWithEmail:(NSString *)email
{
        NSDictionary *params = @{
                                 @"email": email
                                 };
    
    return [self rac_GET:API_SIGNUP_PATH parameters:params];
}

@end
