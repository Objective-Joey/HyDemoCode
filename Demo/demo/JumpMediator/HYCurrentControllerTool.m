//
//  HYCurrentControllerTool.m
//  HYlesAssistant
//
//  Created by huangyi on 17/6/23.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "HYCurrentControllerTool.h"
#import "HYRunTimeTool.h"

@interface HYCurrentControllerTool()
@property (nonatomic, strong) UIViewController *currentController;
@end

@implementation HYCurrentControllerTool
HYSingletonM(CurrentControllerTool);
@end

@implementation UIViewController (HYCurrentControllerTool)
+ (void)load {
    [HYRunTimeTool exchangeMethodWithClass:self
                              systemMethod:@selector(viewWillAppear:)
                              customMethod:@selector(HY_viewWillAppear:)];
}

- (void)HY_viewWillAppear:(BOOL)animated {
    if ([self isKindOfClass:HYBaseViewController.class]) {
        [HYCurrentControllerTool sharedCurrentControllerTool].currentController = self;
    }
    [self HY_viewWillAppear:animated]; 
}

@end
