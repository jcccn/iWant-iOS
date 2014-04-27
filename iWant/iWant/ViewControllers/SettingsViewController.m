//
//  SettingsViewController.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/16/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import <RETableViewManager/RETableViewManager.h>

#import "SettingsViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "UpdateProfileViewController.h"
#import "UpdatePasswordViewController.h"

@interface SettingsViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RETableViewManager *tableViewManager;

- (RETableViewSection *)addTableViewItems;

- (void)showLogoutAlertView;

@end

@implementation SettingsViewController

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
    
    self.navigationItem.title = @"设置";
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableViewManager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    [self.tableViewManager addSection:[self addTableViewItems]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RETableViewSection *)addTableViewItems {
    WeakSelf
    
    RETableViewSection *section = [RETableViewSection section];
    
    //声音提醒
    RETableViewItem *tableViewItem;
    tableViewItem = [REBoolItem itemWithTitle:@"声音提醒"
                                        value:YES
                     switchValueChangeHandler:^(REBoolItem *item) {
                         //TODO:切换声音开关
                     }];
    [section addItem:tableViewItem];
    
    //震动提醒
    tableViewItem = [REBoolItem itemWithTitle:@"震动提醒"
                                        value:YES
                     switchValueChangeHandler:^(REBoolItem *item) {
                         //TODO:切换震动开关
                     }];
    [section addItem:tableViewItem];
    
    //个人资料
    tableViewItem = [RETableViewItem itemWithTitle:@"个人资料"
                                     accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                  selectionHandler:^(RETableViewItem *item) {
                                      [item deselectRowAnimated:YES];
                                      ProfileViewController *viewController = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
                                      [weakSelf.navigationController pushViewController:viewController animated:YES];
                                  }];
    [section addItem:tableViewItem];
    
    //修改密码
    tableViewItem = [RETableViewItem itemWithTitle:@"修改密码"
                                     accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                  selectionHandler:^(RETableViewItem *item) {
                                      [item deselectRowAnimated:YES];
                                      UpdatePasswordViewController *viewController = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"UpdatePasswordViewController"];
                                      [weakSelf.navigationController pushViewController:viewController animated:YES];
                                  }];
    [section addItem:tableViewItem];
    
    //注销
    tableViewItem = [RETableViewItem itemWithTitle:@"注销"
                                     accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                  selectionHandler:^(RETableViewItem *item) {
                                      [item deselectRowAnimated:YES];
                                      
                                      [weakSelf showLogoutAlertView];
                                  }];
    [section addItem:tableViewItem];
    
    return section;
}

- (void)showLogoutAlertView {
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"您确定退出当前账号？"];
    [alertView bk_addButtonWithTitle:@"退出" handler:^{
        [[Login sharedInstance] logout];
    }];
    [alertView bk_setCancelButtonWithTitle:@"取消" handler:^{
        
    }];
    [alertView show];
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
