//
//  APIClient+Email.h
//  ToC
//
//  Created by LinYiting on 2016/10/20.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "APIClient.h"

#define API_SIGNUP_PATH @"/tocUnderPamily/signup"

@interface APIClient (Email)

- (RACSignal *)signupWithEmail:(NSString *)email;

@end
