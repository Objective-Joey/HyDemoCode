//
//  UITableView+HYExtension.m
//  HYBaseProject
//
//  Created by huangyi on 17/6/9.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "UITableView+HYExtension.h"

@implementation UITableView (HYExtension)
- (void)registerCellWithCellClasses:(NSArray<Class> *)cellClasses {
    
    if (!cellClasses.count) { return; }
    [cellClasses enumerateObjectsUsingBlock:^(Class obj,
                                              NSUInteger idx,
                                              BOOL *stop) {
        [self registerCellWithCellClass:obj];
    }];
}

- (void)registerCellWithCellClass:(Class)cellClass {
    
    if (!cellClass) { return; }
    
    NSString *cellClassString = NSStringFromClass(cellClass);
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:cellClassString ofType:@"nib"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:nibPath]) {
        [self registerNib:[UINib nibWithNibName:cellClassString
                                         bundle:nil] forCellReuseIdentifier:cellClassString];
    }else{
        [self registerClass:cellClass forCellReuseIdentifier:cellClassString];
    }
}

- (void)registerHeaderFooterWithViewClasses:(NSArray<Class> *)viewClasses {
    
    if (!viewClasses.count) { return; }
    [viewClasses enumerateObjectsUsingBlock:^(Class obj,
                                              NSUInteger idx,
                                              BOOL *stop) {
        [self registerHeaderFooterWithViewClass:obj];
    }];
}

- (void)registerHeaderFooterWithViewClass:(Class)viewClass {
    
    if (!viewClass) { return; }
    
    NSString *viewClassString = NSStringFromClass(viewClass);
    NSString *nibPath =  [[NSBundle mainBundle] pathForResource:viewClassString ofType:@"nib"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:nibPath]) {
        [self registerNib:[UINib nibWithNibName:viewClassString
                                         bundle:nil] forHeaderFooterViewReuseIdentifier:viewClassString];
    }else{
        [self registerClass:viewClass forHeaderFooterViewReuseIdentifier:viewClassString];
    }
}


@end
