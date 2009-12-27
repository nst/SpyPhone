//
//  SPEmailGmailAccount.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/20/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPEmailGmailAccount.h"


@implementation SPEmailGmailAccount

+ (SPEmailAccount *)accountWithDictionary:(NSDictionary *)d {
	SPEmailGmailAccount *account = [[SPEmailGmailAccount alloc] init];
	
	account.type = [d valueForKey:@"Short Type String"];
	account.fullname = [d valueForKey:@"FullUserName"];
	account.hostname = [d valueForKey:@"Hostname"];
	account.username = [d valueForKey:@"Username"];
	account.displayName = [d valueForKey:@"DisplayName"];

	NSString *theEmail = [d valueForKey:@"Username"];
	if(![[theEmail lowercaseString] hasSuffix:@"@gmail.com"]) {
		theEmail = [theEmail stringByAppendingString:@"@gmail.com"];
	}
	account.emails = [NSArray arrayWithObject:theEmail];
	
	return [account autorelease];
}

@end
