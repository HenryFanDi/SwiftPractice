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

// MARK: - 6. Conditional Conformance Updates

// MARK: - 6.1. Conditional conformance in extensions

struct Tutorial: Hashable, Codable {
    let title: String
    let author: String
}

struct Screencast<Tutorial> {
    let author: String
    let tutorial: Tutorial
}

// Constrain Screencast to conform to Hashable and Codable if Tutorial does.
extension Screencast: Equatable where Tutorial: Equatable {}
extension Screencast: Hashable where Tutorial: Hashable {}
extension Screencast: Codable where Tutorial: Codable {}

let swift41Tutorial = Tutorial.init(title: "What's New in Swift 4.1?", author: "Henry")
let swift42Tutorial = Tutorial.init(title: "What's New in Swift 4.2?", author: "Henry")
let swift41Screencast = Screencast(author: "Henry Fan", tutorial: swift41Tutorial)
let swift42Screencast = Screencast(author: "Henry Fan", tutorial: swift42Tutorial)

// Swift 4.2 adds a default implementation for Equatable conditional conformance to an extension:
let sameScreencast = swift41Screencast == swift42Screencast

// Add screencasts to sets and dictionaries and encode them
let screencastsSet: Set = [swift41Screencast, swift42Screencast]
let screencastsDictionary = [swift41Screencast: "Swift 4.1", swift42Screencast: "Swift 4.2"]

let screencasts = [swift41Screencast, swift42Screencast]
let encoder = JSONEncoder()
do {
    try encoder.encode(screencasts)
} catch {
    print("\(error)")
}

// MARK: - 6.2. Conditional conformance runtime queries

class Instrument {
    let brand: String
    
    init(brand: String = "") {
        self.brand = brand
    }
}

protocol Tuneable {
    func tune()
}

class Keyboard: Instrument, Tuneable {
    func tune() {
        print("\(brand) keyboard tuning.")
    }
}

// Use where to constrain Array to conform to Tuneable as long as Element does.
extension Array: Tuneable where Element: Tuneable {
    internal func tune() {
        forEach { $0.tune() }
    }
}

let instrument = Instrument()
let keyboard = Keyboard.init(brand: "Roland")
let instruments = [instrument, keyboard]

// Check if instruments implements Tuneable and tune it if the test succeeds. In this example, the array can't be cast to Tuneable because the Instrument type isn't tuneable. If you created an array of two keyboards, the test would pass and the keyboards would be tuned.
if let keyboards = instruments as? Tuneable {
    keyboards.tune()
} else {
    print("Can't tune instrument.")
}

// MARK: - 6.3. Hashable conditional conformance improvements in the standard library

// Optionals, arrays, dictionaries and ranges are Hashable in Swift 4.2 when their elements are Hashable as well:
// You add cMajor and aMinor to chords and versions. This wasn’t possible prior to 4.1 because String?, [String], [String: [String]?] and CountableClosedRange<Int> weren’t Hashable.
struct Chord: Hashable {
    let name: String
    let description: String?
    let notes: [String]
    let signature: [String: [String]?]
    let frequency: CountableClosedRange<Int>
}
let cMajor = Chord(name: "C", description: "C major", notes: ["C", "E",  "G"],
                   signature: ["sharp": nil,  "flat": nil], frequency: 432...446)
let aMinor = Chord(name: "Am", description: "A minor", notes: ["A", "C", "E"],
                   signature: ["sharp": nil, "flat": nil], frequency: 440...446)
let chords: Set = [cMajor, aMinor]
let versions = [cMajor: "major", aMinor: "minor"]

// MARK: - 7. Hashable Improvements

class Country: Hashable {
    let name: String
    let capital: String
    
    init(name: String, capital: String) {
        self.name = name
        self.capital = capital
    }
    
    static func ==(lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name && lhs.capital == rhs.capital
    }
    
    // Replaced hashValue with hash(into:) in Country. The function uses combine() to feed the class properties into hasher
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(capital)
    }
}

// MARK: - 8. Removing Elements From Collections

var greetings = ["Hello", "Hi", "Goodbye", "Bye"]
greetings.removeAll { $0.count > 3 }
print(greetings)

// MARK: - 9. Toggling Boolean States

extension Bool {
    mutating func toggle() {
        self = !self
    }
}

var isOn = true
isOn.toggle()

// MARK: - 10. New Compiler Directives

//#warning("There are shorter implementations out there.")

let numbers = [1, 2, 3, 4, 5]
var sum = 0
for number in numbers {
    sum += number
}
print(sum)

//#error("Please fill in your credentials.")

let username = "Henry"
let password = "88888"
switch (username.filter { $0 != " " }, password.filter { $0 != " " }) {
case ("", ""):
    print("Invalid username and password.")
case ("", _):
    print("Invalid username.")
case (_, ""):
    print("Invalid password.")
case (_, _):
    print("Logged in succesfully.")
}

// MARK: - 11. New Pointer Functions

// You had to create a copy of value to make both functions work. Swift 4.2 overloads these functions for constants
let value = 10
withUnsafeBytes(of: value) { pointer in print(pointer.count) }
withUnsafePointer(to: value) { pointer in print(pointer.hashValue) }

// MARK: - 12. Memory Layout Updates

struct Point {
    var x, y: Double
}

struct Circle {
    var center: Point
    var radius: Double
    
    var circumference: Double {
        return 2 * .pi * radius
    }
    
    var area: Double {
        return .pi * radius * radius
    }
}

// Use key paths to get the offsets of the circle’s stored properties.
if let xOffset = MemoryLayout.offset(of: \Circle.center.x),
    let yOffset = MemoryLayout.offset(of: \Circle.center.y),
    let radiusOffset = MemoryLayout.offset(of: \Circle.radius) {
    print("\(xOffset) \(yOffset) \(radiusOffset)")
} else {
    print("Nil offset values.")
}

// Return nil for the offsets of the circle’s computed properties since they aren’t stored inline.
if let circumferenceOffset = MemoryLayout.offset(of: \Circle.circumference),
    let areaOffset = MemoryLayout.offset(of: \Circle.area) {
    print("\(circumferenceOffset) \(areaOffset)")
} else {
    print("Nil offset values.")
}

// MARK: - 13. Inline Functions in Modules

let standard = CustomFactorial()
print(standard.factorial(5))
let custom = CustomFactorial.init(true)
print(custom.factorial(5))
