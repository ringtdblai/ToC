//
//  GifAnimation+Mapper.h
//  ToC
//
//  Created by LinYiting on 2016/10/20.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "GifAnimation+CoreDataClass.h"
#import <ReactiveCoreData.h>

@interface GifAnimation (Mapper)

+ (RACSignal *)updateObject:(GifAnimation *)animation
                   withData:(NSDictionary *)data;

@end
