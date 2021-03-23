//
//  Learn-Swift.swift
//  SwiftProject
//
//  Created by hjn on 2021/3/5.
//

import Foundation

func learnSwift() {

    // MARK: - Array
    _ = Array<Int>()
    _ = [Int]()
    _ = [1,2,3,4,5,6]
    
    //✅ 正确
    _ = ["Red", "Green"] + ["Blue"]
    
    // MARK: - Dictinonary
    //❌ 错误 Dictionary<String : String>()
    //✅ 正确 Dictionary<String, String>()
    _ = Dictionary<String,String>()
    _ = [String: String]()
    let planets = [1: "Mercury", 2: "Venus"]
    _ = planets[3] // nil
    let venus = planets[3, default: "Planet X"] //Planet X
    print(venus)
    
    // MARK: - set
    //❌ 错误 Set[String]()
    //✅ 正确 Set<String>()
    _ = Set([1,2,3,4,2,1])
    var friends = Set<String>()
    friends.insert("a")
 
    // tuple
    _ = (1,2,3,2,3,1)
    
    
    
    _ = 70...100
    
    let numberOfCats = 1
    switch numberOfCats {
    case 0:
        print("You have no cats")
    case 1...3:
        print("You have some cats")
    case 4..<10:
        print("You have many cats!")
    //❌ 缺乏default会报错 错误：Switch must be exhaustive
    default:
        print("")
    }
    
    // MARK: - loop
    outer: for i in 1...10 {
        for j in 1...10 {
            let product = i * j
            print("Product is \(product)")
            //直接跳出双层循环
            break outer
        }
    }
    
    // MARK: - throw
    enum PizzaErrors: Error {
        case hasPineapple
    }
    // throw 抛出错误，函数声明参数末尾(返回类型之前)加上 throws 关键字
    func makePizza(type: String) throws -> String {
        if type != "Hawaiian" {
            return "Your pizza will be ready in 10 minutes."
        } else {
            throw PizzaErrors.hasPineapple
        }
    }
    
    enum ChargeError {
        case noCable
        case noPower
    }
    func chargePhone(atHome: Bool) throws {
        if atHome {
            print("Phone is charging...")
        } else {
            //❌ 错误 'ChargeError' does not conform to 'Error'
            //throw ChargeError.noPower
        }
    }
    
    
    // MARK: - closures
    // 闭包只能用 var/let 声明
    //❌ 错误 func castVote =
    var castVote = {
        print("I voted!")
    }
    castVote()
    
    let eat = {
        print("I eated!")
    }
    eat()
    
    var cleanRoom = { (name: String) in
        print("I'm cleaning the \(name).")
    }
    cleanRoom("kitchen")
    
    //❌ 错误Closure cannot have keyword arguments
    //var cutGrass = { (length currentLength: Double) in
    var cutGrass = { (currentLength: Double) in
        switch currentLength {
        case 0...1:
            print("That's too short")
        case 1...3:
            print("It's already the right length")
        default:
            print("That's perfect.")
        }
    }
    cutGrass(100)
    
    var flyDrone = { (hasPermit: Bool) -> Bool in
        if hasPermit {
            print("Let's find somewhere safe!")
            return true
        }
        print("That's against the law.")
        return false
    }
    
    let awesomeTalk = {
        print("Here's a great talk!")
    }
    func deliverTalk(name: String, type: () -> Void) {
        print("My talk is called \(name)")
        type()
    }
    deliverTalk(name: "My Awesome Talk", type: awesomeTalk)
    
    
    func tendGarden(activities: () -> Void) {
        print("I love gardening")
        activities()
    }
    tendGarden {
        print("Let's grow some roses!")
    }
    
    //❌ 错误 the steps parameter is defined as an empty tuple, not a closure.
    /*
    func brewTea(steps: ()) {
        print("Get tea")
        print("Get milk")
        print("Get sugar")
        steps()
    }
    brewTea {
        print("Brew tea in teapot.")
        print("Add milk to cup")
        print("Pour tea into cup")
        print("Add sugar to taste.")
    }*/
    
    //❌ 错误 The getMeasurement() function accepts a closure, but the closure's parameter is not placed inside parentheses.
    //c func getMeasurement(handler: Double -> Void) {
    //✅ 正确 func getMeasurement(handler: (Double) -> Void) {
    /*func getMeasurement(handler: Double -> Void) {
        let measurement = 32.2
        handler(measurement)
    }
    getMeasurement { (measurement: Double) in
        print("It measures \(measurement).")
    }*/
     
    func processPrimes(using closure: (Int) -> Void) {
        let primes = [2, 3, 5, 7, 11, 13, 17, 19]
        for prime in primes {
            closure(prime)
        }
    }
    //
    //❌ 错误 processPrimes { (prime: Int)  少了一个 in 关键字
    processPrimes { (prime: Int) in
        print("\(prime) is a prime number.")
        let square = prime * prime
        print("\(prime) squared is \(square)")
    }
    
    func encrypt(password: String, using algorithm: (String) -> String) {
        print("Encrypting password...")
        let result = algorithm(password)
        print("The result is \(result)")
    }
    encrypt(password: "t4ylor") { (password: String) in
        print("Using top secret encryption!")
        return "SECRET" + password + "SECRET"
    }
    
    //❌ 错误 Missing return in a closure expected to return 'String'
    /*
    func scoreToGrade(score: Int, gradeMapping: (Int) -> String) {
        print("Your score was \(score)%.")
        let result = gradeMapping(score)
        print("That's a \(result).")
    }
    scoreToGrade(score: 80) { (grade: Int) in
        if grade < 85 {
            return "Fail"
        }
    }*/
    
    func createValidator() -> (String) -> Bool {
        return {
            if $0 == "twostraws" {
                return true
            } else {
                return false
            }
        }
    }
    let validator = createValidator()
    print(validator("twostraws"))
    
    func makeRecorder(media: String) -> () -> String {
        switch media {
        case "podcast":
            return {
                return "I'm recording a podcast"
            }
        default:
            return {
                return "I'm recording a video"
            }
        }
    }
    let recorder = makeRecorder(media: "podcast")
    print(recorder())
    
    //❌ 错误  Single argument function types require parentheses
    /*
    func makeGame() -> Int -> Void {
        return {
            if $0 <= 5 {
                print("Let's play five-a-side football.")
            } else {
                print("Let's play regular football.")
            }
        }
    }
    let game = makeGame()
    game(5)
     */
    
    //❌ 错误   mealProducer() says it will return a closure that accepts an integer and returns a string, but it returns a closure that accepts a string and returns nothing.
    /*
    func mealProducer() -> (Int) -> String {
        return {
            print("I'll make dinner for \($0) people.")
        }
    }
    let makeDinner = mealProducer()
    print(makeDinner(5))
     */
    
    //❌ 错误  $1 is a Double, but this code attempts to compare it against tallestHeight, which is an Int.
    /*
    func findTallest() -> (String, Double) -> (String) {
        var tallestName = ""
        var tallestHeight = 0
        return {
            if $1 > tallestHeight {
                tallestName = $0
                tallestHeight = $1
            }
            return tallestName
        }
    }
    let tallest = findTallest()
    var tallestName = tallest("Hannah", 1.72)
    tallestName = tallest("Christina", 1.68)
   */
     
    func visitPlaces() -> (String) -> Void {
        var places = [String: Int]()
        return {
            places[$0, default: 0] += 1
            let timesVisited = places[$0, default: 0]
            print("Number of times I've visited \($0): \(timesVisited).")
        }
    }
    let visit = visitPlaces()
    visit("London")
    visit("New York")
    visit("London")
    
    
    
    
    
    
    // MARK:- Computed Properties
    //❌ 错误 Computed properties must always have an explicit type.
    /*
    struct Code {
        var language: String
        var containsErrors = false
        var report {
            if containsErrors {
                return "This \(language) code has bugs!"
            } else {
                return "This looks good to me."
            }
        }
    }
     */
    
    //❌ 错误 Constants cannot be computed properties.
    /*
    struct Candle {
        var burnLength: Int
        var alreadyBurned = 0
        let burnRemaining: Int {
            return burnLength - alreadyBurned
        }
    }*/
    
    //❌ 错误 You can't attach a property observer to a constant, because it will never change.
    /*
    struct FootballMatch {
        let homeTeamScore: Int {
            didSet {
                print("Yay - we scored!")
            }
        }
        let awayTeamScore: Int {
            didSet {
                print("Boo - they scored!")
            }
        }
    }
     */
    
    //❌ 错误 This attempts to add stored properties to an enum, which isn't possible.
    /*
    enum Student {
        var name: String
        var debt: Int {
            didSet {
                if debt < 5_000 {
                    print("This is great!")
                } else if debt < 20_000 {
                    print("This is OK.")
                } else {
                    print("Can I fake my own death?")
                }
            }
        }
    }
     */
    
    // MARK: - mutating
    //The staple() method modifies a struct's property without being marked mutating.
    /*
    struct Stapler {
        var stapleCount: Int
        func staple() {
            if stapleCount > 0 {
                stapleCount -= 1
                print("It's stapled!")
            } else {
                print("Please refill me.")
            }
        }
    }
    */
    
    
    //MARK - Struct Initializers
    // 如果结构体的属性没有初始化值 会默认实现一个所有属性的初始化方法
    // 如果自定义实现一个初始化方法，则要把所有未初始化值得属性作为参数,或者在初始化方法内 初始属性的值
    // 需要注意的是 如果有一个属性 声明为 private， 则不能使用默认的初始化方法 ，必须自己自定义实现
    //✅ 正确
    struct Book1 {
        var title: String
        var author: String = ""
        init(bookTitle: String) {
            title = bookTitle
        }
    }
    _ = Book1(bookTitle: "Beowulf")
    
    //❌ 错误 Return from initializer without initializing all stored properties
    /*
    struct Book2 {
        var title: String
        var author: String
        init(bookTitle: String) {
            title = bookTitle
        }
    }
    let book2 = Book2(bookTitle: "Beowulf")
     */
    struct Book3 {
        var title: String
        var author: String
        var publisher: String
    }
    _ = Book3(title: "Flowers", author: "hjn", publisher: "Oneone")
    
    struct Book4 {
        var title: String
        var author: String = "hjn"
        var publisher: String
    }
    _ = Book4(title: "Flowers", publisher: "Oneone")
    
    
    struct Country {
        var name: String
        var usesImperialMeasurements: Bool
        init(countryName: String) {
            name = countryName
            let imperialCountries = ["Liberia", "Myanmar", "USA"]
            if imperialCountries.contains(name) {
                usesImperialMeasurements = true
            } else {
                usesImperialMeasurements = false
            }
        }
    }
    
    struct Message {
        var from: String
        var to: String
        var content: String
        init() {
            from = "Unknown"
            to = "Unknown"
            content = "Yo"
        }
    }
    _ = Message()
    
    struct Cabinet {
        var height: Double
        var width: Double
        var area: Double
        init (itemHeight: Double, itemWidth: Double) {
            height = itemHeight
            width = itemWidth
            area = height * width
        }
    }
    _ = Cabinet(itemHeight: 1.4, itemWidth: 1.0)
    
    
    // MARK: - Access control
    
    //❌ 错误  This has a private property, so Swift is unable to generate its memberwise initializer for us.
    // 'FacebookUser' initializer is inaccessible due to 'private' protection level
    struct FacebookUser {
        private var privatePosts: [String]
        public var publicPosts: [String]
    }
    //❌ 错误  Missing arguments for parameters 'privatePosts', 'publicPosts' in call
    //let user = FacebookUser()
    
    
    struct Doctor {
        var name: String
        var location: String
        
        // 有一个属性为private 权限， 则不能使用默认的初始化方法
        private var currentPatient = "No one"
        
        // 自己实现一个初始化方法
        // ❌ 错误 屏蔽此方法 则会报错 initializer is inaccessible due to 'private' protection level
        init(name: String, location: String) {
            self.name = name
            self.location = location
        }
    }
    _ = Doctor(name: "Esther Jones", location: "Bristol")
    
    struct School {
        var staffNames: [String]
        private var studentNames: [String]
        init(staff: String...) {
            self.staffNames = staff
            self.studentNames = [String]()
        }
    }
    _ = School(staff: "Mrs Hughes")
    
    
    // MARK: - Class

    class Image {
        var filename: String
        var isAnimated: Bool
        init(filename: String, isAnimated: Bool) {
            
            // ❌ 错误   the parameters and properties have the same names,
            // Swift requires that we use self. to distinguish the properties.
            //filename = filename
            //isAnimated = isAnimated
            
            //✅ 正确
            self.filename = filename
            self.isAnimated = isAnimated
        }
    }
    
    
    // MARK: - Class inheritance
    
    // This code demonstrates valid calss inheritance
    class Handbag {
        var price: Int
        init(price: Int) {
            self.price = price
        }
    }
    
    class DesignerHandbag: Handbag {
        var brand: String
        init(brand: String, price: Int) {
            self.brand = brand
            super.init(price: price)
        }
    }
    
    
    // MAEK: -  Deinitializers
    
    
    // ❌ 错误 Structs may not have deinitializers.
    /*
    struct Fairytale {
        deinit {
            print("And they lived happily ever after.")
        }
    }
    */
    
    
    //❌ 错误  This attempts to call a mutating method on a constant struct instance.
    /*
    struct Kindergarten {
        var numberOfScreamingKids = 30
        mutating func handOutIceCream() {
            numberOfScreamingKids = 0
        }
    }
    let kindergarten = Kindergarten()
    kindergarten.handOutIceCream()
     */
    

    
    // MARK: - Unwrapping optionals
    let song: String? = "Shake it Off"
    if let unwrappedSong = song {
        print("The name has \(unwrappedSong.count) letters.")
    }
    
    //❌ 错误Cannot convert value of type 'String' to expected argument type 'Int'
    /*
    let userID: Int? = 556
    let id = userID ?? "Unknown"
     */
    
    let distanceRan: Double? = 0.5
    let distance: Double = distanceRan ?? 0
    
    let songs: [String]? = [String]()
    let finalSong = songs?.last?.uppercased()
    
    let capitals = ["Scotland": "Edinburgh", "Wales": "Cardiff"]
    let scottishCapital = capitals["Scotland"]?.uppercased()
    
    var hasForcePowers = "true"
    let convertedHasForcePowers = Bool(hasForcePowers) // true
    
    var enabled = "False"
    let convertedEnabled = Bool(enabled) // false
    
    
    class Camel {
        var humps: Int
        init?(humpCount: Int) {
            guard humpCount <= 2 else { return nil }
            humps = humpCount
        }
    }
    let horse = Camel(humpCount: 0) // Camel?  not Camel
    
    
    // MARK: - Typecasting

    
}




// MARK: - Protocols
protocol Mailable {
    var width: Double { get set }
    var height: Double { get set }
}

// ❌ 错误  It's not possible to create set-only properties in Swift.
/*
protocol Buildable {
    
    var numberOfBricks: Int { set }
    var materials: [String] { set }
}
 */

// MARK: - Protocol inheritance
protocol MakesDiagnoses {
    func evaluate(patient: String) -> String
}
protocol PrescribesMedicine {
    func prescribe(drug: String)
}
protocol Doctor: MakesDiagnoses, PrescribesMedicine { }

// MARK: - Extensions
// ❌ 错误 The append() method must be marked mutating.
/*
extension String {
    func append(_ other: String) {
        self += other
    }
}
*/

// MARK: - Protocol Extensions
protocol Politician {
    var isDirty: Bool { get set }
    func takeBribe()
}
extension Politician {
    func takeBribe() {
        if isDirty {
            print("Thank you very much!")
        } else {
            print("Someone call the police!")
        }
    }
}

protocol HasAge {
    var age: Int { get set }
    mutating func celebrateBirthday()
}

protocol CanFly {
    var maximumFlightSpeed: Int { get set }
}
protocol CanDrive {
    var maximumDrivingSpeed: Int { get set }
}

struct FlyingCar: CanFly, CanDrive {
    
    // 必须声明以下两个属性
    // 否则报错
    // ❌ 错误 The FlyingCar struct does not conform to the two protocols it says it does because it doesn't have the required properties.
    var maximumFlightSpeed: Int
    var maximumDrivingSpeed: Int
}

// ❌ 错误 All three properties here must have { get } or { get set } after them.
/*
protocol HasPages {
    var pageCount: Int
}
protocol HasTableOfContents {
    var titles: [String]
}
protocol Book: HasPages, HasTableOfContents {
    var author: String
}
*/
