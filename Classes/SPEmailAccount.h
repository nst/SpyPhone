//
//  SPEmailAccount.h
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/20/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import <Foundation/Foundation.h>

// TODO: subclass for AOL accounts

@interface SPEmailAccount : NSObject {
	NSString *fullname;
	NSArray *emails;
	NSString *type;
	NSString *hostname;
	NSString *username;
	NSString *displayName;
	NSMutableArray *calendars;
}

@property (nonatomic, retain) NSString *fullname;
@property (nonatomic, retain) NSArray *emails;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *hostname;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSArray *calendars;

+ (SPEmailAccount *)accountWithDictionary:(NSDictionary *)d;
- (NSArray *)infoArray;

@end
