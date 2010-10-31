//
//  SPSourceWifiTVC.h
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import <UIKit/UIKit.h>
#import "SPSourceTVC.h"
#import "OUILookupTool.h"

@class SPWifiMapVC;

@interface SPSourceWifiTVC : SPSourceTVC <OUILookupToolDelegate> {
	NSMutableArray *annotations;
	NSMutableArray *accessPoints;
	IBOutlet SPWifiMapVC *mapVC;
}

@property (nonatomic, retain) NSMutableArray *annotations;
@property (nonatomic, retain) NSMutableArray *accessPoints;
@property (nonatomic, retain) SPWifiMapVC *mapVC;

@end
