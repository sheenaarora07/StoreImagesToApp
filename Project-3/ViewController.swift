//
//  ViewController.swift
//  Project-3
//
//  Created by Akay Prince on 18/02/22.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var pictures = [Picture]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photo Gallary"
        tableView.rowHeight = 90
        
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let decoder = JSONDecoder()
            do {
                pictures = try decoder.decode([Picture].self, from: savedPictures)
            } catch {
                print("Unable to Decode")
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) as? PictureCell else {fatalError()}
        
        let picture = pictures[indexPath.row]
        
        cell.name.text = picture.name
        
        let path = getDocumentsDirectory().appendingPathComponent(picture.image)
        cell.imageName.image = UIImage(contentsOfFile: path.path)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let picture = pictures[indexPath.row]
        
        let ac = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].text = picture.name
        let ok = UIAlertAction(title: "Update", style: .default) { action in
            if let newName = ac.textFields?[0].text {
                picture.name = newName
                self.save()
                self.tableView.reloadData()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(ok)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pictures.remove(at: indexPath.row)
            save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let picture = pictures[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else{return}
        vc.selectedImage = picture
        vc.path = getDocumentsDirectory().appendingPathComponent(picture.image)
        vc.title = "Picture Detail"
        navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        

            let ac = UIAlertController(title: "What you want to use?", message: nil, preferredStyle: .actionSheet)
            
            let cameraButton = UIAlertAction(title: "Camera", style: .default) { action in
                let picker = UIImagePickerController()
                self.imageSourcePick(picker: picker, isCamera: true)
            }

            let photoButton = UIAlertAction(title: "Library", style: .default) { action in
                let picker = UIImagePickerController()
                self.imageSourcePick(picker: picker, isCamera: false)
        }
            ac.addAction(cameraButton)
            ac.addAction(photoButton)
            present(ac, animated: true)
}
    
    func imageSourcePick(picker: UIImagePickerController, isCamera: Bool) {
        let isCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        
//        let picker = UIImagePickerController()
        
        if isCamera {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else{return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let picture = Picture(name: "Unknown", image: imageName)
        
        pictures.append(picture)
        save()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let savedData = try? encoder.encode(pictures) {
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save data")
        }
    }

}
