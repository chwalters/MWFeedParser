//
//  SimpleSpeechController.m
//  MWFeedParser
//
//  Created by Chris Walters on 10/22/13.
//  Copyright (c) 2013 Michael Waterfall. All rights reserved.
//

#import "SimpleSpeechController.h"

@implementation SimpleSpeechController

- (id) init {
    if ((self = [super init])) {
        self.speechSynth = [[[AVSpeechSynthesizer alloc] init] autorelease];
        
        [self.speechSynth setDelegate:self];
        
        self.ukVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
        self.usVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
        
        // default is to go with US voice
        self.selectedVoice = self.usVoice;
    }

    return self;
}


- (void) stop
{
    [self.speechSynth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

- (void) toggleVoice
{
    if ([self.usVoice isEqual:self.selectedVoice])
        self.selectedVoice = self.ukVoice;
    else
        self.selectedVoice = self.usVoice;
}

- (void) say:(NSString *)something
{
    if ([self.speechSynth isSpeaking])
        [self.speechSynth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    
    if (something) {
        AVSpeechUtterance *utterance = [[[AVSpeechUtterance alloc] initWithString:something] autorelease];

        utterance.voice = self.selectedVoice;
        
        utterance.rate = 0.15f;
        
        [self.speechSynth speakUtterance:utterance];
        
    }
}

// Speech Synthesizer Delegate implementation

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    if (self.speechUIDelegate)
        [self.speechUIDelegate showUIToStartSpeaking];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    if (self.speechUIDelegate)
        [self.speechUIDelegate showUIToStopSpeaking];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance
{
    //
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance
{
    //
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance
{
    //
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance
{
    if (self.speechUIDelegate)
        [self.speechUIDelegate showUIForSpeakingRange:characterRange ofSpeechString:utterance.speechString];
}


@end
