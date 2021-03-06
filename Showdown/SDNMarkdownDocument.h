//
//  SDNMarkdownDocument.h
//  ShowDown
//
//  Created by Brent Nycum on 3/6/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SDNMarkdownDocument : NSDocument {
	FSEventStreamRef _eventStream;
}

/**
 *  Gets the Markdown representation of the current document.
 *
 *  @return The document's markdown representation.
 */
- (NSString *)markdownRepresentation;

@end
