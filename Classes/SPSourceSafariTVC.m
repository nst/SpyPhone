//
//  SPSourceSafariTVC.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

// 		<meta name="title" content="CATcerto. ENTIRE PERFORMANCE. Mindaugas Piecaitis, Nora The Piano Cat">

#import "SPSourceSafariTVC.h"
#import "SPCell.h"
#import "SPWebViewVC.h"

@implementation SPSourceSafariTVC

@synthesize webViewVC;

- (void)loadData {
	if(contentsDictionaries) return;

	self.contentsDictionaries = [NSMutableArray array];
	
	NSString *path = @"/var/mobile/Library/Preferences/com.apple.mobilesafari.plist";
	NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:path];
	NSArray *searches = [d valueForKey:@"RecentSearches"];
	if(!searches) searches = [NSArray array];
	
	[contentsDictionaries addObject:[NSDictionary dictionaryWithObject:searches forKey:@"Recent Searches"]];
}

-(void)dealloc {
	[webViewVC release];
	[super dealloc];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray *searches = [[[contentsDictionaries objectAtIndex:indexPath.section] allValues] lastObject];
	NSString *q = [[searches objectAtIndex:indexPath.row] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *s = [NSString stringWithFormat:@"http://www.google.com/search?q=%@", q];
	NSURL *url = [NSURL URLWithString:s];
	NSURLRequest *r = [NSURLRequest requestWithURL:url];
	webViewVC.request = r;
	[self.navigationController pushViewController:webViewVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

@end
