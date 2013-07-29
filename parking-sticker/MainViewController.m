//
//  MainViewController.m
//  parking-sticker
//
//  Created by Eric Muller on 7/27/13.
//  Copyright (c) 2013 Unexplored Novelty, LLC. All rights reserved.
//

#import "MainViewController.h"
#import "NSString+Emojize.h"

@interface MainViewController ()

@property (nonatomic) GMSMapView *mapView;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadMapView];
}

- (void)loadMapView
{
    CLLocationManager *locationTracker = [[CLLocationManager alloc] init];
    locationTracker.delegate = self;
    GMSCameraPosition *camera;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized && [CLLocationManager locationServicesEnabled] == YES)
    {
        camera = [GMSCameraPosition cameraWithLatitude:locationTracker.location.coordinate.latitude
                                             longitude:locationTracker.location.coordinate.longitude
                                                  zoom:16];
    }
    else
    {
        // to do - better communicate why location services should be enabled
        camera = [GMSCameraPosition cameraWithLatitude:37.805766
                                             longitude:-122.450793
                                                  zoom:16];
    }
    self.mapView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.tiltGestures = NO;
    self.mapView.settings.rotateGestures = NO;
    
    [self.view addSubview:self.mapView];
    
    self.mapView.delegate = self;
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    // removes any other overlays that were added
    [self.mapView clear];
    
    // https://developers.google.com/maps/documentation/ios/reference/interface_g_m_s_marker
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    marker.title = [@"Your Car :blue_car:" emojizedString];
    marker.icon = nil; // to do - cool icon
    marker.map = self.mapView;
}

@end
