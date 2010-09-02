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
    return [NSString stringWithFormat:@"%i Stars", self.romRating, nil];
}

@end
