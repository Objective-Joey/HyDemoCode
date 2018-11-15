//
//  UIScrollView+Refresh.m
//  demo
//
//  Created by huangyi on 2018/11/10.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "HYRefreshFooter.h"
#import "HYRefreshHeader.h"


@implementation UIScrollView (Refresh)

- (void)addRefreshWithHeaderRefreshCallback:(void(^)(void))headerRefreshCallback
                      footerRefreshCallback:(void(^)(void))footerRefreshCallback {
    
    if (headerRefreshCallback) {
        self.mj_header = [HYRefreshHeader headerWithRefreshingBlock:headerRefreshCallback];
    }
    if (footerRefreshCallback) {
        self.mj_footer = [HYRefreshFooter footerWithRefreshingBlock:footerRefreshCallback];
        self.mj_footer.hidden = YES;
    }
}


- (void)addRefreshWithHeaderRefreshCommand:(RACCommand *)headerRefreshCommand
                      footerRefreshCommand:(RACCommand *)footerRefreshCommand {
    
    if (headerRefreshCommand) {
        self.mj_header = [HYRefreshHeader headerWithRefreshingBlock:headerRefreshCommand.bindExcuteEmtyBlock(self)];
    }
    if (footerRefreshCommand) {
        self.mj_footer = [HYRefreshFooter footerWithRefreshingBlock:footerRefreshCommand.bindExcuteEmtyBlock(self)];
        self.mj_footer.hidden = YES;
    }
}

@end
