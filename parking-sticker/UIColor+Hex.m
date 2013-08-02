//
//  UIColor+RGB.m
//  parking-sticker
//
//  Created by Eric Muller on 7/29/13.
//  Copyright (c) 2013 Unexplored Novelty, LLC. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

// http://www.imthi.com/blog/programming/iphone-sdk-convert-hex-color-string-to-uicolor.php
+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(float)alpha
{
    NSString *colorString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([colorString length] < 6)
    {
        return [UIColor blackColor];
    }
    if ([colorString hasPrefix:@"0X"])
    {
        colorString = [colorString substringFromIndex:2];
    }
    if ([colorString hasPrefix:@"#"])
    {
        colorString = [colorString substringFromIndex:1];
    }
    if ([colorString length] != 6)
    {
        return [UIColor blackColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *redString = [colorString substringWithRange:range];
    range.location = 2;
    NSString *greenString = [colorString substringWithRange:range];
    range.location = 4;
    NSString *blueString = [colorString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:redString] scanHexInt:&r];
    [[NSScanner scannerWithString:greenString] scanHexInt:&g];
    [[NSScanner scannerWithString:blueString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ colorFromHexString:(NSString *)hexString
{
    return [UIColor colorFromHexString:hexString alpha:1.0f];
}

@end
