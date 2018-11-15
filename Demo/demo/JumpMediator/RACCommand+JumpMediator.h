//
//  RACCommand+JumpMediator.h
//  demo
//
//  Created by huangyi on 2018/11/14.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "HYJumpConrollerTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACCommand (JumpMediator)

+ (RACCommand *(^)(NSString *controllerName,
                   NSString *viewModelName,
                   NSDictionary *params))pushCommand;

+ (RACCommand *(^)(NSString *controllerName,
                   NSString *viewModelName,
                   NSDictionary *params))presentCommand;

+ (RACCommand *(^)(NSString *controllerName,
                   NSDictionary *params))popCommand;

+ (RACCommand *(^)(NSDictionary *params))dismissCommand;



// enabledSignal
+ (RACCommand *(^)(RACSignal *enabledSignal,
                   NSString *controllerName,
                   NSString *viewModelName,
                   NSDictionary *params))pushEnabledCommand;

+ (RACCommand *(^)(RACSignal *enabledSignal,
                   NSString *controllerName,
                   NSString *viewModelName,
                   NSDictionary *params))presentEnabledCommand;

+ (RACCommand *(^)(RACSignal *enabledSignal,
                   NSString *controllerName,
                   NSDictionary *params))popEnabledCommand;

+ (RACCommand *(^)(RACSignal *enabledSignal,
                   NSDictionary *params))dismissEnabledCommand;

@end

NS_ASSUME_NONNULL_END
