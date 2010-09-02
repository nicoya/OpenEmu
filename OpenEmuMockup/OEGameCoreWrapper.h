//
//  OEGameCoreWrapper.h
//  OpenEmuMockup
//
//  Created by vade on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface OEGameCoreWrapper : NSObject  <NSCopying>
{
    id gameCore;    // actual core associated with the 

    NSAttributedString* consoleIconName; // Quick/Dirty text attachment with image hack for icon in Tableview, barf
    NSString* consoleName;
    NSImage* consoleIcon;
    NSImage* consoleStamp;
}
@property (readwrite, retain) NSAttributedString* consoleIconName;
@property (readwrite, retain) NSString* consoleName;
@property (readwrite, retain) NSImage* consoleIcon;
@property (readwrite, retain) NSImage* consoleStamp;

@end
