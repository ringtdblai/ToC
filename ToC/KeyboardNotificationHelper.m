//
//  KeyboardNotificationHelper.m
//  Trigger
//
//  Created by Ray Shih on 4/5/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import "KeyboardNotificationHelper.h"

#import <ReactiveCocoa.h>


@interface KeyboardNotificationHelper () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *view;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic) CGFloat originHeight;
@property (nonatomic) BOOL keyboardIsShowed;

@end

// TODO figure out how to dismiss keyboard interactively
@implementation KeyboardNotificationHelper

// the view to move according to keyboard frame
- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.view = view;
        [self bindKeyBoardSignal];
    }
    
    return self;
}

- (void)registerKeyboardNotifications
{
    self.originHeight = self.view.frame.size.height;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self registerTapGesture];
}

- (void)registerTapGesture
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
    gesture.delegate = self;
    
    @weakify(self);
    [gesture.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer *gesture) {
        @strongify(self);
        if (gesture.state == UIGestureRecognizerStateEnded) {
            [self dismssKeyboard];
        }
    }];
    
    [self.view addGestureRecognizer:gesture];
    self.tapGesture = gesture;
}

- (void)unregisterKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// TODO use autolayout
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameEnd = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    
    __weak KeyboardNotificationHelper *weakSelf = self;
    [UIView animateKeyframesWithDuration:[[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]
                                   delay:0
                                 options:[[keyboardInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]
                              animations:^{
        CGRect frame = weakSelf.view.frame;
        frame.size.height = self.originHeight - keyboardFrameEndRect.size.height;
        weakSelf.view.frame = frame;
    } completion:^(BOOL finished) {
        weakSelf.keyboardIsShowed = YES;
    }];
    
    
}

// TODO use autolayout
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    __weak KeyboardNotificationHelper *weakSelf = self;
    [UIView animateKeyframesWithDuration:[[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]
                                   delay:0
                                 options:[[keyboardInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]
                              animations:^{
                                  CGRect frame = weakSelf.view.frame;
                                  frame.size.height = self.originHeight;
                                  weakSelf.view.frame = frame;
                              }
                              completion:^(BOOL finished) {
                                      self.keyboardIsShowed = NO;
                              }];

}

- (void)dismssKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.keyboardIsShowed;
}

- (void)bindKeyBoardSignal
{
    RAC(self,isKeyboardShow) = [RACObserve(self, keyboardIsShowed) ignore:nil];
}

@end
