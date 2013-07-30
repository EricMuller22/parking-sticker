//
//  TimingAlertViewController.m
//  parking-sticker
//
//  Created by Eric Muller on 7/29/13.
//  Copyright (c) 2013 Unexplored Novelty, LLC. All rights reserved.
//

#import "TimingViewController.h"

@interface TimingViewController ()

@end

@implementation TimingViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Timing"
                                                        image:[UIImage imageNamed:@"Timing"]
                                                          tag:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
