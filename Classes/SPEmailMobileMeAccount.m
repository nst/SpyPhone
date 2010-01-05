//
//  SPEmailMobileMeAccount.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/20/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPEmailMobileMeAccount.h"


@implementation SPEmailMobileMeAccount

+ (SPEmailAccount *)accountWithDictionary:(NSDictionary *)d {
	SPEmailMobileMeAccount *account = [[SPEmailMobileMeAccount alloc] init];
	
	account.type = [d valueForKey:@"Short Type String"];
	account.fullname = [d valueForKey:@"FullUserName"];
	account.emails = [d valueForKey:@"EmailAddresses"];
	account.username = [d valueForKey:@"Username"];
	account.displayName = [d valueForKey:@"DisplayName"];
	
	NSMutableArray *theCalendars = [NSMutableArray array];
	NSDictionary *calendars = [d valueForKey:@"Subscribed Calendars"];
	if (calendars) {
		for(id calendarItem in [calendars allValues]) {
			[theCalendars addObject:[calendarItem valueForKey:@"com.apple.ical.urlsubscribe.url"]];
		}
						
		account.calendars = theCalendars;
	}
	return [account autorelease];
}

@end
