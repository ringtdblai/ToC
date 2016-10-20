//
//  BaseManager.m
//  Trigger
//
//  Created by Ray Shih on 1/22/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import "BaseManager.h"

#import "NSManagedObject+RemoveAll.h"
#import "NSArray+Immutable.h"
#import "AlertView.h"

@interface BaseManager ()

@property (atomic, readwrite) BOOL isLoading;
@property (nonatomic, assign) NSTimeInterval updateTimeInterval;
@property (nonatomic, strong, readwrite) NSDate *lastUpdateTime;

@end

@implementation BaseManager
@synthesize reloadTrigger = _reloadTrigger;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.updateTimeInterval = 0;
    }
    return self;
}

- (id)initWithUpdateTimeInterval:(NSTimeInterval)timeInterval
{
    self = [super init];
    if (self) {
        self.updateTimeInterval = timeInterval;
    }
    return self;
}

- (RACSubject *)reloadTrigger
{
    if (!_reloadTrigger) {
        _reloadTrigger = [RACSubject subject];
    }
    
    return _reloadTrigger;
}

- (void)load
{
    if ([self shouldLoad]) {
        [self reloadLocal];
        [self reload];
    }
}

- (void)reloadLocal
{
    [self.reloadTrigger sendNext:@1];   // load from db first
}

- (void)loadImmediately
{
    [self reset];
    [self load];
}

- (void)reset
{
    self.lastUpdateTime = nil;
}

- (BOOL)shouldLoad
{
    if (self.updateTimeInterval == 0) {
        return YES;
    }
    if (!self.lastUpdateTime) {
        return YES;
    }
    NSDate *currentTime = [NSDate date];
    NSTimeInterval timeInterval = [currentTime timeIntervalSinceDate:self.lastUpdateTime];
    if (timeInterval > self.updateTimeInterval) {
        return YES;
    }
    return NO;
}

#pragma mark - Reload

// TODO: handle error
- (RACDisposable *)reload
{
    if (self.isLoading) {
        return nil;
    }
    
    self.isLoading = YES;
    
    RACSignal *queryAPISignal = [self queryAPIAndPreprocess];
    
    RACSignal *oldItemsSignal = [self fetchOldItems];
    
    @weakify(self);
    return [[[RACSignal combineLatest:@[queryAPISignal, oldItemsSignal]]
            flattenMap:^RACStream *(id value)
    {
        @strongify(self);
        RACTupleUnpack(NSArray *response, NSArray *oldItems) = value;
        return [self mergeResponse:response withItems:oldItems];
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self reloadLocal];
        self.isLoading = NO;
        self.lastUpdateTime = [NSDate date];
    } error:^(NSError *error) {
        @strongify(self);
        self.isLoading = NO;
        // TODO:
        NSLog(@"error: %@", error.localizedDescription);
        [AlertView showError:error withTitle:NSLocalizedString(@"Error", nil)];
    }];
}


- (RACSignal *)reloadSignal
{
    if (self.isLoading) {
        return nil;
    }
    
    self.isLoading = YES;
    
    RACSignal *queryAPISignal = [self queryAPIAndPreprocess];
    
    RACSignal *oldItemsSignal = [self fetchOldItems];
    
    @weakify(self);
    return [[[[RACSignal combineLatest:@[queryAPISignal, oldItemsSignal]]
             flattenMap:^RACStream *(id value)
             {
                 @strongify(self);
                 RACTupleUnpack(NSArray *response, NSArray *oldItems) = value;
                 return [self mergeResponse:response withItems:oldItems];
             }] doNext:^(id x) {
                 @strongify(self);
                 [self reloadLocal];
                 self.isLoading = NO;
                 self.lastUpdateTime = [NSDate date];
             }] doError:^(NSError *error) {
                 @strongify(self);
                 self.isLoading = NO;
                 // TODO:
                 NSLog(@"error: %@", error.localizedDescription);
             }];
}

- (RACSignal *)queryAPIAndPreprocess
{
    @weakify(self);
    return [[self queryAPI] map:^id(RACTuple *tuple)
    {
        @strongify(self);
        return [self preprocessData:tuple.first];
    }];
}

- (RACSignal *)mergeResponse:(NSArray *)response withItems:(NSArray *)items
{
    return [[[self mappingDataArray:response]
             map:^id(NSArray *updatedItems)
    {
        return [items removedObjectsInArray:updatedItems];
    }] doNext:^(NSArray *toDelete) {
        [NSManagedObject removeAllItems:toDelete];
    }];
}

#pragma mark - Abstract Methods
- (RACSignal *)queryAPI { return [RACSignal return:nil]; }
- (NSArray *)preprocessData:(id)origin { return nil; }
- (RACSignal *)fetchOldItems { return [RACSignal return:nil]; }
- (RACSignal *)mappingDataArray:(NSArray *)array { return nil; }

@end
