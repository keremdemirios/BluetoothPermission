//
//  ViewController.swift
//  BluetoohPermissionExample
//
//  Created by Kerem Demir on 15.06.2023.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate {

    var centralManager: CBCentralManager!

    private lazy var bluetoothButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Connect", for: .normal)
        button.addTarget(self, action: #selector(bluetoothButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()

        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    private func configure() {
        addConstraint()
    }

    private func addConstraint() {
        view.addSubview(bluetoothButton)
        NSLayoutConstraint.activate([
            bluetoothButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            bluetoothButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            bluetoothButton.widthAnchor.constraint(equalToConstant: 120),
            bluetoothButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Functions

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            // Bluetooth açık durumda, erişime izin verilmiş demektir.
            print("Bluetooth açık durumda. İzin verilmiş")
            // Burada Bluetooth cihazlarına erişimi gerçekleştirebilirsiniz.
        case .poweredOff:
            // Bluetooth kapalı durumda, kullanıcıya bir mesaj gösterebilirsiniz.
            print("Bluetooth kapalı.")
        case .unauthorized:
            // Kullanıcı izin vermedi, kullanıcıya bir mesaj gösterebilirsiniz.
            print("Bluetooth izni verilmedi.")
            showBluetoothPermissionAlert()
        case .unknown, .resetting, .unsupported:
            // Diğer durumlar
            print("Bilinmeyen problem.")
            break
        @unknown default:
            break
        }
    }

    func checkBluetoothPermission() {
        if centralManager.state == .poweredOn {
            // Bluetooth açık durumda, erişime izin verilmiş demektir.
            print("Bluetooth açık durumda. İzin verilmiş")
            // Burada Bluetooth cihazlarına erişimi gerçekleştirebilirsiniz.
        } else if centralManager.state == .unauthorized {
            // Bluetooth izni verilmediğinde kullanıcıya izin isteği gösterin
            print("Bluetooth izni verilmedi.")
            showBluetoothPermissionAlert()
        } else {
            // Bluetooth iznini sorgulayın
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }
    }

    func showBluetoothPermissionAlert() {
        let alertController = UIAlertController(title: "Bluetooth izni gerekli", message: "Bluetooth özelliğini kullanabilmek için izin vermeniz gerekmektedir. Ayarlara giderek izni açabilirsiniz.", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)

        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Actions

    @objc func bluetoothButtonTapped() {
        print("Working.")
        checkBluetoothPermission()
    }
}

