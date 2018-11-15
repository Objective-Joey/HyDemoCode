//
//  HYBaseViewController.h
//  demo
//
//  Created by huangyi on 2018/11/14.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYBaseViewController : UIViewController

- (instancetype)initWithViewModel:(HYBaseViewModel *)viewModel;
- (void)configViewModel;

// 处理键盘弹起到view的距离
- (void)handleKeyboardWithView:(UIView *)view spacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
