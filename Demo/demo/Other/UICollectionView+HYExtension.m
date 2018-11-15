//
//  UICollectionView+HYExtension.m
//  HYBaseProject
//
//  Created by huangyi on 17/6/9.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "UICollectionView+HYExtension.h"

@implementation UICollectionView (HYExtension)

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
        [self registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass)
                                         bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
    }else{
        [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
    }
}


- (void)registerHeaderWithViewClasses:(NSArray<Class> *)viewClasses {
    
    if (!viewClasses.count) { return; }
    [viewClasses enumerateObjectsUsingBlock:^(Class obj,
                                              NSUInteger idx,
                                              BOOL *stop) {
        [self registerHeaderWithViewClass:obj];
    }];
}
- (void)registerHeaderWithViewClass:(Class)viewClass {
    
    if (!viewClass) { return; }
    
    NSString *viewClassString = NSStringFromClass(viewClass);
    NSString *nibPath =  [[NSBundle mainBundle] pathForResource:viewClassString ofType:@"nib"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:nibPath]) {
        [self registerHeaderFooterViewIsNib:YES
                                   isHeader:NO
                                  viewClass:viewClass];
    }else{
        [self registerHeaderFooterViewIsNib:NO
                                   isHeader:NO
                                  viewClass:viewClass];
    }
}


- (void)registerFooterWithViewClasses:(NSArray<Class> *)viewClasses {
    
    if (!viewClasses.count) { return; }
    [viewClasses enumerateObjectsUsingBlock:^(Class obj,
                                              NSUInteger idx,
                                              BOOL *stop) {
        [self registerFooterWithViewClass:obj];
    }];
}
- (void)registerFooterWithViewClass:(Class)viewClass {
    
    if (!viewClass) { return; }
    
    NSString *viewClassString = NSStringFromClass(viewClass);
    NSString *nibPath =  [[NSBundle mainBundle] pathForResource:viewClassString ofType:@"nib"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:nibPath]) {
        [self registerHeaderFooterViewIsNib:YES
                                   isHeader:YES
                                  viewClass:viewClass];
    }else{
        [self registerHeaderFooterViewIsNib:NO
                                   isHeader:YES
                                  viewClass:viewClass];
    }
}


- (void)registerHeaderFooterViewIsNib:(BOOL)isNib
                             isHeader:(BOOL)isHeader
                            viewClass:(Class)viewClass {
    
    NSString *ofKind = isHeader ? UICollectionElementKindSectionHeader :
    UICollectionElementKindSectionFooter;
    if (isNib) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass(viewClass)
                                         bundle:nil] forSupplementaryViewOfKind:ofKind withReuseIdentifier:NSStringFromClass(viewClass)];
    } else {
        [self registerClass:viewClass forSupplementaryViewOfKind:ofKind withReuseIdentifier:NSStringFromClass(viewClass)];
    }
}
@end
