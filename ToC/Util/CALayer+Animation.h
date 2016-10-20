//
//  CALayer+Animation.h
//  ToC
//
//  Created by ringtdblai on 2016/10/14.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GifAnimation+CoreDataClass.h"

#import "Animation.h"
@interface CALayer (Animation)

+ (instancetype)layerWithAnimation:(GifAnimation *)animation
                         scaleSize:(CGSize)scaleSize;

@end
