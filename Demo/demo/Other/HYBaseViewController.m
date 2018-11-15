//
//  HYBaseViewController.m
//  demo
//
//  Created by huangyi on 2018/11/14.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "HYBaseViewController.h"
#import "HYBaseViewModel.h"

@interface HYBaseViewController ()
@property (nonatomic, strong) RACDisposable *keyboardDisposable;
@property (nonatomic,weak) UIView *keyboardView;
@property (nonatomic,assign) CGFloat keyboardViewSpacing;
@property (nonatomic,assign,getter=isChangeFrame) BOOL changeFrame;
@property (strong, nonatomic) HYBaseViewModel *viewModel;
@end

@implementation HYBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWhite;
    [self configViewModel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self observerKeyboardFrameChange];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.keyboardDisposable) {
        [self.keyboardDisposable dispose];
        self.keyboardDisposable = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)configViewModel{}

- (instancetype)initWithViewModel:(HYBaseViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)handleKeyboardWithView:(UIView *)view spacing:(CGFloat)spacing {
    self.keyboardView = view;
    self.keyboardViewSpacing = spacing;
    [self observerKeyboardFrameChange];
}

- (void)observerKeyboardFrameChange {
    if (self.keyboardDisposable || !self.keyboardView) {return;}
    
    self.keyboardDisposable =
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil] deliverOnMainThread]
     subscribeNext:^(NSNotification * note) {
         
         CGRect beginKeyboardRect = [[note.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
         CGRect endKeyboardRect = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
         //  CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
         
         UIView *kewWindow = [UIApplication sharedApplication].keyWindow;
         CGRect convertRect = [self.view convertRect:self.keyboardView.frame toView:kewWindow];
         
         CGFloat offset = (CGRectGetMaxY(convertRect) + self.keyboardViewSpacing) - endKeyboardRect.origin.y;
         if (endKeyboardRect.size.height > 100) {
             if (offset > 0 && endKeyboardRect.origin.y < beginKeyboardRect.origin.y) {
                 
                 [UIView animateWithDuration:.25 animations:^{
                     self.view.transform = CGAffineTransformMakeTranslation(0, -offset);
                 } completion:^(BOOL finished) {
                     self.changeFrame = YES;
                 }];
             }
         }
         
         if (self.isChangeFrame && endKeyboardRect.origin.y > beginKeyboardRect.origin.y) {
             [UIView animateWithDuration:.25 animations:^{
                 self.view.transform = CGAffineTransformIdentity;
             } completion:^(BOOL finished) {
                 self.changeFrame = NO;
             }];
         }
     }];
}

- (void)dealloc {
    if (self.keyboardDisposable) {
        [self.keyboardDisposable dispose];
    }
}

@end
