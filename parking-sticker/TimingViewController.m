//
//  TimingAlertViewController.m
//  parking-sticker
//
//  Created by Eric Muller on 7/29/13.
//  Copyright (c) 2013 Unexplored Novelty, LLC. All rights reserved.
//

#import "TimingViewController.h"
#import "NSDate+Escort.h"

#define kCleaningWeeks @[@"1st and 3rd", @"2nd and 4th"]
#define kCleaningDays @[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday"]

#define kCleaningWeeksKey @"street-cleaning-weeks"
#define kCleaningDaysKey @"street-cleaning-days"

@interface TimingViewController ()

@property (nonatomic) UIPickerView *picker;
@property (nonatomic) UISwitch *activator;

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
    
    // Street cleaning picker
    self.picker = [[UIPickerView alloc] init];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    [self.view addSubview:self.picker];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSInteger weeks = [[NSUserDefaults standardUserDefaults] integerForKey:kCleaningWeeksKey];
    NSInteger days = [[NSUserDefaults standardUserDefaults] integerForKey:kCleaningDaysKey];
    [self.picker selectRow:weeks inComponent:0 animated:NO];
    [self.picker selectRow:days inComponent:0 animated:NO];
}

# pragma mark - UIPickerViewDataSource

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (component == 0) ? 2 : 7;
}

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

# pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return (component == 0) ? kCleaningWeeks[row] : kCleaningDays[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [[NSUserDefaults standardUserDefaults] setInteger:row forKey: (component == 0) ? kCleaningWeeksKey : kCleaningDaysKey];
}

@end
