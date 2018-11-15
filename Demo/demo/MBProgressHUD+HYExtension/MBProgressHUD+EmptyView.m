//
//  MBProgressHUD+EmptyView.m
//  demo
//
//  Created by huangyi on 2018/11/12.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "MBProgressHUD+EmptyView.h"

@interface EmptyConfigure ()

// 背景图片 可以是 UIImage| NSString 当设置为nil 则为隐藏
@property (nonatomic,strong) id hy_backgroundImage;

// 上面的logo 可以是 UIImage| NSString 当设置为nil 则为隐藏
@property (nonatomic,strong) id hy_image;

// logo下面的标题 可以是 NSString| NSAttributedString | NSAttributedString 当设置为nil 则为隐藏
// 如果要改变字体大小 颜色等其他属性 可以用富文本 不提直接的属性
@property (nonatomic,strong) id hy_title;

// title下面的复标题 可以是 NSString| NSAttributedString | NSAttributedString 当设置为nil 则为隐藏
// 如果要改变字体大小 颜色等其他属性 可以用富文本 不提供直接的属性
@property (nonatomic,strong) id hy_subTitle;

// 按钮标题
@property (nonatomic,strong) NSString *hy_btnTitle;
// 按钮 图片
@property (nonatomic,strong) id hy_btnImage;
// 按钮背景图片
@property (nonatomic,strong) id hy_btnBackgroundImage;
@property (nonatomic,assign) CGRect hy_contentFrame;
@property (nonatomic,strong) RACTuple *hy_positionConfigure;
+ (instancetype)defaultConfigure; // 初始化默认配置
@end


@implementation EmptyConfigure
+ (instancetype)defaultConfigure {
    EmptyConfigure *configure = [[self alloc] init];
    configure.hy_backgroundImage = nil;
    configure.hy_image = nil;
    configure.hy_title = nil;
    configure.hy_subTitle = nil;
    configure.hy_btnTitle = @"无数据";
    configure.hy_btnImage = nil;
    configure.hy_btnBackgroundImage = nil;
    return configure;
}
- (instancetypeBlock)backgroundImage {
    instancetypeBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[UIImage class]]) {
            _hy_backgroundImage = value;
        } else {
            NSLog(@"赋值backgroundImage的类型不正确");
        }return self;
    };
    return block;
}
- (instancetypeBlock)image {
    instancetypeBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[UIImage class]]) {
            _hy_image = value;
        } else {
            NSLog(@"赋值image的类型不正确");
        }return self;
    };
    return block;
}
- (instancetypeBlock)title {
    instancetypeBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]]) {
            _hy_title = value;
        } else {
            NSLog(@"赋值title的类型不正确");
        }return self;
    };return block;
}
- (instancetypeBlock)subTitle {
    instancetypeBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]]) {
            _hy_subTitle = value;
        } else {
            NSLog(@"赋值subTitle的类型不正确");
        }return self;
    };return block;
}
- (instancetypeBlock)btnTitle {
    instancetypeBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ) {
            _hy_subTitle = value;
        } else {
            NSLog(@"赋值btnTitle的类型不正确");
        }return self;
    };return block;
}
- (instancetypeBlock)btnImage {
    instancetypeBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[UIImage class]]) {
            _hy_image = value;
        } else {
            NSLog(@"赋值btnImage的类型不正确");
        }return self;
    };return block;
}
- (instancetypeBlock)btnBackgroundImage {
    instancetypeBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[UIImage class]]) {
            _hy_backgroundImage = value;
        } else {
            NSLog(@"赋值btnBackgroundImage的类型不正确");
        }return self;
    };return block;
}
- (instancetypeBlock)contentFrame {
    instancetypeBlock block = ^(id value){
        if (value) {
            _hy_contentFrame = [value CGRectValue];
        } else {
            NSLog(@"赋值contentFrame的类型不正确");
        }return self;
    };return block;
}
- (instancetypeBlock)positionConfigure {
    instancetypeBlock block = ^(id value){
        if (value) {
            _hy_positionConfigure = value;
        } else {
            NSLog(@"赋值hy_positionConfigure的类型不正确");
        }return self;
    };return block;
}
@end

@interface EmptyContentView : UIView
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UIButton *reloadBtn;
@property (nonatomic,strong) EmptyConfigure *configure;
@property (nonatomic,copy) reloadBlock reloadCallback;
@property (nonatomic,copy) configureBlock configureBlock;
@end


@implementation EmptyContentView

+ (instancetype)contentViewWithConfigure:(EmptyConfigure *)configure
                          reloadCallback:(reloadBlock)reloadCallback {
    
    EmptyContentView *contentView = [[EmptyContentView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.configure = configure;
    contentView.reloadCallback = [reloadCallback copy];
    [contentView configUI];
    return contentView;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self observeFrame];
}

- (void)observeFrame {
    @weakify(self);
    
    [[[RACObserve(self.superview, frame) takeUntil:self.rac_willDeallocSignal]
      deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self);
        if (self.configure.hy_contentFrame.size.width) {
            self.frame = self.configure.hy_contentFrame;
        } else {
            CGRect rect = [x CGRectValue];
            self.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        }
    }];
}

- (void)configUI {
    
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.reloadBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundImageView.frame = self.bounds;
    
    
    RACTuple *tuple = self.configure.hy_positionConfigure;
    EmptyViewPositon position = [tuple.first integerValue];
    CGFloat offset = [tuple.last floatValue];
    
    switch (position) {
        case EmptyViewPositon_Center: {
            self.reloadBtn.size = CGSizeMake(120, 40);
            self.reloadBtn.centerX = self.width / 2;
            self.reloadBtn.centerY = self.height / 2 + 30 + offset;
            
            self.reloadBtn.hidden = !self.reloadCallback;
            self.reloadBtn.layer.borderColor = [UIColor blueColor].CGColor;
            self.reloadBtn.layer.cornerRadius = 4;
            self.reloadBtn.layer.masksToBounds = YES;
            
            [self.subTitleLabel sizeToFit];
            self.subTitleLabel.width = self.width - 24;
            self.subTitleLabel.left = 12;
            self.subTitleLabel.bottom = self.reloadBtn.top - 20 ;
            
            [self.titleLabel sizeToFit];
            self.titleLabel.width = self.subTitleLabel.width;
            self.titleLabel.left = self.subTitleLabel.left;
            if (self.configure.hy_subTitle) {
                self.titleLabel.bottom = self.subTitleLabel.top - 10 ;
            } else {
                self.titleLabel.bottom = self.reloadBtn.top - 20;
            }
            
            self.imageView.size = self.imageView.image.size;
            self.imageView.centerX = self.reloadBtn.centerX;
            if (self.configure.hy_title) {
                self.imageView.bottom = self.titleLabel.top - 20 ;
            } else if (self.configure.hy_subTitle) {
                self.imageView.bottom = self.subTitleLabel.top - 20 ;
            } else if (!self.configure.hy_title && !self.configure.hy_subTitle) {
                self.imageView.bottom = self.reloadBtn.top - 20 ;
            }
        }break;
        case EmptyViewPositon_Top: {
            
            self.imageView.size = self.imageView.image.size;
            self.imageView.centerX = self.width / 2;
            self.imageView.top = offset ?: 30;
            
            [self.titleLabel sizeToFit];
            self.titleLabel.width = self.width - 24;
            self.titleLabel.left = 12;
            if (self.imageView.size.height) {
                self.titleLabel.top = self.imageView.bottom + 20 ;
            } else {
                self.titleLabel.top = self.imageView.bottom;
            }
            
            [self.subTitleLabel sizeToFit];
            self.subTitleLabel.width = self.width - 24;
            self.subTitleLabel.left = 12;
            if (self.titleLabel.height) {
                self.subTitleLabel.top = self.titleLabel.bottom + 10 ;
            } else {
                self.subTitleLabel.top = self.titleLabel.bottom;
            }
            
            self.reloadBtn.size = CGSizeMake(120, 40);
            self.reloadBtn.centerX = self.width / 2;
            self.reloadBtn.top = self.subTitleLabel.bottom + 20;
            
            self.reloadBtn.hidden = !self.reloadCallback;
            self.reloadBtn.layer.borderColor = [UIColor blueColor].CGColor;
            self.reloadBtn.layer.cornerRadius = 4;
            self.reloadBtn.layer.masksToBounds = YES;
        }break;
        default:
            break;
    }
}

- (void)clickBtnAction {
    //    [self removeFromSuperview];
    self.reloadCallback ? self.reloadCallback() : nil;
}

- (UIImageView *)backgroundImageView {
    return Hy_Lazy(_backgroundImageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        if ([self.configure.hy_backgroundImage isKindOfClass:[NSString class]]) {
            imageView.image = [UIImage imageNamed:self.configure.hy_backgroundImage];
        }
        if ([self.configure.hy_backgroundImage isKindOfClass:[UIImage class]]) {
            imageView.image = self.configure.hy_backgroundImage;
        }
        //        imageView.contentMode = UIViewContentModeScaleAspectFit;
        //        imageView.clipsToBounds = YES;
        imageView;
    }));
}
- (UIImageView *)imageView {
    return Hy_Lazy(_imageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        if ([self.configure.hy_image isKindOfClass:[NSString class]]) {
            imageView.image = [UIImage imageNamed:self.configure.hy_image];
        }
        if ([self.configure.hy_image isKindOfClass:[UIImage class]]) {
            imageView.image = self.configure.hy_image;
        }
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView;
    }));
}
- (UILabel *)titleLabel {
    return Hy_Lazy(_titleLabel, ({
        
        UILabel *lable = [[UILabel alloc] init];
        lable.textColor = [UIColor grayColor];
        lable.font = [UIFont systemFontOfSize:16];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.numberOfLines = 2;
        if ([self.configure.hy_title isKindOfClass:[NSString class]]) {
            lable.text = self.configure.hy_title;
        }
        if ([self.configure.hy_title isKindOfClass:[NSAttributedString class]] ||
            [self.configure.hy_title isKindOfClass:[NSAttributedString class]]) {
            lable.attributedText = self.configure.hy_title;
        }
        lable;
    }));
}
- (UILabel *)subTitleLabel {
    return Hy_Lazy(_subTitleLabel, ({
        
        UILabel *lable = [[UILabel alloc] init];
        lable.textColor = [UIColor grayColor];
        lable.font = [UIFont systemFontOfSize:12];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.numberOfLines = 2;
        if ([self.configure.hy_subTitle isKindOfClass:[NSString class]]) {
            lable.text = self.configure.hy_subTitle;
        }
        if ([self.configure.hy_subTitle isKindOfClass:[NSMutableAttributedString class]] ||
            [self.configure.hy_subTitle isKindOfClass:[NSAttributedString class]]) {
            lable.attributedText = self.configure.hy_subTitle;
        }
        lable;
    }));
}
- (UIButton *)reloadBtn {
    return Hy_Lazy(_reloadBtn, ({
        
        UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reloadBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        reloadBtn.backgroundColor = [UIColor grayColor];
        [reloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [reloadBtn setTitle:self.configure.hy_btnTitle forState:UIControlStateNormal];
        if ([self.configure.hy_btnImage isKindOfClass:[NSString class]]) {
            [reloadBtn setImage:[UIImage imageNamed:self.configure.hy_btnImage] forState:UIControlStateNormal];
        }
        if ([self.configure.hy_btnImage isKindOfClass:[UIImage class]]) {
            [reloadBtn setImage:self.configure.hy_btnImage forState:UIControlStateNormal];
        }
        if ([self.configure.hy_btnBackgroundImage isKindOfClass:[NSString class]]) {
            [reloadBtn setBackgroundImage:[UIImage imageNamed:self.configure.hy_btnBackgroundImage]
                                 forState:UIControlStateNormal];
        }
        if ([self.configure.hy_btnBackgroundImage isKindOfClass:[UIImage class]]) {
            [reloadBtn setBackgroundImage:self.configure.hy_btnBackgroundImage forState:UIControlStateNormal];
        }
        [reloadBtn addTarget:self action:@selector(clickBtnAction) forControlEvents:UIControlEventTouchUpInside];
        reloadBtn;
    }));
}
@end


@implementation MBProgressHUD (EmptyView)
+ (void)showEmptyViewToView:(UIView *)view
                  configure:(configureBlock)configure
             reloadCallback:(reloadBlock)reloadCallback {
    
    if ([self getHasShowContentViewForView:view]) {
        return;
    }
    
    EmptyConfigure *config = [EmptyConfigure defaultConfigure];
    if (configure) {configure(config);}
    
    EmptyContentView *contentView =
    [EmptyContentView contentViewWithConfigure:config
                                  reloadCallback:reloadCallback];
    [view insertSubview:contentView atIndex:0];
    [view bringSubviewToFront:contentView];
}

+ (void)dismissEmptyViewForView:(UIView *)view {
    EmptyContentView *contentView = [self getHasShowContentViewForView:view];
    if (contentView) {
        contentView.reloadCallback = nil;
        contentView.configure = nil;
        [contentView removeFromSuperview];
    }
}

+ (EmptyContentView *)getHasShowContentViewForView:(UIView *)view {
    __block EmptyContentView *contentView = nil;
    [view.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[EmptyContentView class]]) {
            contentView = (EmptyContentView *)obj;
            *stop = YES;
        }
    }];
    return contentView;
}

@end
