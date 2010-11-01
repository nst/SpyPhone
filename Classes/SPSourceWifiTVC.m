//
//  SPSourceWifiTVC.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPSourceWifiTVC.h"
#import "OUILookupTool.h"
#import "SPWifiMapVC.h"
#import "SPWifiAnnotation.h"
#import "SPCell.h"

@implementation SPSourceWifiTVC

@synthesize annotations;
@synthesize accessPoints;
@synthesize mapVC;

- (void)loadData {
	
	if(contentsDictionaries) return;

	UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(mapButtonClicked:)];
	super.navigationItem.rightBarButtonItem = mapButton;
	
	self.contentsDictionaries = [NSMutableArray array];
	
	self.annotations = [NSMutableArray array];
	
	self.accessPoints = [NSMutableArray array];

	NSString *path = @"/Library/Preferences/SystemConfiguration/com.apple.wifi.plist";
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
	if(!dict) return;
	
	NSArray *a = [dict valueForKey:@"List of known networks"];
	if(!a) return;
	
	for(NSDictionary *d in a) {
		NSMutableDictionary *md = [NSMutableDictionary dictionaryWithDictionary:d];
		
		[OUILookupTool locateWifiAccessPoint:md delegate:self];
		
		NSString *name = [d valueForKey:@"SSID_STR"];
		
		NSDate *joined = [md valueForKey:@"lastJoined"];
		NSDate *autoJoined = [md valueForKey:@"lastAutoJoined"];
		
		NSString *date = [NSString stringWithFormat:@"%@", autoJoined ? autoJoined : joined];

		[contentsDictionaries addObject:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:name] forKey:date]];
		[accessPoints addObject:md];
	}
}

- (void)mapButtonClicked:(id)sender {
	mapVC.annotations = annotations;
	[self.navigationController pushViewController:mapVC animated:YES];
}

- (void)dealloc {
	[accessPoints release];
	[annotations release];
	[mapVC release];
	[super dealloc];
}

#pragma mark OUILookupTool

- (void)OUILookupTool:(OUILookupTool *)ouiLookupTool didLocateAccessPoint:(NSDictionary *)ap {
	//NSLog(@"-- %@", ap);
	
	[accessPoints addObject:ap];
	
	SPWifiAnnotation *annotation = [SPWifiAnnotation annotationWithAccessPoint:ap];
	
	if(annotation) [annotations addObject:annotation];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		
	NSDictionary *ap = [accessPoints objectAtIndex:indexPath.section];
	
	SPWifiAnnotation *annotation = [SPWifiAnnotation annotationWithAccessPoint:ap];
	
	if(annotation == nil) return;
	
	mapVC.annotations = [NSArray arrayWithObject:annotation];

	[self.navigationController pushViewController:mapVC animated:YES];
}

@end
