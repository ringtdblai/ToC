//
//  AnimationView.h
//  ToC
//
//  Created by ringtdblai on 2016/10/14.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Animation.h"
#import "GifAnimation+CoreDataClass.h"

@interface AnimationView : UIView

@property (nonatomic, strong) GifAnimation *animation;

@end
