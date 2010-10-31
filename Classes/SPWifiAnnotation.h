//
//  SPWifiAnnotation.h
//  SpyPhone
//
//  Created by Nicolas Seriot on 10/31/10.
//  Copyright 2010 IICT. All rights reserved.
//

#import <MapKit/MapKit.h>

@protocol MKAnnotation;

@interface SPWifiAnnotation : NSObject <MKAnnotation> {
	NSDictionary *accessPoint;
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) NSDictionary *accessPoint;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

+ (SPWifiAnnotation *)annotationWithAccessPoint:(NSDictionary *)d;

- (NSString *)annotationViewIdentifier;

- (NSString *)title;
- (NSString *)subtitle;

@end
