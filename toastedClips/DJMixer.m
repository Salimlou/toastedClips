//
//  DJMixer.m
//  CrossFader
//
//  Created by arab stab on 5/07/09.
//  Copyright 2009 Aran Mulholland. All rights reserved.
//

#import "DJMixer.h"

#pragma mark Listeners


void propListener(	void *                  inClientData,
				  AudioSessionPropertyID	inID,
				  UInt32                  inDataSize,
				  const void *            inData){
	printf("property listener\n");
	//RemoteIOPlayer *THIS = (RemoteIOPlayer*)inClientData;
	if (inID == kAudioSessionProperty_AudioRouteChange){		
	}
}

void rioInterruptionListener(void *inClientData, UInt32 inInterruption){
	printf("Session interrupted! --- %s ---", inInterruption == kAudioSessionBeginInterruption ? "Begin Interruption" : "End Interruption");
	
	if (inInterruption == kAudioSessionEndInterruption) {
		// make sure we are again the active session
		AudioSessionSetActive(true);
		//AudioOutputUnitStart(THIS->audioUnit);
	}
	if (inInterruption == kAudioSessionBeginInterruption) {
		//AudioOutputUnitStop(THIS->audioUnit);
    }
}


#pragma mark Callbacks

static OSStatus crossFaderMixerCallback(void *inRefCon, 
							    AudioUnitRenderActionFlags *ioActionFlags, 
								const AudioTimeStamp *inTimeStamp, 
								UInt32 inBusNumber, 
								UInt32 inNumberFrames, 
								AudioBufferList *ioData) {  
	
	
	//get a reference to the djMixer class, we need this as we are outside the class
	//in just a straight C method.
	DJMixer *djMixer = (DJMixer *)inRefCon;
	
	UInt32 *frameBuffer = ioData->mBuffers[0].mData;
	if (inBusNumber == 0){
		//loop through the buffer and fill the frames
		for (int j = 0; j < inNumberFrames; j++){
			// get NextPacket returns a 32 bit value, one frame.
			frameBuffer[j] = [djMixer.loopOne getNextPacket];
		}
	}
	
	else if (inBusNumber == 1){
		//loop through the buffer and fill the frames
		for (int j = 0; j < inNumberFrames; j++){
			// get NextPacket returns a 32 bit value, one frame.
			frameBuffer[j] = [djMixer.loopTwo getNextPacket];
		}
	}
	return 0;
}

static OSStatus masterFaderCallback(void *inRefCon, 
							    AudioUnitRenderActionFlags *ioActionFlags, 
								const AudioTimeStamp *inTimeStamp, 
								UInt32 inBusNumber, 
								UInt32 inNumberFrames, 
								AudioBufferList *ioData) {  
	
	//get self
	DJMixer *djMixer = (DJMixer *)inRefCon;
	OSStatus err = 0;
	//get the audio from the crossfader, we could directly connect them but this gives us a chance to get at the audio
	//to apply an effect
	err = AudioUnitRender(djMixer.crossFaderMixer, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, ioData);
	//apply master effect (if any)		
	return err;
}

@implementation DJMixer

@synthesize crossFaderMixer;
@synthesize masterFaderMixer;

@synthesize loopOne;
@synthesize loopTwo;

-(id)init{
	
	self = [super init];
	
	loopOne = [[InMemoryAudioFile alloc]init];
	loopTwo = [[InMemoryAudioFile alloc]init];
	[loopOne open:[[NSBundle mainBundle] pathForResource:@"funkBeats" ofType:@"wav"]];
	[loopTwo open:[[NSBundle mainBundle] pathForResource:@"funk stabs 3" ofType:@"wav"]];

	[self initAudio];
	return self;
}

#pragma mark Volume Control

-(void)changeCrossFaderAmount:(float)volume{
	
	float inverseVolume = 1.0 - volume;
	
	float volumeChannelOne = 0.0; 
	float volumeChannelTwo = 0.0;
	
	if (volume > 0.5){
		volumeChannelOne = 1.0;
	}
	else{
		volumeChannelOne = volume * 2.0;		
	}
	
	if (inverseVolume > 0.5){
		volumeChannelTwo = 1.0;
	}
	else{
		volumeChannelTwo = inverseVolume * 2.0;		
	}
	
	//set the volume levels on the two input channels to the crossfader
	AudioUnitSetParameter(crossFaderMixer, kMultiChannelMixerParam_Volume, kAudioUnitScope_Input, 0, volumeChannelOne, 0);	
	AudioUnitSetParameter(crossFaderMixer, kMultiChannelMixerParam_Volume, kAudioUnitScope_Input, 1, volumeChannelTwo, 0);	
}

-(void)play{
	[loopOne play];
	[loopTwo play];
    printf("PLAY##################################################");
	
}


#pragma mark Initialization

-(void)initAudio{

	/*
	 Getting the value of kAudioUnitProperty_ElementCount tells you how many elements you have in a scope. This happens to be 8 for this mixer.
	 If you want to increase it, you need to set this property. 
	 */
	// Initialize and configure the audio session, and add an interuption listener
    AudioSessionInitialize(NULL, NULL, rioInterruptionListener, self);
	
	//set the audio category
	UInt32 audioCategory = kAudioSessionCategory_LiveAudio;
	AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory);
	
	UInt32 getAudioCategory = sizeof(audioCategory);
	AudioSessionGetProperty(kAudioSessionProperty_AudioCategory, &getAudioCategory, &getAudioCategory);
	
	if(getAudioCategory == kAudioSessionCategory_LiveAudio){
		NSLog(@"kAudioSessionCategory_LiveAudio");
	}
	else{
		NSLog(@"Could not get kAudioSessionCategory_LiveAudio");
	}
	
	
	//add a property listener
	AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, propListener, self);
	
	//set the buffer size as small as we can
	Float32 preferredBufferSize = .00125;
	AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration, sizeof(preferredBufferSize), &preferredBufferSize);
	
	//set the audio session active
	AudioSessionSetActive(YES);
	
	//the descriptions for the components
	AudioComponentDescription crossFaderMixerDescription, masterFaderDescription, outputDescription;
	
	//the AUNodes
	AUNode crossFaderMixerNode, masterMixerNode;
	AUNode outputNode;
	
	//the graph
	OSErr err = noErr;
	err = NewAUGraph(&graph);
	NSAssert(err == noErr, @"Error creating graph.");


	//the cross fader mixer
	crossFaderMixerDescription.componentFlags = 0;
	crossFaderMixerDescription.componentFlagsMask = 0;
	crossFaderMixerDescription.componentType = kAudioUnitType_Mixer;
	crossFaderMixerDescription.componentSubType = kAudioUnitSubType_MultiChannelMixer;
	crossFaderMixerDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	err = AUGraphAddNode(graph, &crossFaderMixerDescription, &crossFaderMixerNode);
	NSAssert(err == noErr, @"Error creating mixer node.");	
		
	//the master mixer
	masterFaderDescription.componentFlags = 0;
	masterFaderDescription.componentFlagsMask = 0;
	masterFaderDescription.componentType = kAudioUnitType_Mixer;
	masterFaderDescription.componentSubType = kAudioUnitSubType_MultiChannelMixer;
	masterFaderDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	err = AUGraphAddNode(graph, &masterFaderDescription, &masterMixerNode);
	NSAssert(err == noErr, @"Error creating mixer node.");
	
	//the output
	outputDescription.componentFlags = 0;
	outputDescription.componentFlagsMask = 0;
	outputDescription.componentType = kAudioUnitType_Output;
	outputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	outputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	err = AUGraphAddNode(graph, &outputDescription, &outputNode);
	NSAssert(err == noErr, @"Error creating output node.");
	
	err = AUGraphOpen(graph);
	NSAssert(err == noErr, @"Error opening graph.");
	
	//get the cross fader
	err = AUGraphNodeInfo(graph, crossFaderMixerNode, &crossFaderMixerDescription, &crossFaderMixer);
	//get the master fader
	err = AUGraphNodeInfo(graph, masterMixerNode, &masterFaderDescription, &masterFaderMixer);
	//get the output
	err = AUGraphNodeInfo(graph, outputNode, &outputDescription, &output);
	
	
	//the cross fader mixer
	AURenderCallbackStruct callbackCrossFader;
	callbackCrossFader.inputProc = crossFaderMixerCallback;
	//set the reference to "self" this becomes *inRefCon in the playback callback
	callbackCrossFader.inputProcRefCon = self;
	
	//mixer channel 0
	err = AUGraphSetNodeInputCallback(graph, crossFaderMixerNode, 0, &callbackCrossFader);
	NSAssert(err == noErr, @"Error setting render callback 0 Cross fader.");
	//mixer channel 1
	err = AUGraphSetNodeInputCallback(graph, crossFaderMixerNode, 1, &callbackCrossFader);
	NSAssert(err == noErr, @"Error setting render callback 1 Cross fader.");
	
	// Set up the master fader callback
	AURenderCallbackStruct playbackCallbackStruct;
	playbackCallbackStruct.inputProc = masterFaderCallback;
	//set the reference to "self" this becomes *inRefCon in the playback callback
	playbackCallbackStruct.inputProcRefCon = self;
	
	err = AUGraphSetNodeInputCallback(graph, outputNode, 0, &playbackCallbackStruct);
	NSAssert(err == noErr, @"Error setting effects callback.");
			
	// Describe format
	audioFormat.mSampleRate			= 44100.00;
	audioFormat.mFormatID			= kAudioFormatLinearPCM;
	audioFormat.mFormatFlags		= kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
	audioFormat.mFramesPerPacket	= 1;
	audioFormat.mChannelsPerFrame	= 2;
	audioFormat.mBitsPerChannel		= 16;
	audioFormat.mBytesPerPacket		= 4;
	audioFormat.mBytesPerFrame		= 4;
	
	
	//set the master fader input properties
	err = AudioUnitSetProperty(output, 
							   kAudioUnitProperty_StreamFormat, 
							   kAudioUnitScope_Input, 
							   0, 
							   &audioFormat, 
							   sizeof(audioFormat));
	NSAssert(err == noErr, @"Error setting RIO input property.");
	
	//set the master fader input properties
	err = AudioUnitSetProperty(masterFaderMixer, 
							   kAudioUnitProperty_StreamFormat, 
							   kAudioUnitScope_Input, 
							   0, 
							   &audioFormat, 
							   sizeof(audioFormat));
	NSAssert(err == noErr, @"Error setting Master fader property.");
	
	//set the master fader input properties
	err = AudioUnitSetProperty(masterFaderMixer, 
							   kAudioUnitProperty_StreamFormat, 
							   kAudioUnitScope_Output, 
							   0, 
							   &audioFormat, 
							   sizeof(audioFormat));
	NSAssert(err == noErr, @"Error setting Master fader property.");	

	
	//set the crossfader output properties
	err = AudioUnitSetProperty(crossFaderMixer, 
							   kAudioUnitProperty_StreamFormat, 
							   kAudioUnitScope_Output, 
							   0, 
							   &audioFormat, 
							   sizeof(audioFormat));
	NSAssert(err == noErr, @"Error setting output property format 0.");
	
	
	//set the crossfader input properties
	err = AudioUnitSetProperty(crossFaderMixer, 
							   kAudioUnitProperty_StreamFormat, 
							   kAudioUnitScope_Input, 
							   0, 
							   &audioFormat, 
							   sizeof(audioFormat));
	NSAssert(err == noErr, @"Error setting property format 0.");
	
	err = AudioUnitSetProperty(crossFaderMixer, 
							   kAudioUnitProperty_StreamFormat, 
							   kAudioUnitScope_Input, 
							   1, 
							   &audioFormat, 
							   sizeof(audioFormat));
	NSAssert(err == noErr, @"Error setting property format 1.");
	

	err = AUGraphInitialize(graph);
	NSAssert(err == noErr, @"Error initializing graph.");
	
	CAShow(graph); 
	
	err = AUGraphStart(graph);
	NSAssert(err == noErr, @"Error starting graph.");

}

@end
