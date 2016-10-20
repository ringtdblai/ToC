//
//  APIClient+Vote.h
//  ToC
//
//  Created by ringtdblai on 2016/10/20.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "APIClient.h"

#define API_VOTE_PATH @"/tocUnderPamily/vote"

@interface APIClient (Vote)

- (RACSignal *)getCurrentVoteCount;

- (RACSignal *)voteFor:(NSString *)name;

@end
