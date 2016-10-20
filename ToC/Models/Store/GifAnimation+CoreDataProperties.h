//
//  GifAnimation+CoreDataProperties.h
//  ToC
//
//  Created by LinYiting on 2016/10/20.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "GifAnimation+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface GifAnimation (CoreDataProperties)

+ (NSFetchRequest<GifAnimation *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *imageURL;
@property (nullable, nonatomic, copy) NSString *uniqueId;
@property (nullable, nonatomic, retain) NSObject *bounds;
@property (nullable, nonatomic, retain) NSObject *position;
@property (nullable, nonatomic, retain) NSObject *rotation;
@property (nullable, nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
