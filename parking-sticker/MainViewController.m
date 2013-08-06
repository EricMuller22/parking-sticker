//
//  MainViewController.m
//  parking-sticker
//
//  Created by Eric Muller on 7/27/13.
//  Copyright (c) 2013 Unexplored Novelty, LLC. All rights reserved.
//

#import "MainViewController.h"
#import "MapButton.h"
#import "MapMarker.h"
#import "TimingViewController.h"
#import "UIColor+Hex.h"
#import "UIImage+StackBlur.h"

#define kCarLatitude @"car-latitude"
#define kCarLongitude @"car-longitude"
#define kCarTint @"D35400"
#define kLocationTint @"#2980B9"

@interface MainViewController ()

@property (nonatomic) GMSMapView *mapView;
@property (nonatomic) CLLocationManager *locationTracker;
@property (nonatomic) MapMarker *locationMarker;
@property (nonatomic) MapMarker *carMarker;
@property (nonatomic) TimingViewController *timingVC;
@property (nonatomic) UIImageView *blurImageView;

@end

@implementation MainViewController
{
    MapButton *carButton;
    MapButton *locationButton;
    MapButton *timingButton;
    MapButton *closeButton;
    UIStatusBarStyle statusBarStyle;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map"
                                                        image:[UIImage imageNamed:@"Map"]
                                                          tag:0];
        statusBarStyle = UIStatusBarStyleDefault;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadMapView];
    [self loadButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([CLLocationManager locationServicesEnabled] == YES)
    {
        [self.locationTracker startUpdatingLocation];
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized && self.locationTracker.location)
    {
        [self.mapView animateToLocation:self.locationTracker.location.coordinate];
        
        self.locationMarker.position = self.locationTracker.location.coordinate;
    }
    
    double latitude = [[NSUserDefaults standardUserDefaults] doubleForKey:kCarLatitude];
    double longitude = [[NSUserDefaults standardUserDefaults] doubleForKey:kCarLongitude];
    if (latitude && longitude) // (0, 0) will not play nice here, luckily that's in the Gulf of Guinea
    {
        [self placeCarMarker:CLLocationCoordinate2DMake(latitude, longitude)];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([CLLocationManager locationServicesEnabled] == YES)
    {
        [self.locationTracker stopUpdatingLocation];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return statusBarStyle;
}

# pragma mark - Map

- (void)loadMapView
{
    self.locationTracker = [[CLLocationManager alloc] init];
    self.locationTracker.delegate = self;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.805766
                                                            longitude:-122.450793
                                                                 zoom:16];
    CGRect mapViewFrame = self.view.frame;
    if (self.tabBarController)
    {
        mapViewFrame.size.height -= self.tabBarController.tabBar.frame.size.height; // adjust for tab bar - TODO: handle this with auto-layout
    }
    self.mapView = [GMSMapView mapWithFrame:mapViewFrame camera:camera];

    // self.mapView.myLocationEnabled = YES; // TODO: figure out why "my location" image transparency is broken
    // self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.tiltGestures = NO;
    self.mapView.settings.rotateGestures = NO;
    
    [self.view addSubview:self.mapView];
    
    self.mapView.delegate = self;
}

# pragma mark - Buttons

- (void)loadButtons
{
    CGRect buttonFrame = self.view.frame;
    
    carButton = [MapButton buttonWithImage:[UIImage imageNamed:@"Car"]
                                  position:CGPointMake(buttonFrame.size.width - mapButtonSize - 10,
                                                       buttonFrame.size.height - mapButtonSize - 10)];
    [carButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:carButton];
    
    locationButton = [MapButton buttonWithImage:[UIImage imageNamed:@"Location"]
                                       position:CGPointMake(buttonFrame.size.width - mapButtonSize * 2 - 20,
                                                            buttonFrame.size.height - mapButtonSize - 10)];
    [locationButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationButton];
    
    timingButton = [MapButton buttonWithImage:[UIImage imageNamed:@"Timing"]
                                     position:CGPointMake(buttonFrame.size.width - mapButtonSize * 3 - 30,
                                                          buttonFrame.size.height - mapButtonSize - 10)];
    [timingButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timingButton];
}

- (void)buttonTap:(MapButton *)button
{
    if (button == locationButton && [self.locationMarker hasPosition])
    {
        [self.mapView animateToLocation:self.locationMarker.position];
    }
    else if (button == carButton && [self.carMarker hasPosition])
    {
        [self.mapView animateToLocation:self.carMarker.position];
    }
    else if (button == timingButton)
    {
        [self presentTimingView];
    }
}

# pragma mark - Timing View Modal

- (TimingViewController *)timingVC
{
    if (!_timingVC)
    {
        _timingVC = [[TimingViewController alloc] init];
    }
    return _timingVC;
}

- (void)presentTimingView
{
    // replacement image (for blurred background)
    self.blurImageView = [[UIImageView alloc] initWithImage:[self screenshot]];
    self.blurImageView.frame = self.mapView.frame;
    [self.view addSubview:self.blurImageView];
    
    // timing view controller
    [self addChildViewController:self.timingVC];
    self.timingVC.view.frame = timingButton.frame;
    [self.timingVC willMoveToParentViewController:self];
    [self.view addSubview:self.timingVC.view];
    [self.timingVC didMoveToParentViewController:self];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2
                     animations:^{
                         // add close button and expand timing view
                         weakSelf.timingVC.view.frame = weakSelf.view.frame;
                         closeButton = [MapButton buttonWithImage:[UIImage imageNamed:@"Close"] position:timingButton.frame.origin];
                         [closeButton addTarget:weakSelf action:@selector(dismissTimingView) forControlEvents:UIControlEventTouchUpInside];
                         [weakSelf.view addSubview:closeButton];
                         // blur the background view
                         weakSelf.blurImageView.image = [weakSelf.blurImageView.image stackBlur:9.0];
                         // change status bar
                         statusBarStyle = UIStatusBarStyleLightContent;
                         [weakSelf setNeedsStatusBarAppearanceUpdate];
                     }];
}

- (void)dismissTimingView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2
                     animations:^{
                         // remove blur and shrink timing view
                         weakSelf.timingVC.view.frame = timingButton.frame;
                         [weakSelf.blurImageView removeFromSuperview];
                         // change status bar
                         statusBarStyle = UIStatusBarStyleDefault;
                         [weakSelf setNeedsStatusBarAppearanceUpdate];
                     }
                     completion:^(BOOL finished) {
                         // remove the close button and the timing view
                         [closeButton removeFromSuperview];
                         [weakSelf.timingVC.view removeFromSuperview];
                         [weakSelf.timingVC removeFromParentViewController];
                     }];
}

# pragma mark - Screenshot

- (UIImage *)screenshot
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

# pragma mark - Map Markers

- (GMSMarker *)carMarker
{
    if (!_carMarker)
    {
        // https://developers.google.com/maps/documentation/ios/reference/interface_g_m_s_marker
        _carMarker = [MapMarker markerWithImage:[UIImage imageNamed:@"Car"] title:@"Your Car"];
        _carMarker.map = self.mapView;
        _carMarker.animated = YES;
    }
    return _carMarker;
}

- (GMSMarker *)locationMarker
{
    if (!_locationMarker)
    {
        _locationMarker = [MapMarker markerWithImage:[UIImage imageNamed:@"Location"] title:@"You"];
        _locationMarker.map = self.mapView;
    }
    return _locationMarker;
}

- (void)placeCarMarker:(CLLocationCoordinate2D)location
{
    self.carMarker.map = nil;
    self.carMarker.position = location;
    self.carMarker.map = self.mapView; // encourage the animation
}

# pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [[NSUserDefaults standardUserDefaults] setDouble:coordinate.latitude forKey:kCarLatitude];
    [[NSUserDefaults standardUserDefaults] setDouble:coordinate.longitude forKey:kCarLongitude];
    [self placeCarMarker:coordinate];
}

# pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorized && manager.location)
    {
        [self.mapView animateToLocation:manager.location.coordinate];
        
        self.locationMarker.position = manager.location.coordinate;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.locationMarker.position = ((CLLocation *)[locations lastObject]).coordinate;
}

@end
