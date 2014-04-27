//
//  AppDelegate.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/16/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import <Appirater/Appirater.h>

#import "AppDelegate.h"
#import "MobClick.h"
#import "LBSManager.h"
#import "Login.h"
#import "UpdateProfileViewController.h"

@interface AppDelegate () <LoginObserver>

@property (nonatomic, strong) UIStoryboard *mainStoryboard;

- (void)configUmeng;
- (void)configAppRating;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self configUmeng];
    [self configAppRating];
    
    self.mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *rootViewController;
    
    [Login sharedInstance].rootLoginObserver = self;
    if ([Login sharedInstance].isLogged) {
        rootViewController = [self.mainStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    }
    else {
        UIViewController *loginViewController = [self.mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        rootViewController = navigationController;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[LBSManager sharedInstance] stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[LBSManager sharedInstance] start];
    [[LBSManager sharedInstance] resume];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private Metholds

- (void)configUmeng {
#if ( ! DEBUG)
    [MobClick startWithAppkey:UmengAppKey];
#endif
    [MobClick setAppVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    [MobClick checkUpdate];
    
    [MobClick updateOnlineConfig];
}

- (void)configAppRating {
    [Appirater setAppId:AppId];
    [Appirater setDaysUntilPrompt:7];       //使用N天后跳出提示
    [Appirater setUsesUntilPrompt:21];      //使用N次后跳出提示
    [Appirater setTimeBeforeReminding:2];   //点击稍候提醒，设置N天后再提示
    [Appirater setOpenInAppStore:YES];
    [Appirater setDebug:NO];
    
    [Appirater appLaunched:YES];
}

#pragma mark - Login Observer

- (void)loginSucceeded {
    //判断是否首次登录需要补充资料
    if ([Login sharedInstance].isActivated) {
        self.window.rootViewController = [self.mainStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    }
    else {
        UpdateProfileViewController *updateProfileViewController = [self.mainStoryboard instantiateViewControllerWithIdentifier:@"UpdateProfileViewController"];
        updateProfileViewController.forActivating = YES;
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        if ([navigationController isKindOfClass:[UINavigationController class]]) {
            [navigationController pushViewController:updateProfileViewController animated:YES];
        }
    }
}

- (void)loginFailedWithErrorCode:(NSInteger)errCode errorMessage:(NSString *)errMsg {
    
}

- (void)loggedOut {
    UIViewController *loginViewController = [self.mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    self.window.rootViewController = navigationController;
}

@end
