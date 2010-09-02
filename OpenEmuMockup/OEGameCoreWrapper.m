//
//  OEGameCoreWrapper.m
//  OpenEmuMockup
//
//  Created by vade on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OEGameCoreWrapper.h"


@implementation OEGameCoreWrapper

@synthesize consoleIconName;
@synthesize consoleName;
@synthesize consoleIcon;
@synthesize consoleStamp;

- (id)copyWithZone:(NSZone *)zone
{
    OEGameCoreWrapper *copy = [[self class] allocWithZone:zone];
    
    [copy setConsoleIconName:self.consoleIconName];
    [copy setConsoleName:self.consoleName];    
    [copy setConsoleIcon:self.consoleIcon];
    [copy setConsoleStamp:self.consoleStamp];
    
    return copy;
}

- (NSAttributedString*) consoleIconName
{
    // if we dont have an attributedName
    if(consoleIconName == nil)
    {
        // and we have our requirements
        if(self.consoleName && self.consoleIcon)
        {
            // make the fucker
            [self willChangeValueForKey:@"consoleAttributedName"];
           
            NSTextAttachment* attachment = [[[NSTextAttachment alloc] init] autorelease];
            
            NSImage *icon = [self consoleIcon];
            [[attachment attachmentCell] setImage:icon];
                    
            NSMutableAttributedString *iconString = (id)[NSMutableAttributedString attributedStringWithAttachment:attachment];
           
            NSMutableParagraphStyle * style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setAlignment:NSRightTextAlignment];
            
            [iconString addAttribute:NSParagraphStyleAttributeName
                               value:style
                               range:NSMakeRange(0, [iconString length])]; 
            
            [style release];
            
            [self setConsoleIconName:iconString];
           
            [self didChangeValueForKey:@"consoleAttributedName"];
                        
            return consoleIconName;
        }        
        return nil;
    }
    return consoleIconName;
}

@end
