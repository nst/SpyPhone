//
//  SpyPhoneAppDelegate.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright IICT 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SpyPhoneAppDelegate.h"
#import "TVOutManager.h"

@implementation SpyPhoneAppDelegate

@synthesize window;
@synthesize tabBarController;

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];	

	/*
	 // FIXME: TVOut does not work so well
	 
	 1. start SP, suspend
	 2. plug
	 3. start SP, suspend
	 4. start SP, SP quits
	 5. start SP
	 */
	
	BOOL isTVOutEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"TVOutEnabled"];
	if(isTVOutEnabled) {
		[TVOutManager sharedInstance].tvSafeMode = NO;
		[[TVOutManager sharedInstance] startTVOut];
	}	
}

@end

