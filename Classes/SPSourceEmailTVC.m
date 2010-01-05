//
//  SPSourceEmailTVC.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPSourceEmailTVC.h"
#import "SPCell.h"
#import "SPEmailASAccount.h"
#import "SPEmailPOPAccount.h"
#import "SPEmailIToolsAccount.h"
#import "SPEmailGmailAccount.h"
#import "SPEmailIMAPAccount.h"
#import "SPEmailMobileMeAccount.h"

@implementation SPSourceEmailTVC

@synthesize emails;

- (void)dealloc {
	[emails release];
	[super dealloc];
}

- (NSString *)emailForReport {
	[self loadData];
	
	if([emails count] < 1) return nil;
	return [emails objectAtIndex:0];
}

- (void)loadData {
	if(contentsDictionaries) return;
	
	self.emails = [NSMutableArray array];
	self.contentsDictionaries = [NSMutableArray array];
	
	NSMutableArray *accountsFound = [NSMutableArray array];
	
	NSString *path = @"/var/mobile/Library/Preferences/com.apple.accountsettings.plist";
	NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:path];
	NSArray *accounts = [d valueForKey:@"Accounts"];
	for(NSDictionary *account in accounts) {
		NSString *classValue = [account valueForKey:@"Class"];
		if([classValue isEqualToString:@"ASAccount"])       [accountsFound addObject:[SPEmailASAccount accountWithDictionary:account]];
		if([classValue isEqualToString:@"POPAccount"])      [accountsFound addObject:[SPEmailPOPAccount accountWithDictionary:account]];
		if([classValue isEqualToString:@"iToolsAccount"])   [accountsFound addObject:[SPEmailIToolsAccount accountWithDictionary:account]];
		if([classValue isEqualToString:@"GmailAccount"])    [accountsFound addObject:[SPEmailGmailAccount accountWithDictionary:account]];
		if([classValue isEqualToString:@"IMAPAccount"])	    [accountsFound addObject:[SPEmailIMAPAccount accountWithDictionary:account]];
		if([classValue isEqualToString:@"MobileMeAccount"])	[accountsFound addObject:[SPEmailMobileMeAccount accountWithDictionary:account]];
	}
	
	for(SPEmailAccount *account in accountsFound) {
		if(!account.emails) continue;
		[emails addObjectsFromArray:account.emails];
		[contentsDictionaries addObject:[NSDictionary dictionaryWithObject:[account infoArray] forKey:account.displayName]];			
	}	
}

@end
