//
//  MOLogin.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/19/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import "MOLogin.h"

@implementation MOLogin

+ (RKObjectMapping *)commonMapping {
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[self class]];
    [objectMapping addAttributeMappingsFromArray:@[@"token"]];
    [objectMapping addRelationshipMappingWithSourceKeyPath:@"userinfo" mapping:[MOUserInfo commonMapping]];
    
    return objectMapping;
}

@end
