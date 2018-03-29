import Foundation
import UIKit
import coinbase_official

class QRCodeViewController : UIViewController {
    
    @IBOutlet weak var QRImageView: UIImageView!
    var qrcodeImage : CIImage!
    var account : CoinbaseAccount!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        createQrCode()
    }
    
    func createNewAddress(accountID: String) {
        
        CoinbaseAPIService.createNewAddress(for: accountID)
    }
    
    func createQrCode(){
        
        let addressID = CoinbaseAPIService.createNewAddress(for: account.accountID)
        print("QR code view controller line 28, addressID: \(addressID)")
        
        let data = addressID.data(using: .isoLatin1)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        //inputMessage: the initial data you want to convert to into a QRCode image (should always be an NSData object, original was data
        filter?.setValue(data, forKey: "inputMessage")
        //inputCorrectionLevel: respresents how much error correction extra data should be added to the output qr code image (L = 7%, M = 15%, Q = 25%, H = 30%).   The higher the value, the larger the output QR code image
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        qrcodeImage = filter?.outputImage
    
        //converting to UIImageView
        displayQrCodeImage()

    }
    
    func displayQrCodeImage() {
        //The qrCode needs to be scaled, otherwise it's blurry (qr code image size is not equal to the size of the image view)
        let scaleX = QRImageView.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = QRImageView.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        QRImageView.image = UIImage(ciImage: transformedImage)
    }
}
