import UIKit
import SnapKit

public final class BaseXibView: UIView {

    @IBOutlet var contentView: UIView!

    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }

    var XIB_NAME: String {
        return String(describing: type(of: self))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInit()
    }

    func viewInit() {
        Bundle.main.loadNibNamed(XIB_NAME, owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.frame = self.bounds
        self.addSubview(contentView)

        contentView.backgroundColor = .clear
        contentView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.right.equalToSuperview()
            maker.left.equalToSuperview()
        }
    }

    func addShadow(_ shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }

}

extension UIColor {
    convenience init?(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            self.init()
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIColor {

    // Palette of colors
    private static let color_181A22: UIColor = UIColor(hex: "#181A22")!  // Gray
    private static let color_D4152C: UIColor = UIColor(hex: "#D4152c")!  // Red
    private static let color_0B7FFE: UIColor = UIColor(hex: "#0B7FFE")!  // Blue
    private static let color_C0C0C0: UIColor = UIColor(hex: "#C0C0C0")!  // Gray
    private static let color_F7F7F7: UIColor = UIColor(hex: "#F7F7F7")!  // Gray

    private static let color_13574B: UIColor = UIColor(hex: "#13574B")!  // Green
    private static let color_33343D: UIColor = UIColor(hex: "#33343D") ?? .darkGray // Dark gray
    private static let color_686A79: UIColor = UIColor(hex: "#686A79") ?? .gray  // Gray
    private static let color_4230DD: UIColor = UIColor(hex: "#4230DD") ?? .purple  // Purp
    private static let color_F3F8FF: UIColor = UIColor(hex: "#F3F8FF")!  // Light blue
    private static let color_06022B: UIColor = UIColor(hex: "#06022B")!  // Dark blue
    private static let color_E7FEF8: UIColor = UIColor(hex: "#E7FEF8")!  // Light green
    private static let color_A68400: UIColor = UIColor(hex: "#A68400")!  // Yellow
    private static let color_FFEFD2: UIColor = UIColor(hex: "#FFEFD2")!  // Light Yellow
    private static let color_005785: UIColor = UIColor(hex: "#005785")!  // Blue
    private static let color_E8F2FF: UIColor = UIColor(hex: "#E8F2FF")!  // Light Blue
    private static let color_A6A5A5: UIColor = UIColor(hex: "#A6A5A5")!  // Gray

    // MARK: - Palette

    static let specialGray: UIColor = color_C0C0C0
    static let oldBackgroundGray: UIColor = color_F7F7F7

    // Ink
    static let inkPrimary: UIColor = color_33343D
    static let inkSecondary: UIColor = color_686A79
    static let inkTertiary: UIColor = color_181A22.withAlphaComponent(0.3)

    // Light
    static let lightSecondary: UIColor = color_181A22.withAlphaComponent(0.04)
    static let lightTertiary: UIColor = color_181A22.withAlphaComponent(0.1)

    // Functional/Accent/Labels
    static let cyanBlue: UIColor = color_0B7FFE
    static let darkYellow: UIColor = color_A68400
    static let lightYellow: UIColor = color_FFEFD2
    static let darkBlue: UIColor = color_005785
    static let lightBlue: UIColor = color_E8F2FF
    static let forest: UIColor = color_13574B
    static let lightForest: UIColor = color_E7FEF8

    //EBT
    static let infoGray: UIColor = color_686A79
    static let borderGray: UIColor = color_A6A5A5
}

// MARK: - Referral rewards design

extension UIColor {

    static let primary: UIColor = color_4230DD
    static let background: UIColor = color_F3F8FF
    static let surface: UIColor = .white
    static let secondary: UIColor = color_E7FEF8
    static let error: UIColor = color_D4152C

    static let onPrimary: UIColor  = .white
    static let onBackground: UIColor = color_06022B
    static let onSurface: UIColor = color_06022B
    static let onError: UIColor = .white
    static let onSecondary: UIColor = color_4230DD
}

// MARK: - SF Pro Display

extension UIFont {

    class func sfProDisplayRegular(size: CGFloat) -> UIFont {
        return  UIFont(name: "SFProDisplay-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)
    }

    class func sfProDisplayMedium(size: CGFloat) -> UIFont {
        return  UIFont(name: "SFProDisplay-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }

    class func sfProDisplaySemibold(size: CGFloat) -> UIFont {
        return  UIFont(name: "SFProDisplay-Semibold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
    }

    class func sfProDisplayBold(size: CGFloat) -> UIFont {
        return  UIFont(name: "SFProDisplay-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
    }

    class func sfProDisplayBlack(size: CGFloat) -> UIFont {
        return  UIFont(name: "SFProDisplay-Black", size: size) ?? .systemFont(ofSize: size, weight: .black)
    }
}

// MARK: - Flashfood Fonts

extension UIFont {

    class func fontH2() -> UIFont {
        return UIFont.sfProDisplaySemibold(size: 24.0)
    }

    class func fontH3() -> UIFont {
        return UIFont.sfProDisplaySemibold(size: 20.0)
    }

    class func fontH4() -> UIFont {
        return UIFont.sfProDisplaySemibold(size: 18.0)
    }

    class func fontBody() -> UIFont {
        return UIFont.sfProDisplayRegular(size: 16.0)
    }

    class func fontBodySemibold() -> UIFont {
        return UIFont.sfProDisplaySemibold(size: 16.0)
    }

    class func fontSubtitle() -> UIFont {
        return UIFont.sfProDisplayRegular(size: 14.0)
    }

    class func fontCaption() -> UIFont {
        return UIFont.sfProDisplayRegular(size: 12.0)
    }

    class func fontButton() -> UIFont {
        return UIFont.sfProDisplayMedium(size: 18.0)
    }
}

// MARK: - Referral rewards design

extension UIFont {
    class func referralRewardsSubtitleFont() -> UIFont {
        return UIFont.sfProDisplayRegular(size: 18.0)
    }

    class func referralRewardsFontBtn() -> UIFont {
        return UIFont.sfProDisplayHeavy(size: 18.0)
    }
}

extension UIFont {
    class func sfProDisplayHeavy(size: CGFloat) -> UIFont {
        return  UIFont(name: "SFProText-Heavy", size: size) ?? .systemFont(ofSize: size, weight: .heavy)
    }
}
