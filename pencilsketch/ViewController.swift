import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imageView = UIImageView()
    let processButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    var originalImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = .white

        // Image View
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        // Select Photo Button
        let selectButton = UIButton(type: .system)
        selectButton.setTitle("Select Photo", for: .normal)
        selectButton.backgroundColor = .systemBlue
        selectButton.setTitleColor(.white, for: .normal)
        selectButton.layer.cornerRadius = 10
        selectButton.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectButton)

        // Apply Sketch Button
        processButton.setTitle("Apply Sketch", for: .normal)
        processButton.backgroundColor = .systemGreen
        processButton.setTitleColor(.white, for: .normal)
        processButton.layer.cornerRadius = 10
        processButton.addTarget(self, action: #selector(applySketchEffect), for: .touchUpInside)
        processButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(processButton)

        // Save Image Button
        saveButton.setTitle("Save Image", for: .normal)
        saveButton.backgroundColor = .systemRed
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)

        // Layout Constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 300),

            selectButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectButton.widthAnchor.constraint(equalToConstant: 200),
            selectButton.heightAnchor.constraint(equalToConstant: 50),

            processButton.topAnchor.constraint(equalTo: selectButton.bottomAnchor, constant: 20),
            processButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            processButton.widthAnchor.constraint(equalToConstant: 200),
            processButton.heightAnchor.constraint(equalToConstant: 50),

            saveButton.topAnchor.constraint(equalTo: processButton.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // Select Photo
    @objc func selectPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    // Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
            imageView.image = image
        }
        dismiss(animated: true)
    }

    // 🔥 APPLY SKETCH EFFECT (FIXED)
    @objc func applySketchEffect() {
        guard let original = originalImage else {
            print("No image selected") // Debugging log
            return
        }
        
        if let sketchImage = SketchProcessor.applyPencilSketch(to: original) {
            imageView.image = sketchImage
        } else {
            print("Failed to apply sketch effect") // Debugging log
        }
    }

    // Save Image
    @objc func saveImage() {
        guard let processedImage = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(processedImage, nil, nil, nil)
    }
}
