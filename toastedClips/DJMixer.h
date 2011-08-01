//
//  DJMixer.h
//  CrossFader
//
//  Created by arab stab on 5/07/09.
//  Copyright 2009 Aran Mulholland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#include <AudioUnit/AudioUnit.h>
#import "AudioToolbox/AudioToolbox.h"
#import "InMemoryAudioFile.h"

@interface DJMixer : NSObject {

	//the audio output
	AudioUnit output;
	AudioStreamBasicDescription audioFormat;

	//the graph of audio connections
	AUGraph graph;

	//the audio unit nodes in the graph
	AudioUnit crossFaderMixer;	
	AudioUnit masterFaderMixer;
	
	InMemoryAudioFile *loopOne;
	InMemoryAudioFile *loopTwo;
	
}

@property (nonatomic) AudioUnit crossFaderMixer;
@property (nonatomic) AudioUnit masterFaderMixer;
@property (nonatomic, retain) InMemoryAudioFile *loopOne;
@property (nonatomic, retain) InMemoryAudioFile *loopTwo;

-(void)initAudio;
-(void)changeCrossFaderAmount:(float)volume;
-(void)play;

@end
