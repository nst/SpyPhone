//
//  SPWifiMapVC.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 10/31/10.
//  Copyright 2010 IICT. All rights reserved.
//

#import "SPWifiMapVC.h"


@implementation SPWifiMapVC

@synthesize annotations;

//- (void)setAnnotations:(NSArray *)someAnnotations {
//	[mapView removeAnnotations:mapView.annotations];
//
//	[annotations autorelease];
//	annotations = [someAnnotations retain];
//	
//	[mapView addAnnotations:annotations];
//}

- (void)loadView {
	[super loadView];
	
	self.title = @"Wifi Map";
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
		
	[mapView removeAnnotations:mapView.annotations];
	[mapView addAnnotations:annotations];

	id <MKAnnotation>annotation = [annotations lastObject];
	MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.03);
	MKCoordinateRegion region = [mapView regionThatFits:MKCoordinateRegionMake(annotation.coordinate, span)];

    @try {
	[mapView setRegion:region animated:NO];	
    } @catch (NSException *exception) {
        NSLog(@"-- %@", exception);
    } @finally {
    }
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];


	if([annotations count] == 1) [mapView selectAnnotation:[annotations lastObject] animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	if([annotation isKindOfClass:[MKUserLocation class]]) return nil;
	
    NSString *annID = @"SPWifiAnnotation";
    MKAnnotationView *av = [aMapView dequeueReusableAnnotationViewWithIdentifier:annID];
	
	if(av == nil) {
		av = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annID] autorelease];
		av.canShowCallout = YES;
	}
	return av;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)mapView:(MKMapView *)aMapView didAddAnnotationViews:(NSArray *)views {
    [aMapView selectAnnotation:[aMapView.annotations lastObject] animated:YES];
}

- (void)dealloc {
	[annotations release];
    [super dealloc];
}

@end
