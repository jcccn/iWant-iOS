//
//  Constants.h
//  iWant
//
//  Created by Jiang Chuncheng on 4/19/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#ifndef iWant_Constants_h
#define iWant_Constants_h

#pragma mark - Api Key

#define AppId                   @"111111"

#define BaiduMapApiKey          @"CvYMLpmkBjSIDuW5xaIOGRZr"                 //百度地图ApiKey

#define UmengAppKey             @"5357ebe556240baefc0315f8"                 //友盟统计AppKey

#pragma mark - API Path

#define APIBaseUrl          @"http://115.29.198.184:8080/"              //基地址

#define APIPathRegister         @"/server_web/webapi/user/register"         //注册
#define APIPathLogin            @"/server_web/webapi/user/login"            //登录
#define APIPathGetUserInfo      @"/server_web/webapi/user/info"             //获取用户信息
#define APIPathUpdateUserInfo   @"/server_web/webapi/user/updateuserinfo"   //更新用户信息
#define APIPathUpdatePassword   @"/server_web/webapi/user/updatepwd"        //更新用户密码

#define APIPathPostNeeds        @"/server_web/webapi/request/add"           //发布需求
#define APIPathFindNeeds        @"/server_web/webapi/request/find"          //查找需求

#endif
