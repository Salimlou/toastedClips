//
//  GUIElement.cpp
//  toastedClips
//
//  Created by emsi on 30/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "GUIElement.h"

#import <math.h>

#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#define MAX_ANGLE 160.0f
#define MIN_DISTANCE_SQUARED 16.0f

GUIElement::GUIElement(){}

GUIElement::GUIElement(NSString* resourceName , NSString* resourceName2, TEPoint position, TESize size) {
    
    constPart = new GUIControl(resourceName, position, size) ;
    floatPart  = new GUIControl(resourceName2, position, size) ;
    constPart->isRotary = false;
    floatPart->isRotary = true;
    
    minValue = 0.0f;
	maxValue = 1.0f;
	value = defaultValue = 0.5f;
    floatPart->angle = angleForValue(value);
}

void GUIElement::update() {
    
    floatPart->update();
}

void GUIElement::draw() {
    constPart->draw();
    floatPart->draw();
}


void GUIElement::doExecute(CGPoint point){
    CGPoint direction;
    direction.x = point.x - floatPart->mPosition.x + floatPart->mHeight;
    direction.y = point.y - floatPart->mPosition.y;
    
    printf("\n direction  %f  \n", direction.y );
    printf(" acos     %f ", acos(-point.y) );
    floatPart->angle =angleBetweenCenterAndPoint(point);
    
    printf("value for angle %f ", valueForAngle(floatPart->angle));
    
    //if (point.x> floatPart->mPosition.x - (floatPart->mHeight/4)) {
        floatPart->angle = -floatPart->angle;
    //}
    
    value = valueForAngle(floatPart->angle);
    
}

bool GUIElement::containsPoint(CGPoint point) {
    bool returnValue = false;
    TEPoint position = floatPart->mPosition;
    float left = (float)floatPart->mPosition.x - ((float)floatPart->mWidth / 2);
    float right = (float)floatPart->mPosition.x + ((float)floatPart->mWidth / 2);
    float bottom = (float)floatPart->mPosition.y - ((float)floatPart->mHeight / 2);
    float top = (float)floatPart->mPosition.y + ((float)floatPart->mHeight / 2);
    
    if ((point.x >= left) && (point.x <= right) && (point.y >= bottom) && (point.y <= top)) {
        returnValue = true;
        printf("\n in %f %f %f %f \n", left,right,bottom,top);
        printf("\n in %f %f \n", point.x , point.y);
    }
    return returnValue;
}




float GUIElement::angleForValue(float theValue)
{
	return ((theValue - minValue)/(maxValue - minValue) - 0.5f) * (MAX_ANGLE*2.0f);
}

float GUIElement::valueForAngle(float theAngle)
{
	return (floatPart->angle/(MAX_ANGLE*2.0f) + 0.5f) * (maxValue - minValue) + minValue;
}

float GUIElement::angleBetweenCenterAndPoint(CGPoint point)
{
	CGPoint center = CGPointMake(floatPart->mPosition.x - floatPart->mWidth/4.0f,floatPart->mPosition.y + floatPart->mHeight/4.0f);
    printf("le centre %f %f " , center.x , center.y);
	// Yes, the arguments to atan2() are in the wrong order. That's because our
	// coordinate system is turned upside down and rotated 90 degrees. :-)
	floatPart->angle = atan2(  point.x - center.x , center.y - point.y ) * 180.0f/M_PI;
    
	if (floatPart->angle < -MAX_ANGLE)
    {
		floatPart->angle = -MAX_ANGLE;
    }
	else if (floatPart->angle > MAX_ANGLE)
    {
		floatPart->angle = MAX_ANGLE;
    }
    
	return floatPart->angle;
}

float GUIElement::squaredDistanceToCenter(CGPoint point)
{
	CGPoint center = CGPointMake(floatPart->mWidth/2.0f, floatPart->mHeight/2.0f);
	float dx = point.x - center.x;
	float dy = point.y - center.y;
	return dx*dx + dy*dy;
}


