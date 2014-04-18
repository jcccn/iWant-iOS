//
//  MOBase.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/19/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import <objc/runtime.h>

#import "MOBase.h"

@implementation MOBase

+ (RKObjectMapping *)commonMapping {
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[self class]];
    
    NSMutableArray *propertyArray = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
        
        //只针对特殊类型的属性才做Mapping
        NSString *propertyType = [[[NSString alloc] initWithCString:property_getAttributes(property) encoding:NSASCIIStringEncoding] lowercaseString];
        if ([propertyType hasPrefix:@"ti,"] || //int or NSInteger
            [propertyType hasPrefix:@"tf,"] || //float
            [propertyType hasPrefix:@"td,"] || //double
            [propertyType hasPrefix:@"tl,"] || //long
            [propertyType hasPrefix:@"tq,"] || //long long
            [propertyType hasPrefix:@"tc,"] || //BOOL
            [propertyType hasPrefix:@"t@\"nsnumber\","] ||
            [propertyType hasPrefix:@"t@\"nsstring\","]
            ) {
            [propertyArray addObject:propertyName];
        }
    }
    free(properties);
    
    [objectMapping addAttributeMappingsFromArray:propertyArray];
    return objectMapping;
}

+ (RKObjectMapping *)commonMappingWithArray:(NSArray *)arrayOfAttributeNamesOrMappings {
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[self class]];
    [objectMapping addAttributeMappingsFromArray:arrayOfAttributeNamesOrMappings];
    return objectMapping;
}

+ (RKObjectMapping *)commonMappingWithDictionary:(NSDictionary *)keyPathToAttributeNames {
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[self class]];
    [objectMapping addAttributeMappingsFromDictionary:keyPathToAttributeNames];
    return objectMapping;
}

@end


@implementation MORoot

+ (RKObjectMapping *)rootMapping:(RKMapping *)dataMapping {
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[self class]];
    [responseMapping addAttributeMappingsFromArray:@[@"ret",@"errcode",@"errmsg"]];
    if (dataMapping) {
        [responseMapping addRelationshipMappingWithSourceKeyPath:@"data" mapping:dataMapping];
    }
    else {
        [responseMapping addAttributeMappingsFromArray:@[@"data"]];
    }
    return responseMapping;
}

@end