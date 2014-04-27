//
//  UpdateProfileViewController.h
//  iWant
//
//  Created by Jiang Chuncheng on 4/22/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

/**
 *  更新用户资料
 */

#import "BaseViewController.h"

@interface UpdateProfileViewController : BaseViewController

@property (nonatomic, assign) BOOL forActivating;       //是否等待激活

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) NSInteger birthday;

@end
