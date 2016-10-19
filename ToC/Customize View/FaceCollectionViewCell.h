//
//  FaceCollectionViewCell.h
//  ToC
//
//  Created by LinYiting on 2016/10/13.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *faceCollectionViewCellIdentifier = @"faceCollectionViewCellIdentifier";

@interface FaceCollectionViewCell : UICollectionViewCell

- (void)updateWithPhotoName:(NSString *)name;

@end
