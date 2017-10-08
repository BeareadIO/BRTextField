//
//  BRTextField.h
//  BRTextField
//
//  Created by Archy on 2017/9/26.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BRTextFieldStyle) {
    BRTextFieldStyleDefault,
    BRTextFieldStyleClose,
    BRTextFieldStylePassword,
    BRTextFieldStyleVerifyCode,
    BRTextFieldStyleInternational,
};

IB_DESIGNABLE
/**
 An object that displays an editable text area in your interface.
 
 It will display an underline and a floating label.
 */
@protocol BRTextFieldDelegate;
@interface BRTextField : UIView
/**
 Whether Need Underline. default is YES. line width is 1;
 */
@property (assign, nonatomic, getter=isNeedUnderline)IBInspectable BOOL needUnderLine;
/**
 Whether Need Animation. default is YES.

 */
@property (assign, nonatomic, getter=isNeedAnimation)IBInspectable BOOL needAnimation;
/**
 Whether Need Floating. default is YES.
 */
@property (assign, nonatomic, getter=isNeedFloating) IBInspectable BOOL needFloating;
/**
 The color for underline. default is nil. use opaque black
 */
@property (nullable, nonatomic, strong) IBInspectable UIColor     *underlineColor;
@property (nullable, nonatomic, copy)IBInspectable   NSString      *placeholder;          // default is nil. string is drawn 70% gray
@property (nullable, nonatomic, copy)IBInspectable   NSString      *text;                 // default is nil
@property (nonatomic) NSTextAlignment    textAlignment;        // default is NSLeftTextAlignment
@property (nonatomic) UIKeyboardType     keyboardType;
@property (nonatomic) BRTextFieldStyle   style;
@property (nullable, nonatomic, copy) NSAttributedString     *attributedText NS_AVAILABLE_IOS(6_0); // default is nil
@property (nullable, nonatomic, copy)   NSAttributedString     *attributedPlaceholder NS_AVAILABLE_IOS(6_0); // default is nil
@property (nullable, nonatomic, strong)IBInspectable UIColor                *textColor;            // default is nil. use opaque black
@property (nullable, nonatomic, strong) UIFont                 *font;                 // default is nil. use system font 12 pt
@property (nullable, nonatomic, strong) IBInspectable NSString   *floatText; // default is equal placeholder.
@property (nullable, nonatomic, strong) IBInspectable UIColor    *floatColor; // default
@property (nullable, nonatomic, strong) UIFont                   *floatFont;   // default is nil. use system font 10 pt
@property (nullable, nonatomic, weak)   id<UITextFieldDelegate, BRTextFieldDelegate> delegate;             // default is nil. weak reference
@property (nullable, nonatomic, strong) NSString                *supplyText; // default is nil.
@property (assign, nonatomic, getter=isSupplyEnabled) BOOL      supplyEnabled;
@end

@protocol BRTextFieldDelegate <NSObject>

@optional
- (void)textFieldDidClickSupplyView:(BRTextField *)textField;

@end

NS_ASSUME_NONNULL_END

