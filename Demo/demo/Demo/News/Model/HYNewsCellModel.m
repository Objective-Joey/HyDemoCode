//
//  HYNewsCellModel.m
//  demo
//
//  Created by huangyi on 2018/11/10.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "HYNewsCellModel.h"

@implementation HYNewsCellModel
- (void)handleModel {
    [super handleModel];
    
    /*view层需要的数据 刷新页面前提前算好缓存 用到时候直接用*/
    [self handleTitleAttr];
    [self handleImageUrlStr];
    [self handleCellHeight];
    [self handleCellClass];
}

- (void)handleTitleAttr {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f] ,
                             NSForegroundColorAttributeName: [UIColor blackColor],
                             NSParagraphStyleAttributeName : paragraphStyle };
    self.titleAttr  = [[NSAttributedString alloc]initWithString:self.title attributes:attrs];
}

- (void)handleImageUrlStr {
    self.imageUrlStr = [NSString stringWithFormat:@"%@?w=750&h=20000&quality=75",self.imgsrc.firstObject];
}

- (void)handleCellHeight {
    if (self.showType != 2) {
        self.cellHeight = 80;
    } else {
        CGFloat titleHeight = [self.titleAttr boundingRectWithSize:CGSizeMake(ScreenW - 20, MAXFLOAT)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                           context:nil].size.height;
        self.cellHeight = 100 + titleHeight + 35;
    }
}

- (void)handleCellClass {
    self.cellClass = NSClassFromString(self.showType == 2 ? @"HYNewsImageCell"
                                       : @"HYNewsCell");
}

@end
