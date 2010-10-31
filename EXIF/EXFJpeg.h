/*
 *  EXFJpeg.h
 *  iphoneGeo
 *
 *  Created by steve woodcock on 30/03/2008.
 *  Copyright 2008. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
 *
 * The EXFJpeg object is used to scan the original image in order to extract the JFIF/EXIF data and 
 * following any changes to the EXIF object will return the bytes representing the new image.
 */

#import "EXFMetaData.h"
#import "EXFJFIF.h"
#import "EXFJpeg.h"
#import "EXFConstants.h"


@interface EXFJpeg : NSObject {
    
    // stores length of the image in bytes
    CFIndex imageLength;
    
    // pointer to the start of the image byte array
    ByteArray* imageStartPtr;
    
    // pointer to the current parsing point in the byte array 
    ByteArray* imageBytePtr;
    
    // A dictionary of the EXIF blocks in the file that have been parsed
    NSMutableDictionary* keyedHeaders;
    
    // The EXF MetaData image attributes 
    EXFMetaData* exifMetaData;
    
    // Image attributes outside EXIF in the Components section of the file
    int numComponents;

   // The JFIF MetaData image attributes 
    EXFJFIF* jfif;
				
				NSData* remainingData;
} 

/*
 Returns the EXIF MetaData object. 
*/
@property (readonly, retain) EXFMetaData* exifMetaData;

/*
 Returns the JFIF Meta Data of a scanned Image
*/
@property (readonly, retain) EXFJFIF* jfif;


/*
 Scans the Image Data
*/
-(void) scanImageData:(NSData*) imageData;

/*
 Returns the image byte array for the new image with amended data
*/
-(void) populateImageData: (NSMutableData*) newImageData;


@end
