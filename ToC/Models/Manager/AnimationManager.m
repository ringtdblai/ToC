//
//  AnimationManager.m
//  ToC
//
//  Created by ringtdblai on 2016/10/12.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "AnimationManager.h"

#import <ReactiveCoreData.h>
#import <BlocksKit.h>
#import "NSManagedObject+RemoveAll.h"

#import "APIClient+GifAnimation.h"
#import "Mapper.h"
#import "GifAnimation+Mapper.h"

#import "Animation.h"

@interface AnimationManager ()

@property (nonatomic, strong, readwrite) NSArray *cAnimations;
@property (nonatomic, strong, readwrite) NSArray *tAnimations;
@property (nonatomic, strong, readwrite) NSArray *bothAnimations;

@end

@implementation AnimationManager

+ (instancetype)sharedManager
{
    static AnimationManager *manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[AnimationManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self initializeSignals];
    }
    
    return self;
}

- (void)initializeSignals
{
    RACSubject *trigger = self.reloadTrigger;
    
    RAC(self, cAnimations) = [[[[[GifAnimation findAll]
                           where:@"type == %@ OR type == %@"
                           args:@[@"C", @"B"]]
                          sortBy:@"uniqueId"]
                         fetchWithTrigger:trigger]
                              map:^id(NSArray *x)
                        {
                            return x;
                        }];
    
    RAC(self, tAnimations) = [[[[[GifAnimation findAll]
                                 where:@"type == %@ OR type == %@"
                                 args:@[@"T", @"B"]]
                                sortBy:@"uniqueId"]
                               fetchWithTrigger:trigger]
                              map:^id(NSArray *x)
                              {
                                  return x;
                              }];
}

#pragma mark - Implement
- (RACSignal *)queryAPI
{
    return [[APIClient sharedClient] getListWithType:@""];
}

- (NSArray *)preprocessData:(id)origin
{
    NSLog(@"data:%@",origin);
    return origin;
}

- (RACSignal *)fetchOldItems
{
    return [[GifAnimation findAll]
            fetch];
}

- (RACSignal *)mappingDataArray:(NSArray *)array
{
    return [Mapper loadDataArray:array
                         toStore:[GifAnimation class]
                              by:^RACSignal *(id obj, NSDictionary *data)
            {
                return [GifAnimation updateObject:obj withData:data];
            }];
}


//- (NSArray *)createCAnimations
//{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"CAnimation"
//                                                     ofType:@"plist"];
//    NSArray *array = [NSArray arrayWithContentsOfFile:path];
//    
//    return [[array bk_select:^BOOL(id obj) {
//        return [obj isKindOfClass:[NSDictionary class]];
//    }] bk_map:^id(NSDictionary *dict) {
//        return [[Animation alloc] initWithData:dict];
//    }];
//}

//- (NSArray *)createCAnimations
//{
//    NSMutableArray *animations = [NSMutableArray array];
//    
//    BOOL hasMore = YES;
//    NSInteger index = 1;
//    
//    while (hasMore) {
//        NSString *fileName = [NSString stringWithFormat:@"proC_%ld",(long)index];
//        
//        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:fileName
//                                                 withExtension:@"gif"];
//        if (fileURL) {
//            Animation *animation = [[Animation alloc] initWithImageURL:fileURL];
//            [animations addObject:animation];
//            index ++;
//        } else {
//            hasMore = NO;
//        }
//    }
//    
//    return animations;
//}

//- (NSArray *)createTAnimations
//{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"TAnimation"
//                                                     ofType:@"plist"];
//    NSArray *array = [NSArray arrayWithContentsOfFile:path];
//    
//    return [[array bk_select:^BOOL(id obj) {
//        return [obj isKindOfClass:[NSDictionary class]];
//    }] bk_map:^id(NSDictionary *dict) {
//        return [[Animation alloc] initWithData:dict];
//    }];
//}

//- (NSArray *)createBothAnimations
//{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"BothAnimation"
//                                                     ofType:@"plist"];
//    NSArray *array = [NSArray arrayWithContentsOfFile:path];
//    
//    return [[array bk_select:^BOOL(id obj) {
//        return [obj isKindOfClass:[NSDictionary class]];
//    }] bk_map:^id(NSDictionary *dict) {
//        return [[Animation alloc] initWithData:dict];
//    }];
//
//}

@end
