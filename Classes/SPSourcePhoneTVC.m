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
#import "FMDatabase.h"
#import "NSNumber+SP.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation SPSourcePhoneTVC

@synthesize ICCID;
//@synthesize IMEI;
@synthesize IMSI;
@synthesize phone;
@synthesize UUID;
@synthesize lastDialed;
@synthesize lastContact;
@synthesize lastForwardNumber;
@synthesize callHistories;
@synthesize prettyBytesSent;
@synthesize prettyBytesReceived;

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

	NSString *path = @"/private/var/wireless/Library/Preferences/com.apple.commcenter.plist";
	NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:path];
	self.ICCID = [d valueForKey:@"ICCID"];
	self.IMSI = [d valueForKey:@"IMSI"];
	
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
	NSString *s = [NSString stringWithFormat:@"%@", [d valueForKey:@"DialerSavedNumber"]];
	self.lastDialed = [s length] == 0 ? nil : s;
	
	self.contentsDictionaries = [NSMutableArray array];
	
	NSUInteger abId = [[d valueForKey:@"AddressBookLastDialedUid"] intValue];
	NSString *fullName = [self nameOfABPersonWithID:abId];
	self.lastContact = fullName;
	
	/**/
	
	self.callHistories = [NSMutableArray array];
	
	FMDatabase *db = [FMDatabase databaseWithPath:@"/private/var/wireless/Library/CallHistory/call_history.db"];
	
//	NSLocale *usLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
	
	if([db open]) {
		FMResultSet *rs = [db executeQuery:@"select address, date, flags, duration from call order by date"];
		while ([rs next]) {
			int dateInt = [rs intForColumn:@"date"];
			NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateInt];
			NSDateFormatter *df = [[NSDateFormatter alloc] init];
			[df setDateFormat:@"YYYY-MM-dd HH:mm"];
			NSString *dateString = [df stringFromDate:date]; 
			
			int flagsInt = [rs intForColumn:@"flags"];
			NSString *flags = @"?";
			switch (flagsInt) {
				case 4: flags = @"<-"; break;
				case 5: flags = @"->"; break;
				default: break;
			}
			
			int durationInt = [rs intForColumn:@"duration"];
			NSString *duration = [NSString stringWithFormat:@"%d:%02d", durationInt / 60, durationInt % 60];
			
			NSString *logLine = [NSString stringWithFormat:@"%@ %@ %@ (%@)", dateString, flags, [rs stringForColumn:@"address"], duration];
			[callHistories addObject:logLine];
		}
		[rs close];  
		
		rs = [db executeQuery:@"select bytes_rcvd, bytes_sent from data where pdp_ip = 0"];
		while ([rs next]) {
			double bytes_sent = [rs doubleForColumn:@"bytes_sent"];
			double bytes_rcvd = [rs doubleForColumn:@"bytes_rcvd"];
			
			self.prettyBytesSent = [[NSNumber numberWithDouble:bytes_sent] prettyBytes];
			self.prettyBytesReceived = [[NSNumber numberWithDouble:bytes_rcvd] prettyBytes];
		}
		
		[rs close];
		
		[db close];
	}
	
	/**/

	CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
	CTCarrier *carrier = networkInfo.subscriberCellularProvider;
	[networkInfo release];
	
	NSString *s1 = [NSString stringWithFormat:@"%@ %@", [carrier isoCountryCode], [carrier carrierName]];
	NSString *s2 = [NSString stringWithFormat:@"country %@ network %@", [carrier mobileCountryCode], [carrier mobileNetworkCode]];
	NSArray *carrierInfoArray = [NSArray arrayWithObjects:s1, s2, nil];
	NSDictionary *carrierInfo = [NSDictionary dictionaryWithObjectsAndKeys:carrierInfoArray, @"Carrier Info", nil];

	/**/
	
	if(carrierInfo) {
		[self.contentsDictionaries addObject:carrierInfo];	
	}
	
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
	
	if(prettyBytesSent) {
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:prettyBytesSent], @"Cellular Network - Bytes Sent", nil];
		[self.contentsDictionaries addObject:dict];		
	}

	if(prettyBytesReceived) {
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:prettyBytesReceived], @"Cellular Network - Bytes Received", nil];
		[self.contentsDictionaries addObject:dict];		
	}

	if(callHistories) {
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:callHistories, @"Call History", nil];
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
	[callHistories release];
	[prettyBytesSent release];
	[prettyBytesReceived release];

    [super dealloc];
}

@end
