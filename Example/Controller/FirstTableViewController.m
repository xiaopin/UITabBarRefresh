//
//  FirstTableViewController.m
//  Example
//
//  Created by xiaopin on 2018/11/7.
//  Copyright © 2018 xiaopin. All rights reserved.
//

#import "FirstTableViewController.h"
#import "UITabBar+XPTabBarRefresh.h"
#import "CustomRefreshView.h"
#import "TableViewCell.h"

@interface FirstTableViewController ()

@property (nonatomic, strong) NSArray<NSArray<NSNumber *> *> *colors;

@end

@implementation FirstTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.colors = [self createRandomColors];
    
    // 根据项目实际场景获取UITabBarItem
    UITabBarItem *tabBarItem = self.navigationController.tabBarItem;
    // 启用刷新动画
    tabBarItem.enabledRefreshAnimation = YES;
    // 自定义动画
    tabBarItem.refreshView = [[CustomRefreshView alloc] init];
    // 监听刷新回调
    __weak __typeof(self) weakSelf = self;
    [tabBarItem setRefreshBlock:^(UITabBar *tabBar, UITabBarItem *tabBarItem) {
        // 开始刷新数据
        NSLog(@"First Refresh");
        [weakSelf.tableView setContentOffset:CGPointMake(0, weakSelf.tableView.contentOffset.y - weakSelf.refreshControl.frame.size.height) animated:NO];
        [weakSelf.refreshControl beginRefreshing];
        [weakSelf.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 临时解决UITabBarController切换选项卡时UIRefreshControl停止动画的问题
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - self.refreshControl.frame.size.height) animated:NO];
        [self.refreshControl beginRefreshing];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.colors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const identifier = @"Cell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    NSArray *array = self.colors[indexPath.row];
    double r = [array.firstObject doubleValue];
    double g = [array[1] doubleValue];
    double b = [array.lastObject doubleValue];
    [cell setColorWithRed:r green:g blue:b];
    
    return cell;
}

#pragma mark - Actions

- (void)refreshControlValueChanged:(UIRefreshControl *)sender {
    NSLog(@"%s", __FUNCTION__);
    __weak __typeof(self) weakSelf = self;
    // 模拟网络请求完毕
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.colors = [weakSelf createRandomColors];
        [weakSelf.tableView reloadData];
        [weakSelf.refreshControl endRefreshing];
        // 强制性
        [weakSelf.navigationController.tabBarItem stopRefresh];
    });
}

- (NSArray<NSArray<NSNumber *> *> *)createRandomColors {
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<30; i++) {
        double r = arc4random_uniform(256) / 255.0;
        double g = arc4random_uniform(256) / 255.0;
        double b = arc4random_uniform(256) / 255.0;
        [array addObject:@[@(r), @(g), @(b)]];
    }
    return [NSArray arrayWithArray:array];
}

@end
