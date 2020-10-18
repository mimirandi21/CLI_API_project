class API
    ingredients_list = []

    def initial_fetch
        parsed_url = URI.parse("https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list")
        response = Net::HTTP.get_response(parsed_url)
        ingredients = JSON.parse(response.body)
    
        ingredients["drinks"].each do |ingredient|
            # ingredients_list << ingredient["strIngredient1"].gsub(" ", "_")
            Ingredient.new(ingredient["strIngredient1"])
        end
    end
        
    def  drink_by_ingredient_fetch
    ingredient_url
    end
    
    # parsed_char_url = URI.parse(url)
    # url_response = Net::HTTP.get_response(parsed_char_url)
    # char_hash = JSON.parse(url_response.body)
    # planet_url = char_hash["result"]["properties"]["homeworld"]

    # parsed_homeworld_url = URI.parse(planet_url)
    # planet_url_response = Net::HTTP.get_response(parsed_homeworld_url)
    # planet_hash = JSON.parse(planet_url_response.body)
    # planet_name = planet_hash["result"]["properties"]["name"]

    # planet = Planet.find_or_create_by_name(planet_name)
    # character = Character.new(name, planet)
    # end

end
