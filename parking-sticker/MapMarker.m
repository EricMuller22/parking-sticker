//
//  MapMarker.m
//  parking-sticker
//
//  Created by Eric Muller on 8/1/13.
//  Copyright (c) 2013 Unexplored Novelty, LLC. All rights reserved.
//

#import "MapMarker.h"

@implementation MapMarker

+ (id)markerWithImage:(UIImage *)image title:(NSString *)title
{
    return [[MapMarker alloc] initWithImage:image title:title];
}

- (id)initWithImage:(UIImage *)image title:(NSString *)title
{
    self = [super init];
    if (self)
    {
        self.icon = image;
        self.title = title;
        self.hasPosition = NO;
    }
    return self;
}

- (void)setPosition:(CLLocationCoordinate2D)position
{
    self.hasPosition = YES;
    [super setPosition:position];
}

@end
