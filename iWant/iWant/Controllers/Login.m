//
//  Login.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/23/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import <BlocksKit/BlocksKit.h>

#import "Login.h"

@interface Login ()

@property (nonatomic, assign) BOOL isLogging;

@property (nonatomic, strong) NSMutableArray *loginObservers;

- (void)addKVOObservers;

//登录结果得到后的统一处理
- (void)loginSucceeded;
- (void)loginFailedWithErrorCode:(NSInteger)errCode errorMessage:(NSString *)errMsg;

@end

@implementation Login

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        self.loginObservers = [NSMutableArray array];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.token = [defaults stringForKey:@"login_token"];
        
        [self addKVOObservers];
    }
    return self;
}

- (void)addKVOObservers {
    WeakSelf
    [self bk_addObserverForKeyPath:@"token" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld task:^(id obj, NSDictionary *change) {
        [[NSUserDefaults standardUserDefaults] setObject:weakSelf.token forKey:@"login_token"];
    }];
}

- (void)loginWithAccountName:(NSString *)accountName password:(NSString *)password andObserver:(id<LoginObserver>)observer {
    [self registerLoginObserver:observer];
    if (self.isLogging) {
        return;
    }
    self.isLogging = YES;
    WeakSelf
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:accountName, @"userid", password, @"password", nil];
    [ApiKit getObjectsAtPath:APIPathLogin
                 dataMapping:[MOLogin commonMapping]
                  parameters:param
                          ok:^(id data, NSString *msg) {
                              if ([data isKindOfClass:[MOLogin class]]) {
                                  weakSelf.token = ((MOLogin *)data).token;
                              }
                              
                              [weakSelf loginSucceeded];
                          }
                       error:^(id data, NSInteger errorCode, NSString *errorMsg) {
                           [weakSelf loginFailedWithErrorCode:errorCode errorMessage:errorMsg];
                       }];
}

- (void)logout {
    self.token = nil;
    [ApiKit setToken:nil];
    
    if ([self.rootLoginObserver respondsToSelector:@selector(loggedOut)]) {
        [self.rootLoginObserver loggedOut];
    }
    
    for (id<LoginObserver> observer in self.loginObservers) {
        if ([observer respondsToSelector:@selector(loggedOut)]) {
            [observer loggedOut];
        }
    }
}

- (BOOL)isLogged {
    return [self.token length];
}

- (void)registerLoginObserver:(id<LoginObserver>)observer {
    if (observer) {
        if ( ! [self.loginObservers containsObject:observer]) {
            [self.loginObservers addObject:observer];
        }
    }
}

- (void)unregisterLoginObserver:(id)observer {
    if (observer && [self.loginObservers containsObject:observer]) {
        [self.loginObservers removeObject:observer];
    }
}

#pragma mark - Provate Method

- (void)loginSucceeded {
    self.isLogging = NO;
    
    [ApiKit setToken:self.token];
    
    if ([self.rootLoginObserver respondsToSelector:@selector(loginSucceeded)]) {
        [self.rootLoginObserver loginSucceeded];
    }
    
    for (id<LoginObserver> observer in self.loginObservers) {
        if ([observer respondsToSelector:@selector(loginSucceeded)]) {
            [observer loginSucceeded];
        }
    }
}

- (void)loginFailedWithErrorCode:(NSInteger)errCode errorMessage:(NSString *)errMsg {
    self.isLogging = NO;
    
    for (id<LoginObserver> observer in self.loginObservers) {
        if ([observer respondsToSelector:@selector(loginFailedWithErrorCode:errorMessage:)]) {
            [observer loginFailedWithErrorCode:errCode errorMessage:errMsg];
        }
    }
    
    if ([self.rootLoginObserver respondsToSelector:@selector(loginFailedWithErrorCode:errorMessage:)]) {
        [self.rootLoginObserver loginFailedWithErrorCode:errCode errorMessage:errMsg];
    }
}

@end
