//
//  UIImage+GPS.h
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/21/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface UIImage (GPS)

+(CLLocationCoordinate2D)coordinatesOfImageAtPath:(NSString *)path;

@end
