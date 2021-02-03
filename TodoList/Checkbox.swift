//
//  Checkbox.swift
//  TodoList
//
//  Created by Gabriel Kirkley on 2021-02-02.
//

import UIKit

//@IBDesignable
class Checkbox : UIControl {
        
    private weak var imageView: UIImageView!
    
    private var image : UIImage {
        return checked ? UIImage(systemName: "checkmark.square.fill")! :
            UIImage(systemName: "square")!
    }
    
    @IBInspectable
    public var checked : Bool = false {
        didSet {
            imageView.image = image
        }
    }
    
    // Called when creating from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    // Called when creating from storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor) .isActive = true;
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor) .isActive = true;
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor) .isActive = true;
        imageView.topAnchor.constraint(equalTo: topAnchor) .isActive = true;
        
        imageView.image = image
        
        imageView.contentMode = .scaleAspectFill
        
        self.imageView = imageView
        
        backgroundColor = UIColor.clear
        
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
    @objc func touchUpInside () {
        checked = !checked
        sendActions(for: .valueChanged)
    }
}
