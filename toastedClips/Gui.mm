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
    
    TESize size;
    size.height = 0;
    size.width = 0;
    
    TESize size2;
    size2.height = 0;
    size2.width = 0;
    
    TEPoint point;
    point.x = 0;
    point.y = 0;
    
    TEPoint point2;
    point2.x = 240;
    point2.y = 160;
    
   
    
    getSharedInstance()->knob = new GUIElement(str,str2, point2, size2) ;;
    
    // if (!knobCircle) {
   //     exit(1);
  //  }
//    if (!knobArrow) {
//        exit(1);
//    }
    
}

void Gui::run() {
    getSharedInstance()->knob->update();
    getSharedInstance()->knob->draw();
}

GUIElement * Gui::getElement() {
    return getSharedInstance()->knob;
}
