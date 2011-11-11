//
//  UIImage+GPS.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/21/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "UIImage+GPS.h"
#import "EXF.h"

@implementation UIImage (GPS)

// adapted from http://davidjhinson.wordpress.com/2009/06/05/you-can-have-it-in-any-color-as-long-as-its-black/
+(CLLocationCoordinate2D)coordinatesOfImageAtPath:(NSString *)path {
	CLLocationCoordinate2D coord = {0.0, 0.0};
	    
	NSData *data =[NSData dataWithContentsOfFile:path];
	if(!data) return coord;
	
	EXFJpeg* jpegScanner = [[EXFJpeg alloc] init];
	[jpegScanner scanImageData:data];
	EXFGPSLoc *lat   = [jpegScanner.exifMetaData tagValue:[NSNumber numberWithInt:EXIF_GPSLatitude]];
	NSString *latRef = [jpegScanner.exifMetaData tagValue:[NSNumber numberWithInt:EXIF_GPSLatitudeRef]];
	EXFGPSLoc *lon   = [jpegScanner.exifMetaData tagValue:[NSNumber numberWithInt:EXIF_GPSLongitude]];
	NSString *lonRef = [jpegScanner.exifMetaData tagValue:[NSNumber numberWithInt:EXIF_GPSLongitudeRef]];
	[jpegScanner release];
    
	if([latRef length] == 0 || [lonRef length] == 0) return coord;
	
	coord.latitude = [[NSString stringWithFormat:@"%f", lat.degrees.numerator + ((float)lat.minutes.numerator / (float)lat.minutes.denominator) / 60.0] floatValue];
	coord.longitude = [[NSString stringWithFormat:@"%f", lon.degrees.numerator + ((float)lon.minutes.numerator / (float)lon.minutes.denominator) / 60.0] floatValue];
	
	if([[latRef substringToIndex:1] isEqualToString:@"S"]) coord.latitude = -coord.latitude;
	if([[lonRef substringToIndex:1] isEqualToString:@"W"]) coord.longitude = -coord.longitude;
	
	return coord;
}

@end
