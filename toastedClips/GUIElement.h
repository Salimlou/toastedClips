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
    float value;
    float maxPosition;
    float minPosition;
    
    
public:
    GUIElement();
    GUIElement(NSString* constPart,NSString* floatPart, TEPoint position, TESize size);
    void update();
	void draw();
    bool containsPoint(TEPoint point);
};