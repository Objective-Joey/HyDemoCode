//
//  MBProgressHUD+HYExtension.h
//  MBTest
//
//  Created by huangyi on 16/6/21.
//  Copyright © 2016年 jsb06. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (HYExtension)

/* 没有黑色背景 */
+ (void)showHUD;
+ (void)showHUDOnView:(UIView *)view;
+ (void)showHUDWithMessage:(NSString *)message;
+ (void)showHUDWithMessage:(NSString *)message onView:(UIView *)view;
+ (void)showHUDWithMessage:(NSString *)message deltail:(NSString *)deltail;
+ (void)showHUDWithMessage:(NSString *)message deltail:(NSString *)deltail onView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error onView:(UIView *)view;
+ (void)showSuccess:(NSString *)Success;
+ (void)showSuccess:(NSString *)Success onView:(UIView *)view;
+ (void)showIcon:(NSString *)icon;
+ (void)showMessage:(NSString *)message icon:(NSString *)icon;
+ (void)showMessage:(NSString *)message icon:(NSString *)icon view:(UIView *)view;


+(void)showText:(NSString *)text;
+(void)showText:(NSString *)text onView:(UIView *)view;

+ (BOOL)haveShowingHUD;
+ (BOOL)haveShowingHUDForView:(UIView *)view;

/*   自定义动画   */
+ (void)showAnimotionHUD;
+ (void)showAnimotionHUDOnView:(UIView *)view;
+ (void)showAnimationHUDWithImages:(NSArray *)images title:(NSString *)title;
+ (void)showAnimationHUDWithImages:(NSArray *)images title:(NSString *)title toView:(UIView *)view;

/*  有黑色背景 */
+ (void)showBlackBackgroundHUD;
+ (void)showBlackBackgroundHUDOnView:(UIView *)view;
+ (void)showBlackBackgroundHUDWithMessage:(NSString *)message;
+ (void)showBlackBackgroundHUDMessage:(NSString *)message onView:(UIView *)view;
+ (void)showBlackBackgroundHUDWithMessage:(NSString *)message deltail:(NSString *)deltail;
+ (void)showBlackBackgroundHUDMessage:(NSString *)message deltail:(NSString *)deltail onView:(UIView *)view;

+ (void)showBlackBackgroundError:(NSString *)error;
+ (void)showBlackBackgroundError:(NSString *)error onView:(UIView *)view;
+ (void)showBlackBackgroundSuccess:(NSString *)Success;
+ (void)showBlackBackgroundSuccess:(NSString *)Success onView:(UIView *)view;
+ (void)showBlackBackgroundIcon:(NSString *)icon;
+ (void)showBlackBackgroundMessage:(NSString *)message icon:(NSString *)icon;
+ (void)showBlackBackgroundMessage:(NSString *)message icon:(NSString *)icon view:(UIView *)view;

/*   自定义动画   */
+ (void)showAnimotionBlackBackgroundHUD;
+ (void)showAnimotionBlackBackgroundHUDOnView:(UIView *)view;
+ (void)showAnimationBlackBackgroundHUDWithImages:(NSArray *)images title:(NSString *)title;
+ (void)showAnimationBlackBackgroundHUDWithImages:(NSArray *)images title:(NSString *)title toView:(UIView *)view;

/*  隐藏   */
+ (BOOL)hidden;
+ (BOOL)hiddenForView:(UIView *)view;

/* 给个提示 */
+ (void)hiddenWithMessage:(NSString *)message;
+ (void)hiddenWithSuccessStatus:(NSString *)message;
+ (void)hiddenWithErrowStatus:(NSString *)message;

+ (void)hiddenForView:(UIView *)view Message:(NSString *)message;
+ (void)hiddenForView:(UIView *)view successStatus:(NSString *)message;
+ (void)hiddenForView:(UIView *)view errowStatus:(NSString *)message;

@end
