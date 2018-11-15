//
//  UITableView+HYExtension.h
//  HYBaseProject
//
//  Created by huangyi on 17/6/9.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (HYExtension)
/**
 注册Cell 纯代码和XIB
 
 @param cellClass cell的类
 */
- (void)registerCellWithCellClass:(Class)cellClass;
- (void)registerCellWithCellClasses:(NSArray<Class> *)cellClasses;



/**
 注册 tableview 的 header 和 footer
 
 @param viewClass header 和 footer 的类
 */
- (void)registerHeaderFooterWithViewClass:(Class)viewClass;
- (void)registerHeaderFooterWithViewClasses:(NSArray<Class> *)viewClasses;
@end
