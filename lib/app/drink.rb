class Drink

    attr_accessor :name, :url, :ingredient_hash, :instructions, :ingredient

    @@all = []

    def initialize(name, url, ingredient_hash, instructions)
        @name = name
        @url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=" + url
        @ingredient_hash = ingredient_hash
        @instructions = instructions
        @@all << self
    end

    def self.all
        @@all
    end

    def self.drink_list
        self.all.map {|drink|  drink.name}.sort
    
    end

    def self.drink_list_by_ingredient(ingredient)
        new_list = self.all.select {|drink| drink.ingredient_hash.include?(ingredient) }
        new_list.map { |drink| drink.name}
        
    end

    def make_drink(name)
        puts "We're going to make a #{name}!"
        sleep (1)
        puts "Let's get some ingredients together."
        puts "You are going to need: "
        

        
end