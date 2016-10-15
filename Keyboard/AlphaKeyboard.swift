//
//  AlphaKeyboard.swift
//  SplitKeys
//
//  Created by Owen Yang on 10/5/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit
import AVFoundation

class AlphaKeyboard: DualKeyboard {
    var charSet: [Character] = [] {
        didSet {
            resetKeys()
        }
    }
    
    private var leftLowerIndex = 0
    private var leftUpperIndex = 0
    private var rightLowerIndex = 0
    private var rightUpperIndex = 0
    
    private var userTyping = false;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        leftTapGestureRecognizer.addTarget(self, action: #selector(self.didTapButton(sender:)))
        rightTapGestureRecognizer.addTarget(self, action: #selector(self.didTapButton(sender:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func handleButtonTap(sender: UITapGestureRecognizer) {
        userTyping = true
        if sender == leftTapGestureRecognizer {
            if leftLowerIndex == leftUpperIndex {
                charSelected(char: charSet[leftLowerIndex])
                resetIndexes()
            } else {
                expandLeftIndexes()
            }
        } else if sender == rightTapGestureRecognizer {
            if rightLowerIndex == rightUpperIndex {
                charSelected(char: charSet[rightLowerIndex])
                resetIndexes()
            } else {
                expandRightIndexes()
            }
        }
    }
    
    func createDialog(lowerBound: Int, upperBound: Int) -> [AVSpeechUtterance] {
        if lowerBound == upperBound {
            return [AVSpeechUtterance(string: "\(charSet[lowerBound])")]
        }
        return [
            AVSpeechUtterance(string: "\(charSet[lowerBound])"),
            AVSpeechUtterance(string: "to"),
            AVSpeechUtterance(string: "\(charSet[upperBound])")
            ]
    }
    
    func speakUtterances(utterances: [AVSpeechUtterance]) {
        for utterance in utterances {
            speechSynthesizer?.speak(utterance)
        }
    }
    
    override func announceState() {
        if !Settings.isAudioEnabled {
            return
        }
        if !charJustAnnounced {
            speechSynthesizer?.stopSpeaking(at: .immediate)
        }
        let leftUtterances = createDialog(lowerBound: leftLowerIndex, upperBound: leftUpperIndex)
        let rightUtterances = createDialog(lowerBound: rightLowerIndex, upperBound: rightUpperIndex)
        speakUtterances(utterances: leftUtterances)
        speakUtterances(utterances: rightUtterances)
    }
    
    override func resetKeys() {
        resetIndexes()
    }
    
    private func resetIndexes() {
        userTyping = false
        leftLowerIndex = 0
        leftUpperIndex = charSet.count / 2 - 1
        rightUpperIndex = charSet.count - 1
        rightLowerIndex = min(leftUpperIndex + 1, rightUpperIndex)
        updateButtonLabels()
    }
    
    private func expandLeftIndexes() {
        rightUpperIndex = leftUpperIndex
        leftUpperIndex = (leftLowerIndex + leftUpperIndex) / 2
        rightLowerIndex = min(leftUpperIndex + 1, rightUpperIndex)
        updateButtonLabels()
    }
    
    private func expandRightIndexes() {
        leftLowerIndex = rightLowerIndex
        leftUpperIndex = (rightLowerIndex + rightUpperIndex) / 2
        rightLowerIndex = min(leftUpperIndex + 1, rightUpperIndex)
        updateButtonLabels()
    }
    
    private func updateButtonLabels() {
        leftLabel.text = "\(charSet[leftLowerIndex])"
        if leftLowerIndex != leftUpperIndex {
            leftLabel.text? += "...\(charSet[leftUpperIndex])"
        }
        
        rightLabel.text = "\(charSet[rightLowerIndex])"
        if rightLowerIndex != rightUpperIndex {
            rightLabel.text? += "...\(charSet[rightUpperIndex])"
        }
    }
    
    override func isUserTyping() -> Bool {
        return userTyping
    }
}

class UpperKeyboard: AlphaKeyboard {
    override init(frame: CGRect) {
        super.init(frame: frame)
        charSet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LowerKeyboard: AlphaKeyboard {
    override init(frame: CGRect) {
        super.init(frame: frame)
        charSet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
