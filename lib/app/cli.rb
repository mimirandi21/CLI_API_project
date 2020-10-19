class CLI

    def run
        puts "Greetings, friends."
        puts "Let's get a drink in your hand!"
        sleep (1)
        puts "Searching the bar..."
        API.new.initial_fetch
        puts "Success!"
        sleep (1)
        puts "Let's take a look at what you can make."
        ingredient_prompt = TTY::Prompt.new
        user_ingredient = ingredient_prompt.select("What ingredient do you want to use?", Ingredient.ingredient_list, filter: true)
        puts "You selected #{user_ingredient}."
        puts "Let me search my recipe book..."
        API.new.drink_by_ingredient_fetch(Ingredient.find_or_create_by_name(user_ingredient))
        end
        drink_prompt = TTY::Prompt.new
        user_drink = drink_prompt.select("Which of these delicious drinks would you like to make?", Drink.drink_list_by_ingredient(user_ingredient), filter: true)
        puts "You selected #{user_drink}."
        puts "Let me grab that recipe!"
        
    
end
