//
//  OERomWrapper.h
//  OpenEmuMockup
//
//  Created by vade on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// This class wraps the rom with Meta from some Web API, an image reference, IKImageFlow data.
@interface OERomWrapper : NSObject 
{
    NSString* romPath;      // Path to the rom
    NSString* romName;      // Human Readable name
    NSUInteger romRating;   // 0 - 5 stars
    NSString* consoleName;  // this may end up being a consoleID, so we can map GameCore <-> consoles

    NSString* romImagePath; // Path for the cached image
    NSImage* romImage;      // Image for the Rom / Cover art, etc.
    NSDate* romLastPlayed;  // Last play date
    
    
    // for IKImageBrowser/Flow view / Datasource
    NSString* imageUID;
}

@property (readwrite, retain) NSString* romPath;
@property (readwrite, retain) NSString* romName;
@property (assign) NSUInteger romRating;
@property (readwrite, retain) NSString* consoleName;
@property (readwrite, retain) NSString* romImagePath;
@property (readwrite, retain) NSImage* romImage;
@property (readwrite, retain) NSDate* romLastPlayed;

// IKImageBrowserItem Protocol
@property (readwrite, retain) NSString* imageUID;

- (NSString *) imageRepresentationType;
- (id) imageRepresentation;
- (BOOL) isSelectable;
- (NSString *) imageTitle;
- (NSString *) imageSubtitle;

@end
