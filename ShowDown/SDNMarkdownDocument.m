//
//  SDNMarkdownDocument.m
//  ShowDown
//
//  Created by Brent Nycum on 3/6/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import "SDNMarkdownDocument.h"
#import "SDNMarkdownDocumentWindowController.h"

#import <OCDiscount.h>

@interface SDNMarkdownDocument () {
	FSEventStreamRef _eventStream;
}

@property NSString *fileContents;
@property SDNMarkdownDocumentWindowController *windowController;

- (void)updateFileContents;

@end

@implementation SDNMarkdownDocument

#pragma mark - NSObject

- (void)dealloc {
	FSEventStreamStop(_eventStream);
	FSEventStreamInvalidate(_eventStream);
	FSEventStreamRelease(_eventStream);
}

#pragma mark - SDNMarkdownDocument

- (NSString *)markdownRepresentation {
	return [self.fileContents htmlStringFromMarkdown];
}

- (void)updateFileContents {
	self.fileContents = [NSString stringWithContentsOfFile:self.fileURL.path encoding:NSUTF8StringEncoding error:NULL];
	
	[self.windowController reloadWebView];
}

#pragma mark - FSEvents

void fileChangedCallback(ConstFSEventStreamRef streamRef,
				void *clientCallBackInfo,
				size_t numEvents,
				void *eventPaths,
				const FSEventStreamEventFlags eventFlags[],
				const FSEventStreamEventId eventIds[]) {
	
	SDNMarkdownDocument *document = (__bridge SDNMarkdownDocument *)(clientCallBackInfo);
	[document updateFileContents];
}

#pragma mark - NSDocument

- (void)makeWindowControllers {
	self.windowController = [[SDNMarkdownDocumentWindowController alloc] initWithWindowNibName:@"SDNMarkdown"];
	
	[self addWindowController:self.windowController];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
	self.fileContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	CFStringRef pathRef = (__bridge CFStringRef)[self.fileURL path];
	
    CFArrayRef pathsToWatch = CFArrayCreate(NULL, (const void **)&pathRef, 1, NULL);
	FSEventStreamContext context;
    memset(&context, 0, sizeof(context));
	context.info = (__bridge void *)(self);
	
    _eventStream = FSEventStreamCreate(NULL,
								 &fileChangedCallback,
								 &context,
								 pathsToWatch,
								 kFSEventStreamEventIdSinceNow,
								 1.0,
								 kFSEventStreamCreateFlagFileEvents);
	
	FSEventStreamScheduleWithRunLoop(_eventStream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	FSEventStreamStart(_eventStream);
	
	return YES;
}

@end
