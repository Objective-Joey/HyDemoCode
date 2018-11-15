//
//  HYBaseBlockCollectionView.m
//  HYWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBaseBlockCollectionView.h"
#import "HYBaseCollectionViewCell.h"
#import "HYBaseCollectionCellModel.h"
#import "HYBaseCollectionSectionModel.h"
#import "HYBaseCollectionHeaderFooterView.h"


@interface HYBaseBlockCollectionViewConfigure ()
@property (nonatomic,copy) configureBlock emptyViewConfigure;
@property (nonatomic,strong) NSArray *registerCellClasses;
@property (nonatomic,strong) NSArray *registerHeaderViewClasses;
@property (nonatomic,strong) NSArray *registerFooterViewClasses;

@property (nonatomic,copy) NSInteger(^numberOfSectionsBlock)(UICollectionView *collectionView);
@property (nonatomic,copy) NSInteger(^numberOfItemsInSectionBlock)(UICollectionView *collectionView, NSInteger section);

@property (nonatomic,copy) Class(^cellClassForRowBlock)(HYBaseCollectionCellModel *cellModel,NSIndexPath * indexPath);
@property (nonatomic,copy) Class(^headerFooterViewClassAtSectionBlock)
                                (HYBaseCollectionSectionModel *sectionModel,
                                 HYSeactionViewKinds seactionViewKinds,
                                 NSIndexPath *indexPath);
@property (nonatomic,copy) void (^configCellBlock) (HYBaseCollectionViewCell *cell,
                                                    HYBaseCollectionCellModel *cellModel,
                                                    NSIndexPath *indexPath);
@property (nonatomic,copy) void (^configHeaderFooterViewBlock)( HYBaseCollectionHeaderFooterView *headerFooterView,
                                                                HYBaseCollectionSectionModel *sectionModel,
                                                                HYSeactionViewKinds seactionViewKinds,
                                                                NSIndexPath *indexPath);
@end

@implementation HYBaseBlockCollectionViewConfigure
- (instancetype)configEmptyViewConfigure:(configureBlock)configure {
    if (configure) {
        _emptyViewConfigure = [configure copy];
    }
    return self;
}
- (instancetype)configRegisterCellClasses:(NSArray<Class> *)classes {
    _registerCellClasses = classes;
    return self;
}
- (instancetype)configHeaderViewClasses:(NSArray<Class> *)classes {
    _registerHeaderViewClasses = classes;
    return self;
}
- (instancetype)configFooterViewClasses:(NSArray<Class> *)classes {
    _registerFooterViewClasses = classes;
    return self;
}

- (instancetype)configCellClassForRow:(Class(^)(HYBaseCollectionCellModel *cellModel, NSIndexPath * indexPath))block {
    _cellClassForRowBlock = [block copy];
    return self;
}

- (instancetype)configHeaderFooterViewClassAtSection:(Class(^)(HYBaseCollectionSectionModel *sectionModel,
                                                               HYSeactionViewKinds seactionViewKinds,
                                                               NSIndexPath *indexPath))block {
    _headerFooterViewClassAtSectionBlock = [block copy];
    return self;
}

- (instancetype)configCell:(void(^)(HYBaseCollectionViewCell *cell,
                                    HYBaseCollectionCellModel *cellModel,
                                    NSIndexPath *indexPath))block {
    _configCellBlock = [block copy];
    return self;
    
}

- (instancetype)configHeaderFooterView:(void(^)(HYBaseCollectionHeaderFooterView *headerFooterView,
                                                HYBaseCollectionSectionModel *sectionModel,
                                                HYSeactionViewKinds seactionViewKinds,
                                                NSIndexPath *indexPath))block {
    _configHeaderFooterViewBlock = [block copy];
    return self;
    
}

@end



@interface HYBaseBlockCollectionView ()
@property (nonatomic,copy) void(^signalSub)(id value);
@property (nonatomic,copy) void(^errorsSub)(id value);
@property (nonatomic,copy) void(^executingSub)(id value);
@property (nonatomic,assign) HYRefreshType refreshType;
@property (nonatomic,strong) RACCommand *pullUpCommand;
@property (nonatomic,strong) RACCommand *pullDownCommand;
@property (nonatomic,strong) RACCommand *nsewDataCommand;
@property (nonatomic,strong) HYBaseCollectionViewModel *viewModel;
@property (nonatomic,copy) configureBlock emptyViewConfigure;
@property (nonatomic,strong) NSMutableArray<RACDisposable *> *disposees;
@end


@implementation HYBaseBlockCollectionView
+ (instancetype)colletionViewWithFrame:(CGRect)frame
                                layout:(UICollectionViewLayout *)layout
                           refreshType:(HYRefreshType)refreshType
                             viewModel:(HYBaseCollectionViewModel *)viewModel
                             configure:(HYBaseBlockCollectionViewConfigure *)configure {
    
    typedef void(^action)(void);
    action (^refresh)(BOOL isHeaderFresh) = ^(BOOL isHeaderFresh){
        return ^{
            if ([viewModel isKindOfClass:HYBaseCollectionViewModel.class]) {
                HYCollectionViewLoadDataType type = isHeaderFresh ?
                HYCollectionViewLoadDataTypeNew : HYCollectionViewLoadDataTypeMore;
                [viewModel.collectionViewExecuteCommand(type) execute:nil];
            }
        };
    };

    action headerBlock =
    (refreshType == HYRefreshTypePullDown || refreshType == HYRefreshTypePullDownAndUp) ?
    refresh(YES) : nil;

    action footerBlock =
    (refreshType == HYRefreshTypePullUp || refreshType == HYRefreshTypePullDownAndUp) ?
    refresh(NO) : nil;

    HYBaseBlockCollectionView *collectionView =
    [self collectionViewWithFrame:frame
                           layout:layout
                        configure:configure
            headerRefreshCallback:headerBlock
            footerRefreshCallback:footerBlock];

    if ([viewModel isKindOfClass:HYBaseCollectionViewModel.class]) {
        collectionView.viewModel = viewModel;
        collectionView.refreshType = refreshType;
        collectionView.nsewDataCommand = viewModel.collectionViewExecuteCommand(0);
        collectionView.pullDownCommand = viewModel.collectionViewExecuteCommand(1);
        collectionView.pullUpCommand = viewModel.collectionViewExecuteCommand(2);
    }
    [collectionView configCollectionViewBlockWithConfigure:configure];
    if ([viewModel isKindOfClass:HYBaseCollectionViewModel.class]) {
        [collectionView configViewModel];
    }
    return collectionView;
}

- (void)configCollectionViewBlockWithConfigure:(HYBaseBlockCollectionViewConfigure *)configure {
    @weakify(self);
    if (configure.emptyViewConfigure) {
        self.emptyViewConfigure = configure.emptyViewConfigure;
    }
    
    [self registerCellWithCellClasses:configure.registerCellClasses];
    [self registerHeaderWithViewClasses:configure.registerHeaderViewClasses];
    [self registerFooterWithViewClasses:configure.registerFooterViewClasses];
    
    if (!configure.numberOfSectionsBlock) {
        [configure configNumberOfSections:^NSInteger(UICollectionView *collectionView) {
            @strongify(self)
            return  self.viewModel.sectionModels.count;
        }];
    }
    if (!configure.numberOfItemsInSectionBlock) {
        [configure configNumberOfItemsInSection:^NSInteger(UICollectionView *collectionView, NSInteger section) {
            @strongify(self)
            return [self.viewModel getSectionModelAtSection:section].cellModels.count;
        }];
    }
    
    [[[[configure configCellForItemAtIndexPath:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath) {
        @strongify(self)
        if (configure.cellClassForRowBlock) {
            Class cellClass = configure.cellClassForRowBlock([self.viewModel getCellModelAtIndexPath:indexPath],indexPath);
            if (class_getSuperclass(cellClass) == HYBaseCollectionViewCell.class) {
                return
                [cellClass cellWithColletionView:collectionView
                                       indexPath:indexPath
                                       viewModel:self.viewModel];
            }
        }return nil;
    }] configWillDisplayCell:^(UICollectionView *collectionView, UICollectionViewCell *cell, NSIndexPath *indexPath) {
        @strongify(self)
        if ([cell isKindOfClass:HYBaseCollectionViewCell.class]) {
            [((HYBaseCollectionViewCell *)cell) reloadCellData];
        }
        configure.configCellBlock ?
        configure.configCellBlock((HYBaseCollectionViewCell *)cell, [self.viewModel getCellModelAtIndexPath:indexPath], indexPath) : nil;
    }] configSeactionHeaderFooterView:^UICollectionReusableView *(UICollectionView *collectionView, NSString *kind, NSIndexPath *indexPath) {
        if (configure.headerFooterViewClassAtSectionBlock) {
            if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
                Class secionHeaderClass =
                configure.headerFooterViewClassAtSectionBlock([self.viewModel getSectionModelAtSection:indexPath.section], 0, indexPath);
                if (class_getSuperclass(secionHeaderClass) == HYBaseCollectionHeaderFooterView.class) {
                    return
                    [secionHeaderClass headerFooterViewWithCollectionView:collectionView
                                                                indexPath:indexPath
                                                                 isHeader:YES
                                                                viewModel:self.viewModel];
                }
            } else {
                Class secionFooterClass =
                configure.headerFooterViewClassAtSectionBlock([self.viewModel getSectionModelAtSection:indexPath.section], 1, indexPath);
                if (class_getSuperclass(secionFooterClass) == HYBaseCollectionHeaderFooterView.class) {
                    return
                    [secionFooterClass headerFooterViewWithCollectionView:collectionView
                                                                indexPath:indexPath
                                                                 isHeader:YES
                                                                viewModel:self.viewModel];
                } else {
                    return [secionFooterClass new];
                }
            }
        }return nil;
    }] configWillDisPlayHeaderFooterView:^void (UICollectionView *collectionView, UICollectionReusableView *view, NSString *kind, NSIndexPath *indexPath) {
            @strongify(self)
            if ([view isKindOfClass:HYBaseCollectionHeaderFooterView.class]) {
                [((HYBaseCollectionHeaderFooterView *)view) reloadHeaderFooterViewData];
            }
            configure.configHeaderFooterViewBlock ?
            configure.configHeaderFooterViewBlock((HYBaseCollectionHeaderFooterView *)view, [self.viewModel getSectionModelAtSection:indexPath.section], ![kind isEqualToString:UICollectionElementKindSectionHeader], indexPath) : nil;
    }];
}

- (void)configViewModel {
    
    @weakify(self);
    void (^subscribeSignal)(id) = ^(id x){
        @strongify(self);
        if (!self) {  return ;}
        self.signalSub ?
        ({
            self.signalSub(x);
        }):
        ({
            [self reloadData];
            switch (self.refreshType) {
                case HYRefreshTypePullDown:{
                    [self.mj_header endRefreshing];
                }break;
                case HYRefreshTypePullUp:{
                    [self.mj_footer endRefreshing];
                    if ([x isKindOfClass:[NSNumber class]]) {
                        self.mj_footer.hidden = [x boolValue];
                    }
                }break;
                case HYRefreshTypePullDownAndUp:{
                    [self.mj_header endRefreshing];
                    [self.mj_footer endRefreshing];
                    if ([x isKindOfClass:[NSNumber class]]) {
                        self.mj_footer.hidden = [x boolValue];
                    }
                }break;
                default:
                break;
            }
        });
    };
    
    void(^subscribeErrors)(NSError *x) = ^(NSError *x){
        @strongify(self);
        if (!self) {  return ;}
        self.errorsSub ?
        ({
            self.errorsSub(x);
        }):
        ({
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshing];
            
            if (self.viewModel.sectionModels.count <= 0) {
                [self reloadData];
                if (self.refreshType == HYRefreshTypePullUp ||
                    self.refreshType == HYRefreshTypePullDownAndUp) {
                    self.mj_footer.hidden = YES;
                }
            }
        });
    };
    
    void (^subscribeExecuting)(NSNumber * executing) = ^(NSNumber * executing){
        @strongify(self);
        if (!self) {  return ;}
        self.executingSub ?
        ({
            self.executingSub(executing);
        }):
        ({
            if (!executing.boolValue) {
                [MBProgressHUD hidden];
            } else {
                if (self.viewModel.currentLoadDataType == HYTableViewLoadDataTypeFirst) {
                    [MBProgressHUD showHUD];
                }
            }
        });
    };
    
    __block NSMutableArray *tempArray = @[].mutableCopy;
    NSArray *array = @[self.nsewDataCommand , self.pullDownCommand, self.pullUpCommand];
    [array enumerateObjectsUsingBlock:^(RACCommand *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![tempArray containsObject:obj]) {
            
            RACDisposable *disposeOne = [[obj.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:subscribeSignal];
            RACDisposable *disposeTwo = [obj.errors subscribeNext:subscribeErrors];
            RACDisposable *disposeThree = [[[obj.executing skip:1] deliverOnMainThread] subscribeNext:subscribeExecuting];
            
            if (disposeOne && [disposeOne isKindOfClass:[RACDisposable class]]) {
                [self.disposees addObject:disposeOne];
            }
            
            if (disposeTwo && [disposeTwo isKindOfClass:[RACDisposable class]]) {
                [self.disposees addObject:disposeTwo];
            }
            
            if (disposeThree && [disposeThree isKindOfClass:[RACDisposable class]]) {
                [self.disposees addObject:disposeThree];
            }
        }
        [tempArray addObject:obj];
    }];
}

- (void)configCommandSignaleSub:(void(^)(id value))signaleSub
                       erresSub:(void(^)(id value))erresSub
                   executingSub:(void(^)(id value))executingSub  {
    self.signalSub = [signaleSub copy];
    self.errorsSub = [erresSub copy];
    self.executingSub = [executingSub copy];
}

- (void)showEmptyView {
    if (self.emptyViewConfigure) {
        [MBProgressHUD showEmptyViewToView:self
                                 configure:self.emptyViewConfigure
                            reloadCallback:nil];
    }
}

- (void)dismissEmptyView {
    [MBProgressHUD dismissEmptyViewForView:self];
}

- (void)dealloc {
    [self.disposees makeObjectsPerformSelector:@selector(dispose)];
}

- (NSMutableArray *)disposees {
    return Hy_Lazy(_disposees, ({
        @[].mutableCopy;
    }));
}

@end












