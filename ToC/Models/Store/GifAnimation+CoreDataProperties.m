//
//  GifAnimation+CoreDataProperties.m
//  ToC
//
//  Created by LinYiting on 2016/10/20.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "GifAnimation+CoreDataProperties.h"

@implementation GifAnimation (CoreDataProperties)

+ (NSFetchRequest<GifAnimation *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"GifAnimation"];
}

@dynamic imageURL;
@dynamic uniqueId;
@dynamic bounds;
@dynamic position;
@dynamic rotation;
@dynamic type;
@dynamic width;
@dynamic height;
@dynamic duration;

@end
