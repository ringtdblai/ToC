//
//  NSManagedObject+RemoveAll.m
//  Trigger
//
//  Created by Ray Shih on 3/23/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import "NSManagedObject+RemoveAll.h"

#import <BlocksKit.h>

@implementation NSManagedObject (RemoveAll)

+ (RACSignal *)removeAll
{
    return [[[self findAll] fetch]
    doNext:^(NSArray *items) {
        [self removeAllItems:items];
    }];
}

+ (void)removeAllItems:(NSArray *)items
{
    [items bk_each:^(NSManagedObject *item) {
        [item.managedObjectContext deleteObject:item];
    }];
}

@end
