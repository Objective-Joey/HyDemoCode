//
//  HYNewsCellModel.h
//  demo
//
//  Created by huangyi on 2018/11/10.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "HYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYNewsCellModel : HYBaseModel

@property (nonatomic, copy)   NSString  *url;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSArray   *imgsrc;
@property (nonatomic, assign) NSInteger showType;
@property (nonatomic, assign) NSInteger replyCount;

@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic, assign) Class  cellClass;
@property (nonatomic, copy) NSString *imageUrlStr;
@property (nonatomic, copy) NSAttributedString *titleAttr;

@end

NS_ASSUME_NONNULL_END
