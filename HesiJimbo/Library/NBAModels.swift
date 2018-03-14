struct Team {
	let id: String
	let triCode: String
	let city: String
	let name: String
	
	private init(id: String, triCode: String, city: String, name: String) {
		self.id = id
		self.triCode = triCode
		self.city = city
		self.name = name
	}

	static let bucks = Team(id: "1610612749", triCode: "MIL", city: "Milwaukee", name: "Bucks")
	static let bulls = Team(id: "1610612741", triCode: "CHI", city: "Chicago", name: "Bulls")
	static let cavaliers = Team(id: "1610612739", triCode: "CLE", city: "Cleveland", name: "Cavaliers")
	static let celtics = Team(id: "1610612738", triCode: "BOS", city: "Boston", name: "Celtics")
	static let clippers = Team(id: "1610612746", triCode: "LAC", city: "Los Angeles", name: "Clippers")
	static let grizzlies = Team(id: "1610612763", triCode: "MEM", city: "Memphis", name: "Grizzlies")
	static let hawks = Team(id: "1610612737", triCode: "ATL", city: "Atlanta", name: "Hawks")
	static let heat = Team(id: "1610612748", triCode: "MIA", city: "Miami", name: "Heat")
	static let hornets = Team(id: "1610612766", triCode: "CHA", city: "Charlotte", name: "Hornets")
	static let jazz = Team(id: "1610612762", triCode: "UTA", city: "Utah", name: "Jazz")
	static let kings = Team(id: "1610612758", triCode: "SAC", city: "Sacramento", name: "Kings")
	static let knicks = Team(id: "1610612752", triCode: "NYK", city: "New York", name: "Knicks")
	static let lakers = Team(id: "1610612747", triCode: "LAL", city: "Los Angeles", name: "Lakers")
	static let magic = Team(id: "1610612753", triCode: "ORL", city: "Orlando", name: "Magic")
	static let mavericks = Team(id: "1610612742", triCode: "DAL", city: "Dallas", name: "Mavericks")
	static let nets = Team(id: "1610612751", triCode: "BKN", city: "Brooklyn", name: "Nets")
	static let nuggets = Team(id: "1610612743", triCode: "DEN", city: "Denver", name: "Nuggets")
	static let pacers = Team(id: "1610612754", triCode: "IND", city: "Indiana", name: "Pacers")
	static let pelicans = Team(id: "1610612740", triCode: "NOP", city: "New Orleans", name: "Pelicans")
	static let pistons = Team(id: "1610612765", triCode: "DET", city: "Detroit", name: "Pistons")
	static let raptors = Team(id: "1610612761", triCode: "TOR", city: "Toronto", name: "Raptors")
	static let rockets = Team(id: "1610612745", triCode: "HOU", city: "Houston", name: "Rockets")
	static let sixers = Team(id: "1610612755", triCode: "PHI", city: "Philadelphia", name: "76ers")
	static let spurs = Team(id: "1610612759", triCode: "SAS", city: "San Antonio", name: "Spurs")
	static let suns = Team(id: "1610612756", triCode: "PHX", city: "Phoenix", name: "Suns")
	static let thunder = Team(id: "1610612760", triCode: "OKC", city: "Oklahoma City", name: "Thunder")
	static let timberwolves = Team(id: "1610612750", triCode: "MIN", city: "Minnesota", name: "Timberwolves")
	static let trailBlazers = Team(id: "1610612757", triCode: "POR", city: "Portland", name: "Trail Blazers")
	static let warriors = Team(id: "1610612744", triCode: "GSW", city: "Golden State", name: "Warriors")
	static let wizards = Team(id: "1610612764", triCode: "WAS", city: "Washington", name: "Wizards")

  static let all = [bucks, bulls, cavaliers, celtics, clippers, grizzlies, hawks, heat, hornets, jazz, kings, knicks, lakers, magic, mavericks, nets, nuggets, pacers, pelicans, pistons, raptors, rockets, sixers, spurs, suns, thunder, timberwolves, trailBlazers, warriors, wizards]

	private static var teamsById: [String : Team] = {
		var map: [String : Team] = [:]
		all.forEach { map[$0.id] = $0 }

		return map
	}()

	static func by(id: String) -> Team? {
		return teamsById[id]
	}
}
