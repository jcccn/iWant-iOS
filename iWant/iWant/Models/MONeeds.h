//
//  MONeeds.h
//  iWant
//
//  Created by Jiang Chuncheng on 4/22/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

/**
 *  需求的映射对象
 */

#import "MOBase.h"

@interface MONeeds : MOBase

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, assign) double longtitude;
@property (nonatomic, assign) double latitude;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSTimeInterval todate;    //有效时间，秒
@property (nonatomic, assign) NSTimeInterval startdate;
@property (nonatomic, assign) NSTimeInterval expiredate;
@property (nonatomic, assign) NSInteger status;

@end
