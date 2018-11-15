//
//  HYBaseCollectionViewCell.m
//  HYWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBaseCollectionViewCell.h"


@interface HYBaseCollectionViewCell ()
@property (nonatomic, strong) NSIndexPath *indexPath;
@end


@implementation HYBaseCollectionViewCell
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initConfig];
    }
    return  self;
}

+ (instancetype)cellWithColletionView:(UICollectionView *)collectionView
                            indexPath:(NSIndexPath *)indexPath
                            viewModel:(HYBaseCollectionViewModel *)viewModel {
    
    HYBaseCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self)
                                              forIndexPath:indexPath];
    cell.cellModel = [viewModel getCellModelAtIndexPath:indexPath];
    cell.viewModel = viewModel;
    cell.indexPath = indexPath;
    [cell configureCell];
    return cell;
}

- (void)initConfig {}
- (void)configureCell {};
- (void)reloadCellData {};
- (void)setCustomSubViewsArray:(NSArray<UIView *> *)customSubViewsArray {
    _customSubViewsArray = customSubViewsArray;
    for (UIView *subView in customSubViewsArray) {
        [self.contentView addSubview:subView];
    }
}

@end







