//
//  SPEmailReportVC.h
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/22/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SPAllSourcesTVC.h"

@interface SPEmailReportVC : UIViewController <MFMailComposeViewControllerDelegate> {
	IBOutlet UILabel *message;
	IBOutlet SPAllSourcesTVC *allSources;
}

@property (nonatomic, retain) IBOutlet UILabel *message;
@property (nonatomic, retain) IBOutlet SPAllSourcesTVC *allSources;

- (IBAction)sendReport:(id)sender;

@end
