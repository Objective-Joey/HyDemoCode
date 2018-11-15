//
//  UIImageView+YYExtension.m
//  HYBaseProject
//
//  Created by huangyi on 17/1/10.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "UIImageView+HYExtension.h"

@implementation UIImageView (HYExtension)
- (void)fadeImageWithUrl:(NSString *)url
             placeholder:(NSString *)placeholder {
    [self setImageWithURL:[NSURL URLWithString:url]
              placeholder:[UIImage imageNamed:(placeholder ? placeholder : @"default_image")]
                  options:YYWebImageOptionSetImageWithFadeAnimation |
                          YYWebImageOptionProgressiveBlur           |
                          YYWebImageOptionShowNetworkActivity
               completion:nil];
}

- (void)fadeImageWithUrl:(NSString *)url
             placeholder:(NSString *)placeholder
              completion:(void(^)(UIImage * image))completion {
    [self setImageWithURL:[NSURL URLWithString:url]
              placeholder:[UIImage imageNamed:(placeholder ? placeholder : @"default_image")]
                  options:YYWebImageOptionSetImageWithFadeAnimation |
                          YYWebImageOptionProgressiveBlur           |
                          YYWebImageOptionShowNetworkActivity
               completion:^(UIImage * image,
                            NSURL * _Nonnull url,
                            YYWebImageFromType from,
                            YYWebImageStage stage,
                            NSError * _Nullable error) {
                   completion ? completion(image) : nil;
               }];
}

@end
