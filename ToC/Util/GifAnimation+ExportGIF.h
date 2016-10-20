//
//  GifAnimation+ExportGIF.h
//  ToC
//
//  Created by ringtdblai on 2016/10/20.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "GifAnimation+CoreDataClass.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface GifAnimation (ExportGIF)

- (RACSignal *)exportGIFSignal;

@end
