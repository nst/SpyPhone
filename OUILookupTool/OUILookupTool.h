//
//  OUILookupTool.h
//  OUILookup
//
//  Created by Nicolas Seriot on 10/31/10.
//  Copyright 2010 IICT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OUILookupTool;

@protocol OUILookupToolDelegate
- (void)OUILookupTool:(OUILookupTool *)ouiLookupTool didLocateAccessPoint:(NSDictionary *)ap;
@end

@interface OUILookupTool : NSObject {
	NSObject <OUILookupToolDelegate> *delegate;
}

@property (nonatomic, retain) NSObject <OUILookupToolDelegate> *delegate;

// ap should have a "bssid" key
+ (OUILookupTool *)locateWifiAccessPoint:(NSDictionary *)ap delegate:(NSObject <OUILookupToolDelegate> *)aDelegate;

@end
