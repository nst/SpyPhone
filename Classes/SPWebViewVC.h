//
//  SPWebViewVC.h
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/15/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import <UIKit/UIKit.h>


@interface SPWebViewVC : UIViewController {
	NSURLRequest *request;
	IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) UIWebView *webView;

@end
