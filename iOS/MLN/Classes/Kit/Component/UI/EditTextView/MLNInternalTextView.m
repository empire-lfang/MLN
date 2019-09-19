//
//  MLNInternalTextView.m
//
//
//  Created by MoMo on 2018/12/21.
//

#import "MLNInternalTextView.h"
#import "MLNTextConst.h"

@interface MLNInternalTextView ()

@property(nonatomic, strong) UITextView *myTextView;
@property(nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, copy) NSString *backupText;

@property (nonatomic, assign) UIEdgeInsets defaultPlaceholderPadding;
@property (nonatomic, assign) UIReturnKeyType returnType;

@end
@implementation MLNInternalTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _defaultPlaceholderPadding = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
        _returnType = UIReturnKeyDefault;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!CGRectEqualToRect(self.myTextView.frame, self.bounds)) {
        self.myTextView.frame = self.bounds;
    }
    CGRect pframe = UIEdgeInsetsInsetRect(self.bounds, self.defaultPlaceholderPadding);
    if (!CGRectEqualToRect(self.placeholderLabel.frame, pframe)) {
        self.placeholderLabel.frame = pframe;
        [self.placeholderLabel sizeToFit];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self addSubview:self.placeholderLabel];
        [self addSubview:self.myTextView];
    }
}

#pragma mark - Responder
- (BOOL)isFirstResponder
{
    return [self.myTextView isFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return [self.myTextView canBecomeFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    return [self.myTextView becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.myTextView resignFirstResponder];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    if (self.placeholderLabel.alpha > 0) {
      return  [self.placeholderLabel sizeThatFits:size];
    }
    return  [self.myTextView sizeThatFits:size];
}

#pragma mark - Position
- (UITextPosition *)positionFromPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset {
    return [self.myTextView positionFromPosition:position inDirection:direction offset:offset];
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset {
    return [self.myTextView positionFromPosition:position offset:offset];
}

#pragma mark - SecureTextEntry
- (void)updatePasswordModeIfNeed
{
    if (self.isSecureTextEntry && self.myTextView.text.length >0) {
        NSMutableString * temp = [NSMutableString string];
        for (NSUInteger i= 0; i < self.myTextView.text.length; i++) {
            [temp appendString:@"•"];
        }
        self.myTextView.text = [temp copy];
    }
}

- (void)placeholderHiddenIfNeed:(NSString *)text
{
    self.placeholderLabel.alpha = !(text && text.length > 0);
}

- (void)resetContentOffsetIfNeed
{
    if (self.myTextView.contentSize.height > self.myTextView.frame.size.height) {
        [self.myTextView setNeedsLayout];
        [self.myTextView layoutIfNeeded];
        CGFloat y = self.myTextView.contentSize.height - self.myTextView.frame.size.height;
        [self.myTextView setContentOffset:CGPointMake(0.f, y) animated:NO];
    }
}

- (void)replaceWithRealText:(NSString*)text {
    NSRange rg = self.myTextView.selectedRange;
    if (rg.location == NSNotFound) {
        // 如果没找到光标,就把光标定位到文字结尾
        rg.location =self.myTextView.text.length;
    }
    self.text = text;
    NSInteger offset = self.myTextView.text.length - text.length;
    if (text.length > 0) {
        self.myTextView.selectedRange = NSMakeRange(rg.location + offset, 0);
    }
}

- (NSString *)recalculateRealText:(NSString *)text
{
    if (self.isSecureTextEntry) {
        NSString *origText = self.text.length > 0 ? self.text : @"";
        if (text.length > origText.length) {
            NSMutableString *realText = [NSMutableString stringWithString:origText];
            [realText appendString:[text substringFromIndex:origText.length]];
            return realText.copy;
        } else if (origText.length > text.length) {
            NSMutableString *realText = [NSMutableString stringWithString:origText];
            [realText deleteCharactersInRange:NSMakeRange(text.length, origText.length - text.length)];
            return realText.copy;
        }
    }
    return text;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(MLNInternalTextView *)textView
{
    if ([self.internalTextViewDelegate respondsToSelector:@selector(internalTextViewDidBeginEditing:)]) {
        [self.internalTextViewDelegate internalTextViewDidBeginEditing:textView];
    }
}

- (BOOL)textView:(MLNInternalTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([self.internalTextViewDelegate respondsToSelector:@selector(internalTextView:shouldChangeTextInRange:replacementText:)]) {
        return [self.internalTextViewDelegate internalTextView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (void)textViewDidChange:(MLNInternalTextView *)textView
{
    [self placeholderHiddenIfNeed:textView.text];
    if(textView.markedTextRange == nil){
        [self replaceWithRealText:[self recalculateRealText:textView.text]];
    }
    
    if ([self.internalTextViewDelegate respondsToSelector:@selector(internalTextViewDidChange:)]) {
        [self.internalTextViewDelegate internalTextViewDidChange:textView];
    }
    [self resetContentOffsetIfNeed];
}

#pragma mark - Setter & Getter
- (void)setPlaceholder:(NSString *)placeholder
{
    self.placeholderLabel.text = placeholder;
    if (self.superview) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (NSString *)placeholder
{
    return self.placeholderLabel.text;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor
{
    return self.placeholderLabel.textColor;
}

- (void)setText:(NSString *)text
{
    [self placeholderHiddenIfNeed:text];
    self.myTextView.text = text;
    [self updatePasswordModeIfNeed];
    [self resetContentOffsetIfNeed];
}

- (NSString *)text
{
    return self.myTextView.text;
}

- (void)setTextColor:(UIColor *)textColor
{
    self.myTextView.textColor = textColor;
}

- (UIColor *)textColor
{
    return self.myTextView.textColor;
}

- (void)setFont:(UIFont *)font
{
    self.myTextView.font = font;
    self.placeholderLabel.font = font;
}

- (UIFont *)font
{
    return self.myTextView.font;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    self.myTextView.keyboardType = keyboardType;
}

- (UIKeyboardType)keyboardType
{
    return self.myTextView.keyboardType;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    _returnType = returnKeyType;
}

- (UIReturnKeyType)returnKeyType
{
    return _returnType;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
    _secureTextEntry = secureTextEntry;
    [self updatePasswordModeIfNeed];
}

- (void)setTintColor:(UIColor *)tintColor
{
    self.myTextView.tintColor = tintColor;
}

- (UIColor *)tintColor
{
    return self.myTextView.tintColor;
}

- (void)setEditable:(BOOL)editable
{
    self.myTextView.editable = editable;
}

- (BOOL)isEditable
{
    return self.myTextView.isEditable;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    self.myTextView.attributedText = attributedText;
    [self updatePasswordModeIfNeed];
    [self resetContentOffsetIfNeed];
}

- (NSAttributedString *)attributedText
{
    return self.myTextView.attributedText;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    self.myTextView.textAlignment = textAlignment;
}

- (NSTextAlignment)textAlignment
{
    return self.myTextView.textAlignment;
}

- (UITextRange *)markedTextRange
{
    return self.myTextView.markedTextRange;
}

#pragma mark - Lazy Load
- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _placeholderLabel.text = @" ";
        _placeholderLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _placeholderLabel.textColor = kLuaDefaultPlaceHolderColor;
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.font = kLuaDefaultFont;
        _placeholderLabel.contentMode = UIViewContentModeTop;
    }
    return _placeholderLabel;
}

- (UITextView *)myTextView
{
    if (!_myTextView) {
        _myTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _myTextView.font = self.placeholderLabel.font;
        _myTextView.textColor = [UIColor blackColor];
        _myTextView.tintColor = [UIColor blackColor];
        _myTextView.backgroundColor = [UIColor clearColor];
        _myTextView.textContainerInset = UIEdgeInsetsZero;
        _myTextView.textContainer.lineFragmentPadding = 0;
        _myTextView.contentInset = UIEdgeInsetsZero;
        _myTextView.layoutManager.allowsNonContiguousLayout = NO;
        _myTextView.delegate = self;
    }
    return _myTextView;
}

@end
