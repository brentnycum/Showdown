//
//  SDNAppDelegate.m
//  ShowDown
//
//  Created by Brent Nycum on 3/6/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import "SDNAppDelegate.h"
#import "SDNShowDown.h"

@interface SDNAppDelegate (private)

- (void)_buildColorSchemeMenu;
- (void)_switchColorScheme:(id)sender;

@end

@implementation SDNAppDelegate

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self _buildColorSchemeMenu];
}

#pragma mark - SDNAppDelegate

- (void)_buildColorSchemeMenu {
	[_colorSchemeMenu removeAllItems];
	
	NSString *selectedColorScheme = [[NSUserDefaults standardUserDefaults] valueForKey:SDNColorSchemeKey];
	
	NSDictionary *defaultColorSchemes = @{
		@"Bootstrap": @"bootstrap",
		@"Slate Bootstrap": @"bootstrap-slate",
		@"Showdown": @"showdown"
	};
	
	[defaultColorSchemes enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
		NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:key action:@selector(_switchColorScheme:) keyEquivalent:@""];
		[menuItem setRepresentedObject:value];
		
		if ([selectedColorScheme isEqualTo:value]) {
			[menuItem setState:NSOnState];
		} else {
			[menuItem setState:NSOffState];
		}
		
		[_colorSchemeMenu addItem:menuItem];
	}];
}

- (void)_switchColorScheme:(id)sender {
	NSMenuItem *selectedMenuItem = (NSMenuItem *)sender;
	
	[[NSUserDefaults standardUserDefaults] setValue:[selectedMenuItem representedObject] forKey:SDNColorSchemeKey];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SDNColorSchemeChangedNotification object:nil];
	
	[self _buildColorSchemeMenu];
}

@end
