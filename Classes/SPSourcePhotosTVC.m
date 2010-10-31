//
//  SPSourcePhotosTVC.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import <CoreLocation/CoreLocation.h>
#import "SPSourcePhotosTVC.h"
#import "UIImage+GPS.h"
#import "SPImageMapVC.h"
#import "SPImageVC.h"
#import "SPImageAnnotation.h"

@implementation SPSourcePhotosTVC

@synthesize annotations;
@synthesize coordinates;
@synthesize mapVC;
@synthesize imageVC;

- (void)mapButtonClicked:(id)sender {
	mapVC.annotations = annotations;
	[self.navigationController pushViewController:mapVC animated:YES];
}

- (NSArray *)jpgPaths {
	NSMutableArray *a = [NSMutableArray array];
	
	NSString *path = @"/var/mobile/Media/PhotoData/100APPLE";
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentsDirectory = [paths count] ? [paths objectAtIndex:0] : nil;
//	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"../../../Media/DCIM"];
//	path = [path stringByStandardizingPath];
	
	NSDirectoryEnumerator *dirEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];

	BOOL isDir;

	BOOL exists;
	NSString *filePath = nil;

	NSString *dirContent = nil;	
	while(dirContent = [dirEnumerator nextObject]) {
		filePath = [path stringByAppendingPathComponent:dirContent];
		exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
		if(exists && !isDir && [[filePath pathExtension] isEqualToString:@"THM"]) {
			[a addObject:filePath];
		}
	}
	
	return a;
}

- (void)readPhotosInNewThread {

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSEnumerator *e = [[self jpgPaths] reverseObjectEnumerator];

	NSAutoreleasePool *subpool = [[NSAutoreleasePool alloc] init];

	NSString *s = nil;
	while(s = [e nextObject]) {
		[subpool release];
		subpool = [[NSAutoreleasePool alloc] init];
		
		CLLocationCoordinate2D coord = [UIImage coordinatesOfImageAtPath:s];
		//if(coord.latitude == 0.0 && coord.longitude == 0.0) continue;
		
		NSNumber *lat = [NSNumber numberWithDouble:coord.latitude];
		NSNumber *lon = [NSNumber numberWithDouble:coord.longitude];
		[coordinates addObject:[NSArray arrayWithObjects:lat, lon, nil]];
		
		NSString *coordString = (lat && lon) ? [NSString stringWithFormat:@"%@, %@", lat, lon] : nil;
		
		
		NSError *error = nil;
		NSDictionary *d = [[NSFileManager defaultManager] attributesOfItemAtPath:s error:&error];
		if(!d) {
			NSLog(@"Error, can't read attributes of file at path %@, %@ %@", s, [error description], [error userInfo]);
			continue;
		}
		NSDate *date = [d fileModificationDate];
		NSString *dateString = date ? [date description] : @"";

		SPImageAnnotation *annotation = [SPImageAnnotation annotationWithCoordinate:coord date:date path:s];
		[annotations performSelectorOnMainThread:@selector(addObject:) withObject:annotation waitUntilDone:YES];
		
		NSDictionary *cd = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:coordString] forKey:dateString];
		[contentsDictionaries performSelectorOnMainThread:@selector(addObject:) withObject:cd waitUntilDone:YES];
		
		[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
		
		[mapVC performSelectorOnMainThread:@selector(addAnnotation:) withObject:annotation waitUntilDone:YES];
	}
	
	[subpool release];
	[pool release];
}

- (void)loadData {
	
	if(contentsDictionaries) return;

	UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(mapButtonClicked:)];
	super.navigationItem.rightBarButtonItem = mapButton;
	
	self.contentsDictionaries = [NSMutableArray array];
	self.annotations = [NSMutableArray array];

	[NSThread detachNewThreadSelector:@selector(readPhotosInNewThread) toTarget:self withObject:nil];
}

- (void)dealloc {
	[annotations release];
	[coordinates release];
	[mapVC release];
	[imageVC release];
	[super dealloc];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(indexPath.section >= [annotations count]) return;
	
	NSString *path = [[annotations objectAtIndex:indexPath.section] path];
	
	NSString *imageName = [[path lastPathComponent] stringByDeletingPathExtension];
	
	// NSString *thmPath = [NSString stringWithFormat:@"/var/mobile/Media/DCIM/110APPLE/.MISC/%@.THM", imageName];
	
	imageVC.path = path;
	imageVC.title = imageName;
	[self.navigationController pushViewController:imageVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

@end
