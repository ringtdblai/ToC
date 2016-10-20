//
//  ArrayToDataTransformer.m
//  Trigger
//
//  Created by ringtdblai on 2015/7/6.
//  Copyright (c) 2015年 MobiusBobs Inc. All rights reserved.
//

#import "ArrayToDataTransformer.h"

@implementation ArrayToDataTransformer

+ (Class)transformedValueClass
{
    return [NSArray class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
