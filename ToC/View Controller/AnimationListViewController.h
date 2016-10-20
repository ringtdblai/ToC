//
//  AnimationListViewController.h
//  ToC
//
//  Created by ringtdblai on 2016/10/12.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AnimationType) {
    AnimationTypeClinton = 0,
    AnimationTypeTrump = 1
};

@interface AnimationListViewController : UIViewController

@property (nonatomic, assign) AnimationType type;

@end

