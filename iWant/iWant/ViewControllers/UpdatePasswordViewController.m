//
//  UpdatePasswordViewController.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/22/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import <RETableViewManager/RETableViewManager.h>

#import "UpdatePasswordViewController.h"

@interface UpdatePasswordViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RETableViewManager *tableViewManager;
@property (nonatomic, strong) RETextItem *originPasswordItem;           //旧密码
@property (nonatomic, strong) RETextItem *freshPasswordItem;            //新密码
@property (nonatomic, strong) RETextItem *repeatPasswordItem;           //重复新密码

- (RETableViewSection *)addTableViewItems;


@end

@implementation UpdatePasswordViewController

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
    
    self.title = @"修改密码";
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableViewManager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    [self.tableViewManager addSection:[self addTableViewItems]];
    
    WeakSelf
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemDone handler:^(id sender) {
        [weakSelf.view endEditing:YES];
        [SVProgressHUD showWithStatus:@"正在提交"];
        
        NSString *originPassword = weakSelf.originPasswordItem.value;
        NSString *freshPassword = weakSelf.freshPasswordItem.value;
        NSString *repeatPassword = weakSelf.repeatPasswordItem.value;
        
        if ( ! [originPassword length]) {
            [SVProgressHUD showErrorWithStatus:@"请输入原密码"];
            return;
        }
        if ( ! [freshPassword length]) {
            [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
            return;
        }
        if ( ! [freshPassword isEqualToString:repeatPassword]) {
            [SVProgressHUD showErrorWithStatus:@"两次新密码输入不一致"];
            return;
        }
        
        [SVProgressHUD showWithStatus:@"正在修改密码"];
        //调用修改密码接口
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:originPassword, @"oldpassword", freshPassword, @"newpassword", nil];
        [ApiKit postObjectsAtPath:APIPathUpdatePassword
                      dataMapping:nil
                       parameters:param
                           object:nil
                               ok:^(id data, NSString *msg) {
                                   [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
                                   [weakSelf.navigationController popViewControllerAnimated:YES];
                               }
                            error:^(id data, NSInteger errorCode, NSString *errorMsg) {
                                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"密码修改失败 %@", errorMsg]];
                            }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RETableViewSection *)addTableViewItems {
    RETableViewSection *section = [RETableViewSection section];
    
    //旧密码
    self.originPasswordItem = [RETextItem itemWithTitle:@"旧密码"
                                                  value:nil
                                            placeholder:@"请输入旧密码"];
    self.originPasswordItem.secureTextEntry = YES;
    self.originPasswordItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    [section addItem:self.originPasswordItem];
    
    //新密码
    self.freshPasswordItem = [RETextItem itemWithTitle:@"新密码"
                                                 value:nil
                                           placeholder:@"请输入新密码"];
    self.freshPasswordItem.secureTextEntry = YES;
    self.freshPasswordItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    [section addItem:self.freshPasswordItem];
    
    //重复密码
    self.repeatPasswordItem = [RETextItem itemWithTitle:@"重复密码"
                                                  value:nil
                                            placeholder:@"请再输入一次新密码"];
    self.repeatPasswordItem.secureTextEntry = YES;
    self.repeatPasswordItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    [section addItem:self.repeatPasswordItem];
    
    return section;
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
