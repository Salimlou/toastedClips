//
//  GUIElement.h
//  toastedClips
//
//  Created by emsi on 30/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "UtilTypes.h"
#include "GUIControl.h"

class GUIElement {
private:
    TEPoint mPosition;
    GUIControl * constPart;
    GUIControl * floatPart;
   
    
    
public:
    GUIElement();
    GUIElement(NSString* constPart,NSString* floatPart, TEPoint position, TESize size,int type);
    void update();
	void draw();
    bool containsPoint(CGPoint point);
    void doExecute(CGPoint);
    float value;
    float defaultValue;
    float minValue;
    float maxValue;
    float maxPosition;
    float minPosition;
    
    float angleForValue(float theValue);
    
    float valueForAngle(float theAngle);
    
    float angleBetweenCenterAndPoint(CGPoint point);
    
    float squaredDistanceToCenter(CGPoint point);
    
    
    CGPoint xForValue(float theValue);
    
    float valueForX(CGPoint position);
    
    

};