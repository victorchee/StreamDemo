//
//  ViewController.swift
//  StreamDemo
//
//  Created by Migu on 2018/4/25.
//  Copyright © 2018年 VIctorChee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var inputStream: InputStream?
    var outputStream: OutputStream?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        connectServer("0.0.0.0", port: 12345)
    }
    
    @IBAction func sendDataButtonTapped(_ sender: UIButton) {
        sendData("123")
    }
    
    private func connectServer(_ host: String, port: Int) {
        Stream.getStreamsToHost(withName: host, port: port, inputStream: &inputStream, outputStream: &outputStream)

        inputStream?.delegate = self
        outputStream?.delegate = self
        inputStream?.schedule(in: RunLoop.main, forMode: .commonModes)
        outputStream?.schedule(in: RunLoop.main, forMode: .commonModes)
        inputStream?.open()
        outputStream?.open()
    }
    
    private func sendData(_ string: String) {
        guard let data = string.data(using: String.Encoding.utf8) else {
            return
        }
        let _ = data.withUnsafeBytes{
            outputStream?.write($0, maxLength: data.count)
        }
        print("Has send \(string)")
    }
}

extension ViewController: StreamDelegate {
    private func readData() {
        guard let inputStream = inputStream, inputStream.hasBytesAvailable else {
            return
        }
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
        let length = inputStream.read(buffer, maxLength: 1024)
        let data = Data(bytes: buffer, count: length)
        let string = String(data: data, encoding: String.Encoding.utf8)
        print("Stream receive message: \(String(describing: string))")
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.openCompleted:
            print("Stream open completed")
            
        case .hasBytesAvailable:
            print("Stream has bytes available")
            readData()
            
        case .hasSpaceAvailable:
            print("Stream has space available")
            
        case .errorOccurred:
            print("Stream error occurred")
            
        case .endEncountered:
            print("Stream end encountered")
            inputStream?.close()
            outputStream?.close()
            inputStream?.remove(from: RunLoop.main, forMode: .commonModes)
            outputStream?.remove(from: RunLoop.main, forMode: .commonModes)
            
        default: break
        }
    }
}
