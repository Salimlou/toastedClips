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
#include <vector>
#include "GUIElement.h"

class Gui : public GuiEngine {
public:
    Gui();
    virtual void start();
    virtual void run();
    static Gui * getSharedInstance();
    GUIElement * getElement();
    GUIElement * getElement2();
    void addControls(GUIElement *);
    GUIElement * getElementByTouch( CGPoint point);
private:
    std::vector<GUIElement*> mControls;

};

#endif