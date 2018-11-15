//
//  HYBaseTabBarController.m
//  HYBaseProject
//
//  Created by huangyi on 2017/11/13.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "HYBaseTabBarController.h"

@interface HYBaseTabBarController ()
@property (nonatomic, assign) NSInteger fromIndex;
@end

@implementation HYBaseTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTabBar];
    [self configureChildViewControllers];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([tabBar.items indexOfObject:item] == self.fromIndex) {
        [self clickSelectedItemAction:self.fromIndex];
    }
    self.fromIndex = [tabBar.items indexOfObject:item];
} 

- (void)configureChildViewControllers {}
- (void)clickSelectedItemAction:(NSInteger)index {}

- (void)configureTabBar {
    
    [[UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[HYBaseTabBarController.class]] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorMakeWithRGBA(113, 113, 113, 1)} forState:UIControlStateNormal];
    
     [[UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[HYBaseTabBarController.class]] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorMakeWithRGBA(218, 85, 107,1)} forState:UIControlStateSelected];
}

- (void)addChildViewController:(UIViewController *)childVc
                         title:(NSString *)title
                         image:(NSString *)image
                 selectedImage:(NSString *)selectedImage
                   imageInsets:(UIEdgeInsets)imageInsets
                 titlePosition:(UIOffset)titlePosition
            navControllerClass:(Class)navControllerClass {
    
    [self configureChildViewController:childVc
                                 title:title
                                 image:image
                         selectedImage:selectedImage
                           imageInsets:imageInsets
                         titlePosition:titlePosition];
    id nav = nil;
    if (navControllerClass == nil) {
        nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    }else {
        nav = [[navControllerClass alloc] initWithRootViewController:childVc];
    }
    [self addChildViewController:nav];
}

- (void)configureChildViewController:(UIViewController *)childVc
                               title:(NSString *)title
                               image:(NSString *)image
                       selectedImage:(NSString *)selectedImage
                         imageInsets:(UIEdgeInsets)imageInsets
                       titlePosition:(UIOffset)titlePosition {
    childVc.title = title;
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.imageInsets = imageInsets;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.titlePositionAdjustment = titlePosition;
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]
                                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
