//
//  ShareCollectionViewCell.h
//  Pamily
//
//  Created by LinYiting on 2016/9/13.
//  Copyright © 2016年 Pamily. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *shareCollectionViewCellCellIdentifier = @"shareCollectionViewCellCellIdentifier";

@interface ShareCollectionViewCell : UICollectionViewCell

- (void)updateWithData:(NSDictionary *)data;

@end
