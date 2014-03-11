//
//  SDNAppDelegate.m
//  ShowDown
//
//  Created by Brent Nycum on 3/6/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import "SDNAppDelegate.h"

@interface SDNAppDelegate (private)

- (void)_buildColorSchemeMenu;
- (void)_switchColorScheme:(id)sender;

@end

@implementation SDNAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self _buildColorSchemeMenu];
}

- (void)_buildColorSchemeMenu {
	[_colorSchemeMenu removeAllItems];
	
	NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:@"Bootstrap" action:@selector(_switchColorScheme:) keyEquivalent:@""];
	
	[_colorSchemeMenu addItem:menuItem];
}

- (void)_switchColorScheme:(id)sender {
	
}

@end
