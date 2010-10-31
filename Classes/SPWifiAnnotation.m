//
//  SPWifiAnnotation.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 10/31/10.
//  Copyright 2010 IICT. All rights reserved.
//

#import "SPWifiAnnotation.h"


@implementation SPWifiAnnotation

@synthesize coordinate;
@synthesize accessPoint;

- (NSString *)title {
	return [accessPoint valueForKey:@"SSID_STR"];
}

- (NSString *)subtitle {
	NSDate *joined = [accessPoint valueForKey:@"lastJoined"];
	NSDate *autoJoined = [accessPoint valueForKey:@"lastAutoJoined"];

	NSDate *date = autoJoined ? autoJoined : joined;

	return [date description];
}

+ (SPWifiAnnotation *)annotationWithAccessPoint:(NSDictionary *)ap {
	NSString *latitude = [ap valueForKeyPath:@"location.latitude"];
	NSString *longitude = [ap valueForKeyPath:@"location.longitude"];
	
	if(latitude == nil || longitude == nil) return nil;
		
	SPWifiAnnotation *annotation = [[SPWifiAnnotation alloc] init];
	annotation.accessPoint = ap;
	annotation.coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);;
	return [annotation autorelease];
}

- (void)dealloc {
	[accessPoint release];
	[super dealloc];
}

- (NSString *)annotationViewIdentifier {
	return [accessPoint valueForKey:@"BSSID"];
}

@end
