//
//  SPMapVC.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/21/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPImageMapVC.h"
#import "SPImageVC.h"

@implementation SPImageMapVC

@synthesize annotations;

- (void)addAnnotation:(id <MKAnnotation>)annotation {
	[mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	if([annotation isKindOfClass:[MKUserLocation class]]) return nil;
	
    NSString *annID = @"SPImageAnnotation";
    MKAnnotationView *av = [aMapView dequeueReusableAnnotationViewWithIdentifier:annID];
	
	if(av == nil) {
		av = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annID] autorelease];
		[av setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
		av.canShowCallout = YES;
	}
	return av;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

	NSString *path = [(id)view.annotation path];
	
	NSError *error = nil;
	NSDictionary *d = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
	if(!d) {
		NSLog(@"Error: can't read file attributes at path %@, %@ %@", path, [error description], [error userInfo]);
	}
	
	NSDate *date = [d fileModificationDate];	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy-MM-dd HH:mm"];	
	imageVC.title = error ? @"Photo" : [df stringFromDate:date];
	[df release];
	
	imageVC.path = path;
	[self.navigationController pushViewController:imageVC animated:YES];	
}

- (void)viewDidLoad {
    [super viewDidLoad];

	//mapView.showsUserLocation = YES;

	if([annotations count] == 0) return;
	
	MKCoordinateRegion region;
	MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.03);
	
	for(id <MKAnnotation>annotation in annotations) {
		region = [mapView regionThatFits:MKCoordinateRegionMake(annotation.coordinate, span)];
	}
	
	[mapView setRegion:region];
	[mapView addAnnotations:annotations];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.annotations = nil;
}

- (void)dealloc {
	[annotations release];
    [super dealloc];
}

@end
