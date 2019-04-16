import UIKit

public class SkeletonPiece: UIImageView, SkeletonPieceable {
    
    public var tissue: UIImage
    public var bone: UIImage
    public var piece: UIImage
    public var isMutated: Bool = false
    
    public init(tissue: UIImage, bone: UIImage) {
        self.tissue = tissue
        self.bone = bone
        self.piece = tissue
        super.init(frame: .zero)
        self.image = self.piece
        self.contentMode = .scaleAspectFit
    }
    
    required public convenience init(_ element: SkeletonPiece) {
        self.init(tissue: element.tissue, bone: element.bone)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.tissue = UIImage()
        self.bone = UIImage()
        self.piece = UIImage()
        super.init(coder: aDecoder)
        self.image = piece
    }
    
    public func mutate() {
        image = isMutated ? tissue: bone
    }
}
