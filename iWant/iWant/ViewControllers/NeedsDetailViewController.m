//
//  NeedsDetailViewController.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/22/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import "NeedsDetailViewController.h"

@interface NeedsDetailViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nicknameLabel;
@property (nonatomic, weak) IBOutlet UILabel *ageLabel;
@property (nonatomic, weak) IBOutlet UITextView *contentTextView;
@property (nonatomic, weak) IBOutlet UIButton *contactButton;

@end

@implementation NeedsDetailViewController

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
    
    NSString *title = self.needs.title;
    self.navigationItem.title = ([title length] ? title : @"需求详情");
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:@"http://mimi.wumii.cn/images/download/app_logo_v2.jpg"]];
    
    self.contentTextView.userInteractionEnabled = NO;
    self.contentTextView.text = self.needs.content;
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
