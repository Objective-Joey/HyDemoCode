//
//  RACSignal+JumpMediator.m
//  demo
//
//  Created by huangyi on 2018/11/14.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "RACSignal+JumpMediator.h"

@implementation RACSignal (JumpMediator)

+ (RACSignal *(^)(NSString *controllerName,
                  NSString *viewModelName,
                  NSDictionary *params))pushSignal {
    
    return ^RACSignal *(NSString *controllerName,
                        NSString *viewModelName,
                        NSDictionary *params){
        
        return RACSignal.excuteSignal(^{
            [HYJumpConrollerTool pushViewControllerWithControllerName:controllerName
                                                        viewModelName:viewModelName
                                                               params:params
                                                             animated:YES];
        });
    };
}

+ (RACSignal *(^)(NSString *controllerName,
                  NSString *viewModelName,
                  NSDictionary *params))presentSignal {
    
    return ^RACSignal *(NSString *controllerName,
                        NSString *viewModelName,
                        NSDictionary *params){
        
        return RACSignal.excuteSignal(^{
            [HYJumpConrollerTool presentViewControllerWithControllerName:controllerName
                                                           viewModelName:viewModelName
                                                                  params:params
                                                                animated:YES];
        });
    };
}

+ (RACSignal *(^)(NSString *controllerName,
                   NSDictionary *params))popSignal {
    
    return ^RACSignal *(NSString *controllerName,
                         NSDictionary *params) {
        
        return RACSignal.excuteSignal(^{
            [HYJumpConrollerTool popViewControllerWithControllerName:controllerName
                                                              params:params
                                                            animated:YES];
        });
    };
}

+ (RACSignal *(^)(NSDictionary *params))dismissSignal {
    
    return ^RACSignal *(NSDictionary *params) {
        
        return RACSignal.excuteSignal(^{
            [HYJumpConrollerTool dismissViewControllerWithParams:params
                                                        animated:YES];
        });
    };
}

@end
