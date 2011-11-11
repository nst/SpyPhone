//
//  SPImageAnnotation.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/21/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPImageAnnotation.h"


@implementation SPImageAnnotation

@synthesize title;
@synthesize path;
@synthesize coordinate;

- (BOOL)hasValidCoordinates {
    return coordinate.longitude != 0.0 && coordinate.latitude != 0.0;
}

+ (SPImageAnnotation *)annotationWithCoordinate:(CLLocationCoordinate2D)coord date:(NSDate *)date path:(NSString *)path {
    
	SPImageAnnotation *annotation = [[SPImageAnnotation alloc] init];
	annotation.coordinate = coord;
	annotation.path = path;

	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy-MM-dd HH:mm"];	
	annotation.title = [df stringFromDate:date];
	[df release];
	
	return [annotation autorelease];
}

- (void)dealloc {
	[path release];
	[title release];
	[super dealloc];
}

- (NSString *)annotationViewIdentifier {
	return title;
}

@end
