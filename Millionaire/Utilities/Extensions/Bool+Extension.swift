import Foundation

extension Bool {
    static func random(probability: Double) -> Bool {
        precondition(probability >= 0 && probability <= 1, "Probability must be between 0 and 1")
        return Double.random(in: 0...1) < probability
    }
}
