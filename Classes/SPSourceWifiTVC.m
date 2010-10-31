//
//  SPSourceWifiTVC.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPSourceWifiTVC.h"
#import "OUILookupTool.h"

@implementation SPSourceWifiTVC

- (void)loadData {
	
	//[OUILookupTool lookupBSSID:@"0:30:bd:97:7:72" delegate:self];

	if(contentsDictionaries) return;

	self.contentsDictionaries = [NSMutableArray array];

	NSString *path = @"/Library/Preferences/SystemConfiguration/com.apple.wifi.plist";
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
	if(!dict) return;
	
	NSArray *a = [dict valueForKey:@"List of known networks"];
	if(!a) return;
	
	for(NSDictionary *d in a) {
		[OUILookupTool locateWifiAccessPoint:d delegate:self];
		
		NSString *name = [d valueForKey:@"SSID_STR"];
		
		NSData *joined = [d valueForKey:@"lastJoined"];
		NSData *autoJoined = [d valueForKey:@"lastAutoJoined"];
		
		NSString *date = [NSString stringWithFormat:@"%@", autoJoined ? autoJoined : joined];

		[contentsDictionaries addObject:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:name] forKey:date]];
	}
}

#pragma mark OUILookupTool

- (void)OUILookupTool:(OUILookupTool *)ouiLookupTool didLocateAccessPoint:(NSDictionary *)ap {
	//NSLog(@"-- %@", ap);
}

@end
