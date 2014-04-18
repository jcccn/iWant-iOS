//
//  MOUserInfo.h
//  iWant
//
//  Created by Jiang Chuncheng on 4/19/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

/**
 *  用户信息映射对象
 */

#import "MOBase.h"

@interface MOUserInfo : MOBase

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong) NSString *registerDate;
@property (nonatomic, strong) NSString *headpicurl;
@property (nonatomic, strong) NSArray *piclist;

@end
