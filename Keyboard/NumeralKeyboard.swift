//
//  NumeralKeyboard.swift
//  SplitKeys
//
//  Created by Jason Lam on 10/16/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class NumeralKeyboard: SingleKeyboard {
    
    private var counter: Int {
        didSet {
            label.text = "\(counter)"
        }
    }
    
    private var timer: Timer?
    private let waitInterval = 1.0
    
    override init(frame: CGRect) {
        counter = 0
        super.init(frame: frame)
        tapGestureRecognizer.addTarget(self, action: #selector(self.didTapButton(sender:)))
        longPressGestureRecognizer.addTarget(self, action: #selector(self.didLongPress(sender:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapButton(sender: UITapGestureRecognizer) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: waitInterval, target: self, selector: #selector(self.didSelectNumeral), userInfo: nil, repeats: false)
        counter = counter % 9 + 1
    }
    
    func didLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            delegate?.didSelect(char: "0")
            resetKeys()
        }
    }
    
    func didSelectNumeral() {
        delegate?.didSelect(char: Character("\(counter)"))
        resetKeys()
    }
    
    override func resetKeys() {
        timer?.invalidate()
        counter = 0
    }
    
    override func isUserTyping() -> Bool {
        return counter != 0
    }
}
