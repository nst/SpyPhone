//
//  SPSourceTVC.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/17/09.
//  Copyright 2009. All rights reserved.
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPSourceTVC.h"
#import "SPCell.h"

@implementation SPSourceTVC

@synthesize contentsDictionaries;

- (UIImage *)image {
	NSString *className = NSStringFromClass([self class]);
	NSString *name = nil;
	
	if([className hasPrefix:@"SPSource"] && [className hasSuffix:@"TVC"]) {
		NSRange range = NSMakeRange(8, [className length] - 3 - 8);
		name = [className substringWithRange:range];
	}
	
	NSString *imageName = [name stringByAppendingPathExtension:@"png"];
	return [UIImage imageNamed:imageName];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)loadData {
	// to be overriden by subclasses
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if(!contentsDictionaries) [self loadData];	
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [contentsDictionaries count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSDictionary *d = [contentsDictionaries objectAtIndex:section];
	return [[d allKeys] lastObject];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	NSDictionary *d = [contentsDictionaries objectAtIndex:section];
	NSArray *a = [[d allValues] lastObject];
	return [a count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *SourceCellIdentifier = @"SPCell";
	
	SPCell *cell = (SPCell *)[tableView dequeueReusableCellWithIdentifier:SourceCellIdentifier];
	if (cell == nil) {
		cell = (SPCell *)[[[NSBundle mainBundle] loadNibNamed:@"SPCell" owner:self options:nil] lastObject];
	}
	
	NSArray *a = [[[contentsDictionaries objectAtIndex:indexPath.section] allValues] lastObject];
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.textLabel.adjustsFontSizeToFitWidth = YES;
	cell.textLabel.text = [a objectAtIndex:indexPath.row];
	return cell;
}

@end
