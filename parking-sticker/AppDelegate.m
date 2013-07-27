//
//  AppDelegate.m
//  parking-sticker
//
//  Created by Eric Muller on 7/26/13.
//  Copyright (c) 2013 Unexplored Novelty, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <GoogleMaps/GoogleMaps.h>

#define kGMSKey @"your-google-maps-api-key-here"

@interface AppDelegate ()

@property (nonatomic) MainViewController *mainVC;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Google Maps - to obtain an API key: https://code.google.com/apis/console/
    [GMSServices provideAPIKey:kGMSKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.mainVC = [[MainViewController alloc] init];
    [self.window setRootViewController:self.mainVC];
    [self.window addSubview:self.mainVC.view];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
