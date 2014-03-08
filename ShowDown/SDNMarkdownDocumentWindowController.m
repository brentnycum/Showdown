//
//  SDNMarkdownDocumentWindowController.m
//  ShowDown
//
//  Created by Brent Nycum on 3/6/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import "SDNMarkdownDocument.h"
#import "SDNMarkdownDocumentWindowController.h"

@interface SDNMarkdownDocumentWindowController (private)

- (NSString *)styleSheetText;

@end

@implementation SDNMarkdownDocumentWindowController

#pragma mark - NSWindowController

- (void)windowDidLoad {
	[super windowDidLoad];
	
	[self synchronizeWindowTitleWithDocumentName];
	
	[self reloadWebView];
}

#pragma mark - SDNMarkdownDocumentWindowController

- (NSString *)styleSheetText {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"showdown" ofType:@"css"];
	return [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

- (void)reloadWebView {
	_pageOffset = CGPointMake([self.webView stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"].floatValue,
							  [self.webView stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"].floatValue);
	
	SDNMarkdownDocument *markdownDocument = (SDNMarkdownDocument *)self.document;
	
	NSString *htmlRepresentation = [NSString stringWithFormat:@"<!doctype html>\
									<html lang='en'>\
									<head>\
									<meta charset='UTF-8'>\
									<title>ShowDown</title>\
									<style type='text/css'>\
									%@\
									</style>\
									</head>\
									<body>\
									%@\
									</body>\
									</html>",
									[self styleSheetText],
									[markdownDocument markdownRepresentation]];
	
	[self.webView.mainFrame loadHTMLString:htmlRepresentation baseURL:nil];
}

#pragma mark - WebFrameLoadDelegate

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
	[self.webView stringByEvaluatingJavaScriptFromString:
	 [NSString stringWithFormat:@"window.scrollTo(%f, %f)", _pageOffset.x, _pageOffset.y]];
}

@end
