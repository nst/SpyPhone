/*
 *  EXFConstants.h
 *  
 *
 *  Created by steve woodcock on 30/03/2008.
 *  Copyright 2008. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
 *
 * Constants used in the EXIF library.
 *
 *
 */
/*!
@header EXFConstants.h
@abstract EXFConstants.h provides the definition of commonly used enums, definitions and basic interfaces.
*/

/*
Type defs for some of the internal definitions
*/
/*!
@typedef ByteArray  
*/
typedef UInt8 ByteArray;

/*!
 @typedef EXFTagId 
 @discussion The data type for tag ids.  
 */
typedef UInt16 EXFTagId;

/*!
@enum EXFDataType
@abstract The possible types that an EXIF tag data can be specified as.
@discussion These are the only legal types to be used in the EXFTagDefinition to determine the type of data to be read/written and the number
of bytes that each data type will then occupy.
*/
enum EXFDataType {
    FMT_BYTE =       1,
    FMT_STRING  =    2,
    FMT_USHORT  =    3,
    FMT_ULONG   =    4,
    FMT_URATIONAL  = 5,
    FMT_SBYTE      = 6,
    FMT_UNDEFINED  = 7,
    FMT_SSHORT     = 8,
    FMT_SLONG      = 9,
    FMT_SRATIONAL  =10,
    FMT_SINGLE     =11,
    FMT_DOUBLE     =12
};

/*!
 @typedef EXFDataType  
 */
 
typedef enum EXFDataType EXFDataType;


/*
  EXF Tag Ids 
 
*/
#define EXIF_ImageWidth                       0x0100     
#define EXIF_ImageLength                      0x0101     
#define EXIF_BitsPerSample                    0x0102     
#define EXIF_Compression                      0x0103     
#define EXIF_PhotometricInterpretation        0x0106     
#define EXIF_ImageDescription                 0x010e     
#define EXIF_Make                             0x010f     
#define EXIF_Model                            0x0110     
#define EXIF_StripOffsets                     0x0111     
#define EXIF_Orientation                      0x0112     
#define EXIF_SamplesPerPixel                  0x0115     
#define EXIF_RowsPerStrip                     0x0116     
#define EXIF_StripByteCounts                  0x0117     
#define EXIF_XResolution                      0x011a     
#define EXIF_YResolution                      0x011b     
#define EXIF_PlanarConfiguration              0x011c     
#define EXIF_ResolutionUnit                   0x0128
#define EXIF_Software                         0x0131     
#define EXIF_DateTime                         0x0132
#define EXIF_Artist                           0x013b
#define EXIF_HostComputer                     0x013c
#define EXIF_Predictor                        0x013d
#define EXIF_WhitePoint                       0x013e
#define EXIF_PrimaryChromaticities            0x013f
#define EXIF_JPEGInterchangeFormat            0x0201
#define EXIF_JPEGInterchangeFormatLength      0x0202 
#define EXIF_YCbCrCoefficients                0x0211 
#define EXIF_YCbCrSubSampling                 0x0212
#define EXIF_YCbCrPositioning                 0x0213
#define EXIF_ReferenceBlackWhite              0x0214
#define EXIF_Copyright                        0x8298
#define EXIF_Exif                             0x8769      
#define EXIF_GPS                              0x8825
#define EXIF_SpectralSensitivity              0x8824
#define EXIF_ExposureProgram                  0x8822 
#define EXIF_ISOSpeedratings                  0x8827     
#define EXIF_ExposureTime                     0x829a     
#define EXIF_FNumber                          0x829d     
#define EXIF_ExifVersion                      0x9000     
#define EXIF_DateTimeOriginal                 0x9003 
#define EXIF_DateTimeDigitized                0x9004 
#define EXIF_ComponentsConfiguration          0x9101
#define EXIF_CompressedBitsPerPixel           0x9102
#define EXIF_ShutterSpeedValue                0x9201     
#define EXIF_ApertureValue                    0x9202     
#define EXIF_BrightnessValue                  0x9203     
#define EXIF_ExposureBiasValue                0x9204     
#define EXIF_MaxApertureRatioValue            0x9205     
#define EXIF_SubjectDistance                  0x9206     
#define EXIF_MeteringMode                     0x9207     
#define EXIF_LightSource                      0x9208     
#define EXIF_Flash                            0x9209     
#define EXIF_FocalLength                      0x920a
#define EXIF_MakerNote                        0x927c
#define EXIF_UserComment                      0x9286
#define EXIF_SubSecTime                       0x9290     
#define EXIF_SubSecTimeOriginal               0x9291 
#define EXIF_SubSecTimeDigitized              0x9292 
#define EXIF_FileSource                       0xa300 
#define EXIF_SceneType                        0xa301
#define EXIF_CFAPattern                       0xa302
#define EXIF_FlashpixVersion                  0xa000     
#define EXIF_ColorSpace                       0xa001 
#define EXIF_PixelXDimension                  0xa002
#define EXIF_PixelYDimension                  0xa003
#define EXIF_FocalPlaneXResolution            0xa20e
#define EXIF_FocalPlaneYResolution            0xa20f
#define EXIF_FocalPlaneResolutionUnit         0xa210 
#define EXIF_SubjectLocation                  0xa214
#define EXIF_ExposureIndex                    0xa215
#define EXIF_SensingMethod                    0xa217
#define EXIF_CustomRendered                   0xa401
#define EXIF_ExposureMode                     0xa402
#define EXIF_WhiteBalance                     0xa403
#define EXIF_DigitalZoomRatio                 0xa404
#define EXIF_FocalLengthIn35mmFilm            0xa405
#define EXIF_SceneCaptureType                 0xa406
#define EXIF_GainControl                      0xa407
#define EXIF_Contrast                         0xa408
#define EXIF_Saturation                       0xa409
#define EXIF_Sharpness                        0xa40a
#define EXIF_DeviceSettingDescription         0xa40b
#define EXIF_SubjectDistanceRange             0xa40c
#define EXIF_Gamma                            0xa500
#define EXIF_GPSVersion                       0x0000  
#define EXIF_GPSLatitudeRef                   0x0001     
#define EXIF_GPSLatitude                      0x0002     
#define EXIF_GPSLongitudeRef                  0x0003     
#define EXIF_GPSLongitude                     0x0004     
#define EXIF_GPSAltitudeRef                   0x0005     
#define EXIF_GPSAltitude                      0x0006     
#define EXIF_GPSTimeStamp                     0x0007     
#define EXIF_GPSSatellites                    0x0008     
#define EXIF_GPSStatus                        0x0009     
#define EXIF_GPSMeasureMode                   0x000a     
#define EXIF_GPSDOP                           0x000b     
#define EXIF_GPSSpeedRef                      0x000c     
#define EXIF_GPSSpeed                         0x000d     
#define EXIF_GPSTrackRef                      0x000e     
#define EXIF_GPSTrack                         0x000f     
#define EXIF_GPSImgDirectionRef               0x0010     
#define EXIF_GPSImgDirection                  0x0011     
#define EXIF_GPSMapDatum                      0x0012     
#define EXIF_GPSDestLatitudeRef               0x0013     
#define EXIF_GPSDestLatitude                  0x0014     
#define EXIF_GPSDestLongitudeRef              0x0015     
#define EXIF_GPSDestLongitude                 0x0016     
#define EXIF_GPSDestBearingRef                0x0017     
#define EXIF_GPSDestBearing                   0x0018     
#define EXIF_GPSDestDistanceRef               0x0019     
#define EXIF_GPSDestDistance                  0x001a 




/*!
@class EXFraction
@abstract A simple fraction class used to store all rational data types
@discussion The fraction class is used to avoid precision issues when converting from the fraction format stored 
in the JPEG image.   
The image data is stored as two longs (numerator and denominator)
*/

@interface EXFraction: NSObject {
    
    long numerator;
    long denominator;
}

/*!
@method initWith
@abstract initialises the EXFraction with a numerator and denominator

*/
-(id) initWith: (long) numerator: (long) denominator;

/*!
 @property numerator
 @abstract the numerator part of the fraction
 
 */
@property (readonly) long numerator;

/*!
 @property denominator
 @abstract the denominator part of the fraction
 
 */
@property (readonly) long denominator;

/*!
 @method description
 @abstract Returns a String representing the double format of the fraction.
 @discussion If a true representation of the Fraction is required use the accessor methods to retrieve the two 
 longs and construct the required format.
 
 */
-(NSString*) description;

@end


/*!
@class EXFTag
@abstract Definition data of an EXF Tag
@discussion The EXFTag consists of an tagId, dataType, shortName, parentTagId, whether it is user editable and the number of 
components that each tag consists of. 

The dataType can only be one of the valid EXFDataType enum values.
The shortName is as specified in the EXF specification. If localised or more user readable names are required you should use these 
as the key values to the localised form.
The parentTagId shows the hierarchical parent Tag of each EXFTag. This is required in order to work out which directory or subdirectory 
a tag value should be inserted into.
Editable tags are those that can be altered or add by users of the library. Attempting to alter a non-writable tag will result in an exception.
Components defines the number of instances of each data type. As each data type is a certain number of bytes the actual byte size occupied 
for each tag is components * dataType size.
For more detail see the EXF specification <a href="http://www.exif.org/Exif2-2.PDF">http://www.exif.org/Exif2-2.PDF</a>

*/

@interface EXFTag : NSObject {
    
     
    EXFTagId tagId;
    EXFDataType dataType;
    int parentTagId;
    NSString* name;
    BOOL editable;
    int components;
    
}

/*!
@method initWith
*/

-(id) initWith: (EXFTagId) aTagId: (EXFDataType)aDataType: (NSString*) aName: (int) parentTagId: (BOOL)editable: (int) components;


@property (readonly) EXFTagId tagId;
@property (readonly) EXFDataType dataType;
@property (readonly, retain) NSString* name;
@property (readonly) int parentTagId;
@property (readonly) BOOL editable;
@property (readonly) int components;


@end

