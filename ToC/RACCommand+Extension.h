//
//  RACCommand+Extension.h
//  Trigger
//
//  Created by Ray Shih on 5/28/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa.h>

@interface RACCommand (Extension)

- (void)displayProgressHUDWhileExecutingInView:(UIView *)view;
- (void)displayErrorInAlertViewWithTitle:(NSString *)title;
- (RACDisposable *)subscribeAllNext:(void (^)())callback;
+ (RACCommand *)fromSignal:(RACSignal *(^)())signalFactory;

@end
