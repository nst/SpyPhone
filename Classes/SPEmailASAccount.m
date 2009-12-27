//
//  SPEmailASAccount.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/20/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPEmailASAccount.h"


@implementation SPEmailASAccount

+ (SPEmailAccount *)accountWithDictionary:(NSDictionary *)d {
	SPEmailASAccount *account = [[SPEmailASAccount alloc] init];
	
	account.type = [d valueForKey:@"Short Type String"];
	//account.fullname = nil;
	account.emails = [NSArray arrayWithObject:[d valueForKey:@"ASAccountEmailAddress"]];
	account.hostname = [d valueForKey:@"ASAccountHost"];
	account.username = [d valueForKey:@"ASAccountUsername"];
	account.displayName = [d valueForKey:@"DisplayName"];

	return [account autorelease];
}

@end
