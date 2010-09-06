//
//  OERomWrapper.m
//  OpenEmuMockup
//
//  Created by vade on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OERomWrapper.h"
#import <ImageKit/ImageKit.h>

@implementation OERomWrapper
@synthesize romName;
@synthesize romImage;
@synthesize romPath;
@synthesize romImagePath;
@synthesize romRating;
@synthesize consoleName;
@synthesize imageUID;
@synthesize romLastPlayed;

- (id) init
{
    if( (self = [super init]))
    {
        // Create a new UUID
        CFUUIDRef  uuidObj = CFUUIDCreate(nil);
        
        // Get the string representation of the UUID
        NSString  *uuidString = (NSString *)CFUUIDCreateString(nil, uuidObj);
        CFRelease(uuidObj);
        
        self.imageUID = uuidString;
        [uuidString release]; 
        
        int daysAgo = (random() % 30 * 86400 * 2);
        
        self.romLastPlayed = [NSDate dateWithTimeIntervalSinceNow:-daysAgo]; // dummy date. 
    }
    return self;
}

- (NSString *) imageRepresentationType
{
    // could be IKImageBrowserPathRepresentationType; eventually when we read off disk
    return IKImageBrowserNSImageRepresentationType;
}

- (id) imageRepresentation
{
    return self.romImage;
}

- (BOOL) isSelectable
{
    return YES;
}

- (NSString *) imageTitle
{
    return self.romName;
}

- (NSString *) imageSubtitle
{
    switch (self.romRating)
    {
        case 0:
            return [NSString stringWithUTF8String:"\u2606\u2606\u2606\u2606\u2606"];
        case 1:
            return [NSString stringWithUTF8String:"\u2605\u2606\u2606\u2606\u2606"];
        case 2:
            return [NSString stringWithUTF8String:"\u2605\u2605\u2606\u2606\u2606"];
        case 3:
            return [NSString stringWithUTF8String:"\u2605\u2605\u2605\u2606\u2606"];
        case 4:
            return [NSString stringWithUTF8String:"\u2605\u2605\u2605\u2605\u2606"];
        case 5:
            return [NSString stringWithUTF8String:"\u2605\u2605\u2605\u2605\u2605"];
        default:
            break;
    }
    
    return nil;
}

@end
