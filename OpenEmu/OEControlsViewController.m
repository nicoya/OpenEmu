/*
 Copyright (c) 2009, OpenEmu Team
 
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
     * Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
     * Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.
     * Neither the name of the OpenEmu Team nor the
       names of its contributors may be used to endorse or promote products
       derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY OpenEmu Team ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL OpenEmu Team BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "OEControlsViewController.h"
#import "OEHIDEvent.h"
#import "OEGameCoreController.h"

@implementation OEControlsViewController
@synthesize selectedControl, bindingType, playerSelector, playerStepper, playerField, delegate;

- (void)dealloc
{
    [bindingType    release];
    [playerSelector release];
    [playerStepper  release];
    [playerField    release];
    
    [super dealloc];
}

- (void)awakeFromNib
{
    [playerField setIntegerValue:1];
    [playerStepper setIntegerValue:1];
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (IBAction)selectInputControl:(id)sender
{
    if(sender == nil || [sender respondsToSelector:@selector(state)])
    {
        NSInteger state = [sender state];
        
        [selectedControl setState:NSOffState];
        [[sender window] makeFirstResponder:(state == NSOnState ? [self view] : nil)];
        [[self view] setNextResponder:self];
        selectedControl = (state == NSOnState ? sender : nil);
    }
}

- (IBAction)displayedBindingsChanged:(id)sender
{
    if(sender == playerField)
        [playerStepper setIntegerValue:[playerField integerValue]];
    else if(sender == playerStepper)
        [playerField setIntegerValue:[playerStepper integerValue]];
    
    [self resetKeyBindings];
}

- (void)resetBindingsWithKeys:(NSArray *)keys
{
    for(NSString *key in keys)
    {
        [self willChangeValueForKey:key];
        [self didChangeValueForKey:key];
    }
}

- (void)resetKeyBindings
{
    [self resetBindingsWithKeys:[[self delegate] genericControlNamesInControlsViewController:self]];
}

- (BOOL)isKeyboardEventSelected
{
    return [bindingType selectedTag] == 0;
}

- (NSString *)selectedKey
{
    return [[selectedControl infoForBinding:@"title"] objectForKey:NSObservedKeyPathKey];
}

- (NSUInteger)selectedPlayer
{
    if(playerStepper  != nil) return [playerStepper intValue];
    if(playerSelector != nil) return [playerSelector selectedTag];
    
    return NSNotFound;
}

- (NSString *)keyPathForKey:(NSString *)aKey
{
    NSUInteger player = [self selectedPlayer];
    if(player != NSNotFound)
        return [[self delegate] controlsViewController:self playerKeyForKey:aKey player:player];
    else
        return aKey;
}

- (IBAction)closeWindow:(id)sender
{
    [[[self view] window] close];
}

- (void)registerEvent:(id)anEvent
{
    if(selectedControl != nil)
    {
        [self setValue:anEvent forKey:[self selectedKey]];
        [self selectInputControl:nil];
    }
}

- (void)setSelectedBindingType:(NSInteger)aTag
{
    if([bindingType selectedTag] != aTag)
    {
        [bindingType selectCellWithTag:aTag];
        [self resetKeyBindings];
    }
}

- (void)keyDown:(NSEvent *)theEvent
{
    
}

- (void)keyUp:(NSEvent *)theEvent
{
    
}

- (void)axisMoved:(OEHIDEvent *)anEvent
{
    if([anEvent direction] != OEHIDDirectionNull)
    {
        [self registerEvent:anEvent];
        [self setSelectedBindingType:1];
    }
}

- (void)buttonDown:(OEHIDEvent *)anEvent
{
    [self registerEvent:anEvent];
    [self setSelectedBindingType:1];
}

- (void)hatSwitchChanged:(OEHIDEvent *)anEvent;
{
    if([anEvent position] != 0)
    {
        [self registerEvent:anEvent];
        [self setSelectedBindingType:1];
    }
}

- (void)HIDKeyDown:(OEHIDEvent *)anEvent
{
	[self registerEvent:anEvent];
    [self setSelectedBindingType:0];
}

- (id)valueForKey:(NSString *)key
{
    if([[[self delegate] genericControlNamesInControlsViewController:self] containsObject:key])
    {
        id anEvent = nil;
        if([self isKeyboardEventSelected])
            anEvent = [[self delegate] controlsViewController:self keyboardEventForKey:[self keyPathForKey:key]];
        else
            anEvent = [[self delegate] controlsViewController:self HIDEventForKey:[self keyPathForKey:key]];
        
        return (anEvent != nil ? [anEvent displayDescription] : @"<empty>");
    }
    
    return [super valueForKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    // should be mutually exclusive
    if([[[self delegate] genericControlNamesInControlsViewController:self] containsObject:key])
    {
        [self willChangeValueForKey:key];
        [[self delegate] controlsViewController:self registerEvent:value forKey:[self keyPathForKey:key]];
        [self didChangeValueForKey:key];
    }
    else [super setValue:value forKey:key];
}

@end
