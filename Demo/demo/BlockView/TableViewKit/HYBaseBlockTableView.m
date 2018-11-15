//
//  HYBaseBlockTableView.m
//  HYWallet
//
//  Created by huangyi on 2018/5/23.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBaseBlockTableView.h"
#import "HYBaseTableViewCell.h"
#import "HYBaseTableCellModel.h"
#import "HYBaseTableSectionModel.h"
#import "HYBaseTableViewHeaderFooterView.h"


@interface HYBaseBlockTableViewConfigure ()
@property (nonatomic,copy) configureBlock emptyViewConfigure;
@property (nonatomic,strong) NSArray *registerCellClasses;
@property (nonatomic,strong) NSArray *registerHeaderFooterViewClasses;
@property (nonatomic,copy) NSInteger(^numberOfSections)(UITableView *tableView);
@property (nonatomic,copy) NSInteger(^numberOfRowsInSection)(UITableView *tableView, NSInteger section);
@property (nonatomic,copy) Class(^cellClassForRowBlock)(HYBaseTableCellModel *cellModel,NSIndexPath * indexPath);
@property (nonatomic,copy) Class(^headerFooterViewClassAtSectionBlock)
                                (HYBaseTableSectionModel *sectionModel,
                                HYSeactionViewKinds seactionViewKinds,
                                NSUInteger section);
@property (nonatomic,copy) void (^configCellBlock) (HYBaseTableViewCell *cell,
                                                    HYBaseTableCellModel *cellModel,
                                                    NSIndexPath *indexPath);
@property (nonatomic,copy) void (^configHeaderFooterViewBlock)( HYBaseTableViewHeaderFooterView *headerFooterView,
                                                                HYBaseTableSectionModel *sectionModel,
                                                                HYSeactionViewKinds seactionViewKinds,
                                                                NSUInteger section);
@end
@implementation HYBaseBlockTableViewConfigure
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
- (instancetype)configHeaderFooterViewClasses:(NSArray<Class> *)classes {
    _registerHeaderFooterViewClasses = classes;
    return self;
}
- (instancetype)configCellClassForRow:(Class(^)(HYBaseTableCellModel *cellModel,NSIndexPath * indexPath))block {
    _cellClassForRowBlock = [block copy];
    return self;
}
- (instancetype)configHeaderFooterViewClassAtSection:(Class(^)(HYBaseTableSectionModel *sectionModel,
                                                               HYSeactionViewKinds seactionViewKinds,
                                                               NSUInteger section))block {
    _headerFooterViewClassAtSectionBlock = [block copy];
    return self;
}
- (instancetype)configCell:(void(^)(HYBaseTableViewCell *cell,
                                    HYBaseTableCellModel *cellModel,
                                    NSIndexPath *indexPath))block {
    _configCellBlock = [block copy];
    return self;
}
- (instancetype)configHeaderFooterView:(void(^)(HYBaseTableViewHeaderFooterView *headerFooterView,
                                                HYBaseTableSectionModel *sectionModel,
                                                HYSeactionViewKinds seactionViewKinds,
                                                NSUInteger section))block {
    _configHeaderFooterViewBlock = [block copy];
    return self;
}
@end


@interface HYBaseBlockTableView ()
@property (nonatomic,copy) void(^signalSub)(id value);
@property (nonatomic,copy) void(^errorsSub)(id value);
@property (nonatomic,copy) void(^executingSub)(id value);
@property (nonatomic,assign) HYRefreshType refreshType;
@property (nonatomic,strong) RACCommand *pullUpCommand;
@property (nonatomic,strong) RACCommand *pullDownCommand;
@property (nonatomic,strong) RACCommand *nsewDataCommand;
@property (nonatomic,strong) HYBaseTableViewModel *viewModel;
@property (nonatomic,copy) configureBlock emptyViewConfigure;
@property (nonatomic,strong) NSMutableArray<RACDisposable *> *disposees;
@end


@implementation HYBaseBlockTableView
+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                       refreshType:(HYRefreshType)refreshType
                     refreshAction:(RefreshAction(^)(BOOL isHeaderFresh))refreshAction
                         viewModel:(HYBaseTableViewModel *)viewModel
                         configure:(HYBaseBlockTableViewConfigure *)configure {
    
    RefreshAction (^refresh)(BOOL isHeaderFresh) = ^(BOOL isHeaderFresh){
        RefreshAction action = ^{
            if ([viewModel isKindOfClass:HYBaseTableViewModel.class]) {
                HYTableViewLoadDataType type = isHeaderFresh ?
                HYTableViewLoadDataTypeNew : HYTableViewLoadDataTypeMore;
                [viewModel.tableViewExecuteCommand(type) execute:nil];
            }
        };
        return
        refreshAction ? (refreshAction(isHeaderFresh) ?: action) : action;
    };
    
    RefreshAction headerBlock =
    (refreshType == HYRefreshTypePullDown || refreshType == HYRefreshTypePullDownAndUp) ?
    refresh(YES) : nil;
    
    RefreshAction footerBlock =
    (refreshType == HYRefreshTypePullUp || refreshType == HYRefreshTypePullDownAndUp) ?
    refresh(NO) : nil;
    
    HYBaseBlockTableView *tableView =
    [self tableViewWithFrame:frame
                       style:style
                   configure:configure
       headerRefreshCallback:headerBlock
       footerRefreshCallback:footerBlock];
    
    if ([viewModel isKindOfClass:HYBaseTableViewModel.class]) {
        tableView.viewModel = viewModel;
        tableView.refreshType = refreshType;
        tableView.nsewDataCommand = viewModel.tableViewExecuteCommand(0);
        tableView.pullDownCommand = viewModel.tableViewExecuteCommand(1);
        tableView.pullUpCommand = viewModel.tableViewExecuteCommand(2);
    }
    
    [tableView configTableViewBlockWithConfigure:configure];
    if ([viewModel isKindOfClass:HYBaseTableViewModel.class]) {
        [tableView configViewModel];
    }
    return tableView;
}

- (void)configTableViewBlockWithConfigure:(HYBaseBlockTableViewConfigure *)configure {
    if (configure.emptyViewConfigure) {
        self.emptyViewConfigure = configure.emptyViewConfigure;
    }
    
    [self registerCellWithCellClasses:configure.registerCellClasses];
    [self registerHeaderFooterWithViewClasses:configure.registerHeaderFooterViewClasses];
    
    @weakify(self);
    if (!configure.numberOfSections) {
        [configure configNumberOfSections:^NSInteger(UITableView *tableView) {
            @strongify(self)
            return  self.viewModel.sectionModels.count;
        }];
    }
    if (!configure.numberOfRowsInSection) {
        [configure configNumberOfRowsInSection:^NSInteger(UITableView *tableView, NSInteger section) {
            @strongify(self)
            return [self.viewModel getSectionModelAtSection:section].cellModels.count;
        }];
    }
    
    [[[[[[configure configCellForRowAtIndexPath:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        @strongify(self)
        if (configure.cellClassForRowBlock) {
            Class cellClass = configure.cellClassForRowBlock([self.viewModel getCellModelAtIndexPath:indexPath],indexPath);
            if (class_getSuperclass(cellClass) == HYBaseTableViewCell.class) {
                return [cellClass cellWithTableView:tableView
                                          indexPath:indexPath
                                          viewModel:self.viewModel];
            }
        }return nil;
    }] configWillDisplayCell:^(UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath) {
        @strongify(self)
        if ([cell isKindOfClass:HYBaseTableViewCell.class]) {
           [((HYBaseTableViewCell *)cell) reloadCellData];
        }
        configure.configCellBlock ?
        configure.configCellBlock((HYBaseTableViewCell *)cell, [self.viewModel getCellModelAtIndexPath:indexPath], indexPath) : nil;
    }] configViewForHeaderInSection:^UIView *(UITableView *tableView, NSInteger section) {
        @strongify(self)
        if (configure.headerFooterViewClassAtSectionBlock) {
            id headerClass =
            configure.headerFooterViewClassAtSectionBlock([self.viewModel getSectionModelAtSection:section],0, section);
            if (class_getSuperclass(headerClass) == HYBaseTableViewHeaderFooterView.class) {
                return [headerClass
                        headerFooterViewWithTableView:tableView
                        section:section
                        isHeader:YES
                        viewModel:self.viewModel];
            } else {
                return headerClass;
            }
        }return nil;
    }] configWillDisplayHeaderView:^(UITableView *tableView,UIView *view,NSInteger section) {
        @strongify(self)
        if ([view isKindOfClass:HYBaseTableViewHeaderFooterView.class]) {
            [((HYBaseTableViewHeaderFooterView *)view) reloadHeaderFooterViewData];
        }
        configure.configHeaderFooterViewBlock ?
        configure.configHeaderFooterViewBlock((HYBaseTableViewHeaderFooterView *)view,
                                              [self.viewModel getSectionModelAtSection:section], 0, section) : nil;
    }] configViewForFooterInSection:^UIView *(UITableView *tableView, NSInteger section) {
        @strongify(self)
        if (configure.headerFooterViewClassAtSectionBlock) {
            id headerClass =
            configure.headerFooterViewClassAtSectionBlock([self.viewModel getSectionModelAtSection:section],1, section);
            if (class_getSuperclass(headerClass) == HYBaseTableViewHeaderFooterView.class) {
                return [headerClass
                        headerFooterViewWithTableView:tableView
                        section:section
                        isHeader:NO
                        viewModel:self.viewModel];
            } else {
                return headerClass;
            }
        }return nil;
    }] configWillDisplayFooterView:^(UITableView *tableView, UIView *view, NSInteger section) {
        @strongify(self)
        if ([view isKindOfClass:HYBaseTableViewHeaderFooterView.class]) {
            [((HYBaseTableViewHeaderFooterView *)view) reloadHeaderFooterViewData];
        }
        configure.configHeaderFooterViewBlock ?
        configure.configHeaderFooterViewBlock((HYBaseTableViewHeaderFooterView *)view,
                                              [self.viewModel getSectionModelAtSection:section], 1, section) : nil;
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
            !self.signalSub ?: self.signalSub(x);
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
                if (self.emptyViewConfigure) {
                    if (self.viewModel.sectionModels.count) {
                        [self dismissEmptyView];
                    } else {
                        [self showEmptyView];
                    }
                }
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
                   executingSub:(void(^)(id value))executingSub {
    self.signalSub = [signaleSub copy];
    self.errorsSub = [erresSub copy];
    self.executingSub = [executingSub copy];
}

- (void)insertcellWithcellModel:(HYBaseTableCellModel *)cellModel
                        atIndexPath:(NSIndexPath *)indexPath
                   withRowAnimation:(UITableViewRowAnimation)animation {
    
    if (!cellModel || !indexPath) { return; }
    
    if (indexPath.section > self.viewModel.sectionModels.count - 1) {
        return;
    }
    
    HYBaseTableSectionModel *sectionModel = [self.viewModel getSectionModelAtSection:indexPath.section];
    if (indexPath.row > sectionModel.cellModels.count) {
        return;
    }
    
    NSArray *paths = [NSArray arrayWithObject:indexPath];
    [sectionModel.cellModels insertObject:cellModel atIndex:indexPath.row];
    [self insertRowsAtIndexPaths:paths withRowAnimation:animation];
}

- (void)hy_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
                 withRowAnimation:(UITableViewRowAnimation)animation {
 
    if (!indexPaths || indexPaths.count <= 0) {
        return;
    }
    
    NSMutableArray *MindexArray = [NSMutableArray array];
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.section > self.viewModel.sectionModels.count - 1) {
            return;
        } else {
            NSInteger count =
            [self.viewModel getSectionModelAtSection:indexPath.section].cellModels.count;
            if (indexPath.row >  count - 1) {
                return;
            } else {
                
                [[self.viewModel getSectionModelAtSection:indexPath.section].cellModels removeObjectAtIndex:indexPath.row];
                [MindexArray addObject:indexPath];
            }
        }
    }
    MindexArray.count ?
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation] : nil ;
}

- (void)hy_moveRowAtIndexPath:(NSIndexPath *)atIndexPath
                  toIndexPath:(NSIndexPath *)toIndexPath {
    
    if (![self isCorretIndexPath:atIndexPath] ||
        ![self isCorretIndexPath:toIndexPath]) {
        return;
    }
    
    HYBaseTableCellModel *cellModel = [self.viewModel getCellModelAtIndexPath:atIndexPath];
    
    [[self.viewModel getSectionModelAtSection:atIndexPath.section].cellModels removeObjectAtIndex:atIndexPath.row];
    
    [[self.viewModel getSectionModelAtSection:atIndexPath.section].cellModels insertObject:cellModel atIndex:toIndexPath.row];

    [self  moveRowAtIndexPath:atIndexPath toIndexPath:toIndexPath];
  
}

- (BOOL)isCorretIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section > self.viewModel.sectionModels.count - 1) {
        return NO;
    }
    if (indexPath.row > [self.viewModel getSectionModelAtSection:indexPath.section].cellModels.count - 1) {
        return NO;
    }
    return YES;
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










