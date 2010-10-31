//
//  SPSourceLocationTVC.h
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SPSourceTVC.h"

@class CLLocation;

@interface SPSourceLocationTVC : SPSourceTVC /* <MKReverseGeocoderDelegate> */ {
	NSArray *items;
//	MKReverseGeocoder *geo;
	NSString *geoString;
	
	NSString *locString;
	NSString *locDateString;
	NSString *timezone;
	NSArray *cities;
	
	CLLocation *cachedLocationFromMaps;
}

//@property (nonatomic, retain) MKReverseGeocoder *geo;
@property (nonatomic, retain) NSString *geoString;
@property (nonatomic, retain) CLLocation *cachedLocationFromMaps;
@property (nonatomic, retain) NSArray *cities;
@property (nonatomic, retain) NSString *locString;
@property (nonatomic, retain) NSString *locDateString;
@property (nonatomic, retain) NSString *timezone;

@end
