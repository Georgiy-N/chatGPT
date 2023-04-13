import UIKit

class ViewController: UIViewController {

    let promptTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 20
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray

        view.addSubview(promptTextField)
        view.addSubview(sendButton)
        view.addSubview(textLabel)

        NSLayoutConstraint.activate([
            promptTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            promptTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            promptTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -20),
            promptTextField.heightAnchor.constraint(equalToConstant: 40),

            sendButton.topAnchor.constraint(equalTo: promptTextField.topAnchor),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sendButton.widthAnchor.constraint(equalToConstant: 80),
            sendButton.heightAnchor.constraint(equalTo: promptTextField.heightAnchor),

            textLabel.topAnchor.constraint(equalTo: promptTextField.bottomAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            textLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 200), // Минимальная высота для textLabel
            textLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        sendButton.addTarget(self, action: #selector(sendRequest), for: .touchUpInside)
    }

    @objc func sendRequest() {
        guard let prompt = promptTextField.text, !prompt.isEmpty else {
            textLabel.text = "Please enter a prompt"
            return
        }

        APIService().sendRequest(prompt: prompt) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.textLabel.text = response
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.textLabel.text = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}
