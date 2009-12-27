//
//  SPEmailIToolsAccount.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/20/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPEmailIToolsAccount.h"


@implementation SPEmailIToolsAccount

+ (SPEmailAccount *)accountWithDictionary:(NSDictionary *)d {
	SPEmailIToolsAccount *account = [[SPEmailIToolsAccount alloc] init];
	
	account.type = [d valueForKey:@"Short Type String"];
	account.fullname = [d valueForKey:@"FullUserName"];
	NSArray *theEmailAddresses = [d valueForKey:@"EmailAddresses"];
	NSMutableArray *theEmails = [NSMutableArray array];
	for (id emailAddress in theEmailAddresses) {
		[theEmails addObject:[NSString stringWithFormat:@"%@@me.com", emailAddress]];
	}
	account.emails = theEmails;
	//account.hostname = nil;
	account.username = [d valueForKey:@"Username"];
	account.displayName = [d valueForKey:@"DisplayName"];

	return [account autorelease];
}

@end
