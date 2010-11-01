//
//  SourcesTVController.h
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import <UIKit/UIKit.h>

@class SPSourceEmailTVC;
@class SPSourceWifiTVC;
@class SPSourcePhoneTVC;
@class SPSourceLocationTVC;
@class SPSourcePhotosTVC;
@class SPSourceAddressBookTVC;
@class SPSourceKeyboardTVC;

@interface SPAllSourcesTVC : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	NSArray *sources;
	
	IBOutlet SPSourceEmailTVC *sourceEmailTVC;
	IBOutlet SPSourceWifiTVC *sourceWifiTVC;
	IBOutlet SPSourcePhoneTVC *sourcePhoneTVC;
	IBOutlet SPSourceLocationTVC *sourceLocationTVC;
	IBOutlet SPSourcePhotosTVC *sourcePhotosTVC;
	IBOutlet SPSourceAddressBookTVC *sourceAddressBookTVC;
	IBOutlet SPSourceKeyboardTVC *sourceKeyboardTVC;
}

@property (nonatomic, retain) NSArray *sources;

- (NSString *)emailForReport;
- (NSString *)report;

@end
