//
//  SDNAppDelegate.h
//  ShowDown
//
//  Created by Brent Nycum on 3/6/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SDNAppDelegate : NSObject <NSApplicationDelegate>

/**
 *  The color scheme menu that the app will populate.
 */
@property (nonatomic, retain) IBOutlet NSMenu *colorSchemeMenu;

@end
