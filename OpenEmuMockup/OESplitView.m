//
//  OESlideView.m
//  OpenEmuMockup
//
//  Created by vade on 9/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OESplitView.h"


@implementation OESplitView

- (CGFloat)dividerThickness
{
    return 1;
}

- (void)drawDividerInRect:(NSRect)aRect
{
    [[NSColor colorWithCalibratedWhite:0.15 alpha:1] set];
    [[NSBezierPath bezierPathWithRect:aRect] fill];
}

- (NSColor *)dividerColor
{
    return [NSColor colorWithCalibratedWhite:0.15 alpha:1];
}

@end
