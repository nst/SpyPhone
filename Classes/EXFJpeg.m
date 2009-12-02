//
//  Jpeg.m
//  iphone-test
//
//  Created by steve woodcock on 10/03/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "EXFJpeg.h"
#import "EXFLogging.h"
#import "EXFConstants.h"
#import "EXFMutableMetaData.h"
#import "EXFUtils.h"

#define M_BEG	0xff	/* Start of marker. Used for all markers tags in format ffxx */

/*The next set of bytes define the second part of the tag - e.g the xx part */

/* Start of image. This is the first tag in the file after the header */
#define M_SOI	0xd8	

/* The app tags store the extra dat - usually we expect to see only app1 (and optionally app2) - but other apps could be 
 present */
#define M_APP0	0xe0	/* APP0 marker. */
#define M_APP1	0xe1	/* APP1 marker. */
#define M_APP2	0xe2	/* APP2 marker. */
#define M_APP3	0xe3	/* APP3 marker. */
#define M_APP4	0xe4	/* APP4 marker. */
#define M_APP5	0xe5	/* APP5 marker. */
#define M_APP6	0xe6	/* APP6 marker. */
#define M_APP7	0xe7	/* APP7 marker. */
#define M_APP8	0xe8	/* APP8 marker. */
#define M_APP9	0xe9	/* APP9 marker. */
#define M_APP10	0xea	/* APP10 marker. */
#define M_APP11	0xeb	/* APP11 marker. */
#define M_APP12	0xec	/* APP12 marker. */
#define M_APP13	0xed	/* APP13 marker. */
#define M_APP14	0xee	/* APP14 marker. */
#define M_APP15	0xef	/* APP15 marker. */

#define M_DQT	0xdb	/* Quantatization Table. */
#define M_DHT	0xc4	/* Huffman Table. */
#define M_DRI	0xdd	/* Restart Interoperability. */

/* Start of frame of image data... */
#define M_SOF0	0xc0	
#define M_SOF1	0xc1
#define M_SOF2	0xc2
#define M_SOF3	0xc3
#define M_SOF5	0xc5
#define M_SOF6	0xc6
#define M_SOF7	0xc7
#define M_SOF9	0xc9
#define M_SOF10	0xca
#define M_SOF11	0xcb
#define M_SOF13	0xcd
#define M_SOF14	0xce
#define M_SOF15	0xcf

#define M_SOS	0xda	/* Start of scan. */

#define M_EOI	0xd9	/* End of image. */


#define M_ERR	0x100

#define M_COM	0xfe

@interface EXFJpeg ()
    @property (readwrite, retain) NSMutableDictionary* keyedHeaders;
    @property (readwrite, retain) EXFMetaData* exifMetaData;
    @property (readwrite, retain) EXFJFIF* jfif;
				@property (readwrite, retain) NSData* remainingData;
@end

@implementation EXFJpeg

@synthesize keyedHeaders;
@synthesize exifMetaData;
@synthesize jfif;
@synthesize remainingData;

-(id) init {
    if (self = [super init]) {
		// Initializeyour own data
        NSMutableDictionary* headerDictionary = [[NSMutableDictionary alloc] init];
        self.keyedHeaders =headerDictionary;
        [headerDictionary release];
        
        EXFMetaData* exifParam =[[EXFMetaData alloc]init];
        self.exifMetaData = exifParam;
        [exifParam release];
        
        self.jfif =nil;
        
        // initialise pointers
        imageBytePtr =NULL;
        imageStartPtr =NULL;
        
	}
	return self;
        
    
}

-(void) dealloc{
    
    self.keyedHeaders = nil;
    self.exifMetaData = nil;
    self.jfif =nil;
    self.remainingData =nil;
				
    imageBytePtr =NULL;
    imageStartPtr =NULL;
    
    // release super class
    [super dealloc];
}


-(bool) imageLengthCheck:(int) length{

    int remaining = imageLength -(imageBytePtr - imageStartPtr);
    return (length < remaining);
    
}

- (void) skipBytes: (int) bytes
{
	  
    // increment to leave us at the next byte
    *(imageBytePtr+=bytes);
	
}

- (UInt8) readNextbyte
{
	UInt8 byte;
    // increment the marker ptr
    
	byte = *(imageBytePtr);
    
    // increment to leave us at the next byte
    *(imageBytePtr++);
    return byte;
	
}


- (int) readNext2bytes
{
	UInt8 b1, b2;
    // increment the marker ptr
   
	b1 = *imageBytePtr;
   
    // get the next value
    *(imageBytePtr++);
    b2 = *imageBytePtr;

    *(imageBytePtr++);
    // return the values we have got
    return ((b1 << 8) | b2);
	
}



-(UInt8) nextMarker {
    UInt8 val = [self readNextbyte];
    
    /* Find 0xFF byte; count and skip any non-FFs. */
    while (val != M_BEG){
        val =  [self readNextbyte];
    }
    
    
    do {
        val =  [self readNextbyte];
    } while(val == M_BEG);
    
    // increment to one after
    return val;
}

- (void) readImageInfo 
{
	int len = [self readNext2bytes] - 2;
    
	if (len < 0 ){
	   // throw new JpegException("Erroneous JPEG marker length");
        NSLog(@"ERROR: Length is negative in reading image info ");
        return;
    }
    
    if (len > imageLength){
        NSLog(@"ERROR: Length is bigger than image length ");
        return;
    }
    
    Warn(@"Length in image info %i ",len);
    
	int bitsPerPixel = [self readNextbyte]; len--;
   
	int height = [self readNext2bytes]; len -= 2;
	int width = [self readNext2bytes]; len -= 2;
    
	numComponents = [self readNextbyte]; len--;
    
    Warn(@"Skipping length %i", len);
    //skip over the remainder length - how do we check the length here?
     *(imageBytePtr += len);
    
    // set them into EXIF Data
    self.exifMetaData.height = height;
    self.exifMetaData.width =width;
    self.exifMetaData.bitsPerPixel = bitsPerPixel;
    
	
}

/**
 * skip the body after a marker
 */
- (void) skipVariable 
{
	int len = [self readNext2bytes] - 2;
    
	if (len < 0 ){
        NSLog(@"Error in skip variable length");
        return;
    }
    if (![self imageLengthCheck:len]){
        NSLog(@"ERROR: Length is bigger than image length ");
        return;
    }
    
	// skip the rest
    
     Warn(@"Skipping length %i", len);
    //skip over the remainder length - how do we check the length here?
    *(imageBytePtr += len);
}


- (NSData*) processComment
{
	int length;
    
	/* Get the marker parameter length count */
	length = [self readNext2bytes];
 
	 Debug(@"Got length of comment of %i", length);
    
    /* Length includes itself, so must be at least 2 */
	if (length < 2)
    {
        Debug(@"length must be at least 2");
        // make sure we do not overun the image length
        
    }
    if (![self imageLengthCheck:length]){
        NSLog(@"ERROR: Length is bigger than image length ");
        return nil;
    }
    
    length -=2;
    
   
    
    // get the comment characters - currently use iso latin - could this be different?

   
    NSData* commentData = [NSData dataWithBytes:imageBytePtr length:length]; 
    
    Debug(@"comment data without length 2 bytes %i", [commentData length]);
    // skip the bytes we have just read
    [self skipBytes:length];
   
    return commentData;
   }


-(void) parseExif:(CFDataRef*) exifData
{
    
    [self.exifMetaData parseExif:exifData];
    
}

-(void) parseJfif:(CFDataRef*) jfifData
{
    // we only need to set the jfif if it is a recognized one
    EXFJFIF* localJfif =[[EXFJFIF alloc]init];
   
    
    [localJfif parseJfif:jfifData];
     
    if (localJfif.identifier != nil){
    
        self.jfif = localJfif;
    }
    [localJfif release];
    
    // we may need to add the additional stuff here for jfif extensions
    
}


-(void) scanImageData: (NSData*) jpegData {

    Debug(@"Starting scan headers");

    // pointer to the end of the EXIF Data and the start of the rest of the image
    ByteArray* endOfEXFPtr = NULL;
   
    imageLength = CFDataGetLength((CFDataRef)jpegData);
    
   // CFRetain(&imageLength);
    
    Debug(@"Length of image %i", imageLength);
    
    imageBytePtr = (UInt8 *) CFDataGetBytePtr((CFDataRef)jpegData);
    imageStartPtr = imageBytePtr;
    
    // check if a valid jpeg file
    UInt8 val = [self readNextbyte];
    
    if (val != M_BEG){
         Debug(@"Not a valid JPEG File");
        return;
    }
     
    val = [self readNextbyte];
    
    if (val != M_SOI){
        Debug(@"Not a valid start of image JPEG File");
        return;
    }
   
   
    // increment this to position after second byte
    BOOL finished =FALSE;
				
    while(!finished){
        // increment the marker
        
        val = [self nextMarker];
        
        Debug(@"Got next marker %x at byte count %i", val, (imageBytePtr - imageStartPtr));
        
        switch(val){
                case M_SOF0:	 /* Baseline */
                case M_SOF1:	 /* Extended sequential, Huffman */
                case M_SOF2:	 /* Progressive, Huffman */
                case M_SOF3:	 /* Lossless, Huffman */
                case M_SOF5:	 /* Differential sequential, Huffman */
                case M_SOF6:	 /* Differential progressive, Huffman */
                case M_SOF7:	 /* Differential lossless, Huffman */
                case M_SOF9:	 /* Extended sequential, arithmetic */
                case M_SOF10:	 /* Progressive, arithmetic */
                case M_SOF11:	 /* Lossless, arithmetic */
                case M_SOF13:	 /* Differential sequential, arithmetic */
                case M_SOF14:	 /* Differential progressive, arithmetic */
                case M_SOF15:	 /* Differential lossless, arithmetic */
                    // Remember the kind of compression we saw
                    {
                        int compression = *imageBytePtr;
                        self.exifMetaData.compression = compression;
                        
                        // Get the intrinsic properties fo the image
                        [self readImageInfo];
                    }
                    break;
                
               case M_SOS:	 /* stop before hitting compressed data */
                Debug(@"Found SOS at %i", imageBytePtr - imageStartPtr);
              //  [self skipVariable];
              
                // Update the EXIF
             //  updateExif();
                    finished = TRUE;
																				break;
               case M_EOI:	 /* in case it's a tables-only JPEG stream */
                    Debug(@"End of Image reached at %i ", imageBytePtr - imageStartPtr);
                    finished =TRUE;
																				break;
               case M_COM:
                    Debug(@"Got com  at %i",imageBytePtr - imageStartPtr);
                    break;
                
               case M_APP0:
               case M_APP1:
               case M_APP2:
               case M_APP3:
               case M_APP4:
               case M_APP5:
               case M_APP6:
               case M_APP7:
               case M_APP8:
               case M_APP9:
               case M_APP10:
               case M_APP11:
               case M_APP12:
               case M_APP13:
               case M_APP14:
               case M_APP15:
               // Some digital camera makers put useful textual
               // information into APP1 and APP12 markers, so we print
               // those out too when in -verbose mode.
                {
                    Debug(@"Found app %x at %i", val, imageBytePtr - imageStartPtr);
                    
                    
                    NSData* commentData = [self processComment];
                    NSNumber* key = [[NSNumber alloc]initWithInt:val];
 
                    // add comments to dictionary
                    [self.keyedHeaders  setObject:commentData forKey:key];
                    [key release];
                    // will always mark the end of the app_x block
                    endOfEXFPtr = imageBytePtr;
                     
                    // we pass a pointer to the NSData pointer here
                    if (val == M_APP0){
                         Debug(@"Parsing JFIF APP_0 at %i", imageBytePtr - imageStartPtr);
                        [self parseJfif:(CFDataRef*)&commentData];
                    } else if (val == M_APP1){
                        [self parseExif:(CFDataRef*)&commentData];
                        Debug(@"Finished App1 at %i", endOfEXFPtr - imageStartPtr);
                    } else if (val == M_APP2){
                        Debug(@"Finished APP2 at %i", imageBytePtr - imageStartPtr);
                    }else{
                        Debug(@"Finished App &x at %i", val, imageBytePtr - imageStartPtr);
                    }
                    
                }
               
               
               break;
            case M_SOI:
                Debug(@"SOI encountered at %i",imageBytePtr - imageStartPtr);
                
                break;
               default:	          // Anything else just gets skipped
                Debug(@"NOt handled %x skipping at %i",val, imageBytePtr - imageStartPtr);
                [self skipVariable];  // we assume it has a parameter count...
               break;
               }     
               
        }
        
        
    
    // add in the bytes after the exf block
				NSData* theRemainingdata = [[NSData alloc] initWithBytes:endOfEXFPtr length:imageLength - (endOfEXFPtr - imageStartPtr)];
    self.remainingData = theRemainingdata;
				[theRemainingdata release];
				
				endOfEXFPtr = NULL;
				imageStartPtr = NULL;
				imageBytePtr = NULL;
				
}

-(void) populateImageData: (NSMutableData*) newImage {
    
    if (newImage ==nil){
								NSLog(@"Image array cannot be null");
								return;
				}
    
    UInt8 bytes[4];
    UInt8* ptr = bytes;
     
    bytes[0] = M_BEG;
    bytes[1] = M_SOI;
    bytes [2] = bytes[3] =0;
    [newImage appendBytes:ptr length: 2];
    
    for (int i =0xe0;i<0xf0;i++){
    // use the values we have parsed for M_APP1
        if (i == M_APP1){
            if ([exifMetaData.keyedTagValues count] !=0){
                bytes[0] = M_BEG;
                bytes[1] = (UInt8) i;
                bytes[2] = bytes[3] = 0;
                [newImage appendBytes:ptr length:4];
                
                int initialSize = [newImage length] -2;
                
                Debug(@"Image length before is now %i",initialSize);
                
                
                // process the EXF Data and write into the image
                [exifMetaData getData: newImage];
                
                // calculate the block size
                
                UInt8* ptr = bytes;
                
                [EXFUtils write2Bytes:&ptr :[NSNumber numberWithInt:[newImage length] -initialSize]:TRUE];
                // now append this to the writer
                [newImage replaceBytesInRange:NSMakeRange(initialSize, 2) withBytes:bytes];
                
                Debug(@"Image length after exif is now %i",[newImage length]);
                
            } 
            
        }else{
            NSNumber* key = [[NSNumber alloc] initWithInt:i];
            NSData* data = [keyedHeaders objectForKey:key];
            if (data != nil){
                Debug(@"writing app %x with length %i to image",i,[data length] +2);
                [EXFUtils write2Bytes: &ptr:[NSNumber numberWithInt:[data length]+2] :TRUE];
                bytes[2] = bytes[0];
                bytes[3] = bytes[1];
                bytes[0] = M_BEG;
                bytes[1] = (UInt8) i;
                
                [newImage appendBytes:ptr length:4];
                [newImage appendData:data];
            }
            [key release];
        }
    }
     
    NSLog(@"About to append remaining data");
    // add in the bytes after the exf block
    [newImage appendData:self.remainingData];
    
			
     Debug(@"new Image length is now %i - original image length %i",[newImage length], imageLength);   
}

@end
