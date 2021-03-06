

#include "UtilTexture.h"
#include "UtilsMath.h"

typedef enum {
	kTexture2DPixelFormat_Automatic = 0,
	kTexture2DPixelFormat_RGBA8888,
	kTexture2DPixelFormat_RGB565,
	kTexture2DPixelFormat_A8,
} Texture2DPixelFormat;


UtilTexture::UtilTexture(NSString* resourceName, TEPoint position, TESize size) {
    glGenTextures(1, &mTextureName);
    glBindTexture(GL_TEXTURE_2D, mTextureName);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);    
   // glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
   // glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT); 
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE); //GL10.GL_REPLACE);
    UIImage* image = [UIImage imageNamed:resourceName];
    float width;
	float height;
	if (size.height != 0 || size.width != 0) {
		width = size.width;
		height = size.height;
      //  printf("\nsize %f %f ",width,height );
	} else {
		width = image.size.width;
		height = image.size.height;
        mWidth = image.size.width;
        mHeight = image.size.height;
      //  printf("\n image.size %f %f ",image.size.width,image.size.height );
	}
	float left;
    mPosition = position;
	if (position.x != 0 || position.y != 0) {
		left = position.x /width;
       //  printf("\nleft %f ",left );
	} else {
		left = 0;
       // printf("\nleft %f ",left );
	}
	
	
	const float maxS = ((float)width / image.size.width) + left;
	const float maxT = (float)height / image.size.height;
    // printf("\nmaxS maxT %f %f ",maxS,maxT );
	
	mTextureBuffer[0] = left;//left
	mTextureBuffer[1] = maxT;//top
	mTextureBuffer[2] = maxS;//right
	mTextureBuffer[3] = maxT;//top
	mTextureBuffer[4] = maxS;//right
	mTextureBuffer[5] = 0.0f;//bottom
	mTextureBuffer[6] = left;//left
	mTextureBuffer[7] = 0.0f;//bottom

	const float leftX = -(float)width / 2;
	const float rightX = leftX + width;
	const float bottomY = -(float)height / 2;
	const float topY = bottomY + height;
    
   // printf("\nleftX rightX %f %f ",leftX,rightX );
   // printf("\nbottomY topY  %f %f ",bottomY,topY );
	
	mVertexBuffer[0] = leftX;
	mVertexBuffer[1] = bottomY;
	mVertexBuffer[2] = rightX;
	mVertexBuffer[3] = bottomY;
	mVertexBuffer[4] = rightX;
	mVertexBuffer[5] = topY;
	mVertexBuffer[6] = leftX;
	mVertexBuffer[7] = topY;

    GLUtexImage2D([image CGImage]);
}

TESize UtilTexture::getBitmapSize() const {
    TESize size;
    size.width = mBitmapWidth;
    size.height = mBitmapHeight;
    return size;
}
	
TESize UtilTexture::getCropSize() const {
    TESize size;
    size.width = mCropWidth;
    size.height = mCropHeight;
    return size;
}

void UtilTexture::GLUtexImage2D(CGImageRef cgImage) {
    NSUInteger				width,
    height,
    i;
    CGContextRef			context = nil;
    void*					data = nil;;
    CGColorSpaceRef			colorSpace;
    void*					tempData;
    unsigned int*			inPixel32;
    unsigned short*			outPixel16;
    BOOL					hasAlpha;
    CGImageAlphaInfo		info;
    Texture2DPixelFormat    pixelFormat;
    
    info = CGImageGetAlphaInfo(cgImage);
    hasAlpha = ((info == kCGImageAlphaPremultipliedLast)
                || (info == kCGImageAlphaPremultipliedFirst)
                || (info == kCGImageAlphaLast)
                || (info == kCGImageAlphaFirst));
    
    if(CGImageGetColorSpace(cgImage)) {
        if(hasAlpha)
            pixelFormat = kTexture2DPixelFormat_RGBA8888;
        else
            pixelFormat = kTexture2DPixelFormat_RGB565;
    } else  //NOTE: No colorspace means a mask image
        pixelFormat = kTexture2DPixelFormat_A8;
    
    width = CGImageGetWidth(cgImage);
    height = CGImageGetHeight(cgImage);
   
    width = closestPowerOf2(width);
    height = closestPowerOf2(height);
    mBitmapWidth = width;
    mBitmapHeight = height;
    
    switch(pixelFormat) {
        case kTexture2DPixelFormat_RGBA8888:
            colorSpace = CGColorSpaceCreateDeviceRGB();
            data = malloc(height * width * 4);
            context = CGBitmapContextCreate(data, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
            CGColorSpaceRelease(colorSpace);
            break;
        case kTexture2DPixelFormat_RGB565:
            colorSpace = CGColorSpaceCreateDeviceRGB();
            data = malloc(height * width * 4);
            context = CGBitmapContextCreate(data, width, height, 8, 4 * width, colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big);
            CGColorSpaceRelease(colorSpace);
            break;
            
        case kTexture2DPixelFormat_A8:
            data = malloc(height * width);
            context = CGBitmapContextCreate(data, width, height, 8, width, NULL, kCGImageAlphaOnly);
            break;				
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid pixel format"];
    }
    
    
    //CGContextClearRect(context, CGRectMake(0, 0, width, height));
    //CGContextTranslateCTM(context, 0, height - mImageSize.height);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(cgImage), CGImageGetHeight(cgImage)), cgImage);
    if(pixelFormat == kTexture2DPixelFormat_RGB565) {
        tempData = malloc(height * width * 2);
        inPixel32 = (unsigned int*)data;
        outPixel16 = (unsigned short*)tempData;
        for(i = 0; i < width * height; ++i, ++inPixel32)
            *outPixel16++ = ((((*inPixel32 >> 0) & 0xFF) >> 3) << 11) | ((((*inPixel32 >> 8) & 0xFF) >> 2) << 5) | ((((*inPixel32 >> 16) & 0xFF) >> 3) << 0);
        free(data);
        data = tempData;
        
    }    
    //glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    switch(pixelFormat) {
            
        case kTexture2DPixelFormat_RGBA8888:
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
            break;
        case kTexture2DPixelFormat_RGB565:
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, data);
            break;
        case kTexture2DPixelFormat_A8:
            glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, width, height, 0, GL_ALPHA, GL_UNSIGNED_BYTE, data);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@""];
    }
    //CGContextRelease(context);
    //free(data);
	
}
