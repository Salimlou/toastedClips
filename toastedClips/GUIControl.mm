//
//  GUIControl.cpp
//  toastedClips
//
//  Created by emsi on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//////test
#include "GUIControl.h"
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

GUIControl::GUIControl(){}

GUIControl::GUIControl(NSString* resourceName, TEPoint position, TESize size) {
    //addEventSubscription(TEComponent.Event.EVENT_MOVE_TO_TOP, mMoveToTopListener);
    TEPoint pointZerro;
    pointZerro.x = 0 ;
    pointZerro.y = 0 ;
    mTexture = new UtilTexture(resourceName, pointZerro, size);
    if (size.width == 0 && size.height == 0) {
        size = mTexture->getBitmapSize();
        // NSLog(@"TAille image %f %f " , mTexture->getBitmapSize().width ,mTexture->getBitmapSize().height);
    }
    mWidth = mTexture->mWidth;
    mHeight = mTexture->mHeight;
   
    mCrop[0] = 0;
    mCrop[1] = mTexture->getBitmapSize().height;
    mCrop[2] = mTexture->getBitmapSize().width;
    mCrop[3] = -mTexture->getBitmapSize().height;
    mPosition = position;
    angle = 0;
    NSLog(@"TAille image %d %d %d %d  " , mCrop[0] ,mCrop[1],mCrop[2],mCrop[3]);
     NSLog(@"mPosition %f %f  " , position.x ,position.y);
}

void GUIControl::update() {
    //if (angle ==360) {
    //    angle =0;
   // }else{
   //     angle =  angle++;
   // }

}

void GUIControl::draw() {
	glBindTexture(GL_TEXTURE_2D, mTexture->mTextureName);
	
/*	const bool useDrawTexfOES = false;
	if (useDrawTexfOES) {
		glTexParameteriv(GL_TEXTURE_2D, GL_TEXTURE_CROP_RECT_OES, mCrop);
        glDrawTexfOES(mPosition.x - (mWidth / 2), mPosition.y - (mHeight / 2), 
        0.001f, mWidth, mHeight);
		//glDrawTexfOES(320 - 160,480 - 240, 
          //           0.001f, mWidth, mHeight);
        
//	} else {*/
    
    glPushMatrix();
    
    
    if (isRotary) {
        glTranslatef(mPosition.x - (mWidth / 4) , mPosition.y- (mWidth / 4), 0.0f);
        // glRotatef(180,0, 0 , 1);
        glRotatef(angle,0, 0 , 1);
        glTranslatef(+ (mWidth/4), + (mWidth/4), 0.0f);
    } else if(isSlider){ 
        glTranslatef(mPosition.x ,mPosition.y, 0.0f);
    }else{
        glTranslatef(mPosition.x ,mPosition.y, 0.0f);
    }
    glTexCoordPointer(2, GL_FLOAT, 0, mTexture->mTextureBuffer);
    glVertexPointer(2, GL_FLOAT, 0, mTexture->mVertexBuffer);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
    
    glPopMatrix();
	
    
}

