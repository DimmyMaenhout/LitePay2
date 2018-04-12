import Foundation
import UIKit
import coinbase_official

class QRCodeViewController : UIViewController {
    
    @IBOutlet weak var QRImageView: UIImageView!
    var qrcodeImage : CIImage!
    var account : CoinbaseAccount!
    var addressID : String? {
        didSet {
            createQrCode(for: account.accountID)
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getNewAccountAddress()
    }
    
    func createQrCode(for address: String){
        
        let data = self.addressID!.data(using: .isoLatin1)
        
        //  To create a new CoreImage filter you need to use the CIQRCodeGenerator name
        let filter = CIFilter(name: "CIQRCodeGenerator")
        print("Qr code view controller line 29, data (addressID) \(String(describing: data))")
        
        //  The initial data you want to convert to into a QRCode image (should always be an Data object)
        print("Qr code view controller line 31, data (addressID) \(String(describing: data))")
        filter?.setValue(data, forKey: "inputMessage")
        //  inputCorrectionLevel: respresents how much error correction extra data should be added to the output qr code image (L = 7%, M = 15%, Q = 25%, H = 30%).
        //  The higher the value, the larger the output QR code image
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        qrcodeImage = filter?.outputImage
    
        //converting to UIImageView
        displayQrCodeImage()

    }
    func getNewAccountAddress() {
        CoinbaseAPIService.createNewAddress(for: account.accountID, completion: ({ response in
            print("Qr code view controller line 43, response: \(String(describing: response))")
            
            self.addressID = response!
            print("Qr code view controller line 46, response:\(response!)")
        
        }))
    }
    func displayQrCodeImage() {
        //The qrCode needs to be scaled, otherwise it's blurry (qr code image size is not equal to the size of the image view)
        let scaleX = QRImageView.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = QRImageView.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        QRImageView.image = UIImage(ciImage: transformedImage)
    }
}
