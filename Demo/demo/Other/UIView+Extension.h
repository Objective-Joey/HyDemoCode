//
//  UIView+Extension.h
//  demo
//
//  Created by huangyi on 2018/11/10.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic, readonly) CGPoint middlePoint;

- (UIView *(^)(CGFloat left, CGFloat top, CGFloat width, CGFloat heigth))rectValue;

- (UIView *(^)(CGFloat value))widthValue;
- (UIView *(^)(CGFloat value))heightValue;
- (UIView *(^)(CGFloat width, CGFloat height))sizeValue;

- (UIView *(^)(CGFloat value))leftValue;
- (UIView *(^)(CGFloat value))topValue;
- (UIView *(^)(CGFloat value))rightValue;
- (UIView *(^)(CGFloat value))bottomValue;

- (UIView *(^)(CGFloat value))centerXValue;
- (UIView *(^)(CGFloat value))centerYValue;
- (UIView *(^)(CGFloat left, CGFloat top))originValue;


- (UIView *(^)(UIView *value))widthIsEqualTo;
- (UIView *(^)(UIView *value))heightIsEqualTo;
- (UIView *(^)(UIView *value))sizeIsEqualTo;

- (UIView *(^)(UIView *value))leftIsEqualTo;
- (UIView *(^)(UIView *value))topIsEqualTo;
- (UIView *(^)(UIView *value))rightIsEqualTo;
- (UIView *(^)(UIView *value))bottomIsEqualTo;

- (UIView *(^)(UIView *value))centerXIsEqualTo;
- (UIView *(^)(UIView *value))centerYIsEqualTo;
- (UIView *(^)(UIView *value))originIsEqualTo;
@end

NS_ASSUME_NONNULL_END
