//
//  PhoneBookViewController.swift
//  PokemonTask
//
//  Created by 김인규 on 7/17/24.
//
import UIKit
import SnapKit
import CoreData

class PhoneBookViewController: UIViewController {
    
    var container: NSPersistentContainer!
    var phoneBook: PhoneBook?
    

    init(phoneBook: PhoneBook? = nil) {
           self.phoneBook = phoneBook
           super.init(nibName: nil, bundle: nil)
       }
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    private let profileImageView: UIImageView = {
       let profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = 100
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    lazy var randomImageButton: UIButton = {
       let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(randomImageButtonTapped), for: .touchUpInside)
        return button
    }()
    let nameTextView: UITextView = {
        let nameTextView = UITextView()
        nameTextView.layer.borderWidth = 1
        nameTextView.layer.borderColor = UIColor.lightGray.cgColor
        nameTextView.layer.cornerRadius = 5
        return nameTextView
    }()
    let phoneNumberTextView: UITextView = {
       let phoneNumberTextView = UITextView()
        phoneNumberTextView.layer.borderWidth = 1
        phoneNumberTextView.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberTextView.layer.cornerRadius = 5
        return phoneNumberTextView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "연락처 추가"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        if let phoneBook = phoneBook {
                   tableViewCell(with: phoneBook)
               }
        
        configureUI()
        let applyButton = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(applyButtonTapped))
        navigationItem.rightBarButtonItem = applyButton
    }
    
    func configureUI() {
        view.backgroundColor = .white
        [profileImageView, randomImageButton, nameTextView, phoneNumberTextView].forEach { view.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(200)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
        }
        randomImageButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        nameTextView.snp.makeConstraints {
            $0.top.equalTo(randomImageButton.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(40)
        }
        phoneNumberTextView.snp.makeConstraints {
            $0.top.equalTo(nameTextView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(40)
        }
    }
    //level7 테이블 데이터 받기
    func tableViewCell(with phoneBook: PhoneBook) {
        nameTextView.text = phoneBook.name
        phoneNumberTextView.text = phoneBook.phoneNumber
        if let imageData = phoneBook.profileImage {
            profileImageView.image = UIImage(data: imageData)
        }
    }
    
    @objc func applyButtonTapped() {
        print("적용 버튼 누름")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        
        if let phoneBook = phoneBook {
            phoneBook.name = nameTextView.text
            phoneBook.phoneNumber = phoneNumberTextView.text
            if let imageData = profileImageView.image?.pngData() {
                phoneBook.profileImage = imageData
            }
        } else {
            let newPhoneBook = PhoneBook(context: context)
            newPhoneBook.name = nameTextView.text
            newPhoneBook.phoneNumber = phoneNumberTextView.text
            
            if let imageData = profileImageView.image?.pngData() {
                newPhoneBook.profileImage = imageData
            }
        }
        
        do {
            try context.save()
            if let viewController = navigationController?.viewControllers.first(where: { $0 is ViewController }) as? ViewController {
                viewController.fetchContacts()
            }
            navigationController?.popViewController(animated: true)
        } catch {
            print("저장실패")
        }
        }
        
        
    @objc func randomImageButtonTapped() {
        print("랜덤 이미지 생성 버튼 누림")
        let randomID = Int.random(in: 1...1025)
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(randomID)")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else {
                print("데이터 로드 실패")
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let sprites = json["sprites"] as? [String: Any],
                   let imageUrlString = sprites["front_default"] as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    DispatchQueue.main.async {
                        self.profileImageView.loadImage(from: imageUrl)
                    }
                }
            } catch {
                print("에러발생")
            }
        }
        session.resume()
    }
}

extension UIImageView {
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
