//
//  ToneGenerator.m
//  Moles
//
//  Created by William Izzo on 18/09/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "ToneGenerator.h"
#import <AudioToolbox/AudioToolbox.h>
#import <assert.h>
#import "EventBus.h"
#import "ToneEvent.h"

@interface ToneGenerator()<EventBusDelegate> {
    AudioComponentInstance auToneGenerator;
    double theta; // sine wave current theta
    double pitch;
}

- (OSStatus)toneCallbackWithRefCon:(void*)inRefCon
                   actionFlags:(AudioUnitRenderActionFlags*)actionFlags
                     timestamp:(const AudioTimeStamp*)timestamp
                   inBusNumber:(UInt32)inBusNo
                 inFrameNumber:(UInt32)inFrameNo
                    bufferList:(AudioBufferList*)ioBufferData;

@end

static AudioComponentDescription defaultOutputDescriptor() {
    AudioComponentDescription defaultOutputDescription;
    defaultOutputDescription.componentType = kAudioUnitType_Output;
    defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
    defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    defaultOutputDescription.componentFlags = 0;
    defaultOutputDescription.componentFlagsMask = 0;
    
    return defaultOutputDescription;
}

static OSStatus toneRenderFunction(void *inRefCon,
                                   AudioUnitRenderActionFlags *ioActionFlags,
                                   const AudioTimeStamp *inTimeStamp,
                                   UInt32 inBusNumber,
                                   UInt32 inNumberFrames,
                                   AudioBufferList *ioData) {
    ToneGenerator* callee = (__bridge ToneGenerator*)inRefCon;
    
    return
    [callee toneCallbackWithRefCon:inRefCon
                       actionFlags:ioActionFlags
                         timestamp:inTimeStamp
                       inBusNumber:inBusNumber
                     inFrameNumber:inNumberFrames
                        bufferList:ioData];
}

static AudioStreamBasicDescription defaultStreamDescriptor() {
    const int four_bytes_per_float = 4;
    const int eight_bits_per_byte = 8;
    const int sample_rate = 44100;
    
    AudioStreamBasicDescription defaultDesc;
    
    defaultDesc.mSampleRate = sample_rate;
    defaultDesc.mFormatID = kAudioFormatLinearPCM;
    defaultDesc.mFormatFlags =
    kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
    defaultDesc.mBytesPerPacket = four_bytes_per_float;
    defaultDesc.mFramesPerPacket = 1;
    defaultDesc.mBytesPerFrame = four_bytes_per_float;
    defaultDesc.mChannelsPerFrame = 1;
    defaultDesc.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
    
    return defaultDesc;
}



@implementation ToneGenerator

- (void)startUp {
    AudioComponentDescription defaultOutputDesc = defaultOutputDescriptor();
    AudioStreamBasicDescription defaultStreamDesc = defaultStreamDescriptor();
    
    // Finds default audio output
    AudioComponent defaultOutputAC =
    AudioComponentFindNext(NULL,
                           &defaultOutputDesc);
    
    assert(defaultOutputAC && "default audio output not found.");
    
    // Builds the tone generator out of it
    AudioComponentInstanceNew(defaultOutputAC, &self->auToneGenerator);
    assert(self->auToneGenerator && "cannot instance tone generator");
    
    // Sets tone generator stream format
    AudioUnitSetProperty(self->auToneGenerator,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Input,
                         0,
                         &defaultStreamDesc,
                         sizeof(AudioStreamBasicDescription));
    
    // Attaches the audio rendering callback
    AURenderCallbackStruct callbackDesc;
    callbackDesc.inputProc = toneRenderFunction;
    callbackDesc.inputProcRefCon = (__bridge void * _Nullable)(self);
    
    OSStatus err =
    AudioUnitSetProperty(self->auToneGenerator,
                         kAudioUnitProperty_SetRenderCallback,
                         kAudioUnitScope_Input,
                         0,
                         &callbackDesc,
                         sizeof(AURenderCallbackStruct));
    assert(err == noErr);
    
    // Initialize the output
    err =
    AudioUnitInitialize(self->auToneGenerator);
    assert(err == noErr);
    
    // Start output generation
    err =
    AudioOutputUnitStart(self->auToneGenerator);
    assert(err == noErr);
    
    // Attaches to event bus
    [[EventBus defaultBus] registerListener:self
                               forEventType:kEventTone];
    
    // Sets a default pitch
    self->pitch = 0.0;
}

- (OSStatus)toneCallbackWithRefCon:(void *)inRefCon
                   actionFlags:(AudioUnitRenderActionFlags *)actionFlags
                     timestamp:(const AudioTimeStamp *)timestamp
                   inBusNumber:(UInt32)inBusNo
                 inFrameNumber:(UInt32)inFrameNo
                    bufferList:(AudioBufferList *)ioBufferData {
    
    double amplitude = 0.25;
    double thetaIncr = 2.0 * M_PI * self->pitch / 44100;
    
    const int channel = 0;
    Float32* buffer = (Float32*)ioBufferData->mBuffers[channel].mData;
    for (UInt32 frame = 0; frame < inFrameNo; ++frame) {
        buffer[frame] = sin(self->theta) * amplitude;
        self->theta += thetaIncr;
        
        if (self->theta > M_PI * 2.0) {
            self->theta -= M_PI * 2.0;
        }
    }
    
    return noErr;
}

- (void)update:(NSTimeInterval)dt {}

- (void)pause {}

- (void)shutDown {
    AudioOutputUnitStop(self->auToneGenerator);
    AudioUnitUninitialize(self->auToneGenerator);
    AudioComponentInstanceDispose(self->auToneGenerator);
    self->auToneGenerator = nil;
}

- (void)receivedEvent:(id<IEvent>)event withType:(NSUInteger)type {
    switch (type) {
        case kEventTone:{
            self->pitch = ((ToneEvent*)event)->pitch;
        }break;
        default:
            break;
    }
}

@end
