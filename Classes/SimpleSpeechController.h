//
//  SimpleSpeechController.h
//  MWFeedParser
//
//  Created by Chris Walters on 10/22/13.
//  Copyright (c) 2013 Michael Waterfall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol SimpleSpeechUIDelegate
- (void) showUIForSpeakingRange:(NSRange)range ofSpeechString:(NSString *)string;
- (void) showUIToStartSpeaking;
- (void) showUIToStopSpeaking;
@end

@interface SimpleSpeechController : NSObject <AVSpeechSynthesizerDelegate>

@property (nonatomic, readwrite, retain) id <SimpleSpeechUIDelegate> speechUIDelegate;

@property (nonatomic, readwrite, retain) AVSpeechSynthesisVoice *ukVoice;
@property (nonatomic, readwrite, retain) AVSpeechSynthesisVoice *usVoice;
@property (nonatomic, readwrite, retain) AVSpeechSynthesisVoice *selectedVoice;

@property (nonatomic, readwrite, retain) AVSpeechSynthesizer *speechSynth;

- (void) say:(NSString *)something;
- (void) stop;
- (void) toggleVoice;

@end
