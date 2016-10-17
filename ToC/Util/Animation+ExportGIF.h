//
//  Animation+ExportGIF.h
//  ToC
//
//  Created by ringtdblai on 2016/10/17.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "Animation.h"

@interface Animation (ExportGIF)

- (void)exportGifWithCompletionHandler:(void (^)(NSURL *gifURL))handler;

@end
