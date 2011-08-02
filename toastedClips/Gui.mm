//
//  FreeCellGame.cpp
//  TouchEngine
//
//  Created by geminileft on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "Gui.h"




#define CARD_SIZE_WIDTH 48
#define CARD_SIZE_HEIGHT 64
#define START_X 28
#define X_GAP 50

static Gui * singleton =NULL;

Gui::Gui(){}


Gui * Gui::getSharedInstance(){
    if (singleton==NULL) {
        singleton = new Gui();
    }
    return singleton;
}
void Gui::start() {
    
    
    TESize size2;
    size2.height = 0;
    size2.width = 0;
    
    TEPoint point2;
    point2.x = 160;
    point2.y = 240;
    
    TEPoint point3;
    point3.x = 100;
    point3.y = 200; 
    
   
    
    GUIElement * knob = new GUIElement(@"tes-01",@"tesF", point2, size2,0) ;
    GUIElement * slide = new GUIElement(@"Fader", @"FaderF-01",point3 , size2,1);
    getSharedInstance()->addControls(knob);
    getSharedInstance()->addControls(slide);
  
    
}

void Gui::run() {
   std::vector<GUIElement*>::iterator iterator;
    
    for (iterator = mControls.begin(); iterator != mControls.end();iterator++) {
        GUIElement* component = (GUIElement*)(*iterator);
        component->update();
        component->draw();
    }
   
}
GUIElement * Gui::getElementByTouch( CGPoint point) {
    std::vector<GUIElement*>::iterator iterator;
    
    for (iterator = mControls.begin(); iterator != mControls.end();iterator++) {
        GUIElement* component = (GUIElement*)(*iterator);
        if (component->containsPoint(point)) {
            return component;
        }
    }
    return NULL;
}

void Gui::addControls(GUIElement * temp) {
    mControls.push_back(temp);
    
}

