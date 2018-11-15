//
//  RACSignal+Extension.m
//  demo
//
//  Created by huangyi on 2018/11/9.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "RACSignal+Extension.h"

@implementation RACSignal (Extension)

+ (RACSignal *(^)(EmtyBlock excuteBlock))excuteSignal {
    return ^RACSignal *(EmtyBlock excuteBlock) {
        return
        [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            !excuteBlock ?: excuteBlock();
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
    };
}

+ (RACSignal *(^)(NSArray<RACCommand *> *commands))completionSignal {
    return ^RACSignal *(NSArray<RACCommand *> *commands) {
        NSMutableArray<RACSignal *> *executingSignals = @[].mutableCopy;
        [commands enumerateObjectsUsingBlock:^(RACCommand * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [executingSignals addObject:[obj.executing skip:1]];
        }];
        return  executingSignals ?
        [[[RACSignal combineLatest:executingSignals] or] distinctUntilChanged] :
        [RACSignal empty];
    };
}

@end
