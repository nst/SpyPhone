//
//  SPSourcePhoneTVC.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPSourcePhoneTVC.h"
#import "SPCell.h"
#import <AddressBook/AddressBook.h>

@implementation SPSourcePhoneTVC

@synthesize ICCID;
//@synthesize IMEI;
@synthesize IMSI;
@synthesize phone;
@synthesize UUID;
@synthesize lastDialed;
@synthesize lastContact;
@synthesize lastForwardNumber;

- (NSString *)nameOfABPersonWithID:(NSUInteger)recordID {
	ABAddressBookRef addressBook = ABAddressBookCreate();
	ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, recordID);

	if(!person) {
		CFRelease(addressBook);
		return nil;
	}

	NSString *firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	NSString *lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	
	NSString *fullName = nil;
	
	if(firstName && lastName) {
		fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
	} else if (firstName) {
		fullName = [NSString stringWithString:firstName];
	} else if (lastName) {
		fullName = [NSString stringWithString:lastName];
	}
	
	[firstName release];
	[lastName release];
	CFRelease(addressBook);
	
	return fullName;
}

- (void)loadData {
	if(contentsDictionaries) return;

	NSString *path = @"/var/mobile/Library/Preferences/com.apple.commcenter.plist";
	NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:path];
	self.ICCID = [NSString stringWithFormat:@"%@", [d valueForKey:@"ICCID"]];
	self.IMSI = [NSString stringWithFormat:@"%@", [d valueForKey:@"IMSI"]];
	
	self.phone = [[NSUserDefaults standardUserDefaults] valueForKey:@"SBFormattedPhoneNumber"];
	self.UUID = [[UIDevice currentDevice] uniqueIdentifier];	
	/*
	NSBundle *b = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Message.framework"];
	BOOL success = [b load];
    if(success) {
		Class NetworkController = NSClassFromString(@"NetworkController");
		id nc = [NetworkController sharedInstance];
		if([nc respondsToSelector:@selector(IMEI)]) {
			self.IMEI = [nc IMEI];
		}
	}
	if(!self.IMEI) self.IMEI = @"";
	*/
	path = @"/var/mobile/Library/Preferences/com.apple.mobilephone.settings.plist";
	d = [NSDictionary dictionaryWithContentsOfFile:path];
	
	NSString *callForwardingNumber = [d valueForKey:@"call-forwarding-number"];
	self.lastForwardNumber = callForwardingNumber ? [NSString stringWithFormat:@"%@", callForwardingNumber] : nil;

	path = @"/var/mobile/Library/Preferences/com.apple.mobilephone.plist";
	d = [NSDictionary dictionaryWithContentsOfFile:path];
	self.lastDialed = [NSString stringWithFormat:@"%@", [d valueForKey:@"DialerSavedNumber"]];
	
	self.contentsDictionaries = [NSMutableArray array];
	
	NSUInteger abId = [[d valueForKey:@"AddressBookLastDialedUid"] intValue];
	NSString *fullName = [self nameOfABPersonWithID:abId];
	self.lastContact = fullName;
	
	if(self.lastForwardNumber) {
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:self.lastForwardNumber], @"Call forwarding number", nil];
		[self.contentsDictionaries addObject:dict];
	}
	
	if(self.phone) {
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:self.phone], @"Phone number", nil];
		[self.contentsDictionaries addObject:dict];
	}

	if(self.lastContact) {
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:self.lastContact], @"Last contact called from list", nil];
		[self.contentsDictionaries addObject:dict];
	}
	
	if(self.lastDialed) {
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:self.lastDialed], @"Last dialed", nil];
		[self.contentsDictionaries addObject:dict];
	}
	
	if(self.ICCID) {
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:self.ICCID], @"ICCID (SIM card serial number)", nil];
		[self.contentsDictionaries addObject:dict];
	}

	if(self.IMSI) {
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:self.IMSI], @"IMSI (International Mobile Subscriber Identity)", nil];
		[self.contentsDictionaries addObject:dict];
	}
	
	if(self.UUID) {
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:self.UUID], @"Device UUID", nil];
		[self.contentsDictionaries addObject:dict];
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	[ICCID release];
//	[IMEI release];
	[IMSI release];
	[phone release];
	[UUID release];
	[lastForwardNumber release];
    [lastDialed release];
    [lastContact release];
    [super dealloc];
}

@end
