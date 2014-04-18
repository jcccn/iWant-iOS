//
//  RegisterViewController.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/19/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import <RETableViewManager/RETableViewManager.h>

#import "RegisterViewController.h"
#import "ApiKit.h"

@interface RegisterViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RETableViewManager *tableViewManager;
@property (nonatomic, strong) RETextItem *usernameItem;         //用户名
@property (nonatomic, strong) RETextItem *passwordItem;         //密码
@property (nonatomic, strong) RETextItem *passwordRepeatItem;   //重复密码

- (RETableViewSection *)addTableViewItems;

- (void)signup;

@end

@implementation RegisterViewController

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
    
    self.title = @"注册";
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableViewManager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    [self.tableViewManager addSection:[self addTableViewItems]];
    
    WeakSelf
    RETableViewSection *section = [RETableViewSection section];
    RETableViewItem *item = [RETableViewItem itemWithTitle:@"提交注册"
                                             accessoryType:UITableViewCellAccessoryNone
                                          selectionHandler:^(RETableViewItem *item) {
                                              [item deselectRowAnimated:YES];
                                              
                                              //调用注册接口
                                              [weakSelf signup];
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
                                              placeholder:@"请输入4~10位字母或数字"];
    tableViewItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    [section addItem:tableViewItem];
    self.usernameItem = tableViewItem;
    
    //密码
    tableViewItem = [RETextItem itemWithTitle:@"密码"
                                        value:nil
                                  placeholder:@"请输入8~20位字母或数字"];
    tableViewItem.secureTextEntry = YES;
    tableViewItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    [section addItem:tableViewItem];
    self.passwordItem = tableViewItem;
    
    //重复密码
    tableViewItem = [RETextItem itemWithTitle:@"重复密码"
                                        value:nil
                                  placeholder:@"请输入相同的密码"];
    tableViewItem.secureTextEntry = YES;
    tableViewItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    [section addItem:tableViewItem];
    self.passwordRepeatItem = tableViewItem;
    
    return section;
}

- (void)signup {
    [self.view endEditing:YES];
    
    NSString *username = self.usernameItem.value;
    NSString *password = self.passwordItem.value;
    NSString *passwordRepeat = self.passwordRepeatItem.value;
    if ( ! [username length]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的用户名"];
        return;
    }
    if ( ! [password length]) {
        [SVProgressHUD showErrorWithStatus:@"请输入合适的密码"];
        return;
    }
    if ( ! [password isEqualToString:passwordRepeat]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不相同，请检查"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在注册"];
    //调用注册接口
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:username, @"userid", password, @"password", nil];
    [ApiKit getObjectsAtPath:APIPathRegister
                 dataMapping:nil
                  parameters:param
                          ok:^(id data, NSString *msg) {
                              [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                              //TODO:注册成功后立即登录
                          }
                       error:^(id data, NSInteger errorCode, NSString *errorMsg) {
                           [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"注册失败\n%@", errorMsg]];
                       }];
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
