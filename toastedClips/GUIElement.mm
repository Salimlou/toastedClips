//
//  GUIElement.cpp
//  toastedClips
//
//  Created by emsi on 30/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "GUIElement.h"

#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

GUIElement::GUIElement(){}

GUIElement::GUIElement(NSString* resourceName , NSString* resourceName2, TEPoint position, TESize size) {
    
    constPart = new GUIControl(resourceName, position, size) ;
    floatPart  = new GUIControl(resourceName2, position, size) ;
    constPart->isRotary = false;
    floatPart->isRotary = true;
}

void GUIElement::update() {
    
    floatPart->update();
}

void GUIElement::draw() {
    constPart->draw();
    floatPart->draw();
}


bool GUIElement::containsPoint(TEPoint point) {
    bool returnValue = false;
    TEPoint position = floatPart->mPosition;
    float left = (float)floatPart->mPosition.x - ((float)floatPart->mWidth / 2);
    float right = (float)floatPart->mPosition.x + ((float)floatPart->mWidth / 2);
    float bottom = (float)floatPart->mPosition.y - ((float)floatPart->mHeight / 2);
    float top = (float)floatPart->mPosition.y + ((float)floatPart->mHeight / 2);
    
    if ((point.x >= left) && (point.x <= right) && (point.y >= bottom) && (point.y <= top)) {
        returnValue = true;
        printf("\n in %d %d %d %d \n", left,right,bottom,top);
    }
    return returnValue;
}