//
//  SPWebViewVC.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPWebViewVC.h"


@implementation SPWebViewVC

@synthesize webView;
@synthesize request;

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
	[webView loadRequest:request];
}

- (void)viewDidDisappear:(BOOL)animated {
	[webView loadRequest:nil];
}

- (void)dealloc {
	[request release];
	[webView release];
    [super dealloc];
}


@end
