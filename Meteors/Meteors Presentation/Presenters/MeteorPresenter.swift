import Foundation

public final class MeteorPresenter {
    public static func massFormatter(_ mass: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        let number = NSNumber(value: mass / 1000)
        return "\(formatter.string(from: number) ?? "0") kg"
    }
    
    public static func map(_ meteor: Meteor) -> MeteorViewModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.timeZone = .init(secondsFromGMT: 0)
        let date = dateFormatter.string(from: meteor.year)
        
        let mass = massFormatter(meteor.mass)
        
        return MeteorViewModel(id: meteor.id,
                               name: meteor.name,
                               info: "\(date) · \(mass)")
    }
}
