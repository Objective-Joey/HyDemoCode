//
//  HYBaseTableViewCell.m
//  HYWallet
//
//  Created by huangyi on 2018/5/25.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBaseTableViewCell.h"

@interface HYBaseTableViewCell ()
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) HYBaseTableCellModel *cellModel;
@end

@implementation HYBaseTableViewCell
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initConfig];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initConfig];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableview
                        indexPath:(NSIndexPath *)indexPath
                        viewModel:(HYBaseTableViewModel *)viewModel {
    HYBaseTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass(self)
                                                                  forIndexPath:indexPath];
    cell.cellModel = [viewModel getCellModelAtIndexPath:indexPath];
    cell.viewModel = viewModel;
    cell.indexPath = indexPath;
    [cell configureCell];
    return cell;
}

- (void)initConfig {
    self.opaque = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureCell {};
- (void)reloadCellData {};
- (void)setCustomSubViewsArray:(NSArray<UIView *> *)customSubViewsArray {
    _customSubViewsArray = customSubViewsArray;
    for (UIView *subView in customSubViewsArray) {
        if ([subView isKindOfClass:[UIView class]]) {
          [self.contentView addSubview:subView];
        }
    }
}

@end















