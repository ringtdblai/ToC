//
//  KeyboardNotificationHelper.h
//  Trigger
//
//  Created by Ray Shih on 4/5/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardNotificationHelper : NSObject

@property (nonatomic, assign) BOOL isKeyboardShow;

// the view to move according to keyboard frame
- (instancetype)initWithView:(UIView *)view;

- (void)registerKeyboardNotifications;
- (void)unregisterKeyboardNotifications;


@end
