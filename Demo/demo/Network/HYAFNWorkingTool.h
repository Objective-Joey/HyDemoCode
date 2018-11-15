//
//  DYAFNWorkingTool.h
//  HYBaseProject
//
//  Created by huangyi on 17/3/29.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <YYKit/YYCache.h>

#define loadSuccess [responseObject[@"rsp_code"]  isEqualToString:@"succ"]

static NSString *const HYCache = @"HYCache";
static NSString *const NetErrorTitle = @"网络连接失败";
static NSString *const BaseUrl = @"HYBaseProject.com";

typedef enum {
    NetworkingStatusReachableViaWWAN, // 2，3，4G网络
    NetworkingStatusReachbleViaWiFi, // WiFi网络
    NetworkingStatusUnKnown,        // 未知网络
    NetworkingStatusNotReachable,  // 未连接网络
}NetworkingStatus;


typedef void(^ResponseSuccess)(id response);
typedef void(^ResponseFail)(NSError *error);
@interface HYAFNWorkingTool : NSObject

// Get
+ (NSURLSessionDataTask *)getWithUrl:(NSString *)url
                              params:(NSDictionary *)params
                             success:(ResponseSuccess)success
                             failure:(ResponseFail)failure;
// Get 缓存
+ (NSURLSessionDataTask *)getCacheDataWithUrl:(NSString *)url
                                       params:(NSDictionary *)params
                                      success:(ResponseSuccess)success
                                      failure:(ResponseFail)failure;


// Post
+ (NSURLSessionDataTask *)postWithUrl:(NSString *)url
                               params:(NSDictionary *)params
                             success:(ResponseSuccess)success
                              failure:(ResponseFail)failure;

// Post 缓存
+ (NSURLSessionDataTask *)postCacheDataWithUrl:(NSString *)url
                                        params:(NSDictionary *)params
                                       success:(ResponseSuccess)success
                                       failure:(ResponseFail)failure;

// 上传图片
+ (NSURLSessionDataTask *)postImageWithUrl:(NSString *)url
                   param:(NSDictionary *)param
               dataArray:(NSArray<NSData *> *)dataArray
                 success:(ResponseSuccess)success
                 failure:(ResponseFail)failure;


+ (void)checkNetworkingStatusWithChangeCallback:(void(^)(NetworkingStatus status))ChangeCallback; // 监听网络状态变化
+ (void)setCache:(id<NSCoding>)Cache forKey:(NSString *)key; // 设置缓存
+ (id<NSCoding>)getCacheForKey:(NSString *)key; // 获取某个key的缓冲
+ (AFHTTPSessionManager *)getNetworkManager; // 获取缓存管理
+ (NetworkingStatus)getNetworkingStatus;    // 获取网络状态
+ (unsigned long long)totalCacheSize;      // 获取缓存总大小
+ (YYCache *)getCacheManager;             // 获取缓存管理
+ (void)cancelAllTasks;                  // 取消所有网络请求
+ (void)clearCaches;                    // 清除缓存

@end
