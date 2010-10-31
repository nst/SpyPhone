//
//  SPWifiMapVC.h
//  SpyPhone
//
//  Created by Nicolas Seriot on 10/31/10.
//  Copyright 2010 IICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SPWifiMapVC : UIViewController {
	NSArray *annotations;
	
	IBOutlet MKMapView *mapView;
}

@property (nonatomic, retain) NSArray *annotations;

//- (void)addAnnotation:(id <MKAnnotation>)annotation;

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;

@end
