//
//  Login.h
//  iWant
//
//  Created by Jiang Chuncheng on 4/23/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

/**
 *  管理用户登录
 */

#import "ApiKit.h"
#import "MOLogin.h"

@protocol LoginObserver;

@interface Login : NSObject {
    
}

@property (nonatomic, copy) NSString *token;

@property (nonatomic, weak) id<LoginObserver> rootLoginObserver;    //主监听器。不放在监听列表数组里面。登录成功类要先通知给主监听器，失败类后通知给主监听器

+ (instancetype)sharedInstance;

/**
 *  登录
 *
 *  @param accountName 登录账号
 *  @param password    登录密码
 *  @param observer    登录监听
 */
- (void)loginWithAccountName:(NSString *)accountName password:(NSString *)password andObserver:(id<LoginObserver>)observer;
/**
 *  注销登录
 */
- (void)logout;

- (BOOL)isLogged;

/**
 *  注册登录监听
 *
 *  @param observer 监听者
 */
- (void)registerLoginObserver:(id<LoginObserver>)observer;
/**
 *  取消登录监听
 *
 *  @param observer 监听者
 */
- (void)unregisterLoginObserver:(id)observer;

@end

/**
 *  登录的监听
 */
@protocol LoginObserver <NSObject>

@required
- (void)loginSucceeded;
- (void)loginFailedWithErrorCode:(NSInteger)errCode errorMessage:(NSString *)errMsg;
- (void)loggedOut;

@end
