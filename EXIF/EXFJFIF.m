//
//  EXFJFIF.m
//  iphone-test
//
//  Created by steve woodcock on 24/03/2008.
//  Copyright 2008 __MyCompanyName__. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "EXFMutableMetaData.h"
#import "EXFLogging.h"

@implementation EXFJFIF

@synthesize identifier; 
@synthesize version;
@synthesize length;
@synthesize resolutionX;
@synthesize resolutionY;

@synthesize thumbnailX;
@synthesize thumbnailY;

@synthesize thumbnail;
@synthesize units;

const NSString* JFIF_IDENTIFIER = @"JFIF\0";
const int JFIF_MIN_LENGTH =14;

-(id) init{
    if (self = [super init]) {
        self.identifier =nil;
        self.version =nil;
        self.thumbnail =nil;
        
        self.length =0;
    }
    return self;
}

-(void) dealloc{
    self.identifier = nil;
    self.version =nil;
    self.thumbnail=nil;
    
    [super dealloc];
}

- (void) parseJfif:(CFDataRef*) theJfifData{
    
    CFIndex dataLen = CFDataGetLength(*theJfifData);

    // make sure the data len is big enough for the parsing
    
    if (dataLen < JFIF_MIN_LENGTH )
    {
        Debug(@"Length for JFIF is too short at %i", dataLen);
        return;
    }else{
        int strLen =[JFIF_IDENTIFIER length];
        // get a pointer in the array
        UInt8* bytePtr = (UInt8 *) CFDataGetBytePtr(*theJfifData);
        
        
        // get the text identifier
        NSData* commentData = [NSData dataWithBytes:bytePtr length:strLen]; 
        
        NSString* comments = [[NSString alloc] initWithBytes:[commentData bytes] length:strLen encoding:NSASCIIStringEncoding];
            
        // if identifier is nil or not JFIF then it is some app specific thing that we can skip
        if (comments != nil &&   ([JFIF_IDENTIFIER compare: comments] == NSOrderedSame)){
        
            self.length = dataLen;
            
            self.identifier =comments;
             
             // get the version
             UInt8 majorVersion = bytePtr[strLen];
             UInt8 minorVersion = bytePtr[strLen+1];
             NSString* ver = [[NSString alloc] initWithFormat:@"%x.%x",majorVersion, minorVersion];
             self.version = ver;
             [ver release];
             
           
            // get the units
            self.units = bytePtr[strLen+2];
            
            //JFIF is always big endian
            
            
            
            self.resolutionX = ((bytePtr[strLen+3] << 8) | bytePtr[strLen+4]);
           
            self.resolutionY =((bytePtr[strLen+5] << 8) | bytePtr[strLen+6]);
            
            
            // get the thumbnail data
            
            self.thumbnailX = bytePtr[strLen+7];
            self.thumbnailY = bytePtr[strLen+8];
            
            if (self.thumbnailX  !=0 && self.thumbnailY != 0){
                // thumbnail is 3n where n = thumbnailX x thumnailY
                long thumbnailBytes = 3 * (self.thumbnailX * self.thumbnailY);
                
                // see if the data len is enough for the image
                if (thumbnailBytes == (dataLen -JFIF_MIN_LENGTH)){
                    NSData* thumbnailData = [NSData dataWithBytes: &bytePtr[JFIF_MIN_LENGTH] length:thumbnailBytes]; 
                    self.thumbnail = thumbnailData;
                }else{
                    Debug(@"Thumbnail bytes %i is not equal to data length remaining %i", thumbnailBytes,dataLen -JFIF_MIN_LENGTH);
                }
            }
            
            }
        // release our comments string
        [comments release];
    }
    
    
     
}



@end
