//
//  NSManagedObject+RemoveAll.h
//  Trigger
//
//  Created by Ray Shih on 3/23/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <ReactiveCoreData.h>

@interface NSManagedObject (RemoveAll)

+ (RACSignal *)removeAll;
+ (void)removeAllItems:(NSArray *)items;

@end
