//
//  SPMapVC.h
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/21/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class SPImageVC;

@interface SPImageMapVC : UIViewController <MKMapViewDelegate> {
	NSArray *annotations;
	
	IBOutlet MKMapView *mapView;
	IBOutlet SPImageVC *imageVC;
}

@property (nonatomic, retain) NSArray *annotations;

- (void)addAnnotation:(id <MKAnnotation>)annotation;

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;

@end
