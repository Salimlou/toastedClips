//
//  EAGLView.h
//  toastedClips
//
//  Created by emsi on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "DJMixer.h"

#import "Gui.h"

@class EAGLContext;
@interface EAGLView : UIView {
@private
    GLint mFramebufferWidth;
    GLint mFramebufferHeight;
    GLuint mDefaultFramebuffer;
    GLuint mColorRenderbuffer;
    Gui* mGame;
    DJMixer * djMixer;
}

@property (nonatomic, retain)DJMixer *djMixer;
@property (nonatomic, retain) EAGLContext *context;

- (id)initWithFrame:(CGRect)frame game:(Gui*) game ;
- (void)startAnimation;

@end

