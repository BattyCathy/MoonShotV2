//
//  01. Loading a Specific Kind of Codable Data.swift
//  MoonShotV2
//
//  Created by Austin Roach on 3/2/21.
//

import Foundation

//MARK: 01. Loading a specific kind of Codable data

//In this app we're going to load two different kinds of JSON into Swift structs:  one for astronauts, and one for missions. Making this hapen in a way that is easy to maintain and doesn't clutter our code takes some thinking, but we'll work towards it step by step.

//First, drag in the two JSON files for this project. These are availabe in the GitHut repository for this book, under "project8-files" - look for astronauts.json and missions.json, then drag them into your project navigator. While we're adding assets, you should also copy all the images into your asset catalog - these are in the "Images" subfolder. These images of astrnauts and mission badges were all created by NASA, so under Title 17, Chapter 1, Section 105 of the US Code they are available for us to use under the public domain license.

//If you look in astronauts.json, you'll see each astronaut is defined by three fields: an ID ("griddom", "white", "chaffee", ets) their name ("Virgil I. "Gus" Grissom", etc), and a short descrition that has been copied from Wikipedia. If you intend to use the text in your own shipping projects, it's important you give credit to Wikipedia and its authors and make it clear that the work is licensed under CC-BY-SA avaible from here: http://creativecommons.org/licenses/by-sa/3.0

//Let's convert that astronaut data into a Swift struct now - press Cmd+N to make a new file, choose Swift file, then name it Astronaut.swift. Give it this code:

/*
 struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
 }
 */

//As you can see, I;ve made that conform to Codable so we can create instance of this struct straight from JSON, but also Identifiable so we can use arrays of astronautsinside ForEach and more - that id field will do just fine.

//Next we want to convert astronauts.json into an array of Astonaut instance, which menas we need to use Bundle to find the path of the file, load that into an instance of Data, and pass it through a JSONDecoder. Previously we put this inot a method on ContentView, but here I'd like to show you a better way: we're gonig to write an extension on Bundle to do it all in one centralized place.

//Create another Swift file, this time called Bundle-Decodable.swift. This will mostly use code you've seen before, but there's one small difference: previously we used String(contentsOf:). It works in just the same way as String(contentsOf:): give it a file URL to load, and it either returns its contents or throws an error.

//Add this to Bundle-Decodable.swift now:

/*
 extension Bundle {
    func decode(_ file: String) -> [Astronaut] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
 
        let decoder = JSONDecoder()
 
        guard let loaded = try? decoder.decode([Astronaut].self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
 
        return loaded
    }
 }
 
        
 */

//As you can see, that makes liberal use of fatalError(): if the file can't be found, loaded, or decoded the app will creash. As before, though, this will never actually happen unless you've made a mistake, for example if you forgot to copy th JSON file into your project.

//Now, you might wonder why we used an extension here rather than a method, but the reason i s about to become clear as we load that JSON into our content view. Add this property to the ContentView struct now:

//let astronauts = Bundle.main.decode("astronauts.json")

//Yes, that's all it takes. Sure, all we've done is just moved code out of ContentView and into an extension, but there's nothing wrong with that - anything we can do to help our views stay small and focused is a good thing.

//If you want to double check that your JSON is loaded correctly, modify the default text view to this:

//Text("\(astronauts.count)")

//That should display 32 rather than "Hello World".
