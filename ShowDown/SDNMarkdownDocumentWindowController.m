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

- (void)reloadWebView {
	SDNMarkdownDocument *markdownDocument = (SDNMarkdownDocument *)self.document;
	
	[self.webView.mainFrame loadHTMLString:[markdownDocument markdownRepresentation] baseURL:nil];
}

@end
