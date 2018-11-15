//
//  HYRefreshFooter.m
//  HYTableViewDemo
//
//  Created by metbao1 on 2018/1/22.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "HYRefreshFooter.h"

@implementation HYRefreshFooter
- (void)prepare{
    [super prepare];
    
    // 修改刷新的一些初始化配置
}

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    return [[super footerWithRefreshingTarget:target refreshingAction:action] configFooter];
}

+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    return [[super footerWithRefreshingBlock:refreshingBlock] configFooter];
}

- (instancetype)configFooter {
    
    // 修改其他初始化过后的配置
    
    return self;
}


@end
