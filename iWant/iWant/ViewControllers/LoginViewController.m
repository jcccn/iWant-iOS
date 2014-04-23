//
//  LoginViewController.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/19/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import <RETableViewManager/RETableViewManager.h>

#import "LoginViewController.h"
#import "ApiKit.h"
#import "Login.h"

@interface LoginViewController () <LoginObserver>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RETableViewManager *tableViewManager;
@property (nonatomic, strong) RETextItem *usernameItem;         //用户名
@property (nonatomic, strong) RETextItem *passwordItem;         //密码

- (RETableViewSection *)addTableViewItems;

- (void)login;

@end

@implementation LoginViewController

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
    
    self.title = @"登录";
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableViewManager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    [self.tableViewManager addSection:[self addTableViewItems]];
    
    WeakSelf
    RETableViewSection *section = [RETableViewSection section];
    RETableViewItem *item = [RETableViewItem itemWithTitle:@"立即登录"
                                             accessoryType:UITableViewCellAccessoryNone
                                          selectionHandler:^(RETableViewItem *item) {
                                              [item deselectRowAnimated:YES];
                                              
                                              //调用注册接口
                                              [weakSelf login];
                                          }];
    item.textAlignment = NSTextAlignmentCenter;
    [section addItem:item];
    [self.tableViewManager addSection:section];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RETableViewSection *)addTableViewItems {
    RETableViewSection *section = [RETableViewSection section];
    
    //用户名
    RETextItem *tableViewItem = [RETextItem itemWithTitle:@"用户名"
                                                    value:nil
                                              placeholder:@"请输入字母或数字"];
    tableViewItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    [section addItem:tableViewItem];
    self.usernameItem = tableViewItem;
    
    //密码
    tableViewItem = [RETextItem itemWithTitle:@"密码"
                                        value:nil
                                  placeholder:@"请输入字母或数字"];
    tableViewItem.secureTextEntry = YES;
    tableViewItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    [section addItem:tableViewItem];
    self.passwordItem = tableViewItem;
    
    return section;
}

- (void)login {
    [self.view endEditing:YES];
    
    NSString *username = self.usernameItem.value;
    NSString *password = self.passwordItem.value;
    if ( ! [username length]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的用户名"];
        return;
    }
    if ( ! [password length]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的密码"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在登录"];
    //调用登录接口
    [[Login sharedInstance] loginWithAccountName:username password:password andObserver:self];
}

#pragma mark - Login Observer

- (void)loginSucceeded {
    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loginFailedWithErrorCode:(NSInteger)errCode errorMessage:(NSString *)errMsg {
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"登录失败\n%@", errMsg]];
}

- (void)loggedOut {
    
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
