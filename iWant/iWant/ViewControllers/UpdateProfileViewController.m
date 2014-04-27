//
//  UpdateProfileViewController.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/22/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import <RETableViewManager/RETableViewManager.h>
#import <RETableViewManager/RETableViewOptionsController.h>

#import "UpdateProfileViewController.h"
#import "MOUserInfo.h"
#import "Login.h"

@interface UpdateProfileViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RETableViewManager *tableViewManager;
@property (nonatomic, strong) RETextItem *nicknameItem;         //用户名
@property (nonatomic, strong) REDateTimeItem *birthdayItem;     //生日
@property (nonatomic, strong) RERadioItem *genderItem;          //性别

@property (nonatomic, strong) NSArray *genders;

- (RETableViewSection *)addTableViewItems;


@end

@implementation UpdateProfileViewController

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
    
    self.genders = @[@"男", @"女"];
    
    self.title = @"修改个人资料";
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableViewManager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    [self.tableViewManager addSection:[self addTableViewItems]];
    
    WeakSelf
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemDone handler:^(id sender) {
        [weakSelf.view endEditing:YES];
        [SVProgressHUD showWithStatus:@"正在提交"];
        
        NSString *nickname = weakSelf.nicknameItem.value;
        NSDate *birthday = weakSelf.birthdayItem.value;
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:3];
        param[@"nickname"] = (nickname ? nickname :@"");
        param[@"birthday"] = @((NSInteger)[birthday timeIntervalSince1970]);
        if (weakSelf.genderItem) {
            NSInteger gender = [weakSelf.genders indexOfObject:weakSelf.genderItem.value];
            if (NSNotFound == gender) {     //默认选择女性
                gender = 1;
            }
            param[@"gender"] = @(gender);
        }
        
        //调用资料保存接口
        [ApiKit getObjectsAtPath:APIPathUpdateUserInfo
                     dataMapping:nil
                      parameters:param
                              ok:^(id data, NSString *msg) {
                                  [SVProgressHUD showSuccessWithStatus:@"资料保存成功"];
                                  //判断是否首次激活账号，如果是，需要保存已激活的标志，并跳转相应的页面
                                  [Login sharedInstance].isActivated = YES;
                                  if (weakSelf.forActivating) {
                                      [UIApplication sharedApplication].keyWindow.rootViewController = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                                  }
                                  else {
                                      [weakSelf.navigationController popViewControllerAnimated:YES];
                                  }
                              }
                           error:^(id data, NSInteger errorCode, NSString *errorMsg) {
                               [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"资料保存失败 %@", errorMsg]];
                           }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RETableViewSection *)addTableViewItems {
    WeakSelf
    
    RETableViewSection *section = [RETableViewSection section];
    
    //昵称
    self.nicknameItem = [RETextItem itemWithTitle:@"昵称"
                                            value:self.nickname
                                      placeholder:@"请输入希望显示的名字"];
    [section addItem:self.nicknameItem];
    
    //生日
    NSDate *birthday = (self.birthday ? [NSDate dateWithTimeIntervalSince1970:self.birthday] : [NSDate dateWithTimeIntervalSinceNow:-1 * 3600 * 24 * 365 * 20]);
    self.birthdayItem = [REDateTimeItem itemWithTitle:@"生日"
                                                value:birthday
                                          placeholder:@"请输入您的生日"
                                               format:@"yyyy-MM-dd"
                                       datePickerMode:UIDatePickerModeDate];
    self.birthdayItem.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-1.0f * 3600 * 24 * 365 * 120];   //最大120岁
    self.birthdayItem.maximumDate = [NSDate dateWithTimeIntervalSinceNow:-1.0f * 3600 * 24 * 365 * 1];         //最小1岁
    [section addItem:self.birthdayItem];
    
    if (self.forActivating) {
        //性别
        self.genderItem = [RERadioItem itemWithTitle:@"性别" value:@"一旦确定不能修改" selectionHandler:^(RERadioItem *item) {
            [item deselectRowAnimated:YES];
            
            RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:weakSelf.genders multipleChoice:NO completionHandler:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
                [item reloadRowWithAnimation:UITableViewRowAnimationNone];
            }];
            
            [weakSelf.navigationController pushViewController:optionsController animated:YES];
        }];
        [section addItem:self.genderItem];
    }
    
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
