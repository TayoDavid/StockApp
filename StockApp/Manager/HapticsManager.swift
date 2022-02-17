//
//  HapticsManager.swift
//  StockApp
//
//  Created by Omotayo on 07/01/2022.
//

import Foundation
import UIKit


/// Object to manage haptics
final class HapticManager {
    
    public static let shared = HapticManager()
    
    
    /// Private constructor
    private init() {}
    
    // MARK: - Public
    
    
    /// Vibrate slight for selection
    public func vibrateForSelection() {
        // Vibrate lightly for a selection tap interaction
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    
    /// Play haptic for given type interaction
    /// - Parameter type: Type to vibrate for
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
