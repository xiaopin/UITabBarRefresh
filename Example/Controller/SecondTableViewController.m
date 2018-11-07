//
//  SecondTableViewController.m
//  Example
//
//  Created by xiaopin on 2018/11/7.
//  Copyright © 2018 xiaopin. All rights reserved.
//

#import "SecondTableViewController.h"
#import "UITabBar+XPTabBarRefresh.h"
#import "TableViewCell.h"

@interface SecondTableViewController ()

@property (nonatomic, strong) NSArray<NSArray<NSNumber *> *> *colors;

@end

@implementation SecondTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.colors = [self createRandomColors];
    
    // 启用刷新动画
    self.tabBarItem.enabledRefreshAnimation = YES;
    // 监听刷新回调
    __weak __typeof(self) weakSelf = self;
    [self.tabBarItem setRefreshBlock:^(UITabBar *tabBar, UITabBarItem *tabBarItem) {
        // 开始刷新
        NSLog(@"Sencond Refresh");
        [weakSelf.tableView setContentOffset:CGPointMake(0, weakSelf.tableView.contentOffset.y - weakSelf.refreshControl.frame.size.height) animated:NO];
        [weakSelf.refreshControl beginRefreshing];
        [weakSelf.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
    }];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.colors = [weakSelf createRandomColors];
        [weakSelf.tableView reloadData];
        [weakSelf.refreshControl endRefreshing];
        [weakSelf.tabBarItem stopRefresh];
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
