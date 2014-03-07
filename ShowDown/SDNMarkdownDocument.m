//
//  SDNMarkdownDocument.m
//  ShowDown
//
//  Created by Brent Nycum on 3/6/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import "SDNMarkdownDocument.h"

@implementation SDNMarkdownDocument

#pragma mark - FSEvents

void fileChangedCallback(ConstFSEventStreamRef streamRef,
				void *clientCallBackInfo,
				size_t numEvents,
				void *eventPaths,
				const FSEventStreamEventFlags eventFlags[],
				const FSEventStreamEventId eventIds[]) {
	
	SDNMarkdownDocument *document = (__bridge SDNMarkdownDocument *)(clientCallBackInfo);
	
}

#pragma mark - NSDocument

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
	CFStringRef pathRef = (__bridge CFStringRef)[self.fileURL path];
	
    CFArrayRef pathsToWatch = CFArrayCreate(NULL, (const void **)&pathRef, 1, NULL);
	FSEventStreamContext context;
    memset(&context, 0, sizeof(context));
	context.info = (__bridge void *)(self);
	
    FSEventStreamRef stream = FSEventStreamCreate(NULL,
								 &fileChangedCallback,
								 &context,
								 pathsToWatch,
								 kFSEventStreamEventIdSinceNow,
								 1.0,
								 kFSEventStreamCreateFlagFileEvents);
	
	FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	FSEventStreamStart(stream);
	
	return YES;
}

@end
