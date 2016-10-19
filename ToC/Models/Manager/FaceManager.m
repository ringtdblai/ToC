//
//  FaceManager.m
//  ToC
//
//  Created by ringtdblai on 2016/10/13.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "FaceManager.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "UIImage+Mask.h"

@interface FaceManager ()

@property (nonatomic, strong, readwrite) NSArray *faces;

@property (nonatomic, strong, readwrite) UIImage *selectedFace;
@property (nonatomic, strong, readwrite) UIImage *maskImage;
@property (nonatomic, strong, readwrite) UIImage *maskedImage;

@end

@implementation FaceManager

+ (instancetype)sharedManager
{
    static FaceManager *manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[FaceManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self bindData];
    }
    
    return self;
}

#pragma mark - Binding
- (void)bindData
{
    RAC(self, selectedFace) = [[[[NSUserDefaults standardUserDefaults] rac_channelTerminalForKey:@"selectedFace"]
                                distinctUntilChanged]
                               map:^id(NSString *name) {
                                   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                   NSString *documentsDirectory = [paths objectAtIndex:0];
                                   NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];
                                   
                                   return [UIImage imageWithContentsOfFile:imagePath];
                               }];
    
    RAC(self, faces) = [[[NSUserDefaults standardUserDefaults] rac_channelTerminalForKey:@"photos"]
                        distinctUntilChanged];
    
    @weakify(self);
    [[[RACObserve(self, faces) ignore:nil] take:1]
     subscribeNext:^(NSArray *faces) {
         @strongify(self);
         [self selectFaceWithName:[faces firstObject]];
     }];
    
    self.maskImage = [UIImage imageNamed:@"catOutline"];
    
    RAC(self, maskedImage) = [RACSignal combineLatest:@[RACObserve(self, selectedFace),
                                                        RACObserve(self, maskImage)]
                                               reduce:^id(UIImage *selectedFace, UIImage *maskImage)
                              {
                                  return [UIImage maskImage:selectedFace
                                              withMaskImage:maskImage];
                              }];
}

#pragma mark - Edit
- (void)addFaceWithImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *UUID = [[NSUUID UUID] UUIDString];
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",UUID]];
    
    NSLog(@"pre writing to file");
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog(@"Failed to cache image data to disk");
    }
    else
    {
        NSLog(@"the cachedImagedPath is %@",imagePath);
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"photos"]) {
            NSArray *photos = [[NSUserDefaults standardUserDefaults] objectForKey:@"photos"];
            NSMutableArray *photosArray = [[NSMutableArray alloc] initWithArray:photos];
            [photosArray addObject:UUID];
            [[NSUserDefaults standardUserDefaults] setObject:photosArray forKey:@"photos"];
        } else {
            NSMutableArray *photosArray = [[NSMutableArray alloc] init];
            [photosArray addObject:UUID];
            [[NSUserDefaults standardUserDefaults] setObject:photosArray forKey:@"photos"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)selectFaceWithName:(NSString *)name;
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"selectedFace"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
