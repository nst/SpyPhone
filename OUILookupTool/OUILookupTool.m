//
//  OUILookupTool.m
//  OUILookup
//
//  Created by Nicolas Seriot on 10/31/10.
//  Copyright 2010 IICT. All rights reserved.
//

#import "OUILookupTool.h"
#import "JSON.h"

@implementation OUILookupTool

@synthesize delegate;

- (void)fetchLocationForAccessPointInNewThread:(NSMutableDictionary *)ap {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *aBSSID = [ap valueForKey:@"BSSID"];
	
	NSDictionary *d = [NSDictionary dictionaryWithObject:aBSSID forKey:@"mac_address"];
	NSArray *wifiTowers = [NSArray arrayWithObject:d];
	
	NSDictionary *postDictionary = [[NSMutableDictionary alloc] initWithCapacity:3];
	[postDictionary setValue:@"1.1.0" forKey:@"version"];
	[postDictionary setValue:@"ouilookup" forKey:@"host"];
	[postDictionary setValue:wifiTowers forKey:@"wifi_towers"];
	
	NSString *postJSON = [postDictionary JSONRepresentation];
	[postDictionary release];
	
	NSData *data = [postJSON dataUsingEncoding:NSUTF8StringEncoding];
	
	NSURL *url = [NSURL URLWithString:@"http://66.249.92.104/loc/json"];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPBody:data];
	[request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
	NSString *contentLength = [NSString stringWithFormat:@"%d", [data length]];
	[request setValue:contentLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"www.google.com" forHTTPHeaderField:@"Host"];
	
	NSError *error = nil;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
	NSDictionary *responseDict = [responseString JSONValue];
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:ap, @"originalDict", responseDict, @"responseDict", nil];
	
	[self performSelectorOnMainThread:@selector(didFinishLookup:) withObject:params waitUntilDone:YES];
	
	[pool release];
}

- (void)didFinishLookup:(NSDictionary *)params {
//	NSLog(@"-- %@", ap);

	NSMutableDictionary *ap = [params objectForKey:@"originalDict"];
	NSDictionary *responseDict = [params objectForKey:@"responseDict"];
	
	[ap addEntriesFromDictionary:responseDict];
	
	[delegate OUILookupTool:self didLocateAccessPoint:ap];
}

- (void)dealloc {
	[delegate release];
	[super dealloc];
}

+ (NSString *)formattedBSSID:(NSString *)aBSSID {
	NSArray *comps = [aBSSID componentsSeparatedByString:@":"];
	
	if([comps count] != 6) return nil;
	
	NSMutableArray *a = [NSMutableArray array];
	
	for(NSString *comp in comps) {
		NSUInteger length = [comp length];
		if(length == 0 || length > 2) return nil;

		NSString *s = length == 2 ? comp : [@"0" stringByAppendingString:comp];
		[a addObject:s];
	}
	
	return [a componentsJoinedByString:@":"];
}

+ (OUILookupTool *)locateWifiAccessPoint:(NSMutableDictionary *)ap delegate:(NSObject <OUILookupToolDelegate> *)aDelegate {
	NSString *aBSSID = [ap valueForKey:@"BSSID"];
	NSString *formattedBSSID = [self formattedBSSID:aBSSID];	
	if(formattedBSSID == nil) return nil;
	
	[ap setValue:formattedBSSID forKey:@"BSSID"];
	
	OUILookupTool *olt = [[OUILookupTool alloc] init];
	olt.delegate = aDelegate;
	
	[NSThread detachNewThreadSelector:@selector(fetchLocationForAccessPointInNewThread:) toTarget:olt withObject:ap];
	return [olt autorelease];
}

@end
