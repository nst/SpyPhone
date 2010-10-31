//
//  SPSourcePhotosTVC.h
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPSourceTVC.h"

@class SPImageMapVC;
@class SPImageVC;

@interface SPSourcePhotosTVC : SPSourceTVC {
	NSMutableArray *coordinates;
	NSMutableArray *annotations;
	
	IBOutlet SPImageMapVC *mapVC;
	IBOutlet SPImageVC *imageVC;
}

@property (nonatomic, retain) NSMutableArray *annotations;
@property (nonatomic, retain) NSMutableArray *coordinates;
@property (nonatomic, retain) SPImageMapVC *mapVC;
@property (nonatomic, retain) SPImageVC *imageVC;

@end
