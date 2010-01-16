//
//  SPSourceAddressBookTVC.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/16/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPSourceAddressBookTVC.h"
#import <AddressBook/AddressBook.h>


@implementation SPSourceAddressBookTVC

- (void)loadData {
	if(contentsDictionaries) return;

	ABAddressBookRef addressBook = ABAddressBookCreate();
	
	NSArray *people = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	
	NSMutableArray *allEmails = [NSMutableArray array];
	
	for(id record in people) {
		ABMultiValueRef emailsContainer = ABRecordCopyValue(record, kABPersonEmailProperty);
		CFArrayRef emails = ABMultiValueCopyArrayOfAllValues(emailsContainer);
		CFRelease(emailsContainer);
		if(emails) {
			[allEmails addObjectsFromArray:(NSArray *)emails];
			CFRelease(emails);
		}
	}
	
	[people release];
	
	CFRelease(addressBook);
		
	NSString *keyName = [NSString stringWithFormat:@"%d Email Addresses", [allEmails count]];
	self.contentsDictionaries = [NSArray arrayWithObject:[NSDictionary dictionaryWithObject:allEmails forKey:keyName]];
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
}


- (void)dealloc {
    [super dealloc];
}

@end
