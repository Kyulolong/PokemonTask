//
//  TableViewCell.swift
//  PokemonTask
//
//  Created by 김인규 on 7/17/24.
//

import UIKit
import SnapKit

final class TableViewCell: UITableViewCell {
    
    static let id = "TableViewCell"
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private let pokemonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 30
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
// TableView 의 스타일과 아이디로 초기화를 할 때 사용하는 코드
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    // 인터페이스 빌더를 통해 셀을 초기화 할 때 상용하는 코드
    //여기는 fatalError를 통해 명시적으로 인터페이스 빌더로 초기화 하지 않음을 나타냄
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
        [
        pokemonImage, nameLabel, phoneNumberLabel
        ].forEach { contentView.addSubview($0) }
        
        pokemonImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(60)

        }
        nameLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(pokemonImage.snp.trailing).offset(20)
        }
        
        phoneNumberLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    public func configureCell(with phoneBook: PhoneBook){
        if let imageData = phoneBook.profileImage {
            pokemonImage.image = UIImage(data: imageData)
        } else {
            pokemonImage.image = nil 
        }
        nameLabel.text = phoneBook.name
        phoneNumberLabel.text = phoneBook.phoneNumber
    }
    override func prepareForReuse() {
            super.prepareForReuse()
            pokemonImage.image = nil
            nameLabel.text = nil
            phoneNumberLabel.text = nil
        }
}
