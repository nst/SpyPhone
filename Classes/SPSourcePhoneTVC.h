//
//  SPSourcePhoneTVC.h
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import <UIKit/UIKit.h>
#import "SPSourceTVC.h"

@interface SPSourcePhoneTVC : SPSourceTVC  {
	NSString *ICCID;
//	NSString *IMEI;
	NSString *IMSI;
	NSString *phone;
	NSString *UUID;	
	NSString *lastDialed;	
	NSString *lastContact;
	NSString *lastForwardNumber;
	NSMutableArray *callHistories;
	NSString *prettyBytesSent;
	NSString *prettyBytesReceived;
}

@property (nonatomic, retain) NSString *ICCID;
//@property (nonatomic, retain) NSString *IMEI;
@property (nonatomic, retain) NSString *IMSI;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *UUID;
@property (nonatomic, retain) NSString *lastDialed;
@property (nonatomic, retain) NSString *lastContact;
@property (nonatomic, retain) NSString *lastForwardNumber;
@property (nonatomic, retain) NSString *prettyBytesSent;
@property (nonatomic, retain) NSString *prettyBytesReceived;
@property (nonatomic, retain) NSMutableArray *callHistories;

@end
