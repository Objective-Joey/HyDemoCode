//
//  RACSignal+Extension.h
//  demo
//
//  Created by huangyi on 2018/11/9.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface RACSignal (Extension)

+ (RACSignal *(^)(EmtyBlock excuteBlock))excuteSignal;
+ (RACSignal *(^)(NSArray<RACCommand *> *commands))completionSignal;

@end

NS_ASSUME_NONNULL_END
