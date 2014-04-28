//
//  NearByNeedsViewController.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/16/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import <SVPullToRefresh/SVPullToRefresh.h>
#import <PopoverView/PopoverView.h>

#import "NearByNeedsViewController.h"
#import "PostNeedsViewController.h"
#import "NeedsDetailViewController.h"
#import "NeedsCell.h"
#import "MONeeds.h"
#import "LBSManager.h"
#import "FilterView.h"

@interface NearByNeedsViewController () <UITableViewDataSource, UITableViewDelegate, LBSDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *nearbyNeeds;

@property (nonatomic, assign) NSInteger filterGender;
@property (nonatomic, assign) NSInteger filterTimeIndex;

- (void)showFilterView;

- (void)searchNearbyNeeds;

- (void)refreshTheList;
- (void)loadMore;

- (NSString *)expireDateFromTimestamp:(NSTimeInterval)timestamp;

@end

@implementation NearByNeedsViewController

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
    
    self.nearbyNeeds = [NSMutableArray array];
    self.filterGender = 2;
    self.filterTimeIndex = 3;
    
    self.navigationItem.title = @"附近";
    
    WeakSelf
    UIBarButtonItem *item;
    item = [[UIBarButtonItem alloc] bk_initWithTitle:@"过滤"
                                               style:UIBarButtonItemStylePlain
                                             handler:^(id sender) {
                                                 [weakSelf showFilterView];
                                             }];
    self.navigationItem.leftBarButtonItem = item;
    item = [[UIBarButtonItem alloc] bk_initWithTitle:@" + "
                                               style:UIBarButtonItemStylePlain
                                             handler:^(id sender) {
                                                 PostNeedsViewController *viewController = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"PostNeedsViewController"];
                                                 [weakSelf.navigationController pushViewController:viewController animated:YES];
                                             }];
    self.navigationItem.rightBarButtonItem = item;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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

- (void)showFilterView {
    FilterView *filterView = [FilterView loadInstance];
    CGRect frame = filterView.frame;
    frame.size.width = 280;
    filterView.frame = frame;
    filterView.layer.cornerRadius = 4.0f;
    filterView.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    filterView.genderSegmentedControl.selectedSegmentIndex = self.filterGender;
    filterView.timeSegmentedControl.selectedSegmentIndex = self.filterTimeIndex;
    
    PopoverView *popoverView = [PopoverView showPopoverAtPoint:CGPointMake(30, 2)
                                                        inView:self.view
                                               withContentView:filterView
                                                      delegate:nil];
    
    __weak PopoverView *weakPopover = popoverView;
    __weak FilterView *weakFilterView = filterView;
    WeakSelf
    [filterView.cancelButton bk_addEventHandler:^(id sender) {
        [weakPopover dismiss];
    }
                               forControlEvents:UIControlEventTouchUpInside];
    [filterView.confirmButton bk_addEventHandler:^(id sender) {
        weakSelf.filterGender = weakFilterView.genderSegmentedControl.selectedSegmentIndex;
        weakSelf.filterTimeIndex = weakFilterView.timeSegmentedControl.selectedSegmentIndex;
        
        [weakSelf.tableView performSelectorOnMainThread:@selector(triggerPullToRefresh) withObject:nil waitUntilDone:NO];
        
        [weakPopover dismiss];
    }
                                forControlEvents:UIControlEventTouchUpInside];
}

- (void)searchNearbyNeeds {
    if ( ! [self.nearbyNeeds count]) {
        [self.tableView triggerPullToRefresh];
    }
}

- (void)refreshTheList {
    NSInteger timeInterval;
    if (self.filterTimeIndex == 0) {
        timeInterval = 30 * 60;
    }
    else if (self.filterTimeIndex == 1) {
        timeInterval = 2 * 3600;
    }
    else if (self.filterTimeIndex == 2) {
        timeInterval = 24 * 3600;
    }
    else {
        timeInterval = 3 * 24 * 3600;
    }
    //TODO:增加性别和有效期的筛选参数
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
                                  [weakSelf.nearbyNeeds removeAllObjects];
                                  [weakSelf.nearbyNeeds addObjectsFromArray:data];
                                  
                                  [weakSelf.tableView reloadData];
                              }
                          }
                       error:^(id data, NSInteger errorCode, NSString *errorMsg) {
                           [weakSelf.tableView.pullToRefreshView stopAnimating];
                       }];
}

- (void)loadMore {
    NSInteger timeInterval;
    if (self.filterTimeIndex == 0) {
        timeInterval = 30 * 60;
    }
    else if (self.filterTimeIndex == 1) {
        timeInterval = 2 * 3600;
    }
    else if (self.filterTimeIndex == 2) {
        timeInterval = 24 * 3600;
    }
    else {
        timeInterval = 3 * 24 * 3600;
    }
    //TODO:增加性别和有效期的筛选参数
    WeakSelf
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@([LBSManager sharedInstance].latitude), @"latitude", @([LBSManager sharedInstance].longitude), @"longtitude", @([self.nearbyNeeds count]), @"start", @(10), @"count", nil];
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
                                  [weakSelf.nearbyNeeds addObjectsFromArray:data];
                                  
                                  [weakSelf.tableView reloadData];
                              }
                          }
                       error:^(id data, NSInteger errorCode, NSString *errorMsg) {
                           [weakSelf.tableView.infiniteScrollingView stopAnimating];
                       }];
}

- (NSString *)expireDateFromTimestamp:(NSTimeInterval)timestamp {
    NSString *friendlyString;
    NSTimeInterval timeInterval = timestamp - [[NSDate date] timeIntervalSince1970];
    if (timeInterval < 0) {
        friendlyString = @"已过期";
    }
    else if (timeInterval <= 3600) {     //1小时之内
        friendlyString = [NSString stringWithFormat:@"%.0f分钟", timeInterval / 60.0f];
    }
    else if (timeInterval < 2 * 3600) {
        friendlyString = [NSString stringWithFormat:@"1小时%.0f分钟", (timeInterval - 3600) / 60.0f];
    }
    else if (timeInterval < 24 * 3600) {
        friendlyString = [NSString stringWithFormat:@"%.0f小时", timeInterval / 3600.0f];
    }
    else {
        NSInteger dayCount = (NSInteger)(timeInterval / (24 * 3600));
        friendlyString = [NSString stringWithFormat:@"%d天%0.0f小时", dayCount, (timeInterval / 3600 - dayCount * 24)];
    }
    return friendlyString;
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.nearbyNeeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NeedsCell *cell = (NeedsCell *)[tableView dequeueReusableCellWithIdentifier:@"NeedsCell"];
    if ( ! cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NeedsCell" owner:nil options:nil] lastObject];
    }
    
    MONeeds *needs = self.nearbyNeeds[indexPath.row];
    cell.ageLabel.text = [NSString stringWithFormat:@"%@ | %d岁", @"男", 56];
    cell.distanceLabel.text = @"服务端算距离";
    cell.dateLabel.text = [self expireDateFromTimestamp:needs.expiredate];
    cell.titleLabel.text = needs.title;
    cell.subtitleLabel.text = needs.content;
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:@"http://mimi.wumii.cn/images/download/app_logo_v2.jpg"]];
    
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
    
    MONeeds *needs = self.nearbyNeeds[indexPath.row];
    NeedsDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NeedsDetailViewController"];
    viewController.needs = needs;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - LBSDelegate

- (void)lbsSucceed {
    [self searchNearbyNeeds];
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
