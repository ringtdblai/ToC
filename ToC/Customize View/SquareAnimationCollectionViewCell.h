//
//  SquareAnimationCollectionViewCell.h
//  ToC
//
//  Created by ringtdblai on 2016/10/12.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Animation.h"

static NSString *squareAnimationCollectionViewCellIdentifier = @"squareAnimationCollectionViewCellIdentifier";

@interface SquareAnimationCollectionViewCell : UICollectionViewCell

- (void)updateWithAnimation:(Animation *)animation;

@end
