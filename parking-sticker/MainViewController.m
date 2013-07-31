//
//  MainViewController.m
//  parking-sticker
//
//  Created by Eric Muller on 7/27/13.
//  Copyright (c) 2013 Unexplored Novelty, LLC. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic) GMSMapView *mapView;
@property (nonatomic) CLLocationManager *locationTracker;
@property (nonatomic) GMSMarker *locationMarker;
@property (nonatomic) GMSMarker *carMarker;

@end

@implementation MainViewController

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
}

- (void)loadMapView
{
    self.locationTracker = [[CLLocationManager alloc] init]; // to do - ask for permission instead of letting Google do it
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

    self.mapView.myLocationEnabled = YES; // to do - figure out why "my location" image transparency is broken
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.tiltGestures = NO;
    self.mapView.settings.rotateGestures = NO;
    
    [self.view addSubview:self.mapView];
    
    self.mapView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
        && [CLLocationManager locationServicesEnabled] == YES
        && self.locationTracker.location)
    {
        [self.mapView animateToLocation:self.locationTracker.location.coordinate];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(self.locationTracker.location.coordinate.latitude,
                                                     self.locationTracker.location.coordinate.longitude);
        marker.title = @"Your Location";
        marker.icon = [GMSMarker markerImageWithColor:self.view.tintColor]; // to do - proper coloring
        marker.map = self.mapView;
    }
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    // removes any other overlays that were added
    if (!self.carMarker)
    {
        // https://developers.google.com/maps/documentation/ios/reference/interface_g_m_s_marker
        self.carMarker = [[GMSMarker alloc] init];
        self.carMarker.title = @"Your Car";
        self.carMarker.icon = [GMSMarker markerImageWithColor:self.view.tintColor];
        self.carMarker.map = self.mapView;
    }
    
    self.carMarker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
}

@end
