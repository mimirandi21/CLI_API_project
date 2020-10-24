class API
    ingredients_list = []

    def initial_fetch
        parsed_url = URI.parse("https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list")
        response = Net::HTTP.get_response(parsed_url)
        ingredients = JSON.parse(response.body)
    
        ingredients["drinks"].each do |ingredient|
            # ingredients_list << ingredient["strIngredient1"].gsub(" ", "_")
            Ingredient.find_or_create_by_name(ingredient["strIngredient1"])
        end
    end
        
    def drink_by_ingredient_fetch(ingredient_url)
        by_ingredient_parsed_url = URI.parse(ingredient_url.gsub("ñ", "n"))
        by_ingredient_response = Net::HTTP.get_response(by_ingredient_parsed_url)
        drink_by_ingredient = JSON.parse(by_ingredient_response.body)

        drink_by_ingredient["drinks"].each do |drink|
            drink_url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=" + drink["idDrink"]      
            drink_parsed_url = URI.parse(drink_url)
            drink_info_response = Net::HTTP.get_response(drink_parsed_url)
            drink_info = JSON.parse(drink_info_response.body)

            drink_info["drinks"].each do |info|
                ingredient_hash = {}
                ingredient_hash[info["strIngredient1"]] = info["strMeasure1"] if info["strIngredient1"] != "null" || nil
                ingredient_hash[info["strIngredient2"]] = info["strMeasure2"] if info["strIngredient2"] != "null" || nil
                ingredient_hash[info["strIngredient3"]] = info["strMeasure3"] if info["strIngredient3"] != "null" || nil
                ingredient_hash[info["strIngredient4"]] = info["strMeasure4"] if info["strIngredient4"] != "null" || nil
                ingredient_hash[info["strIngredient5"]] = info["strMeasure5"] if info["strIngredient5"] != "null" || nil
                ingredient_hash[info["strIngredient6"]] = info["strMeasure6"] if info["strIngredient6"] != "null" || nil
                ingredient_hash[info["strIngredient7"]] = info["strMeasure7"] if info["strIngredient7"] != "null" || nil
                ingredient_hash[info["strIngredient8"]] = info["strMeasure8"] if info["strIngredient8"] != "null" || nil
                ingredient_hash[info["strIngredient9"]] = info["strMeasure9"] if info["strIngredient9"] != "null" || nil
                ingredient_hash[info["strIngredient10"]] = info["strMeasure10"] if info["strIngredient10"] != "null" || nil
                ingredient_hash[info["strIngredient11"]] = info["strMeasure11"] if info["strIngredient11"] != "null" || nil
                ingredient_hash[info["strIngredient12"]] = info["strMeasure12"] if info["strIngredient12"] != "null" || nil
                ingredient_hash[info["strIngredient13"]] = info["strMeasure13"] if info["strIngredient13"] != "null" || nil
                ingredient_hash[info["strIngredient14"]] = info["strMeasure14"] if info["strIngredient14"] != "null" || nil
                ingredient_hash[info["strIngredient15"]] = info["strMeasure15"] if info["strIngredient15"] != "null" || nil
                
                Drink.find_or_create_by_name(drink["strDrink"], ("https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=" + drink["idDrink"]), ingredient_hash, info["strInstructions"])
            end
        end
    end
    
    def search_by_drink_name(drink)
        name_url = "https://thecocktaildb.com/api/json/v1/1/search.php?s=" + drink
        name_parsed_url = URI.parse(name_url)
        name_info_response = Net::HTTP.get_response(name_parsed_url)
        name_info = JSON.parse(name_info_response.body)

        name_info["drinks"].each do |info|
        ingredient_hash = {}
        ingredient_hash[info["strIngredient1"]] = info["strMeasure1"] if info["strIngredient1"] != "null" || nil
        ingredient_hash[info["strIngredient2"]] = info["strMeasure2"] if info["strIngredient2"] != "null" || nil
        ingredient_hash[info["strIngredient3"]] = info["strMeasure3"] if info["strIngredient3"] != "null" || nil
        ingredient_hash[info["strIngredient4"]] = info["strMeasure4"] if info["strIngredient4"] != "null" || nil
        ingredient_hash[info["strIngredient5"]] = info["strMeasure5"] if info["strIngredient5"] != "null" || nil
        ingredient_hash[info["strIngredient6"]] = info["strMeasure6"] if info["strIngredient6"] != "null" || nil
        ingredient_hash[info["strIngredient7"]] = info["strMeasure7"] if info["strIngredient7"] != "null" || nil
        ingredient_hash[info["strIngredient8"]] = info["strMeasure8"] if info["strIngredient8"] != "null" || nil
        ingredient_hash[info["strIngredient9"]] = info["strMeasure9"] if info["strIngredient9"] != "null" || nil
        ingredient_hash[info["strIngredient10"]] = info["strMeasure10"] if info["strIngredient10"] != "null" || nil
        ingredient_hash[info["strIngredient11"]] = info["strMeasure11"] if info["strIngredient11"] != "null" || nil
        ingredient_hash[info["strIngredient12"]] = info["strMeasure12"] if info["strIngredient12"] != "null" || nil
        ingredient_hash[info["strIngredient13"]] = info["strMeasure13"] if info["strIngredient13"] != "null" || nil
        ingredient_hash[info["strIngredient14"]] = info["strMeasure14"] if info["strIngredient14"] != "null" || nil
        ingredient_hash[info["strIngredient15"]] = info["strMeasure15"] if info["strIngredient15"] != "null" || nil

        new_drink = Drink.find_or_create_by_name(info["strDrink"], ("https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=" + info["idDrink"]), ingredient_hash, info["strInstructions"])
        return new_drink    
        end
    end
end
