//
//  ApiKit.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/19/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import "ApiKit.h"

#define kCodeSuccess        4000    //有的接口4000表示成功
#define kCodeSuccessZero    0       //还有的接口0表示成功。WTF

@interface ApiKit () {
    
}

@property (nonatomic, strong) RKObjectManager *objectManager;

+ (instancetype)sharedInstance;

+ (RKObjectManager *)objectManager;

/**
 *	API请求
 *
 *	@param	path	REST的PATH
 *	@param	method	请求方式
 *	@param	rootMapping	根对象映射表
 *	@param	parameters	参数字典。【注意】不包含client、sid、sign这三个基本参数
 *	@param	object	要上传的对象（如果是POST）
 *	@param	ok	接口调用成功的回调Block
 *	@param	error	接口调用错误的回调Block
 */
+ (void)requestObjectsAtPath:(NSString *)path
                      method:(RKRequestMethod)method
                 rootMapping:(RKMapping *)rootMapping
                  parameters:(NSDictionary *)parameters
                      object:(id)object
                          ok:(ResultOkCallback)ok
                       error:(ResultErrorCallback)error;

@end



@implementation ApiKit

+ (RKObjectMapping *)mappingWithDataMapping:(RKMapping *)dataMapping {
    RKObjectMapping *rootMapping = [RKObjectMapping mappingForClass:[MORoot class]];
    [rootMapping addAttributeMappingsFromArray:@[@"ret", @"errcode", @"errmsg"]];
    if (dataMapping) {
        [rootMapping addRelationshipMappingWithSourceKeyPath:@"data" mapping:dataMapping];
    }
    else {
        [rootMapping addAttributeMappingsFromArray:@[@"data"]];
    }
    return rootMapping;
}

+ (void)getObjectsAtPath:(NSString *)path
             dataMapping:(RKMapping *)dataMapping
              parameters:(NSDictionary *)parameters
                      ok:(ResultOkCallback)ok
                   error:(ResultErrorCallback)error {
    [self requestObjectsAtPath:path
                        method:RKRequestMethodGET
                   rootMapping:[self mappingWithDataMapping:dataMapping]
                    parameters:parameters
                        object:nil
                            ok:ok
                         error:error];
}

+ (void)postObjectsAtPath:(NSString *)path
              dataMapping:(RKMapping *)dataMapping
               parameters:(NSDictionary *)parameters
                   object:(id)postedObject
                       ok:(ResultOkCallback)ok
                    error:(ResultErrorCallback)error {
    [self requestObjectsAtPath:path
                        method:RKRequestMethodPOST
                   rootMapping:[self mappingWithDataMapping:dataMapping]
                    parameters:parameters
                        object:postedObject
                            ok:ok
                         error:error];
}

#pragma mark - Private

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
        self.objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:APIBaseUrl]];
        [self.objectManager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
        [self.objectManager.HTTPClient setParameterEncoding:AFJSONParameterEncoding];
    }
    return self;
}

+ (RKObjectManager *)objectManager {
    return [ApiKit sharedInstance].objectManager;
}

+ (void)requestObjectsAtPath:(NSString *)path
                      method:(RKRequestMethod)method
                 rootMapping:(RKMapping *)rootMapping
                  parameters:(NSDictionary *)parameters
                      object:(id)object
                     success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                     failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:rootMapping method:method pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKObjectManager *objectManager = [self objectManager];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    NSDictionary *processedParam = parameters;  //if need preprocess
    
    if (method == RKRequestMethodPOST) {
        [objectManager postObject:object ? object : @""
                             path:path
                       parameters:processedParam
                          success:success
                          failure:failure];
    }
    else {
        [objectManager getObjectsAtPath:path
                             parameters:processedParam
                                success:success
                                failure:failure];
    }
}

+ (void)requestObjectsAtPath:(NSString *)path
                      method:(RKRequestMethod)method
                 rootMapping:(RKMapping *)rootMapping
                  parameters:(NSDictionary *)parameters
                      object:(id)object
                          ok:(void (^)(id data, NSString *msg))ok
                       error:(void (^)(id data, NSInteger errorCode, NSString *msg))error {
    [self requestObjectsAtPath:path
                        method:method
                   rootMapping:rootMapping
                    parameters:parameters
                        object:object
                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                           MORoot *response = [mappingResult firstObject];
                           if ( ! [response isKindOfClass:[MORoot class]]) {
                               if (error) {
                                   error(nil, -1, @"数据映射错误");
                               }
                           }
                           else {
                               if (response.ret || response.errcode) {
                                   if (error) {
                                       error(response.data, response.errcode, response.errmsg);
                                   }
                               }
                               else {
                                   if (ok) {
                                       ok(response.data, response.errmsg);
                                   }
                               }
                           }
                       }
                       failure:^(RKObjectRequestOperation *operation, NSError *err) {
                           if (error) {
                               error(nil, -1, @"网络访问错误");
                           }
                       }];
    
}

@end
