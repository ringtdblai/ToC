//
//  FaceManager.h
//  ToC
//
//  Created by ringtdblai on 2016/10/13.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FaceManager : NSObject

@property (nonatomic, strong, readonly) NSArray *faces;

@property (nonatomic, strong, readonly) UIImage *selectedFace;
@property (nonatomic, strong, readonly) UIImage *maskImage;


+ (instancetype)sharedManager;

- (void)addFaceWithImage:(UIImage *)image;
- (void)selectFaceWithName:(NSString *)name;
@end
