/*

File: QuartzUtils.m

*/


#import "QuartzUtils.h"

void ChangeSuperlayer(CALayer *layer, CALayer *newSuperlayer, int index)
{
    // Disable actions, else the layer will move to the wrong place and then back!
    //[CATransaction flush];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];

    CGPoint pos = [newSuperlayer convertPoint: layer.position 
                                    fromLayer: layer.superlayer];
    [layer removeFromSuperlayer];
    if( index >= 0 )
        [newSuperlayer insertSublayer: layer 
                              atIndex: index];
    else
        [newSuperlayer addSublayer: layer];
    layer.position = pos;

    [CATransaction commit];
}


void RemoveImmediately(CALayer *layer)
{
    //[CATransaction flush];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    [layer removeFromSuperlayer];
    [CATransaction commit];
}    

