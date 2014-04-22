//
//  NearByNeedsViewController.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/16/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import <SVPullToRefresh/SVPullToRefresh.h>

#import "NearByNeedsViewController.h"
#import "PostNeedsViewController.h"
#import "NeedsDetailViewController.h"
#import "NeedsCell.h"
#import "MONeeds.h"

@interface NearByNeedsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *nearbyNeeds;

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
    //FIXME:
    MONeeds *testNeeds = [[MONeeds alloc] init];
    testNeeds.title = @"测试需求";
    testNeeds.content = @"测试需求内容";
    [self.nearbyNeeds addObject:testNeeds];
    
    self.navigationItem.title = @"附近";
    
    WeakSelf
    UIBarButtonItem *item;
    item = [[UIBarButtonItem alloc] bk_initWithTitle:@"过滤"
                                               style:UIBarButtonItemStylePlain
                                             handler:^(id sender) {
                                                 
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
