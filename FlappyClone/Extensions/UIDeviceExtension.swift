import UIKit

extension UIDevice {
    public static func isTablet() -> Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    public static func isPhone() -> Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
