//
//  NSArray+Immutable.m
//  Trigger
//
//  Created by Ray Shih on 5/22/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import "NSArray+Immutable.h"

@implementation NSArray (Immutable)

- (NSArray *)removedObjectsInArray:(NSArray *)array
{
    NSMutableArray *r = [self mutableCopy];
    [r removeObjectsInArray:array];
    return [r copy];
}

- (NSArray *)insertedWithObject:(id)obj
                        atIndex:(NSInteger)index
{
    NSMutableArray *r = [self mutableCopy];
    [r insertObject:obj atIndex:index];
    return [r copy];
}

- (NSArray *)insertObjectWithArray:(NSArray *)array
{
    NSMutableArray *r = [self mutableCopy];
    [r addObjectsFromArray:array];
    return [r copy];
}

- (NSArray *)replaceObject:(id)obj
                   atIndex:(NSInteger)index
{
    NSMutableArray *r = [self mutableCopy];
    if (index < [self count]) {
        [r replaceObjectAtIndex:index withObject:obj];
    }
    return [r copy];
}
@end
