//
//  OpenEmuMockupAppDelegate.h
//  OpenEmuMockup
//
//  Created by vade on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OERomWrapper.h"
#import "OEGameCoreWrapper.h"

#import <QuartzCore/QuartzCore.h>
#import "IKImageFlowView.h"

// for private coverflow API
@class IKImageFlowView;

@interface OpenEmuMockupAppDelegate : NSObject <NSApplicationDelegate>
{
    NSWindow *window;
        
    // Rom Library
    NSMutableArray* romLibraryRoms;
    NSArrayController* romLibraryArrayController;
    
    // Console
    NSMutableArray* consoles;
    NSArrayController* consoleArrayController;
    
    // Filtering the CollectionView ...
    NSPredicate* romFilterPredicate;
    
    // Rom Library View management
    NSViewController* romLibraryViewController;
    
    // Views
    NSView* mainView;
    NSTableView* consoleTableView;
    NSImageView* consoleStamp;

    NSView* romLibrarySuperView;
    NSScrollView* romcollectionScroller;
    NSCollectionView* romCollectionView;
    NSTableView* romLibraryTableView;
    NSView* romLibraryFlowViewMaster; // contains splitview for detail and flow view of Cover Flow to be in.
    IKImageFlowView* romLibraryFlowView;
    
    // UI
    NSSlider* scale;
    NSSearchField* search;
    NSButton* iconViewButton;
    NSButton* listViewButton;
    NSButton* flowViewButton;
    NSButton* fullScreenButton;
    BOOL inFullScreen;
}

@property (assign) IBOutlet NSWindow *window;

// Rom Library
@property (readwrite, retain) NSMutableArray* romLibraryRoms;
@property (retain) IBOutlet NSArrayController* romLibraryArrayController;
@property (retain) IBOutlet NSViewController* romLibraryViewController;

// Console Library
@property (readwrite, retain) NSMutableArray* consoles;
@property (retain) IBOutlet NSArrayController* consoleArrayController;

// Views
@property (retain) IBOutlet NSView* mainView;
@property (retain) IBOutlet NSView* romLibrarySuperView;
@property (retain) IBOutlet NSScrollView* romcollectionScroller;
@property (retain) IBOutlet NSCollectionView* romCollectionView;
@property (retain) IBOutlet NSTableView* romLibraryTableView;
@property (retain) IBOutlet NSView* romLibraryFlowViewMaster;
@property (retain) IBOutlet IKImageFlowView* romLibraryFlowView;

@property (retain) IBOutlet NSTableView* consoleTableView;
@property (retain) IBOutlet NSImageView* consoleStamp;

// UI
@property (retain) IBOutlet NSSearchField* search;
@property (retain) IBOutlet NSSlider* scale;
@property (retain) IBOutlet NSButton* iconViewButton;
@property (retain) IBOutlet NSButton* listViewButton;
@property (retain) IBOutlet NSButton* flowViewButton;
@property (retain) IBOutlet NSButton* fullScreenButton;

- (IBAction) adjustRomLibrarySize:(id)sender;
- (IBAction) fireSearch:(id)sender;

- (IBAction) switchRomLibraryToIconMode:(id)sender;
- (IBAction) switchRomLibraryToListMode:(id)sender;
- (IBAction) switchRomLibraryToFlowMode:(id)sender;
- (IBAction) toggleFullscreen:(id)sender;

- (void) filter;
- (void) setupNSThemeFrameMethodRedirect;
- (NSImage*) treatRomTitleImage:(NSImage*)inputImage;

@end
