import Foundation

struct PhysicsCategory {
    static let Player:   UInt32 = 0x1 << 1
    static let Boundary: UInt32 = 0x1 << 2
    static let Wall:     UInt32 = 0x1 << 3
    static let Score:    UInt32 = 0x1 << 4
}
