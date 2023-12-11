import UIKit

extension UIDeviceOrientation {
    public func isFlexiblePortrait() -> Bool {
        return self.isPortrait || (self.isFlat && !self.isLandscape)
    }
}
