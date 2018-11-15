//
//  HYDemoTabBarController.m
//  HYBaseProject
//
//  Created by huangyi on 2017/11/13.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "HYDemoTabBarController.h"

@implementation HYDemoTabBarController
- (void)configureChildViewControllers {
    [super configureChildViewControllers];
    
    NSArray *TabBarControllers = [self handleChildViewControllersJson];
    for (NSDictionary *dict in TabBarControllers) {
        
        UIViewController *vc =
        [HYJumpConrollerTool controllerWithName:dict[@"vc"]
                                  viewModelName:dict[@"viewModel"]
                                         params:dict[@"params"]];
        [self addChildViewController:vc
                               title:dict[@"title"]
                               image:dict[@"image"]
                       selectedImage:dict[@"selectedImage"]
                         imageInsets:UIEdgeInsetsZero
                       titlePosition:UIOffsetMake(0, -2)
                  navControllerClass:[HYBaseNaviController class]];
    }
}

- (void)clickSelectedItemAction:(NSInteger)index {
    [super clickSelectedItemAction:index];
    UIViewController *vc = ((UINavigationController *)self.viewControllers[index]).topViewController;
    if ([vc respondsToSelector:NSSelectorFromString(@"repeatClickTabbarItemAction")]) {
        ((void (*)(id, SEL))objc_msgSend)((id)vc, NSSelectorFromString(@"repeatClickTabbarItemAction"));
    }
}

- (NSArray<NSDictionary *> *)handleChildViewControllersJson {
    NSError *error;
    NSData  *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]
                                                   pathForResource:@"TabBarControllers.json" ofType:nil]];
    NSArray *jumpControllers = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
    for (NSMutableDictionary *dict in jumpControllers) {
        if (![HYRunTimeTool classWithString:dict[@"vc"]]) {
            dict[@"vc"] = @"HYBaseViewController";
        }
    }
    return error ? nil : jumpControllers;
}

@end
