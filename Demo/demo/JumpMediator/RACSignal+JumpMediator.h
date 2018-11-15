//
//  RACSignal+JumpMediator.h
//  demo
//
//  Created by huangyi on 2018/11/14.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "HYJumpConrollerTool.h"


NS_ASSUME_NONNULL_BEGIN

@interface RACSignal (JumpMediator)

+ (RACSignal *(^)(NSString *controllerName,
                  NSString *viewModelName,
                  NSDictionary *params))pushSignal;

+ (RACSignal *(^)(NSString *controllerName,
                  NSString *viewModelName,
                  NSDictionary *params))presentSignal;

+ (RACSignal *(^)(NSString *controllerName,
                   NSDictionary *params))popSignal;

+ (RACSignal *(^)(NSDictionary *params))dismissSignal;


@end

NS_ASSUME_NONNULL_END
