//
//  RACSignal+Extension.m
//  Trigger
//
//  Created by Ray Shih on 5/28/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import "RACSignal+Extension.h"

@implementation RACSignal (Extension)

- (RACCommand *)convertToCommand
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return self;
    }];
}

@end
