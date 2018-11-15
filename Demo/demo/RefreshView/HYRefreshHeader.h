//
//  HYRefreshHeader.h
//  HYTableViewDemo
//
//  Created by metbao1 on 2018/1/22.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

/**
 scrollView 下拉刷新控件 gif 动画用MJRefreshAutoGifFooter
 */
@interface HYRefreshHeader : MJRefreshNormalHeader

/**
 下拉刷新控件Block类方法

 @param refreshingBlock 进入刷新状态的回调
 @return HYRefreshHeader
 */
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;


/**
 下拉刷新控件Target的类方法

 @param target 执行进入刷新状态的回调方法的对象
 @param action 自定义进入刷新状态的回调方法
 @return HYRefreshHeader
 */
+ (instancetype)headerWithRefreshingTarget:(id)target
                          refreshingAction:(SEL)action;
@end
