//
//  ViewController.swift
//  PokemonTask
//
//  Created by 김인규 on 7/17/24.
//

import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController {
    var phoneBook: [PhoneBook] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "친구목록"
        configureUI()
        fetchContacts()
        
        let addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = .white
        // delegate: "대리자" 테이블뷰 속성 세팅을 뷰컨트롤러에서 대신 세팅함
        tableView.delegate = self
        // dataSource: 테이블뷰 안에 데이터를 뷰컨트롤러에서 세팅함
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()
    

    private func configureUI() {
        view.backgroundColor = .white
        [
        tableView
        ].forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
    }
    func fetchContacts() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PhoneBook> = PhoneBook.fetchRequest()
        
        //level6 데이터 순서 정렬 메소드
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            phoneBook = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("저장실패")
        }
    }
    
    @objc func addButtonTapped() {
        let addPage = PhoneBookViewController()
        navigationController?.pushViewController(addPage, animated: true)
        print("추가 버튼 누름")
    }
}


extension ViewController: UITableViewDelegate {
    
    // 테이블 뷰 셀 높이 크기 지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    //level 7 테이블셀 누를 때 화면이동기능
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPhoneBook = phoneBook[indexPath.row]
        let detailPage = PhoneBookViewController(phoneBook: selectedPhoneBook)
        navigationController?.pushViewController(detailPage, animated: true)
    }
}
extension ViewController: UITableViewDataSource {
    //테이블 뷰 indexPath 마다 테이블 뷰 셀을 지정.
    //indexPath = 테이블뷰의 행과 섹션을 의미
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: phoneBook[indexPath.row])
        return cell
    }
    // 테이블뷰 섹션에 행이 몇 개 들어가는가. 여기는 섹션이 없으니 총 행 개수를 입력하면 됩니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phoneBook.count
    }
}
