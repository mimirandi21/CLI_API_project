require 'colorize'

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

    def self.find_or_create_by_name(name, url, ingredient_hash, instructions)
        found_drink = self.all.find { |drink| drink.name == name}
        if found_drink 
            return found_drink
        else
            return self.new(name, url, ingredient_hash, instructions)
        end
    end

    def self.drink_list_by_ingredient(ingredient)
        new_list = self.all.select {|drink| drink.ingredient_hash.include?(ingredient) }
        new_list.map { |drink| drink.name}
        
    end

    def self.drink_ingredient_by_name(name)
        new_list = ""
        new_list = self.all.select {|drink| drink.name == name}
        new_list.map { |info| info.ingredient_hash.map{ |x, y|  "   #{y} #{x}" unless x == nil}.join("\n")}.join
        
    end

    def self.drink_instructions_by_name(name)
        
        new_list = self.all.select {|drink| drink.name == name}
        new_list.map {|info| return info.instructions.to_s}

    end

      
end