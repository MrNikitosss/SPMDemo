import UIKit

enum TextFieldMask {
    case cardNumber
    case cardNumberWithDashes
    case custom(customMask: String)

    var rawValue: String {
        switch self {
        case .cardNumber:
            return "XXXX XXXX XXXX XXXX"
        case .cardNumberWithDashes:
            return "XXXX-XXXX-XXXX-XXXX"
        case .custom(let customMask):
            return customMask
        }
    }
}

enum TextFieldIconPosition {
    case left
    case right
}

public final  class FFTextFieldView: BaseXibView {

    weak var textFieldViewDelegate: UITextFieldDelegate?

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var customTextField: CustomTextField!
    @IBOutlet private weak var errorLabel: UILabel!

    var paragraphStyle: NSMutableParagraphStyle?

    var placeHolderString: String? {
        didSet {
            self.applyPlaceHolder()
        }
    }

    var colorScheme: FlashfoodColorScheme? {
        didSet {
            self.commonTFSetups()
        }
    }
    var typographyScheme: FlashfoodTypographyScheme? {
        didSet {
            self.commonTFSetups()
            self.titleLabelCommonSetups()
        }
    }

    var errorText: String? = nil {
        didSet {
            guard self.errorText != nil else { return }
            self.updateErrorLabelWithNewValue()
            self.updateContentWithErrorState()
        }
    }

    var titleLabelText: String? = nil {
        didSet {
            self.titleLabelCommonSetups()
        }
    }

    var paddings = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) {
        didSet {
            self.customTextField.paddings = self.paddings
        }
    }

    var unmaskedText: String? {
        return self.getUnmaskedText()
    }

    private var needErrorStateIcon: Bool = false
    private var textFieldIconPosition: TextFieldIconPosition = .left

    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.commonSetup()
        self.setupNotifications()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.commonSetup()
        self.setupNotifications()
    }

    func setTFMask(_ mask: TextFieldMask) {
        self.customTextField.setTFMask(mask)
    }

    private func getUnmaskedText() -> String? {
        return self.customTextField.dropMask()
    }

    func needIconForErrorState() {
        self.needErrorStateIcon = true
    }

    func setTextFieldIconPosition(_ position: TextFieldIconPosition) {
        self.textFieldIconPosition = position
    }

    func addIconForTF(iconName: String) {
        if self.textFieldIconPosition == .right {
            self.customTextField.rightView = self.configureIconForTF(iconName: iconName)
            self.customTextField.rightViewMode = .always
        } else {
            let imageView = self.configureIconForTF(iconName: iconName)
            self.customTextField.paddings.left = self.customTextField.paddings.left + imageView.frame.width + 10
            self.customTextField.leftView = imageView
            self.customTextField.leftViewMode = .always
        }
    }

    func addIconForErrorState(iconName: String? = nil) {
        self.customTextField.rightView = self.configureIconForTF(iconName: iconName ?? "Error")
        self.customTextField.rightViewMode = .always
    }

    private func applyPlaceHolder() {
        guard let placeHolderString = self.placeHolderString else { return }

        let attr: [NSMutableAttributedString.Key : Any] = [
            .font : (self.typographyScheme?.headline4.withSize(16) ?? UIFont()),
            .foregroundColor : UIColor.inkPrimary.cgColor,
            .paragraphStyle : (self.paragraphStyle ?? NSMutableParagraphStyle())
        ]
        let string = NSMutableAttributedString(string: placeHolderString, attributes: attr)
        self.customTextField.placeholderText = string
    }

    private func configureIconForTF(iconName: String) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.customTextField.paddings.right, height: 10))
        imageView.image = UIImage(named: iconName)

        return imageView
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didBeginEditing),
            name: UITextField.textDidBeginEditingNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didEndEditing),
            name: UITextField.textDidEndEditingNotification,
            object: nil
        )
    }

    @objc private func didBeginEditing() {
        self.customTextField.layer.borderColor = self.colorScheme?.primaryColor.cgColor
    }

    @objc private func didEndEditing() {
        self.customTextField.layer.borderColor = UIColor.lightTertiary.cgColor
    }

    private func commonSetup() {
        self.customTextField.layer.cornerRadius = 8
        self.customTextField.layer.borderColor = UIColor.lightTertiary.cgColor
        self.customTextField.layer.borderWidth = 1.0
        self.customTextField.realDelegate = textFieldViewDelegate
        self.titleLabel.text = nil
        self.errorLabel.text = nil
    }

    private func commonTFSetups() {
        self.customTextField.layer.cornerRadius = 8
        self.customTextField.layer.borderColor = UIColor.lightTertiary.cgColor
        self.customTextField.layer.borderWidth = 1.0
        self.customTextField.realDelegate = textFieldViewDelegate
    }

    private func titleLabelCommonSetups() {
        self.titleLabel.textColor = UIColor.inkPrimary
        self.titleLabel.font = self.typographyScheme?.headline2.withSize(16)

        guard let titleLabelText = self.titleLabelText else {
            self.titleLabel.isHidden = true
            return
        }
        self.titleLabel.isHidden = false
        self.titleLabel.text = titleLabelText
    }

    private func updateErrorLabelWithNewValue() {
        self.errorLabel.font = self.typographyScheme?.caption
        self.errorLabel.text = self.errorText
        self.errorLabel.textColor = self.colorScheme?.errorColor
    }

    private func updateContentWithErrorState() {
        self.customTextField.layer.borderColor = self.colorScheme?.errorColor.cgColor
        self.customTextField.layer.borderWidth = 1.0
        self.customTextField.layer.masksToBounds = true

        self.addIconForErrorState()

        self.layoutSubviews()
        self.layoutIfNeeded()
    }
}
