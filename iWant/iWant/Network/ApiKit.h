//
//  ApiKit.h
//  iWant
//
//  Created by Jiang Chuncheng on 4/19/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "Constants.h"
#import "MOBase.h"

typedef void (^ResultOkCallback)(id data, NSString *msg);
typedef void (^ResultErrorCallback)(id data, NSInteger errorCode, NSString *errorMsg);

@interface ApiKit : NSObject

/**
 *  设置API访问自动带上的token
 *
 *  @param token token串
 */
+ (void)setToken:(NSString *)token;

/**
 *	生成根映射表
 *
 *	@param	dataMapping	data的映射表
 *
 *	@return	根对象映射表
 */
+ (RKObjectMapping *)mappingWithDataMapping:(RKMapping *)dataMapping;


/**
 *	通过GET获取数据
 *
 *	@param	path	REST的PATH
 *	@param	dataMapping	数据映射表
 *	@param	parameters	参数字典。【注意】不包含client、sid、sign这三个基本参数
 *	@param	ok	接口调用成功的回调Block
 *	@param	error	接口调用错误的回调Block
 */
+ (void)getObjectsAtPath:(NSString *)path
             dataMapping:(RKMapping *)dataMapping
              parameters:(NSDictionary *)parameters
                      ok:(ResultOkCallback)ok
                   error:(ResultErrorCallback)error;

/**
 *	通过POST获取数据
 *
 *	@param	path	REST的PATH
 *	@param	dataMapping	数据映射表
 *	@param	parameters	参数字典。【注意】不包含client、sid、sign这三个基本参数
 *  @param	postedObject    需要POST的对象
 *	@param	ok	接口调用成功的回调Block
 *	@param	error	接口调用错误的回调Block
 */
+ (void)postObjectsAtPath:(NSString *)path
              dataMapping:(RKMapping *)dataMapping
               parameters:(NSDictionary *)parameters
                   object:(id)postedObject
                       ok:(ResultOkCallback)ok
                    error:(ResultErrorCallback)error;

@end
