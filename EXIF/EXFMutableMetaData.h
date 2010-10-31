/*
 *  EXFMutableMetaData.h
 *  iphoneGeo
 *
 *  Created by steve woodcock on 23/03/2008.
 *  Copyright 2008 __MyCompanyName__. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
 *
 */
#import "EXFMetaData.h"
#import "EXFJFIF.h"

 
/* Mutable interface Category for EXFJFIF */

@interface EXFJFIF ()


- (void) parseJfif:(CFDataRef*) theJfifData;

@property (readwrite, retain) NSString* identifier;
@property (readwrite, retain) NSString* version;

@property (readwrite, retain) NSData* thumbnail;

// primitive attributes
@property (readwrite) JFIFUnits units;
@property (readwrite) int length;
@property (readwrite) int resolutionX;
@property (readwrite) int resolutionY;

@property (readwrite) int thumbnailX;
@property (readwrite) int thumbnailY;

@end

/* Mutable interface Category for EXFObject */
@interface EXFMetaData ()



- (void) parseExif:(CFDataRef*) theExifData;
- (void) getData: (NSMutableData*) imageData;

-(void) setupHandlers;


@property (readwrite,retain) NSMutableDictionary* userKeyedHandlers;

@property (readwrite,retain) NSMutableDictionary* keyedHandlers;
@property (readwrite,retain) EXFTagDefinitionHolder* tagDefinitions;
@property (readwrite, retain) NSMutableDictionary* keyedTagValues;

@property (readwrite,retain) NSMutableDictionary* keyedThumbnailTagValues;

@property (readwrite,retain) NSData* thumbnailBytes;

@property (readwrite) int compression;
@property (readwrite) int bitsPerPixel;
@property (readwrite) int height;
@property (readwrite) int width;
@property (readwrite) CFIndex byteLength;

@property (readwrite) BOOL bigEndianOrder;
@property (readwrite) ByteArray* exif_ptr;


@end