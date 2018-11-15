//
//  DYAFNWorkingTool.m
//  HYBaseProject
//
//  Created by huangyi on 17/3/29.
//  Copyright © 2017年 huangyi. All rights reserved.


#import "HYAFNWorkingTool.h"
#import <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD+HYExtension.h"
#import <YYKit/YYKit.h>
#import <AFNetworking/AFNetworking.h>

typedef enum {
    RequestTypeGet,
    RequestTypePost
} RequestType;

static double RequestTimeout = 60.0f;
static AFHTTPSessionManager *mgr;
static YYCache *_yyCache;
static NetworkingStatus _networkingStatus;

@implementation HYAFNWorkingTool
+ (void)load {
    mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = RequestTimeout;
    mgr.operationQueue.maxConcurrentOperationCount = 10;
    mgr.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[ @"application/json",
                                                                           @"text/html",
                                                                           @"text/json",
                                                                           @"text/plain",
                                                                           @"text/javascript",
                                                                           @"text/xml",
                                                                           @"image/*",
                                                                           @"text/css"
                                                                           ]];
    _yyCache = [YYCache cacheWithName:HYCache];
    _yyCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    [self seachNetworkingStatusWithChangeBlock:nil];
}

// Get
+ (NSURLSessionDataTask *)getWithUrl:(NSString *)url
            params:(NSDictionary *)params
           success:(ResponseSuccess)success
           failure:(ResponseFail)failure {
    return
    [self requestWithRequestType:RequestTypeGet
                         url:url
                      params:params
                     isCache:NO
                     success:success
                     failure:failure];
}

// Get 缓存
+ (NSURLSessionDataTask *)getCacheDataWithUrl:(NSString *)url
                     params:(NSDictionary *)params
                    success:(ResponseSuccess)success
                    failure:(ResponseFail)failure {
    return
    [self requestWithRequestType:RequestTypeGet
                             url:url
                          params:params
                         isCache:YES
                         success:success
                         failure:failure];
}

// Post
+ (NSURLSessionDataTask *)postWithUrl:(NSString *)url
             params:(NSDictionary *)params
            success:(ResponseSuccess)success
            failure:(ResponseFail)failure {
    return
    [self requestWithRequestType:RequestTypePost
                             url:url
                          params:params
                         isCache:NO
                         success:success
                         failure:failure];
}

// Post 缓存
+ (NSURLSessionDataTask *)postCacheDataWithUrl:(NSString *)url
                      params:(NSDictionary *)params
                     success:(ResponseSuccess)success
                     failure:(ResponseFail)failure {
    return
    [self requestWithRequestType:RequestTypePost
                             url:url
                          params:params
                         isCache:YES
                         success:success
                         failure:failure];
}

// 归总
+ (NSURLSessionDataTask *)requestWithRequestType:(RequestType)requestType
                                             url:(NSString *)url
                                          params:(NSDictionary *)params
                                         isCache:(BOOL)isCache
                                         success:(ResponseSuccess)success
                                         failure:(ResponseFail)failure {
    
    NSString *cacheKey  = @"";
    if (isCache && url.length > 0) {  cacheKey = url; }
    
    if (_networkingStatus == NetworkingStatusNotReachable ||
        _networkingStatus == NetworkingStatusUnKnown) {
        [MBProgressHUD hidden];
        [MBProgressHUD showText:@" 当前网络不可用 \n 请检查网络设置 "];
        
#pragma mark - 没有网络加载缓存
        BOOL isCacheAndHaveCacheDate = NO;
        if (isCache) {
            id cacheDate = [_yyCache objectForKey:cacheKey];
            isCacheAndHaveCacheDate = cacheDate;
            !cacheDate ?: (!success ?: success(cacheDate));
        }
        isCacheAndHaveCacheDate ?: (!failure ? : failure(nil)); // 没网络也没缓存
        
        return nil;
    }
    
    NSString *currentUrl = BaseUrl;
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        currentUrl = url;
    } else {
        if (url.length > 0 ) {
            if ([currentUrl hasSuffix:@"/"] || [url hasSuffix:@"/"]) {
                 currentUrl = [NSString stringWithFormat:@"%@%@", currentUrl, url];
            } else {
                 currentUrl = [NSString stringWithFormat:@"%@/%@", currentUrl, url];
            }
        }
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    if (requestType == RequestTypeGet) {
        return
        [mgr GET:currentUrl parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {

            !isCache ?: [_yyCache setObject:responseObject forKey:cacheKey];
            !success ?: success(responseObject);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
            if (isCache) {
                id cacheDate = [_yyCache objectForKey:cacheKey];
                !cacheDate ? : (!success ? : success(cacheDate));
            }
            !failure ?: failure(error);
        }];
    } else {
        
        return
        [mgr POST:currentUrl parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
  
            !isCache ? : [_yyCache setObject:responseObject forKey:cacheKey];
            !success ? : success(responseObject);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
           
            [self handleNetworkError:error];
            
            if (isCache) {
                id cacheDate = [_yyCache objectForKey:cacheKey];
                !cacheDate ?: (!success ?: success(cacheDate));
            }
            !failure ?: failure(error);
        }];
    }
    
#pragma clang diagnostic pop
}

+ (void)handleNetworkError:(NSError *)error {
    
//    NSString *errorTitle = [error.userInfo HY_objectForKey:@"NSLocalizedDescription"];
//    if (error.code == NSURLErrorCancelled) {
//        errorTitle = nil;
//    }
    NSString *errorTitle = NetErrorTitle;
    switch (error.code) {
        case NSURLErrorCancelled:
        {
            errorTitle = nil;
        }break;
        case NSURLErrorBadURL:
        {
            errorTitle = @"链接URL错误";
        }break;
        case NSURLErrorTimedOut:
        {
            errorTitle = @"网络连接超时";
        }break;
        case NSURLErrorCannotFindHost:
        {
            errorTitle = @"找不到服务器";
        }break;
        case NSURLErrorCannotConnectToHost:
        {
            errorTitle = @"连接不上服务器";
        }break;
        default:
        break;
    }
    if ([MBProgressHUD haveShowingHUD]) {
        if (!errorTitle.length) {
            [MBProgressHUD hidden];
        } else {
            [MBProgressHUD hiddenWithMessage:errorTitle];
        }
    } else {
        if (errorTitle.length) {
            [MBProgressHUD showText:errorTitle];
        }
    }
}

+ (NSURLSessionDataTask *)postImageWithUrl:(NSString *)url
                                     param:(NSDictionary *)param
                                 dataArray:(NSArray<NSData *> *)dataArray
                                   success:(ResponseSuccess)success
                                   failure:(ResponseFail)failure {
    
    if (_networkingStatus == NetworkingStatusNotReachable ||
        _networkingStatus == NetworkingStatusUnKnown) {
        [MBProgressHUD showText:@" 当前网络不可用 \n 请检查网络设置 "];
        !failure ? : failure(nil);
        return nil;
    }
    
    NSString *currentUrl = @"";
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        currentUrl = url;
    } else {
        if (url.length > 0 ) {
            currentUrl = [NSString stringWithFormat:@"%@/%@", currentUrl, url];
        }
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:param];
    dict[@"deviceNo"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    dict[@"loginType"] = @1;
    dict[@"versionNo"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    return
    [mgr POST:currentUrl parameters:dict constructingBodyWithBlock:
     ^void(id<AFMultipartFormData> formData) {
         for (NSInteger i = 0; i < dataArray.count; i++) {
             NSData *data = dataArray[i];
             [formData appendPartWithFileData:data
                                         name:@"file"
                                     fileName:[NSString stringWithFormat:@"image%zd.jpeg", i]
                                     mimeType:@"image/jpeg"];
         }
     } success:^void(NSURLSessionDataTask * task, id responseObject) {
         success ? success(responseObject) : nil;
     } failure:^void(NSURLSessionDataTask * task, NSError * error) {
         failure ? failure(error) : nil;
     }];
    
#pragma clang diagnostic pop
}

+ (NetworkingStatus)getNetworkingStatus {
    return _networkingStatus;
}

+ (void)cancelAllTasks {
    [mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
}

+ (unsigned long long)totalCacheSize{
    return  [YYCache cacheWithName:HYCache].diskCache.totalCost;
}

+ (void)clearCaches{
    [[YYCache cacheWithName:HYCache].diskCache removeAllObjects];
}

+ (void)setCache:(id<NSCoding>)Cache forKey:(NSString *)key {
    [_yyCache setObject:Cache forKey:key];
}

+ (id<NSCoding>)getCacheForKey:(NSString *)key; {
    return  [_yyCache objectForKey:key];
}

+ (YYCache *)getCacheManager {
    return _yyCache;
}

+ (AFHTTPSessionManager *)getNetworkManager {
    return mgr;
}

+ (void)seachNetworkingStatusWithChangeBlock:(void(^)(NetworkingStatus status))changeBlock {
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable){
            _networkingStatus = NetworkingStatusUnKnown;
        }else if (status == AFNetworkReachabilityStatusUnknown){
            _networkingStatus = NetworkingStatusUnKnown;
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            _networkingStatus = NetworkingStatusReachableViaWWAN;
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            _networkingStatus = NetworkingStatusReachbleViaWiFi;
        }
        !changeBlock ? : changeBlock(_networkingStatus);
    }];
    [reachabilityManager startMonitoring];
}

+ (void)checkNetworkingStatusWithChangeCallback:(void(^)(NetworkingStatus status))ChangeCallback {
    [self seachNetworkingStatusWithChangeBlock:^(NetworkingStatus status) {
        !ChangeCallback ? : ChangeCallback(status);
    }];
}

@end
