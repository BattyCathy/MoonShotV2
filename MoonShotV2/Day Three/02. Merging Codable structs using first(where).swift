//
//  03. Mergin Codable structs using first(where).swift
//  MoonShotV2
//
//  Created by Austin Roach on 3/3/21.
//

import Foundation

//MARK: Merging Codable structs using first(where:)

//Below our mission description we want to show the pictures, names, and roles of each crew member, which is easier said than done.

//The complexity here is that our JSON was provided in two parts: missions.json and astronauts.json. This eliminates duplication in our data, because some astronauts took part in multiple missions, but it also means we need to write some code to join our data together - to resolve "armstrong" to "Neil A. Armstrong", for example. You see, on one side we have missions that know crew member "armstrong" had the role "Commander", but has no idea who "armstrong" is, and on the other side we have "Neil A. Armstrong" and a description of him, but no concept that he was the commander of Apollo 11.

//So, what we need to do is make our MissionView accept the mission that got tapped, along with our full astronauts array, then have it figure out which astronauts actually took part in the launch. Because this merged data is only temporary we could use a tuple rather than a struct, but honestly there isn't realy much difference so we'll be using a new struct here.

//Add this nested struct inside MissionView now:

/*
 struct CrewMember {
    let role: String
    let astronaut: Astronaut
 }
 */

//Now for the tricky part: we need to add a property to MissionView that stores an array of CrewMember object - these are the fully resolved role / astronaut pairings. At first that's as simple as adding another property:

//let astronauts: [CrewMember]

//But then how do we set that property? Well, think about it: if we make this view be handed over all our astronauts, we can loop over the mission crew, then for each crew member loop over all our astronauts to find the one that has a matching ID. When we find one we can convert that and their role into a CrewMember object, but if we don't it means somehow we have a crew role with an invalid or unknown name.

//Swift gives us an array method called first(where:) that really helps this process along. We can give it a predicate (a fancy word for condition), and it will send back the first array element that matches the predicate, or nil if none do. In our case we can use that to say "give me the first astronaut with the ID of armstrong."

//Let's put that all into code, using a custom initializer for MissionView. Like I said, this will  accept the mission it represents along with all the astronauts, and its job is to store the mission away then figure out the array of resolved astronauts.

//Here's the code:

/*
 init(mission: Mission, astronauts: [Astronaut]) {
    self.mission = mission
 
    var matches = [CrewMember]()
 
    for member in mission.crew {
        if let match = astronauts.first(where: { $0.id == member.name }) {
            matches.append(CrewMember(role: member.role, astronaut: match))
        } else {
            fatalError("Missing \(member)")
        }
    }
 
    self.astronauts = matches
 */

//As soon as that code is in, our preview struct will stop working again because it needs more information. So, add a second call to decode() there so it loads all the astronauts, the passes those in too:

/*
 struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
 
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
    }
 }
 */

//Now that we have all our astronaut data, we can show this directly below the mission description using a ForEach. This is going to use the same HStack/VStack combination we used in ContentView, except now we need a spacer at the end of our HStack to push the views to the left - previously we got that for free before because we were in a List, but that isn't the case now. We're also going to add a little extra styling to the astronaut pictures to make them look better, using a capsule clip shape and overlay.

//Add this code before Spacer(minLength: 25) in MissionView:

/*
 ForEach(sel.astronauts, id: \.role) { crewMember in
    HStack {
        Image(crewMember.astronaut.id)
            .resizable()
            .frame(width: 83, height: 60)
            .clipShapte(Capsule())
            .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
 
        VStack(alightment: .leading) {
            Text(crewMember.astronaut.name)
                .font(.headline)
            Text(crewMember.role)
                .foregroundColor(.secondary)
        }
 
        Spacer()
    }
    .padding(.horizontal)
 }
 */

//You should see that loops good in the preview, but to see it live in the simulator we need to modify the NavigationLink in ContentView - it pushes to Text("Detail View") right now, but please replace it with this:

//NavigationLink(destination: MisionView(mission: mission, astronauts: self.astronauts)) {

//Now go ahead and run the app in the simulator - it's starting to become useful!

//Before you move on, try spending a few minutes customizing the way the astronauts are shown - I've used a capsule clip shape and overlay, but you could try circles or rounded rectangles, you could use different fonts or larger images, or even add some way of marking who the mission commander was. 
