//
//  EXFJFIF.h
//  iphone-test
//
//  Created by steve woodcock on 24/03/2008.
//  Copyright 2008 __MyCompanyName__. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//


#define EXIF_JPEGCoding                       0x10     
#define EXIF_1ByteCoding                      0x11     
#define EXIF_3ByteCoding                      0x13

enum JFIFUnits {
    JFIF_NONE =0,
    JFIF_DPI =     1,
    JFIF_DPC  =    2
};
typedef enum JFIFUnits JFIFUnits;

@interface EXFJFIF : NSObject {

    NSString* identifier;
    int length;
    int resolutionX;
    int resolutionY;
    int thumbnailX;
    int thumbnailY;
    NSData* thumbnail;
    NSString* version;
    JFIFUnits units;
}

@property (readonly, retain) NSString* identifier;
@property (readonly, retain) NSString* version;

@property (readonly) int length;
@property (readonly) int resolutionX;
@property (readonly) int resolutionY;

@property (readonly) int thumbnailX;
@property (readonly) int thumbnailY;
@property (readonly,retain) NSData* thumbnail;
@property (readonly) JFIFUnits units;



@end
