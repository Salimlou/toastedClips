//
//  GUIControl.h
//  toastedClips
//
//  Created by emsi on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#ifndef GUICONTROL
#define GUICONTROL


#include "UtilTypes.h"
#include "UtilTexture.h"

class GUIControl {
private:
	UtilTexture* mTexture;
	int mCrop[4];
	
    float angle;
    
public:
    GUIControl();
    GUIControl(NSString* resourceName, TEPoint position, TESize size);
    void update();
	void draw();
    int mWidth;
	int mHeight;
    bool isRotary;
    TEPoint mPosition;
    
};

#endif