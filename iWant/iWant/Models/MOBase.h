//
//  MOBase.h
//  iWant
//
//  Created by Jiang Chuncheng on 4/19/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

/**
 *  RestKit对象映射的基类
 */

#import <RestKit/ObjectMapping.h>

@interface MOBase : NSObject {
    
}

/**
 *  对基本属性做对象映射并返回映射表对象
 *
 *  @return 映射表对象
 */
+ (RKObjectMapping *)commonMapping;
+ (RKObjectMapping *)commonMappingWithArray:(NSArray *)arrayOfAttributeNamesOrMappings;
+ (RKObjectMapping *)commonMappingWithDictionary:(NSDictionary *)keyPathToAttributeNames;

@end

@interface MORoot : NSObject

@property (nonatomic, assign) NSInteger ret;
@property (nonatomic, assign) NSInteger errcode;
@property (nonatomic, strong) NSString *errmsg;
@property (nonatomic, strong) id data;

+ (RKObjectMapping *)rootMapping:(RKMapping *)dataMapping;

@end