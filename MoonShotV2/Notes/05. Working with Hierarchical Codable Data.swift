//
//  05. Working with Hierarchical Codable Data.swift
//  MoonShotV2
//
//  Created by Austin Roach on 3/2/21.
//

import Foundation

//MARK: 05. Working with Hierarchical Codable Data

//The Codable protocol makes it trivial to decode flat data: if you're decoding a single instance of a type, or an array or dictionary of those instances, then thing Just Work. However, in this project we're going to be decoding slightly more complex JSON: there will be an array inside another array, using different data types.

//If you want to decode this kind of hierarchical data, the key is to create separate types for each level you have. As long as the data matches the hierachry you've asked for, Codable is capable of decoding everything with no further work from us.

//To demostrate this, put this button in to you content view:

/*
 Button("Decode JSON") {
    let input = """
    {
        "name": "Taylor Swift",
        "address": {
            "street": "555, Taylor Swift Avenue",
            "city": "Nashville"
        }
    }
    """
 
    //more code to come
 
 }
 */

//That creates a string of JSON in code. In case you aren't too familiar with JSON, it's probably best to look at the Swift structs that match it - you can put these directly into the button action or outside of the ContentView structs, it doesn't matter:

/*
 struct User: Codable {
    var name: String
    var address: Address
 }
 
 struct Address: Codable {
    var street: String
    var city: String
 }
 */

//Hopefully you can now see what the JSON contains: a use has a name string and an address, and addresses are a street string and a city string.

//Now for the best part: we can convert our JSON string to the Data type (which is what Codable works with), then decode that into a User instance:

/*
 let data = Data(input.utf8)
 let decoder = JSONDecoder()
 if let user = try? decoder.decode(User.self, from: data) {
    print(user.address.street)
 }
 */

//If you run that program and tap the button you should see the address printed out - although just from the avoidance of doubt I should say that it's not her actual address!

//There's no limit to the number of levels Codable will go through - all that matters is that the structs you define match your JSON string.

//That brings us to the end of the overview for this project, so please go ahead and reset ContentView.swift to it's original state.

