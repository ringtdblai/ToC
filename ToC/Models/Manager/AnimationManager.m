//
//  AnimationManager.m
//  ToC
//
//  Created by ringtdblai on 2016/10/12.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "AnimationManager.h"

#import <BlocksKit/BlocksKit.h>

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
        self.cAnimations = [self createCAnimations];
        self.tAnimations = [self createTAnimations];
        self.bothAnimations = [self createBothAnimations];
    }
    
    return self;
}

- (NSArray *)createCAnimations
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CAnimation"
                                                     ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    return [[array bk_select:^BOOL(id obj) {
        return [obj isKindOfClass:[NSDictionary class]];
    }] bk_map:^id(NSDictionary *dict) {
        return [[Animation alloc] initWithData:dict];
    }];
}

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

- (NSArray *)createTAnimations
{
//    NSMutableArray *animations = [NSMutableArray array];
//    
//    BOOL hasMore = YES;
//    NSInteger index = 1;
//    
//    while (hasMore) {
//        NSString *fileName = [NSString stringWithFormat:@"proT_%ld",(long)index];
//        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:fileName
//                                                 withExtension:@"gif"];
//
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TAnimation"
                                                     ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    return [[array bk_select:^BOOL(id obj) {
        return [obj isKindOfClass:[NSDictionary class]];
    }] bk_map:^id(NSDictionary *dict) {
        return [[Animation alloc] initWithData:dict];
    }];
}

- (NSArray *)createBothAnimations
{
//    NSMutableArray *animations = [NSMutableArray array];
//    
//    BOOL hasMore = YES;
//    NSInteger index = 1;
//    
//    while (hasMore) {
//        NSString *fileName = [NSString stringWithFormat:@"Both_%ld",(long)index];
//        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:fileName
//                                                 withExtension:@"gif"];
//        
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BothAnimation"
                                                     ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    return [[array bk_select:^BOOL(id obj) {
        return [obj isKindOfClass:[NSDictionary class]];
    }] bk_map:^id(NSDictionary *dict) {
        return [[Animation alloc] initWithData:dict];
    }];

}

@end
