//
//  FreeCellGame.cpp
//  TouchEngine
//
//  Created by geminileft on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "Gui.h"
/*#include "TEGameObject.h"
#include "TEComponentStack.h"
#include "StackTableCell.h"
#include "StackCard.h"*/
#include "UtilTypes.h"
#include "GUIControl.h"


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
void Gui::start(NSString * str , NSString * str2) {
    
    
    TESize size2;
    size2.height = 0;
    size2.width = 0;
    
    TEPoint point2;
    point2.x = 160;
    point2.y = 240;
    
    TEPoint point3;
    point3.x = 240;
    point3.y = 100; 
    
   
    
    getSharedInstance()->knob = new GUIElement(str,str2, point2, size2,0) ;
    getSharedInstance()->slide = new GUIElement(@"sliderFixe", @"sliderFloat",point3 , size2,1);
  
    
}

void Gui::run() {
    getSharedInstance()->knob->update();
    getSharedInstance()->knob->draw();
    getSharedInstance()->slide->update();
    getSharedInstance()->slide->draw();
}

GUIElement * Gui::getElement() {
    return getSharedInstance()->knob;
}
GUIElement * Gui::getElement2() {
    return getSharedInstance()->slide;
}