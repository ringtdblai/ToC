//
//  TriggerUIMaker.m
//  Trigger
//
//  Created by Ray Shih on 5/28/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import "AnchorUIMaker.h"

// Third Party
#import <Masonry.h>

@implementation AnchorUIMaker

#pragma mark - UIButton
+ (UIButton *)createFacebookLoginButton
{
    UIButton *fbLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIColor *defaultColor = [UIColor colorWithRed:59.0/255.0
                                            green:87/255.0
                                             blue:157/255.0
                                            alpha:1.0];
    
    [fbLoginButton setBackgroundColor:defaultColor];
    
    [fbLoginButton setTitle:@"Login with Facebook"
                   forState:UIControlStateNormal];
    
    [fbLoginButton setImage:[UIImage imageNamed:@"iconFb"]
                   forState:UIControlStateNormal];
    fbLoginButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    fbLoginButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    fbLoginButton.titleLabel.textColor = [UIColor whiteColor];
    fbLoginButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    fbLoginButton.layer.cornerRadius = 4.0f;
    fbLoginButton.clipsToBounds = YES;
    
    return fbLoginButton;
}

+ (UIButton *)createRapidLoginButton
{
    UIButton *rapidLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIColor *defaultColor = [UIColor whiteColor];
    
    [rapidLoginButton setBackgroundColor:defaultColor];
    
    [rapidLoginButton setTitle:@"Rapid Login"
                   forState:UIControlStateNormal];
    
    [rapidLoginButton setImage:[UIImage imageNamed:@"iconFastLogin"]
                   forState:UIControlStateNormal];
    rapidLoginButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    rapidLoginButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [rapidLoginButton setTitleColor:[UIColor colorWithWhite:0.216 alpha:1.000] forState:UIControlStateNormal];
    rapidLoginButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    rapidLoginButton.layer.cornerRadius = 4.0f;
    rapidLoginButton.clipsToBounds = YES;
    
    return rapidLoginButton;

}

@end
