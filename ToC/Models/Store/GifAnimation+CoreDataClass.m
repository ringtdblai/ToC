//
//  GifAnimation+CoreDataClass.m
//  ToC
//
//  Created by LinYiting on 2016/10/20.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "GifAnimation+CoreDataClass.h"
#import "ArrayToDataTransformer.h"

@implementation GifAnimation

// Insert code here to add functionality to your managed object subclass
+ (void)initialize {
    if (self == [GifAnimation class]) {
        ArrayToDataTransformer *transformer = [[ArrayToDataTransformer alloc] init];
        [NSValueTransformer setValueTransformer:transformer forName:@"ArrayToDataTransformer"];
    }
}

@end
