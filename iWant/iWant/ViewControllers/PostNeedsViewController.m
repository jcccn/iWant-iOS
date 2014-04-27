//
//  PostNeedsViewController.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/22/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import <GCPlaceholderTextView/GCPlaceholderTextView.h>

#import "PostNeedsViewController.h"
#import "LBSManager.h"

@interface PostNeedsViewController ()

@property (nonatomic, weak) IBOutlet UITextField *titleTextField;                   //需求标题
@property (nonatomic, weak) IBOutlet UISegmentedControl *indateSegmentedControl;    //需求有效期
@property (nonatomic, weak) IBOutlet GCPlaceholderTextView *contentTextView;        //需求内容

- (void)postTheNeeds;

@end

@implementation PostNeedsViewController

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
    
    self.navigationItem.title = @"新需求";
    
    self.titleTextField.layer.borderColor = [UIColor colorWithWhite:0.95f alpha:1.0f].CGColor;
    self.titleTextField.layer.borderWidth = 1.0f;
    self.titleTextField.layer.cornerRadius = 2.0f;
    self.contentTextView.layer.borderColor = [UIColor colorWithWhite:0.95f alpha:1.0f].CGColor;
    self.contentTextView.layer.borderWidth = 1.0f;
    self.contentTextView.layer.cornerRadius = 2.0f;
    self.contentTextView.placeholder = @"请输入需求的具体内容";
    self.indateSegmentedControl.selectedSegmentIndex = 1;
    
    WeakSelf
    UIBarButtonItem *item;
    item = [[UIBarButtonItem alloc] bk_initWithTitle:@"提交"
                                               style:UIBarButtonItemStylePlain
                                             handler:^(id sender) {
                                                 [weakSelf postTheNeeds];
                                             }];
    self.navigationItem.rightBarButtonItem = item;
    
    [[LBSManager sharedInstance] updateLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postTheNeeds {
    WeakSelf
    
    NSString *title = self.titleTextField.text;
    NSString *content = self.contentTextView.text;
    
    if ( ! [title length]) {
        [SVProgressHUD showErrorWithStatus:@"请输入需求的标题"];
        return;
    }
    if ( ! [content length]) {
        [SVProgressHUD showErrorWithStatus:@"请输入需求的详细内容"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在发布您的需求"];
    
    NSInteger indate;
    NSInteger selectedIndex = self.indateSegmentedControl.selectedSegmentIndex;
    if (selectedIndex == 0) {
        indate = 30 * 3600;         //30分钟
    }
    else if (selectedIndex == 1) {
        indate = 2 * 60 * 3600;     //2小时
    }
    else if (selectedIndex == 2) {
        indate = 12 * 60 * 3600;    //12小时
    }
    else {
        indate = 3 * 24 * 60 * 3600;//3天
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", content, @"content", @(indate), @"todate", @([LBSManager sharedInstance].latitude), @"latitude", @([LBSManager sharedInstance].longitude), @"longtitude", nil];
    
    [ApiKit getObjectsAtPath:APIPathPostNeeds
                  dataMapping:nil
                   parameters:param
                           ok:^(id data, NSString *msg) {
                               [SVProgressHUD showSuccessWithStatus:@"需求发布成功"];
                               [weakSelf.navigationController popViewControllerAnimated:YES];
                           }
                        error:^(id data, NSInteger errorCode, NSString *errorMsg) {
                            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"需求发表失败\n%@", errorMsg]];
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
