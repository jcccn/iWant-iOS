//
//  LBSManager.h
//  iWant
//
//  Created by Jiang Chuncheng on 4/24/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import "BMapKit.h"
#import "Constants.h"

@protocol LBSDelegate;

@interface LBSManager : NSObject {
    
}

@property (nonatomic, strong) BMKAddrInfo *address;
@property (nonatomic, assign) double latitude;      //维度
@property (nonatomic, assign) double longitude;     //经度

+ (instancetype)sharedInstance;

- (void)start;
- (void)resume;
- (void)pause;
- (void)stop;

- (void)updateLocation;

- (void)registerLbsObserver:(id<LBSDelegate>)observer;
- (void)unregisterbsObserver:(id<LBSDelegate>)observer;

@end


@protocol LBSDelegate <NSObject>

@required
- (void)lbsSucceed;
- (void)lbsFailedWithError:(NSError *)theError;

@end
