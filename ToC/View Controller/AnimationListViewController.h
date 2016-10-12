//
//  AnimationListViewController.h
//  ToC
//
//  Created by ringtdblai on 2016/10/12.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AnimationType) {
    AnimationTypeBoth = 0,
    AnimationTypeC = 1,
    AnimationTypeT = 2
};

@interface AnimationListViewController : UIViewController

@property (nonatomic, assign) AnimationType type;

@end

