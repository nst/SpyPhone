//
//  SPSourceLocationTVC.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPSourceLocationTVC.h"
#import <CoreLocation/CoreLocation.h>
#import "SPImageMapVC.h"
#import "SPImageAnnotation.h"

@implementation SPSourceLocationTVC

@synthesize cities;
//@synthesize geo;
@synthesize geoString;
@synthesize locString;
@synthesize locDateString;
@synthesize timezone;
@synthesize cachedLocationFromMaps;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 0 && indexPath.row == 0 && cachedLocationFromMaps) {
		SPImageMapVC *mapVC = [[SPImageMapVC alloc] initWithNibName:@"SPImageMapVC" bundle:[NSBundle mainBundle]];
		[self.navigationController pushViewController:mapVC animated:YES];
		SPImageAnnotation *annotation = [SPImageAnnotation annotationWithCoordinate:cachedLocationFromMaps.coordinate date:nil path:nil];
        if(annotation)
            [mapVC addAnnotation:annotation];
	}
}

- (void)loadData {
	if(contentsDictionaries) return;

	NSString *path = @"/var/mobile/Library/Preferences/com.apple.Maps.plist";
	NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:path];
	NSData *data = [d valueForKey:@"UserLocation"];
	CLLocation *loc = data ? [NSKeyedUnarchiver unarchiveObjectWithData:data] : nil;
	self.cachedLocationFromMaps = loc;
	self.locString = @"";
	self.locDateString = @"";
	if(loc) {
		self.locString = [NSString stringWithFormat:@"%f, %f", loc.coordinate.latitude, loc.coordinate.longitude];
		self.locDateString = [NSString stringWithFormat:@"%@", loc.timestamp];
	}
	
	path = @"/var/mobile/Library/Preferences/com.apple.preferences.datetime.plist";
	d = [NSDictionary dictionaryWithContentsOfFile:path];	
	self.timezone = [NSString stringWithFormat:@"%@", [d valueForKey:@"timezone"]];

	path = @"/var/mobile/Library/Preferences/com.apple.weather.plist";
	d = [NSDictionary dictionaryWithContentsOfFile:path];
	NSMutableArray *citiesNames = [NSMutableArray array];
	for(NSDictionary *dict in [d valueForKey:@"Cities"]) {
		[citiesNames addObject:[dict objectForKey:@"Name"]];
	}
	self.cities = citiesNames;

	self.contentsDictionaries = [NSArray arrayWithObjects:
			[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:locString], @"Location", nil],
			[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:locDateString], @"Location Date", nil],
			[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:timezone], @"Timezone", nil],
			[NSDictionary dictionaryWithObjectsAndKeys:cities, @"Weather Cities", nil],
			nil];
	/*
	self.geo = [[[MKReverseGeocoder alloc] initWithCoordinate:loc.coordinate] autorelease];
	geo.delegate = self;
	[geo start];
	 */
}

- (void)dealloc {
	[items release];
//	[geo release];
	[geoString release];
	[cachedLocationFromMaps release];
    [super dealloc];
}
/*
#pragma mark MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	self.geoString = [NSString stringWithFormat:@"%@ %@", placemark.locality, placemark.country];
	
	self.contentsDictionaries = [NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:[NSString stringWithFormat:@"%@ %@", locString, geoString]], @"Location", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:locDateString], @"Location Date", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:timezone], @"Timezone", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:cities, @"Weather Cities", nil],
		nil];

	[self.tableView reloadData];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	NSLog(@"-- Error: %@", [error description]);
}
*/
@end
