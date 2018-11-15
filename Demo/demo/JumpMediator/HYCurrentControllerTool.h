//
//  HYCurrentControllerTool.h
//  HYlesAssistant
//
//  Created by huangyi on 17/6/23.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYSingleton.h"

@interface HYCurrentControllerTool : NSObject
@property (nonatomic, strong, readonly) UIViewController *currentController;

HYSingletonH(CurrentControllerTool);
@end
