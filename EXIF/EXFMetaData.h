/*
 *  EXFMetaData.h
 *  iphoneGeo
 *
 *  Created by steve woodcock on 30/03/2008.
 *  Copyright 2008. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
 *
 * The EXFMetaData stores the EXIF Meta Data itself, as well as the meta data and bytes of the thumbnail image if there is one.
 * 
 * 
 */

#import "EXFTagDefinitionHolder.h"
#import "EXFConstants.h"
#import "EXFHandlers.h"


@interface EXFMetaData : NSObject {
    
    // endian ordering for image
    BOOL bigEndianOrder;
    
    // Dictionary of special tag handlers
    NSMutableDictionary* keyedHandlers; 
    
    // Dictionary of user supplied handlers
    NSMutableDictionary* userKeyedHandlers;
    
    // dictionary of parsed EXIF Data
    NSMutableDictionary* keyedTagValues;
     
    // Dictionary of parsed Thumbnail EXIF Data
    NSMutableDictionary* keyedThumbnailTagValues;
     
    // pointer to byte array of EXIF Block
    ByteArray* exif_ptr;
    
    // The NSByte array for the thumbnail data
    NSData* thumbnailBytes;
    
    // tag definitions
    EXFTagDefinitionHolder* tagDefinitions;
    
    // Image attributes outside EXIF
    int compression;
    int bitsPerPixel;
    int height;
    int width;
    int numComponents;
    
    // length of image
    CFIndex byteLength;
}

/*
 Add a user specified handler prior to parsing the data. Allows over-ride of existing behaviour or 
 handling of tags that are not in the EXIF spec.
 
 The handler will throw an NSException if:
 1) the Key is not a valid Number
 2) The tag handler is nil
 3) The tag handler does not conform to the EXFHandler protocol
 4) The handler attempts to override one for the container tags that contains other tags
 5) The handler does not conform to the optional part of the protocol if is being used to handle a tag that is not already defined.
 6) The handler returns an invalid parent Id or tagformat if it supports the optional part of the protocol
 */
-(void) addHandler:(id<EXFTagHandler>) aTagHandler forKey:(NSNumber*) aKey;

/*
 Remove a handler. Note this only removes user handlers and cannot be used to remove a built in handler
 */
-(void) removeHandler: (NSNumber*) aKey;

/*
 Removes all user handlers.
 */
-(void) removeAllHandlers;


// Returns a tag definition for a particular tag
- (EXFTag*) tagDefinition: (NSNumber*)aTagId ;

//returns all keys for parent id
-(NSMutableArray*) tagDefinitionsForParent:(NSNumber*) parent withoutImmutable:(BOOL) includeImmutable ;

// Gets the tag value from a parsed file (if any)
- (id) tagValue: (NSNumber*)aTagId; 


// Gets the thumbnail tag value from a parsed file (if any)
- (id) thumbnailTagValue: (NSNumber*)aTagId;


-(void) addTagValue:(id)value forKey:(NSNumber*) atagKey;

-(void) removeTagValue:(NSNumber*) atagKey;

// returns the tag definitions for the EXIF Data
@property (readonly,retain) NSDictionary* keyedTagDefinitions;

// The parsed Exif tag values.
@property (readonly,retain) NSMutableDictionary* keyedTagValues;

// The parsed Exif thumbnail values
@property (readonly,retain) NSMutableDictionary* keyedThumbnailTagValues;

// The thumbnail bytes if any
@property (readonly,retain) NSData* thumbnailBytes;

// Compression value
@property (readonly) int compression;

// bits per pixel
@property (readonly) int bitsPerPixel;

// image height
@property (readonly) int height;

// image width
@property (readonly) int width;

// byte length
@property (readonly) CFIndex byteLength;

// byte order
@property (readonly) BOOL bigEndianOrder;
@end



