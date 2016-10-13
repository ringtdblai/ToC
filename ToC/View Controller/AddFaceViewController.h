//
//  AddFaceViewController.h
//  ToC
//
//  Created by LinYiting on 2016/10/13.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddFaceViewControllerDelegate <NSObject>
@optional
- (void)didSelectFace:(NSString *)name;
@end


@interface AddFaceViewController : UIViewController

@property (nonatomic, weak) id<AddFaceViewControllerDelegate> delegate;

@end
