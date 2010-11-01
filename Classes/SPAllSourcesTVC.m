//
//  SourcesTVController.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPAllSourcesTVC.h"
#import "SPSourceTVC.h"
#import "SPCell.h"

@implementation SPAllSourcesTVC

@synthesize sources;

- (void)loadSources {
	if(sources) return;
	
	if(!self.isViewLoaded) [self loadView];
	
 	self.sources = [NSArray arrayWithObjects:
					sourceEmailTVC,
					sourceWifiTVC,
					sourcePhoneTVC,
					sourceLocationTVC,
					sourcePhotosTVC,
					sourceAddressBookTVC,
					sourceKeyboardTVC,
					nil];
}

- (NSString *)emailForReport {
	if(!self.isViewLoaded) [self loadView];

	return [sourceEmailTVC emailForReport];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
 
	if(!sources) [self loadSources];
}

- (NSString *)report {
	[self loadSources];
	
	NSMutableString *s = [NSMutableString string];
	
	for(SPSourceTVC *source in sources) {
		[s appendString:[NSString stringWithFormat:@"----- %@ -----\n\n", [source.title uppercaseString]]];
		
		[source loadData];
		NSArray *a = source.contentsDictionaries;
		for(NSDictionary *d in a) {
			[s appendString:[NSString stringWithFormat:@"[[ %@ ]]\n", [[d allKeys] lastObject]]];
			[s appendString:[[[d allValues] lastObject] componentsJoinedByString:@"\n"]];
			[s appendString:@"\n\n"];
		}
		//[s appendString:@"\n"];
	}
	
	return s;
}

- (void)dealloc {
	[sources release];
    [super dealloc];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return [sources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *SourceCellIdentifier = @"SPCell";
	
	SPCell *cell = (SPCell *)[tableView dequeueReusableCellWithIdentifier:SourceCellIdentifier];
	if (cell == nil) {
		cell = (SPCell *)[[[NSBundle mainBundle] loadNibNamed:@"SPCell" owner:self options:nil] lastObject];
	}
	
	SPSourceTVC *sourceTVC = [sources objectAtIndex:indexPath.row];	
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = [sourceTVC title];
	cell.imageView.image = [sourceTVC image];
	return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIViewController *sourceVC = [sources objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:sourceVC animated:YES];
}

@end
