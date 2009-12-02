//
//  SPSourceYouTubeTVC.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPSourceYouTubeTVC.h"
#import "SPCell.h"

@implementation SPSourceYouTubeTVC

@synthesize lastSearch;
@synthesize bookmarks;
@synthesize history;

- (void)loadData {
	if(contentsDictionaries) return;

	NSString *path = @"/var/mobile/Library/Preferences/com.apple.youtube.plist";
	NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:path];
		
	self.bookmarks = [d valueForKey:@"Bookmarks"];
	self.history = [d valueForKey:@"History"];
	self.lastSearch = [d valueForKey:@"lastSearch"];
	
	if(!lastSearch) self.lastSearch = @"";
	if(!bookmarks) self.bookmarks = [NSArray array];
	if(!history) self.history = [NSArray array];

	self.contentsDictionaries = [NSArray arrayWithObjects:
								 [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:lastSearch] forKey:@"Last Search"],
								 [NSDictionary dictionaryWithObject:bookmarks forKey:@"Bookmarks"],
								 [NSDictionary dictionaryWithObject:history forKey:@"History"], nil];
}

-(void)dealloc {
	[bookmarks release];
	[history release];
	[lastSearch release];
	[super dealloc];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *s = nil;
	if(indexPath.section == 0) {
		s = [[NSString stringWithFormat:@"http://youtube.com/results?search_query=%@", lastSearch] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	} else if (indexPath.section == 1) {
		NSString *x = [bookmarks objectAtIndex:indexPath.row];
		s = [NSString stringWithFormat:@"http://youtube.com/watch?v=%@", x];
	} else if (indexPath.section == 2) {
		NSString *x = [history objectAtIndex:indexPath.row];
		s = [NSString stringWithFormat:@"http://youtube.com/watch?v=%@", x];
	}
	NSURL *url = [NSURL URLWithString:s];
	[[UIApplication sharedApplication] openURL:url];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

@end
