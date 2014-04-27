//
//  MOUserInfo.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/19/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import "MOUserInfo.h"

@implementation MOUserInfo

+ (RKObjectMapping *)commonMapping {
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[self class]];
    [objectMapping addAttributeMappingsFromArray:@[@"name", @"birthday", @"gender", @"active", @"registerDate", @"headpicurl", @"piclist"]];
    [objectMapping addAttributeMappingsFromDictionary:@{@"_id": @"userId"}];
    
    return objectMapping;
}

@end
