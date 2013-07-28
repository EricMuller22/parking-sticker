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

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadMapView];
}

- (void)loadMapView
{
    // to do - core location to position camera
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.805766
                                                            longitude:-122.450793
                                                                 zoom:16];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.tiltGestures = NO;
    self.mapView.settings.rotateGestures = NO;
    self.view = self.mapView;
    
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
    marker.title = @"Your Car :)";
    marker.icon = nil; // to do - cool icon
    marker.map = self.mapView;
}

@end
