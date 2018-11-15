//
//  RACCommand+Network.m
//  demo
//
//  Created by huangyi on 2018/11/10.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "RACCommand+Network.h"
#import "RACSignal+Network.h"


// command 订阅函数
requestSignalBlock requestCommand(id input, requestCommandBlock handleCommand) {
    return !handleCommand  ? nil :
    ^(id response, id<RACSubscriber> subscriber) {
        handleCommand(input, response, subscriber);
    };
}

// 处理参数函数
id requestParams(id input, requestParamsBlock params) {
    return params ? params(input) : input;
}

// 处理Url函数
id requestUrl(id input, requestUrlBlock url) {
    return url ? url(input) : @"";
}



@implementation RACCommand (Network)

// Get
+ (instancetype)commandGetWithUrl:(requestUrlBlock)url
                          params:(requestParamsBlock)params
                   handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {;
        return [RACSignal signalGetWithUrl:requestUrl(input, url)
                                    params:requestParams(input, params)
                              handleSignal:requestCommand(input, handleCommand)];
    }];
}

// Get 缓存
+ (instancetype)commandGetCacheWithUrl:(requestUrlBlock)url
                               params:(requestParamsBlock)params
                        handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {;
        return [RACSignal signalGetCacheWithUrl:requestUrl(input, url)
                                         params:requestParams(input, params)
                                   handleSignal:requestCommand(input, handleCommand)];
    }];
}

// Post
+ (instancetype)commandPostWithUrl:(requestUrlBlock)url
                           params:(requestParamsBlock)params
                    handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {;
        return [RACSignal signalPostWithUrl:requestUrl(input, url)
                                    params:requestParams(input, params)
                              handleSignal:requestCommand(input, handleCommand)];
    }];
}


// Post 缓存
+ (instancetype)commandPostCacheWithUrl:(requestUrlBlock)url
                                params:(requestParamsBlock)params
                         handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {;
        return [RACSignal signalPostCacheWithUrl:requestUrl(input, url)
                                         params:requestParams(input, params)
                                   handleSignal:requestCommand(input, handleCommand)];
    }];
}

@end
