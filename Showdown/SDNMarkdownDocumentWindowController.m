//
//  SDNMarkdownDocumentWindowController.m
//  ShowDown
//
//  Created by Brent Nycum on 3/6/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import "SDNMarkdownDocument.h"
#import "SDNMarkdownDocumentWindowController.h"
#import "SDNShowDown.h"

@interface SDNMarkdownDocumentWindowController (private)

- (NSString *)_styleSheetText;
- (void)_colorSchemeSelectionChanged:(NSNotification *)notification;
- (void)_saveWindowLocationAndSize;

@end

@implementation SDNMarkdownDocumentWindowController

#pragma mark - NSObject

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSWindowController

- (void)windowDidLoad {
	[super windowDidLoad];
	
	NSString *windowLocationAndSize = [[NSUserDefaults standardUserDefaults] valueForKey:SDNWindowLocationAndSize];
	
	if (windowLocationAndSize) {
		[self.window setFrame:NSRectFromString(windowLocationAndSize) display:YES];
	}
	
	[self synchronizeWindowTitleWithDocumentName];
	
	[self reloadWebView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(_colorSchemeSelectionChanged:)
												 name:SDNColorSchemeChangedNotification
											   object:nil];
}

#pragma mark - SDNMarkdownDocumentWindowController

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
									[self _styleSheetText],
									[markdownDocument markdownRepresentation]];
	
	[self.webView.mainFrame loadHTMLString:htmlRepresentation baseURL:nil];
}

#pragma mark - SDNMarkdownDocumentWindowController private

- (NSString *)_styleSheetText {
	NSString *selectedColorScheme = [[NSUserDefaults standardUserDefaults] valueForKey:SDNColorSchemeKey];
	
	if (!selectedColorScheme) {
		selectedColorScheme = SDNDefaultColorScheme;
	}
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:selectedColorScheme ofType:@"css"];
	return [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

- (void)_colorSchemeSelectionChanged:(NSNotification *)notification {
	[self reloadWebView];
}

- (void)_saveWindowLocationAndSize {
	[[NSUserDefaults standardUserDefaults] setValue:NSStringFromRect(self.window.frame) forKey:SDNWindowLocationAndSize];
}

#pragma mark - WebFrameLoadDelegate

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
	[self.webView stringByEvaluatingJavaScriptFromString:
	 [NSString stringWithFormat:@"window.scrollTo(%f, %f)", _pageOffset.x, _pageOffset.y]];
	
	NSScrollView *scrollView = self.webView.mainFrame.frameView.documentView.enclosingScrollView;
	[scrollView setHorizontalScrollElasticity:NSScrollElasticityNone];
	[scrollView setVerticalScrollElasticity:NSScrollElasticityNone];
}

#pragma mark - NSWindowDelegate

- (void)windowDidBecomeMain:(NSNotification *)notification {
	[self _saveWindowLocationAndSize];
}

- (void)windowDidMove:(NSNotification *)notification {
	[self _saveWindowLocationAndSize];
}

- (void)windowDidResize:(NSNotification *)notification {
	[self _saveWindowLocationAndSize];
}

@end
