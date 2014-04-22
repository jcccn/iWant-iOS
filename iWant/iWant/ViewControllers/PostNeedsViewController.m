//
//  PostNeedsViewController.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/22/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import <GCPlaceholderTextView/GCPlaceholderTextView.h>

#import "PostNeedsViewController.h"

@interface PostNeedsViewController ()

@property (nonatomic, weak) IBOutlet UITextField *titleTextField;   //需求标题
@property (nonatomic, weak) IBOutlet UITextField *dateTextField;    //需求有效期
@property (nonatomic, weak) IBOutlet GCPlaceholderTextView *contentTextView;    //需求内容

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
    
    WeakSelf
    UIBarButtonItem *item;
    item = [[UIBarButtonItem alloc] bk_initWithTitle:@"提交"
                                               style:UIBarButtonItemStylePlain
                                             handler:^(id sender) {
                                                 //TODO:调用需求发布接口
                                             }];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
