//
//  MBProgressHUD+EmptyView.h
//  demo
//
//  Created by huangyi on 2018/11/12.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, EmptyViewPositon) {
    EmptyViewPositon_Center,    // 中间
    EmptyViewPositon_Top,      //  顶部开始
    //    EmptyViewPositon_Bottom,//   可以多选
};


@interface EmptyConfigure : NSObject
typedef EmptyConfigure *_Nullable(^instancetypeBlock)(id value);

- (instancetypeBlock)backgroundImage;
- (instancetypeBlock)image;
- (instancetypeBlock)title;
- (instancetypeBlock)subTitle;
- (instancetypeBlock)btnTitle;
- (instancetypeBlock)btnImage;
- (instancetypeBlock)btnBackgroundImage;
- (instancetypeBlock)contentFrame;
- (instancetypeBlock)positionConfigure;
@end



typedef void(^configureBlock)(EmptyConfigure *configure);
typedef void (^reloadBlock)(void);
@interface MBProgressHUD (EmptyView)
/**
 类方法初始化缺省View
 
 @param view 将要加到的view
 @param configure 一些配置属性
 @param reloadCallback 按钮点击的回调 当是nil的时候 按钮将会隐藏
 */
+ (void)showEmptyViewToView:(UIView *)view
                  configure:(configureBlock)configure
             reloadCallback:(_Nullable reloadBlock)reloadCallback;



/**
 消除缺省View
 
 @param view 之前加载到的view
 */
+ (void)dismissEmptyViewForView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
