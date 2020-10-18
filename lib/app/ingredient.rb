class Ingredient
    attr_accessor :name, :url

    @@all = []

    def initialize(name)
        @name = name
        @url = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=" + name.gsub(" ", "_")
        @@all << self
    end

    def self.all
        @@all
    end

    def self.ingredient_list
        list = []
        self.all.each { |ingredient|  list << self.name}
        list
    end



end