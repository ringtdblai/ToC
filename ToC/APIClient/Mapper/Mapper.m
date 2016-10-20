//
//  Mapper.m
//  Trigger
//
//  Created by Ray Shih on 1/20/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import <ReactiveCoreData/ReactiveCoreData.h>
#import <NSArray+BlocksKit.h>

#import "Mapper.h"

@implementation Mapper

+ (RACSignal *)loadDataArray:(NSArray *)array
                     toStore:(Class)klass
                          by:(MapperBlock)mapper
{
    return [self loadDataArray:array
                       toStore:klass
                            by:mapper
                   withContext:[NSManagedObjectContext currentContext]];
}

+ (RACSignal *)loadDataArray:(NSArray *)array
                     toStore:(Class)klass
                          by:(MapperBlock)mapper
                 withContext:(NSManagedObjectContext *)context
{
    if (!array || array == (id)[NSNull null] || [array count] == 0) {
        return [RACSignal return:@[]];
    }
    
    return [[RACSignal combineLatest:[array bk_map:^id(id data) {
        return [self loadDataDictionary:data
                                toStore:klass
                                     by:mapper
                            withContext:context];
    }]] map:^id(RACTuple *tuple) {
        return tuple.allObjects;
    }];
}

+ (RACSignal *)loadDataDictionary:(NSDictionary *)dictionary
                          toStore:(Class)klass
                               by:(MapperBlock)mapper
{
    return [self loadDataDictionary:dictionary
                            toStore:klass
                                 by:mapper
                        withContext:[NSManagedObjectContext currentContext]];
}

+ (RACSignal *)loadDataDictionary:(NSDictionary *)dictionary
                          toStore:(Class)klass
                               by:(MapperBlock)mapper
                      withContext:(NSManagedObjectContext *)context
{
    RACSignal *objSignal;
    
    if ([dictionary isKindOfClass:[NSDictionary class]] &&
        dictionary[@"_id"]) {
        
        objSignal = [[[[klass findOne]
        where:@"uniqueId"
        equals:dictionary[@"_id"]]
        fetchInMOC:context]
        map:^(id obj) {
            if (!obj) return [klass insert];
            return obj;
        }];
    } else {
        objSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:[klass insert]];
            [subscriber sendCompleted];
            return nil;
        }];
    }
    
    return [objSignal flattenMap:^RACStream *(id obj) {
        return mapper(obj, dictionary);
    }];
}

@end
