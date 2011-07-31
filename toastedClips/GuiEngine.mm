//
//  GuiEngine.cpp
//  toastedClips
//
//  Created by emsi on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "GuiEngine.h"
/*
#include "TEManagerRender.h"
#include "TEManagerTouch.h"
#include "TEManagerStack.h"
#include "TEComponentRender.h"
#include "TEComponentTouch.h"
#include "TEComponentStack.h"
#include "TEGameObject.h"
 */
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include "UtilTypes.h"
#include "GUIControl.h"


#define CARD_SIZE_WIDTH 48
#define CARD_SIZE_HEIGHT 64


GuiEngine::GuiEngine() {
    mWidth = 320;
	mHeight = 480;
}

GuiEngine::GuiEngine(int width, int height) {
	mWidth = 320;
	mHeight = 480;
    
   
   
   /* TEManagerTouch* touchManager = TEManagerTouch::sharedManager();
    TEManagerStack* stackManager = TEManagerStack::sharedManager();
    //TEManagerSound soundManager = TEManagerSound.sharedManager();
    TEManagerRender* renderManager = TEManagerRender::sharedManager();
    mManagers.push_back(touchManager);
    mManagers.push_back(stackManager);
    //mManagers.add(soundManager);
    mManagers.push_back(renderManager);*/
}



void GuiEngine::addObject() {
   /* TEManagerRender* renderManager = TEManagerRender::sharedManager();
    TEManagerTouch* touchManager = TEManagerTouch::sharedManager();
    TEManagerStack* stackManager = TEManagerStack::sharedManager();
    
    TEComponentContainer components = gameObject->getComponents();
    TEComponentContainer::iterator iterator;
    TEComponent* component;
    for(iterator = components.begin();iterator != components.end();++iterator) {
        component = *iterator;
        if (dynamic_cast<TEComponentRender*>(component)) {
            renderManager->addComponent(component);
        } else if (dynamic_cast<TEComponentTouch*>(component)) {
            touchManager->addComponent(component);
        } else if (dynamic_cast<TEComponentStack*>(component)) {
            stackManager->addComponent(component);
          
        }
    }
    mGameObjects.push_back(gameObject);*/
}

void GuiEngine::initGraphics(int width, int height) {
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_FASTEST);
	glShadeModel(GL_FLAT);
	glDisable(GL_DEPTH_TEST);
	glDisable(GL_DITHER);
	glDisable(GL_LIGHTING);
	glTexEnvx(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    //always drawing textures...enable once
    glEnable(GL_TEXTURE_2D);
    //required for vertex/textures
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
      
	graphicsChange(width, height);
    
}

void GuiEngine::graphicsChange(int width, int height) {
    /*
     glViewport(0, 0, width, height);
     glMatrixMode(GL_PROJECTION);
     glOrthof(0.0f, width, 0.0f, height, 0.0f, 1.0f);
     glMatrixMode(GL_MODELVIEW);
     glLoadIdentity();
     */
	bool useOrtho = true;
	const int scaleFactor = 1;
	const int zDepth = height / (2 / scaleFactor);
	const float ratio = (float)width / height;
	glViewport(0, 0, width, height);
	glMatrixMode(GL_PROJECTION);
	if (useOrtho) {
		glOrthof(0.0f, width, 0.0f, height, 0.0f, 1.0f);
	} else {
		glFrustumf(-ratio, ratio, -1, 1, 1, zDepth);
	}
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	if (!useOrtho) {
		glTranslatef(-width / 2, -height / 2, -zDepth);
        //glTranslatef(0, 0, 0);
	}
}

 