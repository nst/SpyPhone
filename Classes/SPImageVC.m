//
//  SPImageVC.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/21/09.
//  Copyright 2009. All rights reserved.
//

#import "SPImageVC.h"


@implementation SPImageVC

@synthesize imageView;
@synthesize path;

- (void)viewDidAppear:(BOOL)animated {
	imageView.image = [UIImage imageWithContentsOfFile:path];
}

- (void)viewDidDisappear:(BOOL)animated {
	imageView.image = nil;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[path release];
	[imageView release];
    [super dealloc];
}


@end
