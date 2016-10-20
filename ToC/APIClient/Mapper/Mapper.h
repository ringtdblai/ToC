//
//  Mapper.h
//  Trigger
//
//  Created by Ray Shih on 1/20/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa.h>

typedef RACStream *(^MapperBlock)(id obj, NSDictionary *data);

@interface Mapper : NSObject

+ (RACSignal *)loadDataArray:(NSArray *)array
              toStore:(Class)klass
                   by:(MapperBlock)mapper;

+ (RACSignal *)loadDataArray:(NSArray *)array
              toStore:(Class)klass
                   by:(MapperBlock)mapper
          withContext:(NSManagedObjectContext *)context;

+ (RACSignal *)loadDataDictionary:(NSDictionary *)dictionary
                          toStore:(Class)klass
                               by:(MapperBlock)mapper;

+ (RACSignal *)loadDataDictionary:(NSDictionary *)dictionary
                          toStore:(Class)klass
                               by:(MapperBlock)mapper
                      withContext:(NSManagedObjectContext *)context;

@end
