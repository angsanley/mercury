import UIKit

class DefinitionTableViewCell: UITableViewCell {

    @IBOutlet weak var fotoView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func showLoadingAnimation() {
        fotoView.showAnimatedGradientSkeleton()
        typeLabel.showAnimatedGradientSkeleton()
        definitionLabel.showAnimatedGradientSkeleton()
    }
    public func hideLoadingAnimation() {
        fotoView.hideSkeleton()
        typeLabel.hideSkeleton()
        definitionLabel.hideSkeleton()
    }
    
    public func setType(type: String) {
        typeLabel.text = type
    }
    
    public func setDefinition(definition: String) {
        definitionLabel.text = definition
    }
    
    public func setFoto(foto: UIImage) {
        fotoView.image = foto
    }
}
