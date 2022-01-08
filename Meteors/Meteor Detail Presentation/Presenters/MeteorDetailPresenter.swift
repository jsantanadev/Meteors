import Foundation

public final class MeteorDetailPresenter {
    public static func map(_ meteor: Meteor, localStorage: FavoritesData) -> MeteorDetailViewModel {
        let isFavorite = localStorage.isMeteorFavorite(id: meteor.id)
        
        let coordinatesTitle = setupLocalizedString("COORDINATES_TITLE", comment: "Title for the meteor coordinates info")
        let coordinatesInfo = MeteorDeailInfoViewModel(title: coordinatesTitle,
                                                       info: "(\(meteor.geoLocation.latitude), \(meteor.geoLocation.longitude))")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateFormatter.timeZone = .init(secondsFromGMT: 0)
        let year = dateFormatter.string(from: meteor.year)
        let dateTitle = setupLocalizedString("DATE_TITLE", comment: "Title for the meteor date info")
        let yearInfo = MeteorDeailInfoViewModel(title: dateTitle, info: year)
        
        let massTitle = setupLocalizedString("MASS_TITLE", comment: "Title for the meteor mass info")
        let mass = MeteorPresenter.massFormatter(meteor.mass)
        let massInfo = MeteorDeailInfoViewModel(title: massTitle, info: mass)
        
        let fallTitle = setupLocalizedString("FALL_TITLE", comment: "Title for the meteor fall info")
        let fallInfo = MeteorDeailInfoViewModel(title: fallTitle, info: meteor.fall)
        
        let typeTitle = setupLocalizedString("TYPE_TITLE", comment: "Title for the meteor type info")
        let typeInfo = MeteorDeailInfoViewModel(title: typeTitle, info: meteor.type)
         
        let classTitle = setupLocalizedString("CLASS_TITLE", comment: "Title for the meteor class info")
        let classInfo = MeteorDeailInfoViewModel(title: classTitle, info: meteor.recclass)
        
        let details = [massInfo, fallInfo, typeInfo, classInfo]
        
        return MeteorDetailViewModel(id: meteor.id, name: meteor.name,
                                     isFavorite: isFavorite,
                                     geoLocation: meteor.geoLocation,
                                     coordinatesInfo: coordinatesInfo,
                                     yearInfo: yearInfo,
                                     details: details)
    }
    
    private static func setupLocalizedString(_ key: String, comment: String) -> String {
        return NSLocalizedString(key,tableName: "Meteor Detail",
                                 bundle: Bundle(for: MeteorDetailPresenter.self),
                                 comment: comment)
    }
}
