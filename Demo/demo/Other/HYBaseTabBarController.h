//
//  HYBaseTabBarController.h
//  HYBaseProject
//
//  Created by huangyi on 2017/11/13.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYBaseTabBarController : UITabBarController
- (void)configureChildViewControllers;
- (void)clickSelectedItemAction:(NSInteger)index;
- (void)addChildViewController:(UIViewController *)childVc
                         title:(NSString *)title
                         image:(NSString *)image
                 selectedImage:(NSString *)selectedImage
                   imageInsets:(UIEdgeInsets)imageInsets
                 titlePosition:(UIOffset)titlePosition
            navControllerClass:(Class)navControllerClass;
@end
