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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:12];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = self.mapView;
    
    self.mapView.delegate = self;
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}

@end
