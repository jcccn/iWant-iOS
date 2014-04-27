//
//  ProfileViewController.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/22/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import "ProfileViewController.h"

#import <RETableViewManager/RETableViewManager.h>
#import <RETableViewManager/RETableViewOptionsController.h>

#import "ProfileViewController.h"
#import "UpdateProfileViewController.h"
#import "MOUserInfo.h"
#import "Login.h"

@interface ProfileViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RETableViewManager *tableViewManager;
@property (nonatomic, strong) RETableViewItem *nicknameItem;    //用户名
@property (nonatomic, strong) RETableViewItem *ageItem;         //年龄
@property (nonatomic, strong) RETableViewItem *genderItem;      //性别

@property (nonatomic, strong) MOUserInfo *userInfo;

- (RETableViewSection *)addTableViewItems;

/**
 *  获取用户资料
 */
- (void)fetchUserInfo;
- (void)reloadWithUserInfo:(MOUserInfo *)userInfo;


@end

@implementation ProfileViewController

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
    
    //如果未传入用户id参数，就默认为是查看自己的资料
    if ( ! self.userId) {
        self.userId = [Login sharedInstance].userId;
    }
        
    self.title = @"个人资料";
    
    WeakSelf
    
    //如果是自己的资料页，增加修改按钮
    if ([self.userId isEqualToString:[Login sharedInstance].userId]) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] bk_initWithTitle:@"修改" style:UIBarButtonItemStylePlain handler:^(id sender) {
            UpdateProfileViewController *updateProfileViewController = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"UpdateProfileViewController"];
            updateProfileViewController.nickname = weakSelf.userInfo.name;
            updateProfileViewController.birthday = weakSelf.userInfo.birthday;
            UINavigationController *navigationController = weakSelf.navigationController;
            [navigationController popViewControllerAnimated:NO];
            [navigationController pushViewController:updateProfileViewController animated:NO];
        }];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableViewManager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    [self.tableViewManager addSection:[self addTableViewItems]];
    
    [self fetchUserInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RETableViewSection *)addTableViewItems {
    RETableViewSection *section = [RETableViewSection section];
    
    //昵称
    self.nicknameItem = [RETableViewItem itemWithTitle:@"昵称："
                                         accessoryType:UITableViewCellAccessoryNone
                                      selectionHandler:^(RETableViewItem *item) {
                                          [item deselectRowAnimated:NO];
                                      }];
    self.nicknameItem.style = UITableViewCellStyleValue1;
    self.nicknameItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:self.nicknameItem];
    
    //年龄
    self.ageItem = [RETableViewItem itemWithTitle:@"年龄："
                        accessoryType:UITableViewCellAccessoryNone
                                 selectionHandler:^(RETableViewItem *item) {
                                     [item deselectRowAnimated:NO];
                                 }];
    self.ageItem.style = UITableViewCellStyleValue1;
    self.ageItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:self.ageItem];
    
    //性别
    self.genderItem = [RETableViewItem itemWithTitle:@"性别："
                                       accessoryType:UITableViewCellAccessoryNone
                                    selectionHandler:^(RETableViewItem *item) {
                                        [item deselectRowAnimated:NO];
                                    }];
    self.genderItem.style = UITableViewCellStyleValue1;
    self.genderItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:self.genderItem];
    
    return section;
}

- (void)fetchUserInfo {
    WeakSelf
    [SVProgressHUD showWithStatus:@"正在获取资料"];
    NSString *userId = self.userId;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"id", nil];
    [ApiKit getObjectsAtPath:APIPathGetUserInfo
                 dataMapping:[MOUserInfo commonMapping]
                  parameters:param
                          ok:^(id data, NSString *msg) {
                              [weakSelf performSelectorOnMainThread:@selector(reloadWithUserInfo:)
                                                         withObject:data
                                                      waitUntilDone:YES];
                              [SVProgressHUD dismiss];
                          }
                       error:^(id data, NSInteger errorCode, NSString *errorMsg) {
                           [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"资料获取失败 %@", errorMsg]];
                       }];
}

- (void)reloadWithUserInfo:(MOUserInfo *)userInfo {
    if ( ! [userInfo isKindOfClass:[MOUserInfo class]]) {
        return;
    }
    
    self.userInfo = userInfo;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY";
    NSInteger age = [[dateFormatter stringFromDate:[NSDate date]] integerValue] - [[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:userInfo.birthday]] integerValue];
    self.nicknameItem.detailLabelText = userInfo.name;
    self.ageItem.detailLabelText = [NSString stringWithFormat:@"%d岁", age];
    self.genderItem.detailLabelText = (userInfo.gender == 0 ? @"男" : @"女");
    
    [self.tableView reloadData];
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
