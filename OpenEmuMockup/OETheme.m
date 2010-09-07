//
//  OETheme.m
//  OpenEmuMockup
//
//  Created by vade on 9/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OETheme.h"


@implementation OETheme

#pragma mark -
#pragma mark Token Theme
-(NSColor *)tokenBorder                         //Color used to draw token border
{
    return [NSColor colorWithDeviceWhite:0.08 alpha:1.0];
}

#pragma mark -
#pragma mark Scroller Theme

-(NSColor *)scrollerStroke                          //Color for Arrows/Knob Border
{
    return [NSColor colorWithDeviceWhite:0.08 alpha:1.0];
}

//-(NSGradient *)scrollerArrowNormalGradient		//Gradient used on normal Arrow button
//{
//    return [[[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:0.69 alpha:1.0] endingColor:[NSColor colorWithDeviceWhite:0.90 alpha:1.0]] autorelease];
//}
#pragma mark -
#pragma mark Table Theme

-(NSColor *)cellHighlightColor					//Color used to highlight selected row
{
    return  [NSColor alternateSelectedControlColor]; }

-(NSArray *)cellAlternatingRowColors			//NSArray with 2 Colors used to draw alternating rows
{
    return [NSArray arrayWithObjects:[NSColor colorWithDeviceWhite:0.05 alpha:1.0], [NSColor colorWithDeviceWhite:0.11 alpha:1.0],nil];
}

-(NSColor *)cellSelectedTextColor				//Color used to draw text when row selected
{
    return [NSColor colorWithDeviceWhite:0.88 alpha:1.0];
}

-(NSColor *)tableHeaderCellBorderColor			//Color used to draw border in column headers
{
    return [NSColor colorWithDeviceWhite:0.08 alpha:1.0];
}

-(NSGradient *)tableHeaderCellNormalFill		//Gradient used to draw normal column header
{
    return [[[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:0.29 alpha:1.0] endingColor:[NSColor colorWithDeviceWhite:0.16 alpha:1.0]] autorelease];
}
/*-(NSColor *)cellEditingFillColor;				//Color used to draw background of editing cell
-(NSColor *)tableBackgroundColor;				//Color used to fill table background
-(NSGradient *)tableHeaderCellNormalFill;		//Gradient used to draw normal column header
-(NSGradient *)tableHeaderCellPushedFill;		//Gradient used to draw pushed column header
-(NSGradient *)tableHeaderCellSelectedFill;		//Gradient used to draw selected column header
*/

#pragma mark -
#pragma mark Slider Theme
-(NSColor *)sliderTrackColor					//Color used to draw slider track
{
    return [NSColor colorWithDeviceWhite:0.16 alpha:1.0];
}

-(NSColor *)disabledSliderTrackColor			//Color used to draw disabled slider track
{
    return [NSColor colorWithDeviceWhite:0.26 alpha:1.0];
}

-(NSGradient *)knobColor						//Gradient used to draw the knob
{
    return [[[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:0.9 alpha:1.0] endingColor:[NSColor colorWithDeviceWhite:0.6 alpha:1.0]] autorelease];
}

-(NSGradient *)highlightKnobColor				//Gradient used to draw highlighted knob
{
    return [[[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:1.0 alpha:1.0] endingColor:[NSColor colorWithDeviceWhite:0.7 alpha:1.0]] autorelease];
}

-(NSGradient *)disabledKnobColor				//Gradient used to draw the knob
{
    return [[[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:0.5 alpha:1.0] endingColor:[NSColor colorWithDeviceWhite:0.3 alpha:1.0]] autorelease];
}

#pragma mark -
#pragma mark General Theme

-(NSColor *)textColor							//Color used to draw text
{
    return [NSColor colorWithDeviceWhite:0.88 alpha:1.0];
}

-(NSColor *)strokeColor                         //Color used to draw border
{
    return [NSColor colorWithDeviceWhite:0.08 alpha:1.0];
}

-(NSColor *)disabledStrokeColor				//Color used for disabled border
{
    return [NSColor colorWithDeviceWhite:0.12 alpha:1.0];
}

-(NSShadow *)focusRing							//Shadow used for the focus rings
{
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [NSColor colorWithDeviceWhite:0.5 alpha:0.8];
    shadow.shadowBlurRadius = 3.0;
    
    return [shadow autorelease];
}

@end
