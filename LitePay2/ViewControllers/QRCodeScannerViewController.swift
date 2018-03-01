//
//  QRCodeScannerViewController.swift
//  LitePay2
//
//  Created by Dimmy Maenhout on 01/03/2018.
//  Copyright © 2018 Dimmy Maenhout. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class QRCodeScannerViewController : UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var QRCodeScannerImageView : UIImageView!
    @IBOutlet weak var headerInfoLbl: UILabel!
    @IBOutlet weak var infoIcon: UIImageView!
    @IBOutlet weak var explanationLbl: UILabel!
}
