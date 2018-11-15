//
//  RACCommand+JumpMediator.m
//  demo
//
//  Created by huangyi on 2018/11/14.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "RACCommand+JumpMediator.h"

@implementation RACCommand (JumpMediator)

+ (RACCommand *(^)(NSString *controllerName,
                   NSString *viewModelName,
                   NSDictionary *params))pushCommand {
    
    return ^RACCommand *(NSString *controllerName,
                         NSString *viewModelName,
                         NSDictionary *params){
        
        return RACCommand.emptyCommand(^(id input){
            [HYJumpConrollerTool pushViewControllerWithControllerName:controllerName
                                                        viewModelName:viewModelName
                                                               params:params
                                                             animated:YES];
        });
    };
}

+ (RACCommand *(^)(NSString *controllerName,
                   NSString *viewModelName,
                   NSDictionary *params))presentCommand {
    
    return ^RACCommand *(NSString *controllerName,
                         NSString *viewModelName,
                         NSDictionary *params){
        
        return RACCommand.emptyCommand(^(id input){
            [HYJumpConrollerTool presentViewControllerWithControllerName:controllerName
                                                           viewModelName:viewModelName
                                                                  params:params
                                                                animated:YES];
        });
    };
}

+ (RACCommand *(^)(NSString *controllerName,
                   NSDictionary *params))popCommand {
    
    return ^RACCommand *(NSString *controllerName,
                         NSDictionary *params) {
        
        return RACCommand.emptyCommand(^(id input){
            [HYJumpConrollerTool popViewControllerWithControllerName:controllerName
                                                              params:params
                                                            animated:YES];
        });
    };
}

+ (RACCommand *(^)(NSDictionary *params))dismissCommand {
    
    return ^RACCommand *(NSDictionary *params) {
        
        return RACCommand.emptyCommand(^(id input){
            [HYJumpConrollerTool dismissViewControllerWithParams:params animated:YES];
        });
    };
}





+ (RACCommand *(^)(RACSignal *enabledSignal,
                   NSString *controllerName,
                   NSString *viewModelName,
                   NSDictionary *params))pushEnabledCommand {
    
    return ^RACCommand *(RACSignal *enabledSignal,
                         NSString *controllerName,
                         NSString *viewModelName,
                         NSDictionary *params){
        
        return RACCommand.emptyEnabledCommand(enabledSignal, ^(id input){
            [HYJumpConrollerTool pushViewControllerWithControllerName:controllerName
                                                        viewModelName:viewModelName
                                                               params:params
                                                             animated:YES];
        });
    };
}

+ (RACCommand *(^)(RACSignal *enabledSignal,
                   NSString *controllerName,
                   NSString *viewModelName,
                   NSDictionary *params))presentEnabledCommand {
    
    return ^RACCommand *(RACSignal *enabledSignal,
                         NSString *controllerName,
                         NSString *viewModelName,
                         NSDictionary *params){
        
        return RACCommand.emptyEnabledCommand(enabledSignal, ^(id input){
            [HYJumpConrollerTool presentViewControllerWithControllerName:controllerName
                                                           viewModelName:viewModelName
                                                                  params:params
                                                                animated:YES];
        });
    };
}

+ (RACCommand *(^)(RACSignal *enabledSignal,
                   NSString *controllerName,
                   NSDictionary *params))popEnabledCommand {
    
    return ^RACCommand *(RACSignal *enabledSignal,
                         NSString *controllerName,
                         NSDictionary *params) {
        
        return RACCommand.emptyEnabledCommand(enabledSignal, ^(id input){
            [HYJumpConrollerTool popViewControllerWithControllerName:controllerName
                                                              params:params
                                                            animated:YES];
        });
    };
}

+ (RACCommand *(^)(RACSignal *enabledSignal,
                   NSDictionary *params))dismissEnabledCommand {
    
    return ^RACCommand *(RACSignal *enabledSignal,
                         NSDictionary *params) {
        
        return RACCommand.emptyEnabledCommand(enabledSignal, ^(id input){
            [HYJumpConrollerTool dismissViewControllerWithParams:params animated:YES];
        });
    };
}

@end
