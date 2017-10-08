//
//  BRTextField.m
//  BRTextField
//
//  Created by Archy on 2017/9/26.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import "BRTextField.h"

#define FloatFadeInDuration     0.2
#define FloatFadeOutDuration    0.3
#define ModuleGap               10.f

@interface BRTextField ()

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel     *lblFloat;
@property (strong, nonatomic) UIView      *underlineView;

@property (strong, nonatomic) UIButton    *btnClose;
@property (strong, nonatomic) UIButton    *btnSecureEye;
@property (strong, nonatomic) UIView      *verticalSepLine;
@property (strong, nonatomic) UIImageView *imgMore;
@property (strong, nonatomic) UILabel     *lblSupply;

@property (strong, nonatomic) UIView      *viewInternational;
@property (strong, nonatomic) UIView      *viewVerifyCode;
@property (strong, nonatomic) UIView      *viewPassword;

@property (strong, nonatomic) UITapGestureRecognizer *tapSupply;

@end


@implementation BRTextField

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        [self propertyInit];
        [self updateUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self propertyInit];
        [self updateUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self propertyInit];
        [self updateUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateUI];
}

- (void)propertyInit {
    _needUnderLine = YES;
    _needAnimation = YES;
    _needFloating = YES;
    _supplyEnabled = YES;
    _style = BRTextFieldStyleDefault;
    
    self.clipsToBounds = NO;
}

- (void)updateUI {
    if (!self.textColor) {
        self.textColor = [UIColor blackColor];
    }
    if (!self.floatColor) {
        self.floatColor = [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.22];
    }
    self.lblFloat.textColor = self.floatColor;
    [self addSubview:self.textField];
    [self addSubview:self.lblFloat];
    [self addSubview:self.underlineView];
    
    [self updateFrame];
    [self addObserverOrAction];
}

- (void)addObserverOrAction {
    [self.textField addTarget:self action:@selector(inputDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.textField addTarget:self action:@selector(inputDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self.textField addTarget:self action:@selector(inputDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [self.textField addTarget:self action:@selector(inputDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)deviceOrientationDidChange {
    [self updateFrame];
}

- (void)updateFrame {
    self.textField.frame = self.bounds;
    self.lblFloat.frame = [self floatLabelRectForRect:[self.textField textRectForBounds:self.bounds] editing:self.textField.text.length > 0];
    self.underlineView.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
}

- (void)prepareForInterfaceBuilder {
    self.textField.frame = self.bounds;
    self.lblFloat.frame = [self floatLabelRectForRect:[self.textField textRectForBounds:self.bounds] editing:NO];
    self.underlineView.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(25, 30);
}

#pragma mark - BRTextFieldStyle
- (void)updateStyle {
    [self resetModules];
    
    NSString *selectorName = [self selectorNameOfStyle:self.style];
    SEL selector = NSSelectorFromString(selectorName);
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector];
#pragma clang diagnostic pop
    }
}

- (void)updateSupplyView {
    if (self.style == BRTextFieldStyleInternational) {
        [self resetModules];
        [self configInternationalStyle];
    } else if (self.style == BRTextFieldStyleVerifyCode) {
        self.lblSupply.text = self.supplyText;
    }
}

- (void)resetModules {
    [self.btnClose removeFromSuperview];
    [self.btnSecureEye removeFromSuperview];
    [self.verticalSepLine removeFromSuperview];
    
    self.textField.leftView = nil;
    self.textField.rightView = nil;
    [self.textField.leftView removeGestureRecognizer:self.tapSupply];
    [self.textField.rightView removeGestureRecognizer:self.tapSupply];
}

- (void)reactionForStyleWhenBeginInput {
    if (self.style != BRTextFieldStyleClose && self.style != BRTextFieldStyleInternational) {
        self.btnClose.hidden = NO;
        self.verticalSepLine.hidden = NO;
    }
}

- (void)reactionForStyleWhenEndInput {
    if (self.style != BRTextFieldStyleClose && self.style != BRTextFieldStyleInternational) {
        self.btnClose.hidden = YES;
        self.verticalSepLine.hidden = YES;
    }
}

//@(BRTextFieldStyleDefault)        : @"configDefaultStyle",
//@(BRTextFieldStyleClose)          : @"configCloseStyle",
//@(BRTextFieldStylePassworld)      : @"configPasswordStyle",
//@(BRTextFieldStyleVerifyCode)     : @"configVerifyCodeStyle",
//@(BRTextFieldStyleInternational)  : @"configInternationalStyle"

- (void)configDefaultStyle {
    // Do Nothing
}

- (void)configCloseStyle {
    self.textField.rightView = self.btnClose;
    self.textField.rightViewMode = UITextFieldViewModeWhileEditing;
}

- (void)configPasswordStyle {
    CGFloat totalWidth = self.btnClose.bounds.size.width + self.btnSecureEye.bounds.size.width + self.verticalSepLine.bounds.size.width + ModuleGap * 2;
    self.viewPassword = [[UIView alloc] initWithFrame:CGRectMake(0, 0, totalWidth, self.bounds.size.height)];
    
    CGFloat closeX = 0;
    CGFloat closeY = (self.bounds.size.height - self.btnClose.bounds.size.height) / 2.0;
    CGFloat closeWidth = self.btnClose.bounds.size.width;
    CGFloat closeHeight = self.btnClose.bounds.size.height;
    self.btnClose.frame = CGRectMake(closeX, closeY, closeWidth, closeHeight);

    CGFloat lineX = ModuleGap * 1 + closeWidth;
    CGFloat lineY = (self.bounds.size.height - self.verticalSepLine.bounds.size.height) / 2.0;
    CGFloat lineWidth = self.verticalSepLine.bounds.size.width;
    CGFloat lineHeight = self.verticalSepLine.bounds.size.height;
    self.verticalSepLine.frame = CGRectMake(lineX, lineY, lineWidth, lineHeight);
    
    CGFloat secureX = ModuleGap * 2 + closeWidth + lineWidth;
    CGFloat secureY = (self.bounds.size.height - self.btnSecureEye.bounds.size.height ) / 2.0;
    CGFloat secureWidth = self.btnSecureEye.bounds.size.width;
    CGFloat secureHeight = self.btnSecureEye.bounds.size.height;
    self.btnSecureEye.frame = CGRectMake(secureX, secureY, secureWidth, secureHeight);
    
    self.btnClose.hidden = YES;
    self.verticalSepLine.hidden = YES;
    
    [self.viewPassword addSubview:self.btnClose];
    [self.viewPassword addSubview:self.verticalSepLine];
    [self.viewPassword addSubview:self.btnSecureEye];
    self.btnSecureEye.selected = NO;
    self.textField.secureTextEntry = YES;
    self.textField.rightView = self.viewPassword;
    self.textField.rightViewMode = UITextFieldViewModeAlways;
}

- (void)configVerifyCodeStyle {
    if (!self.supplyText) {
        self.lblSupply.text = @"获取验证码";
    } else {
        self.lblSupply.text = self.supplyText;
    }
    if (self.font) {
        self.lblSupply.font = self.font;
    } else {
        self.lblSupply.font = [UIFont systemFontOfSize:12];
    }
    self.lblSupply.textColor = [UIColor colorWithRed:250/255.0 green:112/255.0 blue:136/255.0 alpha:1];
    CGSize lblSize = [self.lblSupply sizeThatFits:CGSizeMake(self.bounds.size.width, self.bounds.size.height)];
    CGFloat totalWidth = self.btnClose.bounds.size.width + lblSize.width + self.verticalSepLine.bounds.size.width + ModuleGap * 2;
    self.viewVerifyCode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, totalWidth, self.bounds.size.height)];

    CGFloat closeX = 0;
    CGFloat closeY = (self.bounds.size.height - self.btnClose.bounds.size.height) / 2.0;
    CGFloat closeWidth = self.btnClose.bounds.size.width;
    CGFloat closeHeight = self.btnClose.bounds.size.height;
    self.btnClose.frame = CGRectMake(closeX, closeY, closeWidth, closeHeight);
    
    CGFloat lineX = ModuleGap * 1 + closeWidth;
    CGFloat lineY = (self.bounds.size.height - self.verticalSepLine.bounds.size.height) / 2.0;
    CGFloat lineWidth = self.verticalSepLine.bounds.size.width;
    CGFloat lineHeight = self.verticalSepLine.bounds.size.height;
    self.verticalSepLine.frame = CGRectMake(lineX, lineY, lineWidth, lineHeight);
    
    CGFloat lblX = ModuleGap * 2 + closeWidth + lineWidth;
    CGFloat lblY = (self.bounds.size.height - lblSize.height ) / 2.0;
    CGFloat lblWidth = lblSize.width;
    CGFloat lblHeight = lblSize.height;
    self.lblSupply.frame = CGRectMake(lblX, lblY, lblWidth, lblHeight);
    
    self.btnClose.hidden = YES;
    self.verticalSepLine.hidden = YES;
    
    [self.viewVerifyCode addSubview:self.btnClose];
    [self.viewVerifyCode addSubview:self.verticalSepLine];
    [self.viewVerifyCode addSubview:self.lblSupply];
    self.textField.rightView = self.viewVerifyCode;
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    [self.viewVerifyCode addGestureRecognizer:self.tapSupply];
}

- (void)configInternationalStyle {
    self.textField.rightView = self.btnClose;
    self.textField.rightViewMode = UITextFieldViewModeWhileEditing;
    
    if (!self.supplyText) {
        self.lblSupply.text = @"+86";
    } else {
        self.lblSupply.text = self.supplyText;
    }
    if (self.font) {
        self.lblSupply.font = self.font;
    } else {
        self.lblSupply.font = [UIFont systemFontOfSize:12];
    }
    self.lblSupply.textColor = [UIColor colorWithRed:46/255.0 green:159/255.0 blue:1 alpha:1];
    CGSize lblSize = [self.lblSupply sizeThatFits:CGSizeMake(self.bounds.size.width, self.bounds.size.height)];
    CGFloat totalWidth = lblSize.width + self.imgMore.bounds.size.width + self.verticalSepLine.bounds.size.width + 3 * ModuleGap;
    self.viewInternational = [[UIView alloc] initWithFrame:CGRectMake(0, 0, totalWidth, self.bounds.size.height)];
    
    CGFloat lblX = 0;
    CGFloat lblY = (self.bounds.size.height - lblSize.height) / 2.0;
    CGFloat lblWidth = lblSize.width;
    CGFloat lblHeight = lblSize.height;
    self.lblSupply.frame = CGRectMake(lblX, lblY, lblWidth, lblHeight);
    
    CGFloat moreX = lblWidth + ModuleGap;
    CGFloat moreY = (self.bounds.size.height - self.imgMore.bounds.size.height) / 2.0;
    CGFloat moreWidth = self.imgMore.bounds.size.width;
    CGFloat moreHeight = self.imgMore.bounds.size.height;
    self.imgMore.frame = CGRectMake(moreX, moreY, moreWidth, moreHeight);
    
    CGFloat lineX = ModuleGap * 2 + lblWidth + moreWidth;
    CGFloat lineY = (self.bounds.size.height - self.verticalSepLine.bounds.size.height) / 2.0;
    CGFloat lineWidth = self.verticalSepLine.bounds.size.width;
    CGFloat lineHeight = self.verticalSepLine.bounds.size.height;
    self.verticalSepLine.frame = CGRectMake(lineX, lineY, lineWidth, lineHeight);
    
    [self.viewInternational addSubview:self.lblSupply];
    [self.viewInternational addSubview:self.imgMore];
    [self.viewInternational addSubview:self.verticalSepLine];
    self.textField.leftView = self.viewInternational;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    [self.viewInternational addGestureRecognizer:self.tapSupply];
}

#pragma mark - Control Events
- (void)inputDidBegin:(UITextField *)textField {
    [self reactionForStyleWhenBeginInput];
}

- (void)inputDidEnd:(UITextField *)textField {
    [self reactionForStyleWhenEndInput];
}

- (void)inputDidChange:(UITextField *)textField {
    if (!self.isNeedFloating) {
        return;
    }
    if (textField.text.length > 0) {
        if (![self floatLabelIsShow]) {
            [self floatLabelShow];
        }
    } else {
        if ([self floatLabelIsShow]) {
            [self floatLabelHide];
        }
    }
}

#pragma mark - Float Label

- (CGRect)floatLabelRectForRect:(CGRect)rect editing:(BOOL)editing {
    if (editing) {
        return CGRectMake(rect.origin.x, -self.lblFloat.font.lineHeight, rect.size.width, self.lblFloat.font.lineHeight);
    }
    return CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height);
}

- (void)floatLabelShow {
    if (self.isNeedAnimation) {
        [UIView animateWithDuration:FloatFadeInDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.lblFloat.alpha = 1;
            self.lblFloat.frame = [self floatLabelRectForRect:[self.textField textRectForBounds:self.bounds] editing:YES];
        } completion:nil];
    } else {
        self.lblFloat.alpha = 1;
        self.lblFloat.frame = [self floatLabelRectForRect:[self.textField textRectForBounds:self.bounds] editing:YES];
    }
}

- (void)floatLabelHide {
    if (self.isNeedAnimation) {
        [UIView animateWithDuration:FloatFadeOutDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.lblFloat.alpha = 0;
            self.lblFloat.frame = [self floatLabelRectForRect:[self.textField textRectForBounds:self.bounds] editing:NO];
        } completion:nil];
    } else {
        self.lblFloat.alpha = 0;
        self.lblFloat.frame = [self floatLabelRectForRect:[self.textField textRectForBounds:self.bounds] editing:NO];
    }
}

- (BOOL)floatLabelIsShow {
    CGRect showRect = [self floatLabelRectForRect:[self.textField textRectForBounds:self.bounds] editing:YES];
    return CGRectEqualToRect(self.lblFloat.frame, showRect);
}

#pragma mark - Private
/**
 Reset Text Field

 @param button btnClose
 */
- (void)resetTextField:(UIButton *)button {
    self.textField.text = @"";
    [self floatLabelHide];
}

/**
 Change Text Field SecureTextEntry Status

 @param button btnSecure
 */
- (void)changeTextFieldSecure:(UIButton *)button {
    button.selected = !button.isSelected;
    self.textField.secureTextEntry = !button.isSelected;
}

- (void)supplyAction:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(textFieldDidClickSupplyView:)]) {
        [self.delegate textFieldDidClickSupplyView:self];
    }
}

#pragma mark - Setter & Getter
#pragma mark - Setter
- (void)setNeedUnderLine:(BOOL)needUnderLine {
    _needUnderLine = needUnderLine;
    self.underlineView.hidden = !needUnderLine;
}

- (void)setNeedAnimation:(BOOL)needAnimation {
    _needAnimation = needAnimation;
}

- (void)setNeedFloating:(BOOL)needFloating {
    _needFloating = needFloating;
    self.lblFloat.hidden = !needFloating;
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    _underlineColor = underlineColor;
    self.underlineView.backgroundColor = underlineColor;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
    if (_floatText == nil) {
        _floatText = placeholder;
        self.lblFloat.text = _floatText;
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textField.text = text;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    self.textField.textAlignment = textAlignment;
    self.lblFloat.textAlignment = textAlignment;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.textField.keyboardType = keyboardType;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    self.textField.attributedText = attributedText;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    _attributedPlaceholder = attributedPlaceholder;
    self.textField.attributedPlaceholder = attributedPlaceholder;
    if (_floatText == nil) {
        _floatText = attributedPlaceholder.string;
        self.lblFloat.text = _floatText;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.textField.textColor = textColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.textField.font = font;
    if (!self.floatFont) {
        self.lblFloat.font = [UIFont systemFontOfSize:font.pointSize - 2];
    }
}

- (void)setFloatText:(NSString *)floatText {
    _floatText = floatText;
    self.lblFloat.text = floatText;
}

- (void)setFloatColor:(UIColor *)floatColor {
    _floatColor = floatColor;
    self.lblFloat.textColor = floatColor;
}

- (void)setFloatFont:(UIFont *)floatFont {
    _floatFont = floatFont;
    self.lblFloat.font = floatFont;
}

- (void)setStyle:(BRTextFieldStyle)style {
    _style = style;
    [self updateStyle];
}

- (void)setSupplyText:(NSString *)supplyText {
    _supplyText = supplyText;
    [self updateSupplyView];
}

- (void)setSupplyEnabled:(BOOL)supplyEnabled {
    _supplyEnabled = supplyEnabled;
    self.tapSupply.enabled = supplyEnabled;
}

#pragma mark - Getter
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = [UIColor blackColor];
        _textField.font = [UIFont systemFontOfSize:12];
    }
    return _textField;
}

- (UILabel *)lblFloat {
    if (!_lblFloat) {
        _lblFloat = [[UILabel alloc] init];
        _lblFloat.font = [UIFont systemFontOfSize:10];
        _lblFloat.alpha = 0;
    }
    return _lblFloat;
}

- (UIView *)underlineView {
    if (!_underlineView) {
        _underlineView = [[UIView alloc] init];
        _underlineView.backgroundColor = [UIColor blackColor];
    }
    return _underlineView;
}

- (UIButton *)btnClose {
    if (!_btnClose) {
        _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnClose setImage:[UIImage imageNamed:@"close_clicked"] forState:UIControlStateNormal];
        [_btnClose sizeToFit];
        [_btnClose addTarget:self action:@selector(resetTextField:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnClose;
}

- (UIButton *)btnSecureEye {
    if (!_btnSecureEye) {
        _btnSecureEye = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSecureEye setImage:[UIImage imageNamed:@"eye_reg"] forState:UIControlStateNormal];
        [_btnSecureEye setImage:[UIImage imageNamed:@"eye_clicked"] forState:UIControlStateSelected];
        [_btnSecureEye sizeToFit];
        [_btnSecureEye addTarget:self action:@selector(changeTextFieldSecure:) forControlEvents:UIControlEventTouchUpInside];
        _btnSecureEye.selected = !self.textField.secureTextEntry;
    }
    return _btnSecureEye;
}

- (UIView *)verticalSepLine {
    if (!_verticalSepLine) {
        _verticalSepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 15)];
        _verticalSepLine.backgroundColor = [UIColor colorWithRed:224/255.0 green:229/255.0 blue:232/255.0 alpha:1];
    }
    return _verticalSepLine;
}

- (UIImageView *)imgMore {
    if (!_imgMore) {
        _imgMore = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrows_down_b_xs"]];
    }
    return _imgMore;
}

- (UILabel *)lblSupply {
    if (!_lblSupply) {
        _lblSupply = [[UILabel alloc] init];
        _lblSupply.textAlignment = NSTextAlignmentCenter;
    }
    return _lblSupply;
}

- (UITapGestureRecognizer *)tapSupply {
    if (!_tapSupply) {
        _tapSupply = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(supplyAction:)];
    }
    return _tapSupply;
}

#pragma mark - Style Mapping

- (NSString *)selectorNameOfStyle:(BRTextFieldStyle)style {
    static NSDictionary *mapping = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = @{
                    @(BRTextFieldStyleDefault)          : @"configDefaultStyle",
                    @(BRTextFieldStyleClose)            : @"configCloseStyle",
                    @(BRTextFieldStylePassworld)        : @"configPasswordStyle",
                    @(BRTextFieldStyleVerifyCode)       : @"configVerifyCodeStyle",
                    @(BRTextFieldStyleInternational)    : @"configInternationalStyle"
                    };
    });
    return mapping[@(style)];
}

@end

#undef FloatFadeInDuration
#undef FloatFadeOutDuration
#undef ModuleGap
