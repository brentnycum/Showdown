//
//  SDNMarkdownDocumentWindowController.m
//  ShowDown
//
//  Created by Brent Nycum on 3/6/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import "SDNMarkdownDocument.h"
#import "SDNMarkdownDocumentWindowController.h"

@implementation SDNMarkdownDocumentWindowController

#pragma mark - NSWindowController

- (void)windowDidLoad {
	[super windowDidLoad];
	
	[self synchronizeWindowTitleWithDocumentName];
	
	[self reloadWebView];
}

#pragma mark - SDNMarkdownDocumentWindowController

- (void)reloadWebView {
	SDNMarkdownDocument *markdownDocument = (SDNMarkdownDocument *)self.document;
	
	NSString *htmlRepresentation = [NSString stringWithFormat:@"<!doctype html>\
									<html lang='en'>\
									<head>\
									<meta charset='UTF-8'>\
									<title>ShowDown</title>\
									</head>\
									<body>\
									%@\
									</body>\
									</html>", [markdownDocument markdownRepresentation]];
	
	[self.webView.mainFrame loadHTMLString:htmlRepresentation baseURL:nil];
}

@end
