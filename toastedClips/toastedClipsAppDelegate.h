//
//  toastedClipsAppDelegate.h
//  toastedClips
//
//  Created by emsi on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJMixer.h"

@interface toastedClipsAppDelegate : NSObject <UIApplicationDelegate> {
@private
    UIWindow* mWindow;
    DJMixer *djMixer;
}



@end
