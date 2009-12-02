//
//  SPSourceTVC.h
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/17/09.
//  Copyright 2009. All rights reserved.
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import <UIKit/UIKit.h>
#import "SPWebViewVC.h"

/*
 [{[va, vb], k1},
  {[vc, vd], k2},
  {[ve, vf], k3}]
 */

@interface SPSourceTVC : UITableViewController {
	NSMutableArray *contentsDictionaries;
}

@property (retain) NSMutableArray *contentsDictionaries;

- (UIImage *)image;

- (void)loadData;

@end
