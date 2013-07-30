//
//  AppDelegate.m
//  parking-sticker
//
//  Created by Eric Muller on 7/26/13.
//  Copyright (c) 2013 Unexplored Novelty, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "TimingViewController.h"
#import "UIColor+Hex.h"
#import <GoogleMaps/GoogleMaps.h>

#define kGMSKey @"your-google-maps-api-key-here"

@interface AppDelegate ()

@property (nonatomic) UITabBarController *tabBarController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Google Maps - to obtain an API key: https://code.google.com/apis/console/
    [GMSServices provideAPIKey:kGMSKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    TimingViewController *timingVC = [[TimingViewController alloc] init];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[mainVC, timingVC];
    self.window.tintColor = [UIColor colorFromHexString:@"#27AE60"];
    [self.window setRootViewController:self.tabBarController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
