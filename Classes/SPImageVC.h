//
//  SPImageVC.h
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/21/09.
//  Copyright 2009. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SPImageVC : UIViewController {
	NSString *path;
	IBOutlet UIImageView *imageView;
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSString *path;

@end
