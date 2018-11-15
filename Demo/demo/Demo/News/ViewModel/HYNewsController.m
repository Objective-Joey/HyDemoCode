//
//  HYNewsController.m
//  demo
//
//  Created by huangyi on 2018/11/10.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "HYNewsController.h"
#import "HYBaseBlockTableView.h"
#import "HYNewsImageCell.h"
#import "HYNewsViewModel.h"
#import "HYNewsCellModel.h"
#import "HYNewsCell.h"


@interface HYNewsController ()
@property (nonatomic,strong) HYNewsViewModel *viewModel;
@property (nonatomic,strong) HYBaseBlockTableView *tableView;
@end


@implementation HYNewsController
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
}

- (void)repeatClickTabbarItemAction {
    [self.tableView scrollToTop];
}

#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
}

#pragma mark — 配置UI相关
- (void)configUI {
    self.navigationItem.title = @"新闻";
    self.view.backgroundColor = UIColorWhite;
    [self.view addSubview:self.tableView];
    [self.viewModel.tableViewExecuteCommand(0) execute:nil];
}

#pragma mark - getters and setters
- (HYBaseBlockTableView *)tableView {
    return Hy_Lazy(_tableView, ({
        
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - kNavigationBarHeight  - kTabBarHeight - kSafeAreaTop - kSafeAreaBottom);
        
        HYBaseBlockTableView *tableView =
        [HYBaseBlockTableView tableViewWithFrame:rect
                                             style:UITableViewStylePlain
                                       refreshType:HYRefreshTypePullDownAndUp
                                     refreshAction:nil
                                         viewModel:self.viewModel
                                         configure:[self tableViewConfigure]];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
        tableView;
    }));
}

- (HYBaseBlockTableViewConfigure *)tableViewConfigure {
    
    HYBaseBlockTableViewConfigure *configure = [[HYBaseBlockTableViewConfigure alloc] init];
    [[[[configure configRegisterCellClasses:@[HYNewsCell.class, HYNewsImageCell.class]] configCellClassForRow:^Class(HYBaseTableCellModel *cellModel, NSIndexPath *indexPath) {
        return ((HYNewsCellModel *)cellModel).cellClass;
    }] configHeightForRowAtIndexPath:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
        return ((HYNewsCellModel *)[self.viewModel getCellModelAtIndexPath:indexPath]).cellHeight;
    }] configDidSelectRowAtIndexPath:^(UITableView *tableView, NSIndexPath *indexPath) {
        [HYJumpConrollerTool pushViewControllerWithControllerName:@"HYRecommendController"
                                                    viewModelName:@"HYRecommendViewModel"
                                                           params:nil
                                                         animated:YES];
    }];
    
    [[[configure configCanEditRowAtIndexPath:^BOOL (UITableView *tableView, NSIndexPath *indexPath) {
        return YES;
    }] configEditingStyleForRowAtIndexPath:^UITableViewCellEditingStyle(UITableView *tableView, NSIndexPath *indexPath) {
        return 1;
    }]  configEditActionsForRowAtIndexPath:^NSArray<UITableViewRowAction *> *(UITableView *tableView, NSIndexPath *indexPath) {
        // 删除
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            
            [self.tableView hy_deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
            
        }];
        
        // 上移
        UITableViewRowAction *upAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"上移" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:toIndexPath];
            
        }];
        upAction.backgroundColor = [UIColor blackColor];
        
        // 下移
        UITableViewRowAction *downAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"下移" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:toIndexPath];
            
        }];
        downAction.backgroundColor = [UIColor greenColor];
        
        // 插入
        UITableViewRowAction *inserAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"插入" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            [self.tableView insertcellWithcellModel:[self.viewModel getCellModelAtIndexPath:indexPath]
                                            atIndexPath:indexPath
                                       withRowAnimation:0];
            
        }];
        inserAction.backgroundColor = [UIColor purpleColor];
        
        return @[deleteAction, upAction, downAction, inserAction];
    }];
    
    return configure;
}


@end
