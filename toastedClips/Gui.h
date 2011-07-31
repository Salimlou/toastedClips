//
//  Gui.cpp
//  toastedClips
//
//  Created by emsi on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#ifndef GUI 

#define GUI





#include "GuiEngine.h"

#include "GUIElement.h"
class Gui : public GuiEngine {
public:
    Gui();
    virtual void start(NSString * str, NSString * str2);
    virtual void run();
    static Gui * getSharedInstance();
    GUIElement * getElement();
private:
    GUIElement * knob;
    

};

#endif