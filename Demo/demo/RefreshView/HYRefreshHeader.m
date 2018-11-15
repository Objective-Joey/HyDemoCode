//
//  HYRefreshHeader.m
//  HYTableViewDemo
//
//  Created by metbao1 on 2018/1/22.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "HYRefreshHeader.h"

@implementation HYRefreshHeader
- (void)prepare{
    [super prepare];
    
    // 修改刷新的一些初始化配置
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    return [[super headerWithRefreshingTarget:target refreshingAction:action] configHeader];
}

+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    return [[super headerWithRefreshingBlock:refreshingBlock] configHeader];
}

- (instancetype)configHeader {
    
   // 修改其他初始化过后的配置

    return self;
}

@end
