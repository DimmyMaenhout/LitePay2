import Foundation
import UIKit
import AVFoundation

//AVCaptureMetadataOutput = het coregedeelte om qr code te lezen
//AVCaptureMetadataOutputObjectsDelegate =
class QRCodeReaderViewController : UIViewController {

    
    @IBOutlet weak var qrCodeLbl: UILabel!
    @IBOutlet weak var videoPreview: UIView!
    var captureSession = AVCaptureSession()
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var address : String!
    var amount : Decimal!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /* get the back-facing camera for capturing videos
        *  we get retrieve the device that supports the mediatype AVMediaType.video
        *  to perform real-time capture we use AVCaptureSession object and add the input of te video capture device
        */
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        print("QRCode reader view controller lijn 24, get the rear end camera: \(deviceDiscoverySession)")
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("QRCode reader view controller lijn 26, Failed to get the camera device")
            return
        }
        
        do
        {
            //get an instance of the AVCaptureDeviceInput class using the previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            //Set the input device on the capture session
            captureSession.addInput(input)
            
            //initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetaDataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetaDataOutput)
            
            //we set self as the delegate of the captureMetaDataOutput object
            //we specify the dispatch queue on which to excute the delegate's methods, because the queue must be serial we use DispatchQueue.main to get the default serial queue
            captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            //metadataObjectTypes, this is the point where we tell the app what kind of metada were interested in (QR)
            captureMetaDataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            print("QRCode reader view controller lijn 48, interested in (type) QR: \(captureMetaDataOutput.metadataObjectTypes)")
            
            //initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            //start video capture
            captureSession.startRunning()
            print("QRCode reader view controller lijn 58, started video capture")
        }
        catch {
            //if any error occurs
            print("QRCode reader view controller lijn 62, error occured: \(error)")
            return
        }
        //initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if captureSession.isRunning == false {
            
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        if captureSession.isRunning == true {
            
            captureSession.stopRunning()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pinCodeSegue" {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "confirmPayment") as! ConfirmPaymentViewController
            vc.addressPassed = address
            print("QRCode reader view controller lijn 82, going to next controller. address (addressPassed to next controller): \(address)")
           
            vc.amount = amount
        }
    }
}

extension QRCodeReaderViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let qrCodeData = metadataObjects.first {
            let qrCodeReadable = qrCodeData as? AVMetadataMachineReadableCodeObject
            if let readableCode = qrCodeReadable {
                qrCodeDetected(code: readableCode.stringValue!);
            }
        }
        captureSession.stopRunning()
        //check if the metadataObjects array is not nill and it contains at least one object
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            //explanationLbl.text = "No QR code is detected"
            return
        }
        
        //get the metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject //hier stond /*
        print("QRCode reader view controller lijn 100, metadataObj: \(String(describing: metadataObj.stringValue))")
        
        //If the data type is QR go in statement
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            
            //if the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barcodeObject!.bounds
            print("Qr code view controller line 107, trying to go to next view controller and giving address with it")
            
            if metadataObj.stringValue != nil {
                print("Qr code reader view controller line 115 metadataObj has a value (not nil)")
                
                //Check if metadataObj isn't an empty String
                if metadataObj.stringValue != "" {
                    
                    print("Qr code reader view controller line 119 metadataObj isn't an empty String")
                    address = metadataObj.stringValue!
                }
                
                //to see if the scanned value is correct (may be deleted)
                qrCodeLbl.text = metadataObj.stringValue
                
                self.performSegue(withIdentifier: "pinCodeSegue", sender: self)
            }
        }
    }
    
    func qrCodeDetected(code: String) {
        self.performSegue(withIdentifier: "pinCodeSegue", sender: self)
    }
}
