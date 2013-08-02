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
#import "UIColor+Hex.h"

#define kCarLatitude @"car-latitude"
#define kCarLongitude @"car-longitude"
#define kCarTint @"D35400"
#define kLocationTint @"#2980B9"

@interface MainViewController ()

@property (nonatomic) GMSMapView *mapView;
@property (nonatomic) CLLocationManager *locationTracker;
@property (nonatomic) MapMarker *locationMarker;
@property (nonatomic) MapMarker *carMarker;

@end

@implementation MainViewController
{
    MapButton *carButton;
    MapButton *locationButton;
    MapButton *timingButton;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map"
                                                        image:[UIImage imageNamed:@"Map"]
                                                          tag:0];
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
        mapViewFrame.size.height -= self.tabBarController.tabBar.frame.size.height; // adjust for tab bar - to do - handle this with auto-layout
    }
    self.mapView = [GMSMapView mapWithFrame:mapViewFrame camera:camera];

    // self.mapView.myLocationEnabled = YES; // to do - figure out why "my location" image transparency is broken
    // self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.tiltGestures = NO;
    self.mapView.settings.rotateGestures = NO;
    
    [self.view addSubview:self.mapView];
    
    self.mapView.delegate = self;
}

# pragma mark - Buttons

- (void)loadButtons
{
<<<<<<< Updated upstream
    CGRect buttonFrame = self.view.frame;
=======
    UIView *buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - mapButtonSize * 3 - 40,
                                                                       self.view.frame.size.height - mapButtonSize - 20,
                                                                       mapButtonSize * 3 + 40,
                                                                       mapButtonSize + 20)];
    buttonContainer.backgroundColor = [UIColor colorFromHexString:@"#404040" alpha:0.8];
>>>>>>> Stashed changes
    
    carButton = [MapButton buttonWithImage:[UIImage imageNamed:@"Car"]
                                  position:CGPointMake(buttonFrame.size.width - mapButtonSize - 10,
                                                       buttonFrame.size.height - mapButtonSize - 10)];
    [carButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [carButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainer addSubview:carButton];
    
    locationButton = [MapButton buttonWithImage:[UIImage imageNamed:@"Location"]
                                       position:CGPointMake(buttonFrame.size.width - mapButtonSize * 2 - 20,
                                                            buttonFrame.size.height - mapButtonSize - 10)];
    [locationButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [locationButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainer addSubview:locationButton];
    
    timingButton = [MapButton buttonWithImage:[UIImage imageNamed:@"Timing"]
                                     position:CGPointMake(buttonFrame.size.width - mapButtonSize * 3 - 30,
                                                          buttonFrame.size.height - mapButtonSize - 10)];
    [timingButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [timingButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainer addSubview:timingButton];
    
    [self.view addSubview:buttonContainer];
}

- (void)buttonPress:(MapButton *)button
{
    [(MapButton *)button shrink];
}

- (void)buttonTap:(MapButton *)button
{
    [(MapButton *)button expand];
    // [(MapButton *)button highlight:self.view.tintColor];
    
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
        NSLog(@"Display timing");
    }
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
