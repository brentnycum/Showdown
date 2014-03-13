//
//  SDNMarkdownDocumentWindowController.h
//  ShowDown
//
//  Created by Brent Nycum on 3/6/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <Cocoa/Cocoa.h>

@interface SDNMarkdownDocumentWindowController : NSWindowController <NSWindowDelegate> {
	CGPoint _pageOffset;
}

@property (weak) IBOutlet WebView *webView;

- (void)reloadWebView;

@end
