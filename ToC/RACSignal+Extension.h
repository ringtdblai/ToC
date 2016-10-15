//
//  RACSignal+Extension.h
//  Trigger
//
//  Created by Ray Shih on 5/28/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import <ReactiveCocoa.h>

@interface RACSignal (Extension)

- (RACCommand *)convertToCommand;

@end
