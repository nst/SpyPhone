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
	account.email = [[[d valueForKey:@"EmailAddresses"] lastObject] stringByAppendingString:@"@me.com"];
	//account.hostname = nil;
	account.username = [d valueForKey:@"Username"];
	
	return [account autorelease];
}

@end
