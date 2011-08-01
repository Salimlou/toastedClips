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

GUIElement::GUIElement(NSString* resourceName , NSString* resourceName2, TEPoint position, TESize size,int type) {
    //0 rotory
    //1 horizontal
    constPart = new GUIControl(resourceName, position, size , this) ;
    floatPart  = new GUIControl(resourceName2, position, size , this) ;
    if (type==0) {
        floatPart->isRotary = true;
        floatPart->isSlider =false;
    }else{
        floatPart->isRotary = false;
        floatPart->isSlider =true;
    }
    constPart->isSlider = false;
    constPart->isRotary = false;
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
   
    if (floatPart->isRotary ) {
        
        floatPart->angle =angleBetweenCenterAndPoint(point);
        floatPart->angle = -floatPart->angle;
        
        value = valueForAngle(floatPart->angle);
    }else if (floatPart->isSlider ){
        floatPart->mPosition.x =valueForX(point);
        
    } 
  
    
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


CGPoint GUIElement::xForValue(float theValue)

{ CGPoint p = CGPointMake(constPart->mPosition.x + constPart->mWidth*theValue, floatPart->mPosition.y) ;
    if (p.x > constPart->mWidth) {
        p.x = constPart->mWidth;
    }else if(p.x< constPart->mPosition.x){
        p.x = constPart->mPosition.x;
    }
	return p;
}

float GUIElement::valueForX(CGPoint position)
{   float temp = position.x - constPart->mWidth / constPart->mWidth;
    if (temp<0) {
        return 0 ;
    }else if(temp > 1){
        return 1;
    }
	return temp;
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


