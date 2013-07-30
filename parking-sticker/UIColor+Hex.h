//
//  UIColor+RGB.h
//  parking-sticker
//
//  Created by Eric Muller on 7/29/13.
//  Copyright (c) 2013 Unexplored Novelty, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
