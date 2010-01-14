//
//  SpyPhoneAppDelegate.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright IICT 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SpyPhoneAppDelegate.h"

@interface UIApplication (tvout)
- (void) startTVOut;
@end 

@implementation SpyPhoneAppDelegate

@synthesize window;
@synthesize tabBarController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
	
	BOOL isTVOutEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"TVOutEnabled"];
	if(isTVOutEnabled) {
		[[UIApplication sharedApplication] startTVOut];
	}
}


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

