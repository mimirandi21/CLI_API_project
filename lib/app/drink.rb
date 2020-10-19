class Drink

    attr_accessor :name, :url, :ingredient_hash, :instructions

    @@all = []

    def initialize(name, url, ingredient_hash, instructions)
        @name = name
        @url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=" + url
        @@all << self
    end

    def self.drink_list
        self.all.map {|drink|  drink.name}.sort
    
    end

    def self.drink_list_by_ingredient(ingredient)
        self.all.select {|drink| return ingredient_hash.include?(ingredient).name}
    end
        
end