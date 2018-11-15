//
//  UIScrollView+Refresh.h
//  demo
//
//  Created by huangyi on 2018/11/10.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Refresh)

- (void)addRefreshWithHeaderRefreshCallback:(void(^)(void))headerRefreshCallback
                      footerRefreshCallback:(void(^)(void))footerRefreshCallback;


- (void)addRefreshWithHeaderRefreshCommand:(RACCommand *)headerRefreshCommand
                      footerRefreshCommand:(RACCommand *)footerRefreshCommand;

@end

NS_ASSUME_NONNULL_END
