//
//  UICollectionView+HYExtension.h
//  HYBaseProject
//
//  Created by huangyi on 17/6/9.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (HYExtension)
- (void)registerCellWithCellClass:(Class)cellClass;
- (void)registerCellWithCellClasses:(NSArray<Class> *)cellClasses;

- (void)registerHeaderWithViewClass:(Class)viewClass;
- (void)registerHeaderWithViewClasses:(NSArray<Class> *)viewClasses;

- (void)registerFooterWithViewClass:(Class)viewClass;
- (void)registerFooterWithViewClasses:(NSArray<Class> *)viewClasses;
@end
