//
//  HYRefreshFooter.h
//  HYTableViewDemo
//
//  Created by metbao1 on 2018/1/22.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

//

/**
 scrollView 上拉刷新控件 gif 动画用MJRefreshAutoGifFooter
 */
@interface HYRefreshFooter : MJRefreshAutoNormalFooter

/**
 上拉刷新控件Block类方法

 @param refreshingBlock 进入刷新状态的回调
 @return HYRefreshFooter
 */
+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;


/**
 上拉刷新控件target类方法

 @param target 执行进入刷新状态的回调方法的对象
 @param action 自定义进入刷新状态的回调方法
 @return HYRefreshFooter
 */
+ (instancetype)footerWithRefreshingTarget:(id)target
                          refreshingAction:(SEL)action;
@end
