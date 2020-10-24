class User
    attr_accessor :name, :favorite
    @@all = []

    def initialize(name)
        @name = name
        @@all << self
        @favorite = []
    end

    def self.all
        @@all
    end

    def self.find_or_create_by_name(name)
        found_user = self.all.find { |user| user.name == name}
        if found_user 
            return found_user
        else
            puts ""
            puts "     Huh, I wasn't able to find a previous drinking buddy under that name.".light_blue
            puts "     That's ok, we can just create a new one!".light_blue
            return self.new(name)
        end
    end

    def add_to_favorite(name)
        found_drink = self.favorite.find { |drink| drink == name}
        if found_drink
            puts "      This drink is already in your favorites.".light_blue
            puts ""
        else
            self.favorite << name
            puts "      This drink has been added!".light_blue
            puts ""
        end
    end
end