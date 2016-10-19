//
//  RACCommand+Extension.m
//  Trigger
//
//  Created by Ray Shih on 5/28/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import "RACCommand+Extension.h"

#import <MBProgressHUD.h>

#import "AlertView.h"

@implementation RACCommand (Extension)

- (void)displayProgressHUDWhileExecutingInView:(UIView *)view
{
    [self.executing subscribeNext:^(id x) {
        if ([x boolValue]) {
            [MBProgressHUD showHUDAddedTo:view animated:YES];
        } else {
            [MBProgressHUD hideAllHUDsForView:view animated:YES];
        }
    }];
}

- (void)displayErrorInAlertViewWithTitle:(NSString *)title
{
    __weak NSString *weakTitle = title;
    [self.errors subscribeNext:^(NSError *error) {
        [AlertView showError:error withTitle:weakTitle];
    }];
}

- (RACDisposable *)subscribeAllNext:(void (^)())callback
{
    return [[[self.executionSignals
    flattenMap:^RACStream *(id value) {
        return [value materialize];
    }] filter:^BOOL(RACEvent *event) {
        return event.eventType == RACEventTypeNext;
    }] subscribeNext:^(id x) {
        callback();
    }];
}

+ (RACCommand *)fromSignal:(RACSignal *(^)())signalFactory
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return signalFactory();
    }];
}

@end
