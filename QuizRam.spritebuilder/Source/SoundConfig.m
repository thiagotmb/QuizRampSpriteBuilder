//
//  SoundConfig.m
//  QuizRam
//
//  Created by Thiago Bernardes on 6/25/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "SoundConfig.h"

@implementation SoundConfig


-(void)setFxVolume{
    
    NSLog(@"%.2f",_fxSlider.sliderValue);
}


-(void)setMusicVolume{
    
    NSLog(@"%.2f",_musicSlider.sliderValue);

}


@end
