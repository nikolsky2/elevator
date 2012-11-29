//
//  Person.m
//  EducationUI2
//
//  Created by Sergey Nikolsky on 23.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonLayer.h"

@implementation PersonLayer

- (id) initWithHeight:(CGFloat)height andDesiredFloor:(unsigned)desiredFloor;
{
    if (self = [super init]) {
        layerHeight = height;
        dFloor = desiredFloor;
        
        body = [self createBody];
        [self addSublayer: body];
        
        textLabel = [self createLabel];
        [self addSublayer: textLabel];
        
        //self.bounds = CGRectMake(0.0f, 0.0f, body.bounds.size.width, layerHeight);
        //self.cornerRadius = 5.0f;        
    }    
    return self;
    
}

- (CALayer*) createBody
{
    UIImage *personImg = [UIImage imageNamed:@"VectorPerson2.png"];
    self.bounds = CGRectMake(0.0f, 0.0f, personImg.size.width, layerHeight);
    
    CALayer *personBody = [CALayer layer];
    personBody.bounds = CGRectMake(0.0f, 0.0f, 
                                   (personImg.size.width / personImg.size.height) * 0.7 * layerHeight, 
                                   0.7f * layerHeight);
    personBody.position = CGPointMake(self.bounds.size.width/2, 0.65f * layerHeight);
    personBody.cornerRadius = 5.0f;    
    personBody.contents = (id)[personImg CGImage];
    
    return personBody;
}

- (CALayer*) createLabel
{
    
    //Wrong
    //CALayer *textLayer = [[CALayer alloc] init];    
    
    //Correct
    CALayer *textLayer = [CALayer layer];
    
    CGFloat textHeight = layerHeight/3.0f;
    textLayer.bounds = CGRectMake(0, 0, self.bounds.size.width, textHeight);
    textLayer.position = CGPointMake(self.bounds.size.width/2, textHeight/2);
    //textLayer.backgroundColor = [UIColor whiteColor].CGColor;
    
    
    CATextLayer *label = [CATextLayer layer];    
    label.string = [NSString stringWithFormat:@"%u", dFloor];
    //label.font=@"Lucida-Grande";
    label.wrapped = NO;
    label.alignmentMode = kCAAlignmentCenter;
    label.fontSize = textHeight;
    label.foregroundColor = [UIColor blackColor].CGColor;
    //label.backgroundColor = [UIColor whiteColor].CGColor;
    
    label.bounds = CGRectMake(0, 0, textLayer.bounds.size.width, textLayer.bounds.size.height);
    label.position = textLayer.position;

    [textLayer addSublayer: label];
    
     
    return textLayer;
}



@end
