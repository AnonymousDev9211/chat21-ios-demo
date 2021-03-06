//
//  UIPresentationController.h
//  UIKit
//
//  Copyright (c) 2014 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKitDefines.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIViewController.h>
#import <UIKit/UIAppearance.h>
#import <UIKit/UIGeometry.h>
#import <UIKit/UITraitCollection.h>
#import <UIKit/UIViewControllerTransitionCoordinator.h>

@class UIPresentationController;

@protocol UIAdaptivePresentationControllerDelegate <NSObject>

@optional

/* For iOS8.0, the only supported adaptive presentation styles are UIModalPresentationFullScreen and UIModalPresentationOverFullScreen. */
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller;

/* If this method is not implemented, or returns nil, then the originally presented view controller is used. */
- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style;

@end

NS_CLASS_AVAILABLE_IOS(8_0) @interface UIPresentationController : NSObject <UIAppearanceContainer, UITraitEnvironment, UIContentContainer>

@property(nonatomic, retain, readonly) UIViewController *presentingViewController;
@property(nonatomic, retain, readonly) UIViewController *presentedViewController;

@property(nonatomic,readonly) UIModalPresentationStyle presentationStyle;

// The view in which a presentation occurs. It is an ancestor of both the presenting and presented view controller's views.
// This view is being passed to the animation controller.
@property(nonatomic, readonly) UIView *containerView;

@property(nonatomic, assign) id <UIAdaptivePresentationControllerDelegate> delegate;

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController;

// By default this implementation defers to the delegate, if one exists, or returns the current presentation style. UIFormSheetPresentationController, and
// UIPopoverPresentationController override this implementation to return UIModalPresentationStyleFullscreen if the delegate does not provide an
// implementation for adaptivePresentationStyleForPresentationController:
- (UIModalPresentationStyle)adaptivePresentationStyle;

- (void)containerViewWillLayoutSubviews;
- (void)containerViewDidLayoutSubviews;

// A view that's going to be animated during the presentation. Must be an ancestor of a presented view controller's view
// or a presented view controller's view itself.
// (Default: presented view controller's view)
- (UIView *)presentedView;

// Position of the presented view in the container view by the end of the presentation transition.
// (Default: container view bounds)
- (CGRect)frameOfPresentedViewInContainerView;

// By default each new presentation is full screen.
// This behavior can be overriden with the following method to force a current context presentation.
// (Default: YES)
- (BOOL)shouldPresentInFullscreen;

// Indicate whether the view controller's view we are transitioning from will be removed from the window in the end of the
// presentation transition
// (Default: YES)
- (BOOL)shouldRemovePresentersView;

- (void)presentationTransitionWillBegin;
- (void)presentationTransitionDidEnd:(BOOL)completed;
- (void)dismissalTransitionWillBegin;
- (void)dismissalTransitionDidEnd:(BOOL)completed;

// Modifies the trait collection for the presentation controller.
@property(nonatomic, copy) UITraitCollection *overrideTraitCollection;

@end

