//
//  MapButton.h
//  parking-sticker
//
//  Created by Eric Muller on 8/1/13.
//  Copyright (c) 2013 Unexplored Novelty, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define mapButtonSize 60

@interface MapButton : UIButton

+ (MapButton *)buttonWithImage:(UIImage *)image position:(CGPoint)position;

- (void)shrink;
- (void)expand;

@end
