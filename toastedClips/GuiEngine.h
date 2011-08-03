//
//  GuiEngine.h
//  toastedClips
//
//  Created by emsi on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#ifndef GUIENGINE
#define GUIENGINE

#include "UtilTypes.h"
/*#include <vector>
*/

class GuiEngine {
    
private:
    //std::vector<TEManager*> mManagers;
   // std::vector<TEGameObject*> mGameObjects;
   
public:
	int mHeight;
	int mWidth;
    GuiEngine();
    GuiEngine(int width, int height);
    virtual void start() =0;
    virtual void run() =0;
    void addObject(/*TEGameObject* gameObject*/);
    void initGraphics(int width, int height);
	void graphicsChange(int width, int height);
    TESize getScreenSize() const;
};

#endif