//
//  UIApplication+TVOut.m
//  MediaMotion2
//
//  Created by Rob Terrell on 5/15/09 
//  Copyright 2009 Stinkbot LLC. All rights reserved.
//

// http://gist.github.com/119128

#define kFPS 10
#define kUseBackgroundThread	YES
 
@interface UIApplication (tvout)
- (void) startTVOut;
- (void) stopTVOut;
- (void) updateTVOut;
@end
 
@interface MPTVOutWindow : UIWindow
- (id)initWithVideoView:(id)fp8;
@end
 
@interface MPVideoView : UIView
- (id)initWithFrame:(struct CGRect)fp8;
@end
 
@implementation MPVideoView (tvout)
- (void) addSubview: (UIView *) aView
{	
    [super addSubview:aView];
}
@end
 
CGImageRef UIGetScreenImage();
 
@interface UIImage (tvout)
+ (UIImage *)imageWithScreenContents;
@end
 
@implementation UIImage (tvout)
+ (UIImage *)imageWithScreenContents
{
    CGImageRef cgScreen = UIGetScreenImage();
    if (cgScreen) {
        UIImage *result = [UIImage imageWithCGImage:cgScreen];
        CGImageRelease(cgScreen);
        return result;
    }
    return nil;
}
@end
 
UIWindow* deviceWindow;
MPTVOutWindow* tvoutWindow;
NSTimer *updateTimer;
UIImage *image;
UIImageView *mirrorView;
BOOL done;
 
@implementation UIApplication (tvout)
 
// if you uncomment this, you won't need to call startTVOut in your app.
// but the home button will no longer work! Other badness may follow!
//
// - (void)reportAppLaunchFinished;
//{
//	[self startTVOut];
//}
 
 
- (void) startTVOut;
{
	// you need to have a main window already open when you call start
	if (!tvoutWindow) {
		deviceWindow = [self keyWindow];
 
		MPVideoView *vidView = [[MPVideoView alloc] initWithFrame: CGRectZero];	
		tvoutWindow = [[MPTVOutWindow alloc] initWithVideoView:vidView];
		[tvoutWindow makeKeyAndVisible];
		tvoutWindow.userInteractionEnabled = NO;
 
		mirrorView = [[UIImageView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
 
		if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait) {
			mirrorView.transform = CGAffineTransformRotate(mirrorView.transform, M_PI * 1.5);
		}
		mirrorView.center = vidView.center;
		[vidView addSubview: mirrorView];
 
		[deviceWindow makeKeyAndVisible];
 
		[NSThread detachNewThreadSelector:@selector(updateLoop) toTarget:self withObject:nil];
	}
}
 
- (void) stopTVOut;
{
	done = YES;
	if (updateTimer) {
		[updateTimer invalidate];
		[updateTimer release];
		updateTimer = nil;
	}
	if (tvoutWindow) {
		[tvoutWindow release];
		tvoutWindow = nil;
	}
}
 
- (void) updateTVOut;
{
	image = [UIImage imageWithScreenContents];
	mirrorView.image = image;
}
 
 
- (void)updateLoop;
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    done = NO;
 
    while ( ! done )
    {
		[self performSelectorOnMainThread:@selector(updateTVOut) withObject:nil waitUntilDone:NO];
        [NSThread sleepForTimeInterval: (1.0/kFPS) ];
    }
    [pool release];
}
 
@end
