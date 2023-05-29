import UIKit

struct FlashfoodColorScheme {
    var primaryColor: UIColor
    var secondaryColor: UIColor
    var errorColor: UIColor
    var surfaceColor: UIColor
    var backgroundColor: UIColor
    var onPrimaryColor: UIColor
    var onSecondaryColor: UIColor
    var onSurfaceColor: UIColor
    var onBackgroundColor: UIColor
}

enum FFTFState {
    case `default`
    case focused
    case filled
    case error
    case disable
    case correct
}

struct FFTFColorSchemeModel {
    let titleLabelTextColor: UIColor
    let textColor: UIColor
    let errorLabelTextColor: UIColor
    let borderColor: UIColor
}

struct FFTFTypographyScheme {
    let titleLabelFont: UIFont
    let textFieldFont: UIFont
    let errorLabelFont: UIFont
}

struct FlashfoodTypographyScheme {
    var headline1: UIFont
    var headline2: UIFont
    var headline3: UIFont
    var headline4: UIFont
    var headline5: UIFont
    var headline6: UIFont
    var subtitle1: UIFont
    var subtitle2: UIFont
    var body1: UIFont
    var body2: UIFont
    var caption: UIFont
    var caption2: UIFont
    var button: UIFont
    var overline: UIFont
}

public final class CustomTextField: UITextField {

    // MARK: - Properties

    weak var realDelegate: UITextFieldDelegate?

    private var resultingString: String? = nil

    var paddings = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16) {
        didSet {
            setNeedsLayout()
        }
    }

    var placeholderText: NSMutableAttributedString? {
        didSet {
            if let text = placeholderText {
                self.attributedPlaceholder = text
            }
        }
    }

    var placeholderIcon: UIImage? {
        didSet {
            guard let attachedImage = self.placeholderIcon else { return }

            let attachmentImage = NSTextAttachment(image: attachedImage)
            let imageString = NSMutableAttributedString(attachment: attachmentImage)
            let font = (self.placeholderText?.attribute(.font, at: 0, effectiveRange: nil) as? UIFont ?? self.font)
            attachmentImage.bounds = CGRect(x: 0, y: CGFloat(Int(((font?.capHeight ?? 0.0) - (attachmentImage.image?.size.height ?? 0)).rounded()) / 2), width: attachmentImage.image?.size.width ?? 0, height: attachmentImage.image?.size.height ?? 0)
            self.placeholderText?.append(imageString)
        }
    }

    var placeholderPadding: CGFloat = 0 {
        didSet {
            placeholderParagraphStyle.headIndent = placeholderPadding
        }
    }

    private var tfMask: TextFieldMask? {
        didSet {
            self.applyMask()
        }
    }

    private lazy var placeholderParagraphStyle: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.headIndent = placeholderPadding
        return style
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        super.delegate = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        super.delegate = self
    }

    func setTFMask(_ mask: TextFieldMask) {
        self.tfMask = mask
    }

    func applyMask() {
        guard let mask = self.tfMask else { return }
        let attributes = self.placeholderText?.attributes(at: 0, effectiveRange: nil)
        let attributesString = NSMutableAttributedString(string: mask.rawValue, attributes: attributes ?? [:])
        self.placeholderText = attributesString
    }

    func dropMask() -> String? {
        guard
            let text = self.text,
            let mask = self.tfMask
        else { return nil }

        let array = text.map{ String($0) }

        return array.compactMap { $0 != mask.rawValue.map({ String($0) }).filter({ $0 != "X" }).first ? $0 : nil }.joined()
    }

    // MARK: - Layout

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddings)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddings)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddings)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: CGFloat(bounds.width - (20 + self.paddings.right)), y: self.paddings.top + 2, width: 20, height: 20)
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: CGFloat(self.paddings.right), y: self.paddings.top + 2, width: 20, height: 20)
    }
}

extension CustomTextField: UITextFieldDelegate {

      public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
          return self.realDelegate?.textFieldShouldBeginEditing?(textField) ?? true
      }

      public func textFieldDidBeginEditing(_ textField: UITextField) {
          self.realDelegate?.textFieldDidBeginEditing?(textField)
      }

      public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
          return self.realDelegate?.textFieldShouldEndEditing?(textField) ?? true
      }

      public func textFieldDidEndEditing(_ textField: UITextField) {
          self.realDelegate?.textFieldDidEndEditing?(textField)
      }

      public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
      ) -> Bool {

          guard let currentMask = self.tfMask else { return true }

          let currentMaskArray = currentMask.rawValue.map { String($0) } // ["X", "X", "X", "X", "-"]
          let targetLocationInTheMask = currentMaskArray[range.location]

          var charactersSeparator: String? {
              return targetLocationInTheMask != "X" ? targetLocationInTheMask : nil
          }

          let isEndOfTheString = (textField.text?.count ?? 0) == range.location

          if string == "" {

              if textField.text?.map({ String($0) })[range.location - 1] == currentMaskArray.filter({ $0 != "X" }).first {

                  for _ in 0..<2 {
                      textField.text?.removeLast()
                  }

                  return false
              }

          } else {

              if isEndOfTheString {

                  if let separator = charactersSeparator { // is need to add separator?
                      textField.text?.append(separator)
                      return true
                  }

                  return true

              } else {

                  guard
                    var text = textField.text
                  else { return true }

                  if charactersSeparator != nil { // is need to add separator?

                      let inputedCharacterIndex = text.index(text.startIndex, offsetBy: range.location + 2)
                      textField.text?.insert(Character(string), at: inputedCharacterIndex)

                  } else {

                      guard
                        let locationOfLastCharacter = text.map({ String($0) }).enumerated().map({ $0.offset }).last
                      else { return true }

                      if currentMaskArray[locationOfLastCharacter + 1] != "X" {

                          let newCharacterIndex = text.index(text.startIndex, offsetBy: range.location)
                          text.insert(Character(string), at: newCharacterIndex)

                          let separatorIndex = text.index(text.startIndex, offsetBy: locationOfLastCharacter + 1)

                          text.insert(Character(currentMaskArray[locationOfLastCharacter + 1]), at: separatorIndex)

                          textField.text = text

                          return false
                      } else {

                          let inputedCharacterIndex = text.index(text.startIndex, offsetBy: range.location)
                          text.insert(Character(string), at: inputedCharacterIndex)

                          textField.text = text
                          return false
                      }
                  }
              }
          }

          return true
      }

      public func textFieldShouldClear(_ textField: UITextField) -> Bool {
          return self.realDelegate?.textFieldShouldClear?(textField) ?? true
      }

      public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          return self.realDelegate?.textFieldShouldReturn?(textField) ?? true
      }
      
}
