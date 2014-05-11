//
//  RecommendNeedsViewController.m
//  iWant
//
//  Created by Jiang Chuncheng on 5/11/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import <SVPullToRefresh/SVPullToRefresh.h>

#import "RecommendNeedsViewController.h"
#import "NeedsDetailViewController.h"
#import "NeedsCell.h"
#import "MONeeds.h"
#import "LBSManager.h"

@interface RecommendNeedsViewController () <UITableViewDataSource, UITableViewDelegate, LBSDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *recommendNeeds;

- (void)searchRecommendNeeds;

- (void)refreshTheList;
- (void)loadMore;

@end

@implementation RecommendNeedsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.recommendNeeds = [NSMutableArray array];
    
    self.navigationItem.title = @"推荐给我的";
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    WeakSelf
    
    //配置下拉刷新
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshTheList];
    }];
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTitle:@"松开刷新" forState:SVPullToRefreshStateTriggered];
    [self.tableView.pullToRefreshView setTitle:@"正在刷新" forState:SVPullToRefreshStateLoading];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if (weakSelf.tableView.pullToRefreshView.state != SVInfiniteScrollingStateStopped) {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            return;
        }
        [weakSelf loadMore];
    }];
    
    [[LBSManager sharedInstance] registerLbsObserver:self];
    
    //FIXME:使用缓存的位置
    [self.tableView triggerPullToRefresh];
}

- (void)dealloc {
    [[LBSManager sharedInstance] unregisterbsObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchRecommendNeeds {
    if ( ! [self.recommendNeeds count]) {
        [self.tableView triggerPullToRefresh];
    }
}

- (void)refreshTheList {
    //TODO:换成推荐接口
    WeakSelf
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@([LBSManager sharedInstance].latitude), @"latitude", @([LBSManager sharedInstance].longitude), @"longtitude", @(0), @"start", @(10), @"count", nil];
    [ApiKit getObjectsAtPath:APIPathFindNeeds
                 dataMapping:[MONeeds commonMapping]
                  parameters:param
                          ok:^(id data, NSString *msg) {
                              [weakSelf.tableView.pullToRefreshView stopAnimating];
                              
                              if ([data isKindOfClass:[NSArray class]]) {
                                  //FIXME:数据为空，所以返回数据为0时不刷新
                                  if ( ! [data count]) {
                                      return ;
                                  }
                                  [weakSelf.recommendNeeds removeAllObjects];
                                  [weakSelf.recommendNeeds addObjectsFromArray:data];
                                  
                                  [weakSelf.tableView reloadData];
                              }
                          }
                       error:^(id data, NSInteger errorCode, NSString *errorMsg) {
                           [weakSelf.tableView.pullToRefreshView stopAnimating];
                       }];
}

- (void)loadMore {
    //TODO:换成推荐接口
    WeakSelf
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@([LBSManager sharedInstance].latitude), @"latitude", @([LBSManager sharedInstance].longitude), @"longtitude", @([self.recommendNeeds count]), @"start", @(10), @"count", nil];
    [ApiKit getObjectsAtPath:APIPathFindNeeds
                 dataMapping:[MONeeds commonMapping]
                  parameters:param
                          ok:^(id data, NSString *msg) {
                              [weakSelf.tableView.infiniteScrollingView stopAnimating];
                              
                              if ([data isKindOfClass:[NSArray class]]) {
                                  //FIXME:数据为空，所以返回数据为0时不刷新
                                  if ( ! [data count]) {
                                      return ;
                                  }
                                  [weakSelf.recommendNeeds addObjectsFromArray:data];
                                  
                                  [weakSelf.tableView reloadData];
                              }
                          }
                       error:^(id data, NSInteger errorCode, NSString *errorMsg) {
                           [weakSelf.tableView.infiniteScrollingView stopAnimating];
                       }];
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recommendNeeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NeedsCell *cell = (NeedsCell *)[tableView dequeueReusableCellWithIdentifier:@"NeedsCell"];
    if ( ! cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NeedsCell" owner:nil options:nil] lastObject];
    }
    
    MONeeds *needs = self.recommendNeeds[indexPath.row];
    
    [cell layoutWithNeeds:needs];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MONeeds *needs = self.recommendNeeds[indexPath.row];
    NeedsDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NeedsDetailViewController"];
    viewController.needs = needs;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - LBSDelegate

- (void)lbsSucceed {
    [self searchRecommendNeeds];
}

- (void)lbsFailedWithError:(NSError *)theError {
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
