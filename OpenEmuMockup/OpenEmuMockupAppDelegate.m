//
//  OpenEmuMockupAppDelegate.m
//  OpenEmuMockup
//
//  Created by vade on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OpenEmuMockupAppDelegate.h"

#import <objc/runtime.h>

// Our Data sources...
#define OEConsoleNames [NSArray arrayWithObjects:@"Nintendo (NES)", @"Super Nintendo (SNES)", @"GameBoy", @"GameBoy Advance", @"Game Gear", @"Sega Genesis", @"Sega Master System", @"Sega SG-1000", nil]
#define OERomNESLibraryImages [NSArray arrayWithObjects:@"Castlevania", @"Contra", @"DonkeyKong", @"The Legend of Zelda", @"Super Mario Bros 2", @"Mario Bros", @"Super Mario Bros 3", nil]
#define OERomSNESLibraryImages [NSArray arrayWithObjects:@"Street Fighter 2", @"Super Mario Kart", @"Contra 3", @"Starfox", @"Super Mario All Stars", @"Super Mario World", @"Super Metroid", @"Yoshis Island", nil]
#define OERomGameBoyLibraryImages [NSArray arrayWithObjects:@"Metroid 2", @"Super Mario Land", @"Super Mario Land 2", @"Wario Land", nil]

#define OERomSegaSG1000LibraryImages [NSArray arrayWithObjects:@"Borderline", nil]

#define OERomDictionary [NSDictionary dictionaryWithObjects:

// See Overriding NSThemeFrame
@interface OpenEmuMockupAppDelegate (Shh)
- (float)roundedCornerRadius;
- (void)drawRectOriginal:(NSRect)rect;
- (NSWindow*)window;
@end

@implementation OpenEmuMockupAppDelegate

@synthesize window;
@synthesize mainView;

@synthesize romLibraryRoms;
@synthesize romLibraryArrayController;
@synthesize romcollectionScroller;
@synthesize romCollectionView;
@synthesize romLibraryTableView;
@synthesize romLibraryViewController;
@synthesize romLibraryFlowView;
@synthesize romLibrarySuperView;
@synthesize romLibraryFlowViewMaster;

@synthesize consoles;
@synthesize consoleArrayController;
@synthesize consoleTableView;
@synthesize consoleStamp;

@synthesize search;
@synthesize scale;
@synthesize iconViewButton;
@synthesize listViewButton;
@synthesize flowViewButton;
@synthesize fullScreenButton;

- (void) awakeFromNib
{
    inFullScreen = NO;
    
    // might as well take the time to set up our space for the bottom bar.
    [[self window] setContentBorderThickness:45	forEdge:NSMinYEdge];
    
    // setup our window HUD toolbar hack
    [self setupNSThemeFrameMethodRedirect];
    
    // init CoverFlow properly
    [romLibraryFlowView setDelegate:self];
    [romLibraryFlowView setDataSource:self];
    
    [self adjustRomLibrarySize:scale];
    [romcollectionScroller setDocumentView:romCollectionView];
    [iconViewButton setState:NSOnState];   
    
    // set up our arrays
    self.consoles = [NSMutableArray arrayWithCapacity:[OEConsoleNames count]];
    self.romLibraryRoms = [NSMutableArray arrayWithCapacity:[OERomNESLibraryImages count]]; 
    
    [romLibraryArrayController setContent:romLibraryRoms];
    [consoleArrayController setContent:consoles];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // yes this is horrible, we will use Core Data later, I mean really I dont have a backing store...
    
    // Add dummy consoles/cores
    for(NSString* consoleName in OEConsoleNames)
    {
        OEGameCoreWrapper* core = [[OEGameCoreWrapper alloc] init];
        core.consoleName = consoleName;
        core.consoleIcon = [NSImage imageNamed:consoleName];
        core.consoleStamp = [NSImage imageNamed:[consoleName stringByAppendingString:@" Stamp"]];

        // add to library
        [consoleArrayController addObject:core];
        
        // retained by library
        [core release];
    }
        
    // Add some dummy roms into our libary.
    for(NSString* romImageName in OERomNESLibraryImages)
    {
        OERomWrapper* rom = [[OERomWrapper alloc] init];
        
        rom.romImagePath = [[NSBundle mainBundle] pathForResource:romImageName ofType:@"png"];
        rom.romImage = [self treatRomTitleImage:[NSImage imageNamed:romImageName]];
        rom.romImage = (rom.romImage) ? rom.romImage : [NSImage imageNamed:@"FileNotFound"];
        rom.romName = romImageName;
        rom.romRating = 3;
        rom.consoleName = @"Nintendo (NES)";
        
        // "add to library"
        [romLibraryArrayController addObject:rom];
        
        // retained by library
        [rom release];
    }
    
    // Add some dummy roms into our libary.
    for(NSString* romImageName in OERomSNESLibraryImages)
    {
        OERomWrapper* rom = [[OERomWrapper alloc] init];
        rom.romImagePath = [[NSBundle mainBundle] pathForResource:romImageName ofType:@"png"];
        rom.romImage = [self treatRomTitleImage:[NSImage imageNamed:romImageName]];
        rom.romImage = (rom.romImage) ? rom.romImage : [NSImage imageNamed:@"FileNotFound"];
        rom.romName = romImageName;
        rom.romRating = 3;
        rom.consoleName = @"Super Nintendo (SNES)";
        
        // "add to library"
        [romLibraryArrayController addObject:rom];
        
        // retained by library
        [rom release];
    }
    
    // Add some dummy roms into our libary.
    for(NSString* romImageName in OERomGameBoyLibraryImages)
    {
        OERomWrapper* rom = [[OERomWrapper alloc] init];
        
        rom.romImagePath = [[NSBundle mainBundle] pathForResource:romImageName ofType:@"png"];
        rom.romImage = [self treatRomTitleImage:[NSImage imageNamed:romImageName]];
        rom.romImage = (rom.romImage) ? rom.romImage : [NSImage imageNamed:@"FileNotFound"];
        rom.romName = romImageName;
        rom.romRating = 3;
        rom.consoleName = @"GameBoy";
        
        // "add to library"
        [romLibraryArrayController addObject:rom];
        
        // retained by library
        [rom release];
    }
    
    
    // Add some dummy roms into our libary.
    for(NSString* romImageName in OERomSegaSG1000LibraryImages)
    {
        OERomWrapper* rom = [[OERomWrapper alloc] init];
        
        rom.romImagePath = [[NSBundle mainBundle] pathForResource:romImageName ofType:@"png"];
        rom.romImage = [self treatRomTitleImage:[NSImage imageNamed:romImageName]];
        rom.romImage = (rom.romImage) ? rom.romImage : [NSImage imageNamed:@"FileNotFound"];
        rom.romName = romImageName;
        rom.romRating = 3;
        rom.consoleName = @"Sega SG-1000";
        
        // "add to library"
        [romLibraryArrayController addObject:rom];
        
        // retained by library
        [rom release];
    }
    
    // ping Converflow
    [romLibraryFlowView reloadData];
}

#pragma mark -
#pragma mark  TableView Datasource Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{    
    return [[consoleArrayController arrangedObjects]count];
}


- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    OEGameCoreWrapper* wrapper = (OEGameCoreWrapper*)[[consoleArrayController arrangedObjects] objectAtIndex:rowIndex];
    if([[aTableColumn identifier] isEqualToString:@"icon"])
        return [wrapper consoleIconName];
    
    if([[aTableColumn identifier] isEqualToString:@"name"])
        return [wrapper consoleName];
        
    return nil;
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{   
    [self filter];
}


#pragma mark -
#pragma mark IKImageFlowView Datasource & Delegate Methods

- (NSUInteger)numberOfItemsInImageFlow:(id)aFlowLayer
{
    return [[romLibraryArrayController arrangedObjects] count];
}

- (id)imageFlow:(id)aFlowLayer itemAtIndex:(int)index
{
    OERomWrapper* wrapper = [[romLibraryArrayController arrangedObjects] objectAtIndex:index];
    
    return wrapper;
}

#pragma mark -
#pragma mark IB Actions

- (IBAction) adjustRomLibrarySize:(id)sender
{
    NSSize normalSize = NSMakeSize(182, 222);
    
    float scaleValue = [sender floatValue];
    
    NSSize newSize = NSMakeSize(scaleValue * normalSize.width, scaleValue * normalSize.height);
    
    [romCollectionView setMaxItemSize:newSize];
    [romCollectionView setMinItemSize:newSize];
}

- (IBAction) fireSearch:(id)sender
{
    [self filter];
}

- (IBAction) switchRomLibraryToIconMode:(id)sender
{
    [listViewButton setState:0];
    [flowViewButton setState:0];
    [scale setEnabled:YES];
    
    //[self animateRemoveSubviews];
    
    [romcollectionScroller setDocumentView:romCollectionView];
    [romCollectionView setFrame:[romcollectionScroller frame]];
}

- (IBAction) switchRomLibraryToListMode:(id)sender
{
    [iconViewButton setState:0];
    [flowViewButton setState:0];
    [scale setEnabled:NO];

    //[self animateRemoveSubviews];
    //[romcollectionScroller setDocumentView:];
}

- (IBAction) switchRomLibraryToFlowMode:(id)sender
{
    [listViewButton setState:0];
    [iconViewButton setState:0];
    [scale setEnabled:NO];
    
    //[self animateRemoveSubviews];
    [romcollectionScroller setDocumentView:romLibraryFlowViewMaster];
    [romLibraryFlowViewMaster setFrame:[romcollectionScroller frame]];
}

- (IBAction) toggleFullscreen:(id)sender
{
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NO],NSFullScreenModeAllScreens,
                             [NSNumber numberWithInt:NSNormalWindowLevel], NSFullScreenModeWindowLevel,
                             [NSNumber numberWithUnsignedInt:NSApplicationPresentationAutoHideMenuBar|NSApplicationPresentationAutoHideDock], NSFullScreenModeApplicationPresentationOptions, nil];
   
    if(![mainView isInFullScreenMode])
    {
        [fullScreenButton setState:NSOnState];
        [mainView enterFullScreenMode:[window screen] withOptions:options];
        inFullScreen = YES;
    }
    else
    {
        [fullScreenButton setState:NSOffState];
        [mainView exitFullScreenModeWithOptions:options];
        inFullScreen = NO;
    }

}


#pragma mark -
#pragma mark Filtering

- (void) filter
{    
    NSIndexSet* selectedConsolesIndex = [consoleTableView selectedRowIndexes];
    
    // strings of selected console names to filter 
    NSMutableArray* selectedConsoleNamesArray = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray* selectedConsoleStampsArray = [NSMutableArray arrayWithCapacity:3];
    
    for(OEGameCoreWrapper* wrapper in [[consoleArrayController arrangedObjects] objectsAtIndexes:selectedConsolesIndex])
    {
        [selectedConsoleNamesArray addObject:[wrapper consoleName]];
        if([wrapper consoleStamp])
            [selectedConsoleStampsArray addObject:[wrapper consoleStamp]];
    }
    
    NSPredicate * romLibraryFilter;
    
    if([[search stringValue] isEqualToString:@""])
        romLibraryFilter = [NSPredicate predicateWithFormat:@"(consoleName in %@)", selectedConsoleNamesArray];
    else
        romLibraryFilter = [NSPredicate predicateWithFormat:@"(consoleName in %@ AND romName contains[cd] %@)", selectedConsoleNamesArray, [search stringValue]];
    

    [romLibraryArrayController setFilterPredicate:romLibraryFilter];
    
    // mess with stamp... if we have many
    if([selectedConsoleStampsArray count] == 1)
        [[consoleStamp animator] setImage:[selectedConsoleStampsArray objectAtIndex:0]];
    else
        [[consoleStamp animator] setImage:[NSImage imageNamed:@"All"]];
    
    // force the coverflow view to update
    [romLibraryFlowView reloadData];
}   

#pragma mark -
#pragma mark Icon Image Treatment

- (NSImage*) treatRomTitleImage:(NSImage*)inputImage
{
    // make a new graphics context and load an image
    // make a shadow
    // add the highlight
    // spit out another image.

    NSImage *returnImage = [[NSImage alloc] initWithSize:NSMakeSize(inputImage.size.width + 20, inputImage.size.height + 20)];
    
    // draw into our destination
    [returnImage lockFocus];
    
    // enable shadows
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 15;
    shadow.shadowOffset = NSMakeSize(0, -3);
    shadow.shadowColor = [NSColor colorWithDeviceWhite:0 alpha:0.85];
    [shadow set];
    
    NSRect destRect = NSMakeRect(+10, +15, inputImage.size.width, inputImage.size.height);
    [inputImage drawInRect:destRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    
    [shadow release];
    
    [returnImage unlockFocus];
    [returnImage recache];
    
    return [returnImage autorelease];
}

#pragma mark -
#pragma mark Overriding NSThemeFrame 

// Gets us nice bottom HUD look without needing to roll our own window. 
// Sorry Psy.
// Via: http://parmanoir.com/Custom_NSThemeFrame

- (void) setupNSThemeFrameMethodRedirect
{	
	// Get window's frame view class
	id class = [[[window contentView] superview] class];    
	
	// Exchange draw rect
	Method m0 = class_getInstanceMethod([self class], @selector(drawRect:));
	class_addMethod(class, @selector(drawRectOriginal:), method_getImplementation(m0), method_getTypeEncoding(m0));
	
	Method m1 = class_getInstanceMethod(class, @selector(drawRect:));
	Method m2 = class_getInstanceMethod(class, @selector(drawRectOriginal:));
	
	method_exchangeImplementations(m1, m2);
    
    //[window setContentBorderThickness:145.0 forEdge:NSMinYEdge];
}

// See above for why.
- (void)drawRect:(NSRect)rect
{
	// Call original drawing method
	[self drawRectOriginal:rect];
        
	//
	// Build clipping path : intersection of frame clip (bezier path with rounded corners) and rect argument
	//
	NSRect windowRect = [[self window] frame];
	windowRect.origin = NSMakePoint(0, 0);
    
    // make a new Rect that is the width of our window, and is 45 pixels high (the size of our toolbar)
	float cornerRadius = [self roundedCornerRadius];    
    NSRect toolBarRect = NSMakeRect(0, 0, windowRect.size.width, 44);
	[[NSBezierPath bezierPathWithRoundedRect:windowRect xRadius:cornerRadius yRadius:cornerRadius] addClip];
	[[NSBezierPath bezierPathWithRect:rect] addClip];
    
    NSBezierPath* toolBarPath = [NSBezierPath bezierPathWithRect:toolBarRect];
    
    NSColor* topColor = [NSColor colorWithCalibratedWhite:0.15 alpha:1];
	NSColor* bottomColor = [NSColor colorWithCalibratedWhite:0.1 alpha:1];
        
	NSGradient* gradient = [[NSGradient alloc] initWithColorsAndLocations:
                            topColor, (CGFloat)0.0,
                            bottomColor, (CGFloat)1.0,
                            nil];
        
    [gradient drawInBezierPath:toolBarPath angle:270];
    
    [[NSGraphicsContext currentContext] setShouldAntialias:NO];
    
    NSColor* topLineColor = [NSColor colorWithCalibratedRed:0.21 green:0.2 blue:0.21 alpha:1.0];

    NSBezierPath* darkLinePath = [NSBezierPath bezierPath];
    [darkLinePath setLineWidth:1.0];
    
    [[NSColor blackColor] set];
    [darkLinePath moveToPoint:NSMakePoint(0.0, 44)];
    [darkLinePath lineToPoint:NSMakePoint(windowRect.size.width, 44)];
    [darkLinePath stroke];
    
    NSBezierPath* lightLinePath = [NSBezierPath bezierPath];
    [lightLinePath setLineWidth:1.0];
    
    [topLineColor set];
    [lightLinePath moveToPoint:NSMakePoint(0.0, 43)];
    [lightLinePath lineToPoint:NSMakePoint(windowRect.size.width, 43)];
    [lightLinePath stroke];
    
    
    [gradient release];
}


@end
