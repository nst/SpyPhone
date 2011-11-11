//
//  SPImageAnnotation.h
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/21/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import <MapKit/MapKit.h>

@protocol MKAnnotation;

@interface SPImageAnnotation : NSObject <MKAnnotation> {
	NSString *title;
	NSString *path;
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

+ (SPImageAnnotation *) annotationWithCoordinate:(CLLocationCoordinate2D)coord date:(NSDate *)date path:(NSString *)path;

- (NSString *)annotationViewIdentifier;
- (BOOL)hasValidCoordinates;

@end
