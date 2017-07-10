import UIKit

public class ExpandableCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        print(#function)
        return super.preferredLayoutAttributesFitting(layoutAttributes)
    }
    
    public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        print(#function)
        super.apply(layoutAttributes)
    }
    
    
    fileprivate func setupViews() {
    
        label = UILabel(frame: CGRect.zero)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        contentView.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    
    }
    
}

public extension ExpandableCollectionViewCell {
    
    func configure(from indexPath: IndexPath) {
        
        var title = ""
        
        if indexPath.row % 3 == 0 {
            
            title = "Hello there"
            
        } else if indexPath.row % 3 == 1 {
            
            title = "Hello there\nHello there bro"
            
        } else {
            
            title = "Hello there\nHello there bro\nHi lad"
            
        }
        
        label.text = title
        
    }
    
}
