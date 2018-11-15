//
//  HYSystemNaviController.m
//  HYBaseProject
//
//  Created by huangyi on 17/6/23.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "HYBaseNaviController.h"

@implementation HYBaseNaviController
+ (void)load {
    UINavigationBar *bar = [UINavigationBar appearance];
    UIImage * image = [[UIImage imageWithColor:[UIColor whiteColor]] imageByBlurLight];
    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[[UIImage imageWithColor:RGBA(238, 240, 245, .78)] imageByBlurExtraLight]];
    [bar setTitleTextAttributes:@{
                                  NSFontAttributeName : [UIFont systemFontOfSize:20],
                                  NSForegroundColorAttributeName:[UIColor blackColor]
                                 }];

    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{
                                   NSForegroundColorAttributeName:[UIColor blackColor],
                                   NSFontAttributeName:[UIFont systemFontOfSize:16]
                                  }forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{
                                   NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                   NSFontAttributeName:[UIFont systemFontOfSize:16]
                                 }forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PageColor;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"bakcArrow"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"bakcArrow"] forState:UIControlStateHighlighted];
        button.size = CGSizeMake(70, 30);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        button.rac_command = RACCommand.popCommand(@"", @{});
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)goBackHome {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([vc isKindOfClass:[HYBaseNaviController class]]) {
        HYBaseNaviController *nav = (HYBaseNaviController *)vc;
        if (self.presentingViewController) {
            [nav popToRootViewControllerAnimated:NO];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else if (nav.presentedViewController) {
            [nav popToRootViewControllerAnimated:NO];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [nav popToRootViewControllerAnimated:YES];
        }
    }
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

@end
