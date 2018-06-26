import UIKit

var str = "Hello, playground"

// MARK: - A. Language Improvements

// MARK: - 1. Generating Random Numbers

let digit = Int.random(in: 0..<10)

// Return nil if the range is empty
if let anotherDigit = (0..<10).randomElement() {
    print(anotherDigit)
} else {
    print("Empty range.")
}

let double = Double.random(in: 0..<1)
let float = Float.random(in: 0..<1)
let cgFloat = CGFloat.random(in: 0..<1)
let bool = Bool.random()

let playlist = ["Nothing Else Matters", "Stairway to Heaven", "I Want to Break Free", "Yesterday"]
if let song = playlist.randomElement() {
    print(song)
} else {
    print("Empty playlist.")
}

let shuffledPlaylist = playlist.shuffled()

// MARK: - 2. Dynamic Member Lookup

@dynamicMemberLookup
class Person {
    let name: String
    let age: Int
    private let details: [String: String]
    
    init(name: String, age: Int, details: [String: String]) {
        self.name = name
        self.age = age
        self.details = details
    }
    
    // Conform to @dynamicMemberLookup
    subscript(dynamicMember key: String) -> String {
        switch key {
        case "info":
            return "\(name) is \(age) years old."
        default:
            return details[key] ?? ""
        }
    }
}

let details = ["title": "Author", "instrument": "Guitar"]
let me = Person.init(name: "Cosmin", age: 32, details: details)
me.info
me.instrument
me.name
me.age

// Inherit dynamic member lookup
@dynamicMemberLookup
class Vehicle {
    let brand: String
    let year: Int
    
    init(brand: String, year: Int) {
        self.brand = brand
        self.year = year
    }
    
    subscript(dynamicMember key: String) -> String {
        return "\(brand) made in \(year)"
    }
}

class Car: Vehicle {
}

let car = Car.init(brand: "Tesla", year: 2018)
car.info

// Protocol extensions
@dynamicMemberLookup
protocol Random {}

extension Random {
    subscript(dynamicMember key: String) -> Int {
        return Int.random(in: 0..<10)
    }
}

extension Int: Random {
}

let number = 10
let randomDigit = String(number.digit)
let noRandomDigit = String(number).filter {
    String($0) != randomDigit
}

// MARK: - 3. Enumeration Cases Collections

// Conform Seasons to CaseIterable
enum Seasons: String, CaseIterable {
    case spring = "Spring", summer = "Summer", autumn = "Autumn", winter = "Winter"
}

enum SeasonType {
    case equinox
    case solstice
}

for (index, season) in Seasons.allCases.enumerated() {
    let seasonType = index % 2 == 0 ? SeasonType.equinox : .solstice
    print("\(season.rawValue) \(seasonType).")
}

// Adding certain cases to enumeration cases array
enum Months: CaseIterable {
    case january, february, march, april, may, june, july, august, september, october, november, december
    
    static var allCases: [Months] {
        return [.june, .july, .august]
    }
}

for (_, month) in Months.allCases.enumerated() {
    print(month)
}

// Add all unavailable cases manually to the array if the enumeration contains unavailable ones
enum Days: CaseIterable {
    case monday, tuesday, wednesday, thursday, friday
    
    @available(*, unavailable)
    case saturday, sunday
    
    // You add only weekdays to allCases because you mark both .saturday and .sunday as unavailable on any version of any platform.
    static var allCases: [Days] {
        return [.monday, .tuesday, .wednesday, .thursday, .friday]
    }
}

// Add cases with associated values to the enumeration cases array
enum BlogPost: CaseIterable {
    case article
    case tutorial(updated: Bool)
    
    // Add all types of blog posts on the website to allCases: articles, new tutorials and updated ones.
    static var allCases: [BlogPost] {
        return [.article, .tutorial(updated: true), .tutorial(updated: false)]
    }
}

// MARK: - 4. New Sequence Methods

let ages = ["ten", "twelve", "thirteen", "nineteen", "eighteen", "seventeen", "fourteen",  "eighteen",
            "fifteen", "sixteen", "eleven"]

// index(where:) becomes firstIndex(where:), and index(of:) becomes firstIndex(of:) to remain consistent with first(where:)
if let firstTeen = ages.first(where: { $0.hasSuffix("teen") }),
    let firstIndex = ages.firstIndex(where: { $0.hasSuffix("teen") }),
    let firstMajorIndex = ages.firstIndex(of: "eighteen") {
    print("Teenager number \(firstIndex + 1) is \(firstTeen) years old.")
    print("Teenager number \(firstMajorIndex + 1) isn't a minor anymore.")
} else {
    print("No teenagers around here.")
}

// Simply use last(where:), lastIndex(where:) and lastIndex(of:) to find the previous element and specific indices in ages
if let lastTeen = ages.last(where: { $0.hasSuffix("teen") }),
    let lastIndex = ages.lastIndex(where: { $0.hasSuffix("teen") }),
    let lastMajorIndex = ages.lastIndex(of: "eighteen") {
    print("Teenager number \(lastIndex + 1) is \(lastTeen) years old.")
    print("Teenager number \(lastMajorIndex + 1) isn't a minor anymore.")
} else {
    print("No teenagers around here.")
}

// MARK: - 5. Testing Sequence Elements

let values = [10, 8, 12, 20]
let allEven = values.allSatisfy{ $0 % 2 == 0 }
