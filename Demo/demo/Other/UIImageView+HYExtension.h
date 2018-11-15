//
//  UIImageView+YYExtension.h
//  HYBaseProject
//
//  Created by huangyi on 17/1/10.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>

@interface UIImageView (HYExtension)
- (void)fadeImageWithUrl:(NSString *)url
             placeholder:(NSString *)placeholder;

- (void)fadeImageWithUrl:(NSString *)url
             placeholder:(NSString *)placeholder
              completion:(void(^)(UIImage * image))completion;
@end
