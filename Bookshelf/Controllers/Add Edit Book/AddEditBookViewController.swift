import UIKit

final class AddEditBookViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!

    // MARK: - Properties

    var book: Book?

    // MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupContent()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Actions

    @IBAction func saveBook() {
        guard let ratingText = ratingTextField.text,
              let ratingValue = Double(ratingText)
        else { return }

        if book == nil {
            book = Book(context: context)
        }

        book?.title = titleTextField.text
        book?.summary = descriptionTextView.text
        book?.rating = ratingValue
        book?.image = bookImageView.image

        do {
            try context.save()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }

    @IBAction func loadBookImage() {
        let alertController = UIAlertController(
            title: "Selecionar imagem",
            message: "Selecione a origem para a imagem",
            preferredStyle: .actionSheet
        )

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { [weak self] _ in
                self?.selectImage(source: .camera)
            }
            alertController.addAction(cameraAction)
        }

        let photosAction = UIAlertAction(title: "Álbum de Fotos", style: .default) { [weak self] _ in
            self?.selectImage(source: .photoLibrary)
        }
        alertController.addAction(photosAction)

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    // MARK: - Private Methods

    private func setupView() {
        bookImageView.layer.cornerRadius = bookImageView.frame.height/2
        actionButton.layer.cornerRadius = 8

        let grayColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        descriptionTextView.layer.borderWidth = 0.3
        descriptionTextView.layer.borderColor = grayColor.cgColor
        descriptionTextView.layer.cornerRadius = 5
    }

    private func setupContent() {
        if book == nil {
            displayCreateNewBookState()
        } else {
            displayExistingBookState()
        }
    }

    private func displayCreateNewBookState() {
        title = "Cadastrar livro"
        bookImageView.image = UIImage(systemName: "plus.circle.fill")
        actionButton.setTitle("Cadastrar", for: .normal)
    }

    private func displayExistingBookState() {
        title = "Alterar livro"
        bookImageView.image = book?.image as? UIImage
        titleTextField.text = book?.title
        descriptionTextView.text = book?.summary
        ratingTextField.text = "\(book?.rating ?? 0)"
        actionButton.setTitle("Alterar", for: .normal)
    }

    private func selectImage(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerController delegate

extension AddEditBookViewController: UIImagePickerControllerDelegate {
    typealias InfoKey = UIImagePickerController.InfoKey

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[InfoKey.originalImage] as? UIImage else {
            return
        }

        let aspectRatio = image.size.width / image.size.height
        var smallSize: CGSize

        if aspectRatio > 1{
            smallSize = CGSize(width: 800, height: 800/aspectRatio)
        } else {
            smallSize = CGSize(width: 800*aspectRatio, height: 800)
        }

        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        let smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        bookImageView.image = smallImage

        dismiss(animated: true)
    }
}

// MARK: - UINavigationController delegate

extension AddEditBookViewController: UINavigationControllerDelegate { }
