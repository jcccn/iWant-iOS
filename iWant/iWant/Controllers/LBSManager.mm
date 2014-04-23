//
//  LBSManager.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/24/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import "LBSManager.h"

@interface LBSManager () <BMKMapViewDelegate, BMKSearchDelegate>

@property (nonatomic, strong) NSMutableArray *lbsObservers;

@property (nonatomic, strong) BMKMapManager *mapManager;

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKSearch *mapSearch;

@property (nonatomic, assign) BOOL reversingGeocode;

@end

@implementation LBSManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    if (self = [super init]) {
        
        self.lbsObservers = [NSMutableArray array];
        
        self.mapManager = [[BMKMapManager alloc] init];
        
        [self.mapManager start:BaiduMapApiKey generalDelegate:nil];
        
        self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        self.mapView.delegate = self;
        
        self.mapSearch = [[BMKSearch alloc] init];
        self.mapSearch.delegate = self;
    }
    return self;
}

- (void)start {
    self.reversingGeocode = NO;
    [self.mapManager start:BaiduMapApiKey generalDelegate:nil];
}

- (void)resume {
    self.reversingGeocode = NO;
    if ( ! self.mapView.showsUserLocation) {
        self.mapView.showsUserLocation = YES;
    }
}

- (void)pause {
    if (self.mapView.showsUserLocation) {
        self.mapView.showsUserLocation = NO;
    }
}

- (void)stop {
    [self.mapManager stop];
}

- (void)updateLocation {
    [self resume];
}

- (void)registerLbsObserver:(id<LBSDelegate>)observer {
    if (observer) {
        if ( ! [self.lbsObservers containsObject:observer]) {
            [self.lbsObservers addObject:observer];
        }
    }
}

- (void)unregisterbsObserver:(id<LBSDelegate>)observer {
    if (observer) {
        [self.lbsObservers removeObject:observer];
    }
}

#pragma mark - Baidu Map Delegate

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView {
    
}

- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView {
    
}

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation {
    self.latitude = userLocation.coordinate.latitude;
    self.longitude = userLocation.coordinate.longitude;
    
    [self pause];
    for (id<LBSDelegate> observer in self.lbsObservers) {
        if ([observer respondsToSelector:@selector(lbsSucceed)]) {
            [observer lbsSucceed];
        }
    }
    
    /*
     //暂不需要编码/反编码
    if ( ! self.reversingGeocode) {
        [self pause];
        self.reversingGeocode = YES;
        [self.mapSearch reverseGeocode:userLocation.location.coordinate];
    }
     */
}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    for (id<LBSDelegate> observer in self.lbsObservers) {
        if ([observer respondsToSelector:@selector(lbsFailedWithError:)]) {
            [observer lbsFailedWithError:error];
        }
    }
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error {
    [self pause];
    
    self.address = result;
    
    self.latitude = result.geoPt.latitude;
    self.longitude = result.geoPt.longitude;
    
    for (id<LBSDelegate> observer in self.lbsObservers) {
        if ([observer respondsToSelector:@selector(lbsSucceed)]) {
            [observer lbsSucceed];
        }
    }
}

@end
