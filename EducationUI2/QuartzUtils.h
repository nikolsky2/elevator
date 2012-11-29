/*

File: QuartzUtils.h

*/


#import <QuartzCore/QuartzCore.h>


// Moves a layer from one superlayer to another, without changing its position onscreen.
void ChangeSuperlayer( CALayer *layer, CALayer *newSuperlayer, int index );

// Removes a layer from its superlayer without any fade-out animation.
void RemoveImmediately( CALayer *layer );

