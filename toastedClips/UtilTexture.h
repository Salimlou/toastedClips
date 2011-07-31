#ifndef TEUTILTEXTURE
#define TEUTILTEXTURE

#include <string>

#include <OpenGLES/ES1/glext.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <QuartzCore/QuartzCore.h>
#include "UtilTypes.h"

class UtilTexture{
private:
	int mBitmapWidth;
	int mBitmapHeight;
	int mCropWidth;
	int mCropHeight;
    
    void GLUtexImage2D(CGImageRef cgImage);

public:
    UtilTexture(NSString * resourceName, TEPoint position, TESize size);
	GLuint mTextureName;
	float mTextureBuffer[8];
	float mVertexBuffer[8];
	TEPoint mPosition;
    TESize getBitmapSize() const;
	TESize getCropSize() const;
};

#endif