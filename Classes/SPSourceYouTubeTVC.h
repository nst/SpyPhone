//
//  SPSourceYouTubeTVC.h
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import <UIKit/UIKit.h>
#import "SPSourceTVC.h"

@interface SPSourceYouTubeTVC : SPSourceTVC {
	NSString *lastSearch;
	NSArray *bookmarks;
	NSArray *history;
}

@property (nonatomic, retain) NSArray *bookmarks;
@property (nonatomic, retain) NSArray *history;
@property (nonatomic, retain) NSString *lastSearch;

@end
