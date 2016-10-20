//
//  APIClient+Vote.m
//  ToC
//
//  Created by ringtdblai on 2016/10/20.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "APIClient+Vote.h"

@implementation APIClient (Vote)

- (RACSignal *)getCurrentVoteCount
{
    return [self rac_GET:API_VOTE_PATH parameters:nil];
}

- (RACSignal *)voteFor:(NSString *)name
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (name) {
        params[@"votoFor"] = name;
    }

    return [self rac_POST:API_VOTE_PATH parameters:params];
}
@end
