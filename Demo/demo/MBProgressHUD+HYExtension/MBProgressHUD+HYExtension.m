//
//  MBProgressHUD+HYExtension.m
//  MBTest
//
//  Created by huangyi on 16/6/21.
//  Copyright © 2016年 jsb06. All rights reserved.
//

#import "MBProgressHUD+HYExtension.h"
#import <objc/message.h>
#define AnimationImgsArr @[[UIImage imageNamed:@"header"]]
#define kKeyWindowView [[UIApplication sharedApplication].windows lastObject]
#define kSystemFontOfSize(size) [UIFont systemFontOfSize:size]
#define HYScreenW [UIScreen mainScreen].bounds.size.width
#define HYScreenH [UIScreen mainScreen].bounds.size.height
#define kWarningImgLenght 100
#define kWarningLabelW 320
#define kWarningLabelH 100
#define kSpace 20

#define WidthRateBase6P(a) HYScreenW/1080*a
#define HeightRatebase6P(a) HYScreenH/1920*a

static CGFloat const margin = 25.0f;
// 运行时objc_msgSend
#define HYReloadMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define HYReloadMsgTarget(target) (__bridge void *)(target)

@interface HYReLoadingButton : UIButton
@property (nonatomic, copy) void (^clickWithBlock)(void);
@property (nonatomic,assign) SEL reLoadAction;
@property (nonatomic,strong) id reLoadtarget;
@end

@implementation HYReLoadingButton
@end

@interface MBProgressHUD (HYExtension)
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) HYReLoadingButton *reLoadingBtn;
@end

@implementation MBProgressHUD (HYExtension)

/* 关联相关 */
static char hudKey;
static char bgViewKey;
static char ReLoadingBtnKey;
- (id)bgView {
    return objc_getAssociatedObject(self, &bgViewKey);
}
- (void)setBgView:(UIView *)bgView {
    objc_setAssociatedObject(self, &bgViewKey, bgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)hud {
    return objc_getAssociatedObject(self, &hudKey);
}
- (void)setHud:(UIView *)hud {
    objc_setAssociatedObject(self, &hudKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HYReLoadingButton *)reLoadingBtn {
    return objc_getAssociatedObject(self, &ReLoadingBtnKey);
}
- (void)setReLoadingBtn:(HYReLoadingButton *)reLoadingBtn {
    objc_setAssociatedObject(self, &ReLoadingBtnKey, reLoadingBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/* 没有黑色背景 */
+ (void)showHUD {
    [self showHUDOnView:nil];
}
+ (void)showHUDOnView:(UIView *)view {
    [self showHUDWithMessage:nil onView:view];
}
+ (void)showHUDWithMessage:(NSString *)message {
    [self showHUDWithMessage:message deltail:nil onView:nil];
}
+ (void)showHUDWithMessage:(NSString *)message onView:(UIView *)view {
    [self showHUDWithMessage:message deltail:nil onView:view];
}
+ (void)showHUDWithMessage:(NSString *)message deltail:(NSString *)deltail {
    [self showHUDWithMessage:message deltail:deltail onView:nil];
}
+ (void)showHUDWithMessage:(NSString *)message deltail:(NSString *)deltail onView:(UIView *)view {
    MBProgressHUD *hud = [self showMessage:message detail:deltail showView:view img:nil isCustomImage:NO time:0.0 aplhaBackground:NO isAutoDismis:NO];
    hud.mode = MBProgressHUDModeIndeterminate;
}
+ (void)showError:(NSString *)error {
    [self showError:error onView:nil];
}
+ (void)showError:(NSString *)error onView:(UIView *)view {
    [self showMessage:error detail:nil showView:view img:@"error.png" isCustomImage:NO time:1.0 aplhaBackground:NO isAutoDismis:YES];
}
+ (void)showSuccess:(NSString *)Success {
    [self showSuccess:Success onView:nil];
}
+ (void)showSuccess:(NSString *)Success onView:(UIView *)view {
     [self showMessage:Success detail:nil showView:view img:@"success.png"  isCustomImage:NO time:1.0 aplhaBackground:NO isAutoDismis:YES];
}
+ (void)showIcon:(NSString *)icon {
    [self showMessage:nil icon:icon];
}
+ (void)showMessage:(NSString *)message icon:(NSString *)icon {
    [self showMessage:message icon:icon view:nil];
}
+ (void)showMessage:(NSString *)message icon:(NSString *)icon view:(UIView *)view {
    [self showMessage:message detail:nil showView:view img:icon isCustomImage:YES time:1.0 aplhaBackground:NO isAutoDismis:YES];
}

+ (void)showAnimotionHUD {
    [self showAnimotionHUDOnView:nil];
}
+ (void)showAnimotionHUDOnView:(UIView *)view {
    [self showAnimationHUDWithImages:nil title:nil onView:view];
}
+ (void)showAnimationHUDWithImages:(NSArray *)images title:(NSString *)title {
    [self showAnimationHUDWithImages:images title:title toView:nil];
}
+ (void)showAnimationHUDWithImages:(NSArray *)images title:(NSString *)title onView:(UIView *)view {
    [self showAnimationHUDWithImages:images title:title showView:view aplhaBackground:NO];
}

/*  有黑色背景 */
+ (void)showBlackBackgroundHUD {
    [self showBlackBackgroundHUDOnView:nil];
}
+ (void)showBlackBackgroundHUDOnView:(UIView *)view {
    [self showBlackBackgroundHUDMessage:nil onView:view ];
}
+ (void)showBlackBackgroundHUDWithMessage:(NSString *)message {
    [self showBlackBackgroundHUDMessage:message onView:nil];
}
+ (void)showBlackBackgroundHUDMessage:(NSString *)message onView:(UIView *)view {
    [self showBlackBackgroundHUDMessage:message deltail:nil onView:view];
}
+ (void)showBlackBackgroundHUDWithMessage:(NSString *)message deltail:(NSString *)deltail {
    [self showBlackBackgroundHUDMessage:message deltail:deltail onView:nil];
}
+ (void)showBlackBackgroundHUDMessage:(NSString *)message deltail:(NSString *)deltail onView:(UIView *)view {
    MBProgressHUD *hud = [self showMessage:message detail:deltail showView:view img:nil isCustomImage:NO time:0.0 aplhaBackground:YES isAutoDismis:NO];
    hud.mode = MBProgressHUDModeIndeterminate;
}
+ (void)showBlackBackgroundError:(NSString *)error {
     [self showBlackBackgroundError:error onView:nil];
}
+ (void)showBlackBackgroundError:(NSString *)error onView:(UIView *)view {
    [self showMessage:error detail:nil showView:view img:@"error.png" isCustomImage:NO time:1.0 aplhaBackground:YES isAutoDismis:YES];
}
+ (void)showBlackBackgroundSuccess:(NSString *)Success {
    [self showBlackBackgroundSuccess:Success onView:nil];
}
+ (void)showBlackBackgroundSuccess:(NSString *)Success onView:(UIView *)view{
    [self showMessage:Success detail:nil showView:view img:@"success.png" isCustomImage:NO time:1.0 aplhaBackground:YES isAutoDismis:YES];
}
+ (void)showBlackBackgroundIcon:(NSString *)icon {
    [self showBlackBackgroundMessage:nil icon:icon];
}
+ (void)showBlackBackgroundMessage:(NSString *)message icon:(NSString *)icon {
    [self showBlackBackgroundMessage:message icon:icon view:nil];
}
+ (void)showBlackBackgroundMessage:(NSString *)message icon:(NSString *)icon view:(UIView *)view {
     [self showMessage:message detail:nil showView:view img:icon isCustomImage:YES time:1.0 aplhaBackground:YES isAutoDismis:YES];
}

+ (void)showAnimotionBlackBackgroundHUD {
    [self showAnimotionBlackBackgroundHUDOnView:nil];
}
+ (void)showAnimotionBlackBackgroundHUDOnView:(UIView *)view {
    [self showAnimationBlackBackgroundHUDWithImages:nil title:nil toView:view];
}
+ (void)showAnimationBlackBackgroundHUDWithImages:(NSArray *)images title:(NSString *)title {
    [self showAnimationBlackBackgroundHUDWithImages:images title:title toView:nil];
}
+ (void)showAnimationBlackBackgroundHUDWithImages:(NSArray *)images title:(NSString *)title toView:(UIView *)view {
    [self showAnimationHUDWithImages:images title:title showView:view aplhaBackground:YES];
}

/*  隐藏  */
+ (BOOL)hidden {
  return  [self hideHUDForView:kKeyWindowView animated:YES];
}
+ (BOOL)hiddenForView:(UIView *)view {
   return [self hideHUDForView:view animated:YES];
}
+ (void)hiddenWithMessage:(NSString *)message {
    [self hideHUDForView:kKeyWindowView animated:NO];
    [self showText:message];
//    ![self hideHUDForView:kKeyWindowView animated:NO] ? : [self showText:message];
}
+ (void)hiddenWithSuccessStatus:(NSString *)message {
    [self hideHUDForView:kKeyWindowView animated:NO];
    [self showSuccess:message];
//    ![self hideHUDForView:kKeyWindowView animated:NO] ? : [self showSuccess:message];
}
+ (void)hiddenWithErrowStatus:(NSString *)message {
    [self hideHUDForView:kKeyWindowView animated:NO];
    [self showError:message];
//    ![self hideHUDForView:kKeyWindowView animated:NO] ? : [self showError:message];
}
+ (void)hiddenForView:(UIView *)view Message:(NSString *)message {
    [self hideHUDForView:view animated:NO];
    [self showText:message onView:view];
//    ![self hideHUDForView:view animated:NO] ? : [self showText:message onView:view];
}
+ (void)hiddenForView:(UIView *)view successStatus:(NSString *)message {
    [self hideHUDForView:view animated:NO];
    [self showSuccess:message onView:view];
//    ![self hideHUDForView:view animated:NO] ? : [self showSuccess:message onView:view];
}
+ (void)hiddenForView:(UIView *)view errowStatus:(NSString *)message {
    [self hideHUDForView:view animated:NO];
    [self showError:message onView:view];
//    ![self hideHUDForView:view animated:NO] ? : [self showError:message onView:view];
}

+ (instancetype)showMessage:(NSString *)message detail:(NSString *)detail showView:(UIView *)view img:(NSString *)imgName isCustomImage:(BOOL)isCustomImage time:(float)time aplhaBackground:(BOOL)bg isAutoDismis:(BOOL)dismiss {
   MBProgressHUD *hud = view ?  [self showHUDAddedTo:view animated:YES] :[self showHUDAddedTo:kKeyWindowView animated:YES];
    if (view) {
        [view bringSubviewToFront:hud];
    } else {
        [kKeyWindowView bringSubviewToFront:hud];
    }
    hud.labelText = message;
//    hud.opacity = 0.7;
    if (!isCustomImage) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", imgName]]];
    } else {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    }
    hud.mode = MBProgressHUDModeCustomView;
    if (detail) {
         hud.labelFont = kSystemFontOfSize(16);
    } else {
         hud.labelFont = kSystemFontOfSize(14);
    }
    hud.removeFromSuperViewOnHide = YES;
    hud.cornerRadius = 5.0;
    hud.margin = margin;
    if (detail) {
        hud.detailsLabelText = detail;
    }
    if (bg) {
        hud.dimBackground = YES;
        hud.animationType = MBProgressHUDAnimationFade;
    } else {
        hud.animationType = MBProgressHUDAnimationZoomOut;
    }
    if (dismiss) {
        [hud hide:YES afterDelay:time];
    }
    return hud;
}

+(void)showText:(NSString *)text {
    [self showText:text onView:nil];
}

+(void)showText:(NSString *)text onView:(UIView *)view {
    MBProgressHUD *hud = view ?  [self showHUDAddedTo:view animated:YES] :[self showHUDAddedTo:kKeyWindowView animated:YES];
    if (view) {
        [view bringSubviewToFront:hud];
    } else {
        [kKeyWindowView bringSubviewToFront:hud];
    }
//    hud.detailsLabelFont = kSystemFontOfSize(18);
    hud.detailsLabelFont = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:18];
    hud.detailsLabelText = text;
    hud.mode = MBProgressHUDModeText;
    hud.margin = margin;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.opacity = 0.75;
    hud.cornerRadius = 5.0;
//    hud.color = NaviBackColor;
    [hud hide:YES afterDelay:1.5];
}

+ (void)showAnimationHUDWithImages:(NSArray *)images title:(NSString *)title showView:(UIView *)view aplhaBackground:(BOOL)bg {
    UIImageView *actionImage = [[UIImageView alloc] init];
    actionImage.frame = CGRectMake(0, 0, WidthRateBase6P(300), HeightRatebase6P(300));
    images ? [actionImage setAnimationImages:images] : [actionImage setAnimationImages:AnimationImgsArr];
    [actionImage setAnimationDuration:images.count * 1];
    [actionImage startAnimating];
    MBProgressHUD *hud = view ?  [self showHUDAddedTo:view animated:YES] :[self showHUDAddedTo:kKeyWindowView animated:YES];
    if (view) {
        [view bringSubviewToFront:hud];
    } else {
        [kKeyWindowView bringSubviewToFront:hud];
    }
    hud.dimBackground = bg;
    hud.customView = actionImage;
    if (!title) {
        title = @"努力加载中...";
    }
    hud.labelText = title;
    hud.labelFont = kSystemFontOfSize(18);
    hud.labelColor = [UIColor darkGrayColor];
    hud.opacity = 0.0;
    hud.cornerRadius = 5.0;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationZoomOut;
}

+ (BOOL)haveShowingHUDForView:(UIView *)view {
    BOOL haveShowingHUD = NO;
    for (UIView *childView in view.subviews) {
        if ([childView isKindOfClass:self]) {
            haveShowingHUD = YES;
        }
    }
    return haveShowingHUD;
}

+ (BOOL)haveShowingHUD {
    BOOL haveShowingHUD = NO;
    for (UIView *childView in kKeyWindowView.subviews) {
        if ([childView isKindOfClass:self]) {
            haveShowingHUD = YES;
        }
    }
    return haveShowingHUD;
}

@end
