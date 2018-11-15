//
//  RACSignal+Network.h
//  demo
//
//  Created by huangyi on 2018/11/10.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

// 订阅处理block
typedef void (^requestSignalBlock)(id response, id<RACSubscriber> subscriber);


@interface RACSignal (Network)

// Get
+ (instancetype)signalGetWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                    handleSignal:(requestSignalBlock)handleSignal;

// Get 缓存
+ (instancetype)signalGetCacheWithUrl:(NSString *)url
                               params:(NSDictionary *)params
                         handleSignal:(requestSignalBlock)handleSignal;

// Post
+ (instancetype)signalPostWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                    handleSignal:(requestSignalBlock)handleSignal;

// Post 缓存
+ (instancetype)signalPostCacheWithUrl:(NSString *)url
                                params:(NSDictionary *)params
                          handleSignal:(requestSignalBlock)handleSignal;

@end

NS_ASSUME_NONNULL_END
