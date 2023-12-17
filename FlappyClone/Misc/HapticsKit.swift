import UIKit

struct HapticsKit {
    
    public static func impact(
        style: UIImpactFeedbackGenerator.FeedbackStyle = .medium,
        intensity: CGFloat = 1.0
    ) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred(intensity: intensity)
    }
    
    public static func impactIf(
        _ predicate: Bool,
        style: UIImpactFeedbackGenerator.FeedbackStyle = .medium,
        intensity: CGFloat = 1.0
    ) {
        guard predicate else { return }
        impact(style: style, intensity: intensity)
    }
    
    public static func notification(
        type: UINotificationFeedbackGenerator.FeedbackType = .success
    ) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
    
    public static func notificationIf(
        _ predicate: Bool,
        type: UINotificationFeedbackGenerator.FeedbackType = .success
    ) {
        guard predicate else { return }
        notification(type: type)
    }
}
 
