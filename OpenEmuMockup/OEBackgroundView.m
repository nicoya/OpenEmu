//
//  OEBackgroundView.m
//  OpenEmuMockup
//
//  Created by vade on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OEBackgroundView.h"


@implementation OEBackgroundView
- (void)drawRect:(NSRect)dirtyRect
{    
    if([self isInFullScreenMode])
    {
        [[NSColor colorWithCalibratedWhite:0.1 alpha:1.0] set];
        [[NSBezierPath bezierPathWithRect:dirtyRect] fill];
    }
}

- (void)exitFullScreenModeWithOptions:(NSDictionary *)options
{
    [super exitFullScreenModeWithOptions:options];
    [self setNeedsDisplay:YES];
}

@end
