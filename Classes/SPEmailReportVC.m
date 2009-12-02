//
//  SPEmailReportVC.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/22/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPEmailReportVC.h"

@implementation SPEmailReportVC

@synthesize message;
@synthesize allSources;


- (IBAction)sendReport:(id)sender {
	if([MFMailComposeViewController canSendMail] == NO) {
		message.text = @"Error: this device can't send emails.";
		return;
	}
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"SpyPhone Report"];

    // Set up recipients
	NSString *email = [allSources emailForReport];
	if(email) [picker setToRecipients:[NSArray arrayWithObject:email]];
    
    // Fill out the email body text
    NSString *emailBody = [allSources report];
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {    
    // message.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result) {
        case MFMailComposeResultCancelled:
            message.text = @"Result: canceled";
            break;
        case MFMailComposeResultSaved:
            message.text = @"Result: saved";
            break;
        case MFMailComposeResultSent:
            message.text = @"Result: sent";
            break;
        case MFMailComposeResultFailed:
            message.text = @"Result: failed";
            break;
        default:
            message.text = @"Result: not sent";
            break;
    }
	
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [allSources release];
    [message release];
    [super dealloc];
}


@end
