//
//  HYJumpConrollerTool.h
//  HYlesAssistant
//
//  Created by huangyi on 17/7/6.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBaseViewController.h"
#import "HYBaseViewModel.h"


@interface HYJumpConrollerTool : NSObject

+ (HYBaseViewController *)controllerWithName:(NSString *)controllerName
                               viewModelName:(NSString *)viewModelName
                                      params:(NSDictionary *)params;

+ (HYBaseViewModel *)viewModelWithName:(NSString *)viewModelName
                                params:(NSDictionary *)params;


+ (void)pushViewControllerWithControllerName:(NSString *)controllerName
                               viewModelName:(NSString *)viewModelName
                                      params:(NSDictionary *)params
                                    animated:(BOOL)flag;


+ (void)presentViewControllerWithControllerName:(NSString *)controllerName
                                  viewModelName:(NSString *)viewModelName
                                         params:(NSDictionary *)params
                                       animated:(BOOL)flag;


+ (void)popViewControllerWithControllerName:(NSString *)controllerName
                                     params:(NSDictionary *)params
                                   animated:(BOOL)flag;


+ (void)dismissViewControllerWithParams:(NSDictionary *)params
                               animated:(BOOL)flag;

@end
