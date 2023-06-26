import UIKit

class ViewController: UIViewController {

    let stackView = UIStackView()
    let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        containerView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
          stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
          stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
          stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
        ])

        containerView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        containerView.layer.cornerRadius = 100
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowRadius = 1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.masksToBounds = false

        containerView.layoutMargins = UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20)
    }
}
