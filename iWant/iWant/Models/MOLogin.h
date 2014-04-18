//
//  MOLogin.h
//  iWant
//
//  Created by Jiang Chuncheng on 4/19/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

/**
 *  登录映射对象
 */

#import "MOBase.h"
#import "MOUserInfo.h"

@interface MOLogin : MOBase

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) MOUserInfo *userinfo;

@end
