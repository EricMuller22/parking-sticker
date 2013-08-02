//
//  MapButton.m
//  parking-sticker
//
//  Created by Eric Muller on 8/1/13.
//  Copyright (c) 2013 Unexplored Novelty, LLC. All rights reserved.
//

#import "MapButton.h"
#import "UIColor+Hex.h"

#define mapButtonColor [UIColor colorFromHexString:@"#a0a0a0"]
#define shrinkSize 2

@implementation MapButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];// [UIButton buttonWithType:UIButtonTypeCustom];
    if (self)
    {
        self.frame = frame;
    }
    return self;
}

+ (MapButton *)buttonWithImage:(UIImage *)image position:(CGPoint)position
{
    MapButton *button = [[MapButton alloc] initWithFrame:CGRectMake(position.x, position.y, mapButtonSize, mapButtonSize)];
    // rounding
    button.layer.cornerRadius = mapButtonSize / 2;
    [button setImage:image forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.tintColor = mapButtonColor;
    
    // shadow
    button.layer.shadowColor = button.tintColor.CGColor;
    button.layer.shadowRadius = 3;
    button.layer.shadowOpacity = 0.8;
    button.layer.shadowOffset = CGSizeMake(0, 0);
    button.clipsToBounds = NO;

    return button;
}

- (void)shrink
{
    // self.layer.shadowRadius = 1;
    CGRect frame = self.frame;
    frame.size = CGSizeMake(self.frame.size.width - shrinkSize, self.frame.size.height - shrinkSize);
    frame.origin = CGPointMake(self.frame.origin.x + shrinkSize/2, self.frame.origin.y + shrinkSize/2);
    self.frame = frame;
}

- (void)expand
{
    // self.layer.shadowRadius = 3;
    CGRect frame = self.frame;
    frame.size = CGSizeMake(self.frame.size.width + shrinkSize, self.frame.size.height + shrinkSize);
    frame.origin = CGPointMake(self.frame.origin.x - shrinkSize/2, self.frame.origin.y - shrinkSize/2);
    self.frame = frame;
}

@end
