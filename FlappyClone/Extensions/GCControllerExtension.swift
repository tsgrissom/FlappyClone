import GameController

extension GCController {
    
    public func getVendorName() -> String {
        let vendorName: String? = self.vendorName
        if vendorName == nil {
            return "Unknown Controller"
        }
        return vendorName!
    }
    
    public func isXboxFormat() -> Bool {
        !isPlayStationFormat()
    }
    
    public func isPlayStationFormat() -> Bool {
        self.getVendorName().contains("PlayStation")
    }
    
    public func printLayout() {
        let vendorName = getVendorName()
        if vendorName.contains("PlayStation") {
            print("Layout: PlayStation")
        } else {
            print("Layout: Generic (Xbox)")
        }
    }
}
