//
//  MapMarker.h
//  parking-sticker
//
//  Created by Eric Muller on 8/1/13.
//  Copyright (c) 2013 Unexplored Novelty, LLC. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@interface MapMarker : GMSMarker

@property (nonatomic) BOOL hasPosition;

+ (id)markerWithImage:(UIImage *)image title:(NSString *)title;

@end
