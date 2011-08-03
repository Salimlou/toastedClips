//
//  GUIControl.h
//  toastedClips
//
//  Created by emsi on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#ifndef GUICONTROL
#define GUICONTROL



#include "UtilTexture.h"
#include "GUIElement.h"
class GUIElement;

class GUIControl {
private:
	UtilTexture* mTexture;
	int mCrop[4];
    GUIElement * parent;
	
    
    
public:
    GUIControl();
    GUIControl(NSString* resourceName, TEPoint position, TESize size, GUIElement * parent );
    void update();
	void draw();
    int mWidth;
	int mHeight;
    bool isRotary;
    bool isSlider;
    TEPoint mPosition;
    float angle;
    
};

#endif