//
//  BaseManager.h
//  Trigger
//
//  Created by Ray Shih on 1/22/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BaseManager : NSObject

@property (nonatomic, strong, readonly) RACSubject *reloadTrigger;
@property (atomic, readonly) BOOL isLoading;

- (void)load;
- (void)reloadLocal;

- (void)loadImmediately;

- (void)reset;

- (RACDisposable *)reload;
- (RACSignal *)reloadSignal; // for RACCommand

- (id)initWithUpdateTimeInterval:(NSTimeInterval)timeInterval;

- (RACSignal *)mergeResponse:(NSArray *)response withItems:(NSArray *)items;

// abstract, need to be overwrited
- (RACSignal *)queryAPI;
- (NSArray *)preprocessData:(id)origin;
- (RACSignal *)fetchOldItems;
- (RACSignal *)mappingDataArray:(NSArray *)array;

@end
