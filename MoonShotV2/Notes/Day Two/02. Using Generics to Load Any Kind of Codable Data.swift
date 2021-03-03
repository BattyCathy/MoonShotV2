//
//  02. Using Generics to Load Any Kind of Codable Data.swift
//  MoonShotV2
//
//  Created by Austin Roach on 3/2/21.
//

import Foundation

//MARK: 02. Using Generics to Load Any Kind of Codable Data

//We've added a Bundle extension for loading one specific type of JSON data from our app bundle, but now we have a second type: missions.json. This contains slightly more complex JSON:

//--Every mission has an ID number, which means we can use Identifiable easily

//--Every mission has a description, which is a free tet string taken from Wikipedia (see above for the license!)

//--Every mission has an array of crew, where each crew member has a name and role.

//--All but one missons has a launch date. Sadly, Apollo 1 never launched because a launch rehearsal cabin fire destroyed the command module and killed the crew.

//Let's start converting that to code. Crew roles need to be represented as their own struct, storing the name string and role string. So, create a new Swift file called Mission.swift and give it this code:

/*
 struct CrewRole: Codable {
    let name: String
    let role: String
 }
 */

//As for the missions this will be an ID iteger, an array of CrewRole, and a description string. But what about the launch date - we might have one, but we also might now have one. What should that be?

//Well, think about it: how does Swift represent this "maybe, maybe not" elsewhere? How would we store "might be a string, might be nothing at all"? I hope the answer is clear: we use optionals. In fact, if we mark a rpopert as optional Codable will automatically skip over it if the value is missing from our input JSON.

//So, add this second struct to Mission.swift now:

/*
 struct Mission: Codable, Identifiable {
    let id: Int
    let launchDate: String?
    let crew: [CrewRole]
    let description: String
 }
 */

//Before we look at how to load JSON into that, I want to demonstrate one more thing: our CrewRole struct was made specifically to hold data about missions, and as a result we can actaully put the CrewRole struc inside the Mission struct like this:

/*
 struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
 
    let id: Int
    let launchDate: String?
    let crew: [CrewRole]
    let description: String
 }
 */

//This is called a nested struct, and is simple one struct placed inside of another. This won't affect our code in this project, but elsewhere it's useful to help keep your code organized: rather than saying CrewRole you'd write Mission.CrewRole. If you can image a project with several hundred custom types, adding this extra context can really help!

//Now let's think about how we can load missions.json into an array of Mission structs. We already added a bundle extension that loads some JSON file into an array of Astronaut structs, so we could very easliy copy and paste that, then tweat it so it loads missions rather than astronauts. However, there's a better solution: we can leverage Swift's generics system, which is an advance feature we touched on lightly back in project 3.

//Generics allow us to write code that is capable of working with a variety of differnt types. In this project, we wrote the Bundle extension to work with arrays of astronauts, but we really want to be able to handle arrays of astronauts, arrays of missions, or potentially lots of other things.

//To make a method generic, we give it a placeholder for certain types. This is written in angle brackets (< and >) after the method name but before its parameters, like this:

//func decode<T>(_file: String) -> [Astronaut] {

//We can use anything for that placeholder - we could have written "Type", TypeOfThing", or even "Fish"; it doesn't matter. "T" is a bit of a convention in coding as a short-hand placeholder for "Type".

//Iside the method we can now use "T" everywhere we would use [Astronaut] - it is literally a placeholder for the type we want to work with. So, rather than returning [Astronaut] we would use this:

//func decode<T>(_ file: String) _> T {

//Be very careful: There is a big difference between T and [T]. Remember T is a placeholder for whatever type we ask for, so if we say "decode an array of astronauts" then T becomes [Astronaut]. If we attempt to return [T] from decode() then we would actually be returning [[Astronaut]] - an array of arrays of astronauts.

//Towards the end of the decode() method there's another place where [Astronaut] is used:

//guard let loaded = try? decoder.decode([Astronaut].self, from: data) else {

//Again, please chage that to T, like this:

//guard let loaded = try? decoder.deocde(T.self, from: data) else{

//So what we've said is that decode() will be used with some sort of type, such as [Astronaut], and it should attempt to decode the file it has loaded to be that type.

//If you try compiling this code, you'll see an error in Xcode: "Instance method 'decode(_:from:)' requires that 'T' conform to 'Decodable'". What it means is that T could be anything: it could be an array of astronauts, or it could be an array of something else entirely. The problem is that Swift can't be sure the type we're working with conforms to the Codable protocol, so rather than take a risk it's refusing to build our code.

//Fortunately we can fix this with a constraint: we can tell Swift that T can be whatever we want, as long as that thing conforms to Codable. That way Swift knows it's safe to use, and will make sure we don't try to use the method with a type that doen't conform to Codable.

//To add the constraint, change the method signature to this:

//func decode<T: Codable>(_ file: String) -> T {

//If you try compiling again, you'll see that things still aren't working, but now it's for a different reason: "Generic parameter 'T' could not be inferred", over in the astronauts property of ContentView. This line worked fine before, but there had been an important change now: before decode() would always return an array of astronauts, but now it returns anything we want as long as it conforms to Codable.

//We know it will still return an array of astronauts because the actual underlying data hans't changed, but Swift doesn't know that. Our problem is that decode() can return any type that conforms to Codable,but Swift needs more information - it wants to know extactly what type it will be:

//let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")

//Finally - after all that work! - we can now also load mission.json into another property in ContentView. Please add this below astronauts:

//let missions: [Mission] = Bundle.main.decode("missions.json")

//And that is the power of generics: we can use the same decode() method to load any JSON from our bundle into any Swift type that conforms to Codable - we don't need a half dozen variants of the same method.

//Before we're done, there's one last thing I'd like to explain. Ealier you say the message "Instance method 'decode(_:from:)' requires that 'T' conform to 'Decodable'", and you might have wondered what Decodable was - after all, we've been using Cadable everywhere. Well, behind the scenes, Codable is just an alias for two separate protocols: Encodable and Decodable. You can use Codable if you want, or you can use Encodable and Decodable if you prefer being specific. It's down to you.
