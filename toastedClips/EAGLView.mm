//
//  EAGLView.m
//  toastedClips
//
//  Created by emsi on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "EAGLView.h"

@implementation EAGLView

@synthesize context;
@synthesize djMixer;
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame game:(Gui*) game {
	const int scaleFactor = 1;
    Gui * gui = Gui::getSharedInstance();
    if (!gui) {
        exit(1);
    }
	frame.size.width = gui->mWidth * scaleFactor;
	frame.size.height = gui->mHeight * scaleFactor;
    self = [super initWithFrame:frame];
	if (self) {
       
       
        EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        if (!aContext)
            NSLog(@"Failed to create ES context");
        else if (![EAGLContext setCurrentContext:aContext])
            NSLog(@"Failed to set ES context current");
        self.context = aContext;
        [aContext release];
        glGenFramebuffers(1, &mDefaultFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, mDefaultFramebuffer);
        glGenRenderbuffers(1, &mColorRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, mColorRenderbuffer);
        [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &mFramebufferWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &mFramebufferHeight);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, mColorRenderbuffer);
        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
            NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));        
        glBindFramebuffer(GL_FRAMEBUFFER, mDefaultFramebuffer);
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
                                        nil];
        NSLog(@"taille frame buffer width  %d height   %d",mFramebufferWidth,mFramebufferHeight);
      
        Gui::getSharedInstance()->initGraphics(mFramebufferWidth, mFramebufferHeight);
         Gui::getSharedInstance()->start(); 
        [self startAnimation];
         NSLog(@"create ES context");
    }
      
    
    //initialisation audio
    djMixer = [[DJMixer alloc]init];
    [djMixer play];
    return self;
}

- (void)dealloc
{
    [context release];
    
    [super dealloc];
}
- (void)startAnimation {
    
    CADisplayLink *aDisplayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(drawFrame)];
    [aDisplayLink setFrameInterval:1/60];
    [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
  	
}

- (void)drawFrame
{
    glClear(GL_COLOR_BUFFER_BIT);
    Gui::getSharedInstance()->run();
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  //  TEManagerInput* inputManager = TEManagerInput::sharedManager();
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    for (UITouch* touch in touches) {
        CGPoint point = [touch locationInView:self];
        float x = point.x;
        float y = screenSize.size.height - point.y;
      //  TEInputTouch* inputTouch = new TEInputTouch([touch hash], x, y);
      //  inputManager->beginTouch(inputTouch);
        
        TEPoint p;
        p.x = x;
        p.y = y;
        GUIElement * element = Gui::getSharedInstance()->getElementByTouch(point);
        if (element != NULL) {
            element->doExecute(point);
            [djMixer changeCrossFaderAmount:element->value];
        }

    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  //  TEManagerInput* inputManager = TEManagerInput::sharedManager();
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    for (UITouch* touch in touches) {
        CGPoint point = [touch locationInView:self];
        float x = point.x;
        float y = screenSize.size.height - point.y;	
        TEPoint p;
        p.x = x;
        p.y = y;
        GUIElement * element = Gui::getSharedInstance()->getElementByTouch(point);
        if (element != NULL) {
            element->doExecute(point);
            [djMixer changeCrossFaderAmount:element->value];
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  //  TEManagerInput* inputManager = TEManagerInput::sharedManager();
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    for (UITouch* touch in touches) {
        CGPoint point = [touch locationInView:self];
        float x = point.x;
        float y = screenSize.size.height - point.y;	
      //  TEInputTouch* inputTouch = new TEInputTouch([touch hash], x, y);
      //  inputManager->endTouch(inputTouch);
        TEPoint p;
        p.x = x;
        p.y = y;
        GUIElement * element = Gui::getSharedInstance()->getElementByTouch(point);
        if (element != NULL) {
            element->doExecute(point);
            [djMixer changeCrossFaderAmount:element->value];
        }
        
       

    }
}







@end

