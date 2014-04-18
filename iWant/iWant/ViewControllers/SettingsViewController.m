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

@interface SettingsViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RETableViewManager *tableViewManager;

- (RETableViewSection *)addTableViewItems;

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
    
    //登录
    RETableViewItem *tableViewItem;
    tableViewItem = [RETableViewItem itemWithTitle:@"登录"
                                     accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                  selectionHandler:^(RETableViewItem *item) {
                                      [item deselectRowAnimated:YES];
                                      LoginViewController *viewController = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                                      [weakSelf.navigationController pushViewController:viewController animated:YES];
                                  }];
    [section addItem:tableViewItem];
    
    //注册
    tableViewItem = [RETableViewItem itemWithTitle:@"注册"
                                     accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                  selectionHandler:^(RETableViewItem *item) {
                                      [item deselectRowAnimated:YES];
                                      RegisterViewController *viewController = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
                                      [weakSelf.navigationController pushViewController:viewController animated:YES];
                                  }];
    [section addItem:tableViewItem];
    
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
