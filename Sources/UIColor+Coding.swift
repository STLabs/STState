import UIKit

extension UIColor : Encodable, Decodable {
   
   public static func decode(decoder: Decoder) -> Self? {
      
      if let
         red : CGFloat  = decoder.decode("red"),
         green: CGFloat = decoder.decode("green"),
         blue:    CGFloat  = decoder.decode("blue"),
         alpha: CGFloat = decoder.decode("alpha") {
         
         return self.init(red: red, green: green, blue: blue, alpha: alpha)
      }
      else {
         return nil
      }
   }
   
    public convenience init?(decoder: Decoder) {
      if let
         red : CGFloat  = decoder.decode("red"),
         green: CGFloat = decoder.decode("green"),
         blue:    CGFloat  = decoder.decode("blue"),
         alpha: CGFloat = decoder.decode("alpha") {
         
         self.init(red: red, green: green, blue: blue, alpha: alpha)
      }
      else {
         return nil
      }
   }
   
   public func encode(encoder: Encoder) {
      
      var red, green, blue, alpha  : CGFloat
      red = 0; green = 0; blue = 0; alpha = 0
      self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
      
      encoder.encode(red, "red")
      encoder.encode(green, "green")
      encoder.encode(blue, "blue")
      encoder.encode(alpha, "alpha")
   }
}