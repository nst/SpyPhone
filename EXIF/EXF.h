/*
 *  EXF.h
 *  
 *
 *  Created by steve woodcock on 23/03/2008.
 *  Copyright 2008. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
 *
 */

/*!
@header EXF.h
@abstract The group of the entire EXIF API headers
@discussion These are:
1) EXFConstants.h
2) EXFMetaData.h
3) EXFJFIF.h
4) EXFJpeg.h
5) EXFGPS.h
6) EXFHandlers.h

To use the framework just use the follwoign import statement 
#import "EXF.h"
*/
 
/*
Details the Constants for the tag Ids, enums etc
*/
#import "EXFConstants.h"


/*
Details the EXFObject which represents the meta information of the JPEG image.
*/
#import "EXFMetaData.h"

/*
The JFIF is an alternative meta format used to encode information.
*/
#import "EXFJFIF.h"

/*
The entry point which is used to scan an existing file and reconstruct a new image
*/
#import "EXFJpeg.h"

/*
A GPS Location object
*/
#import "EXFGPS.h"

/*
The tag specific handlers which represent special processing required for some tags.
*/
#import "EXFHandlers.h"

