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
        CLI.ingredient_choice
        CLI.drink_choice
        sleep (15)
        y_or_n_prompt = TTY::Prompt.new
        y_or_n_prompt.select("Would you like to make another drink?") do |menu|
            menu.choice "Hells yeah", 1
            menu.choice "Maybe later", 2
        
            if menu.choice == 1
                CLI.ingredient_choice
            else
                puts "Thank you for drinking with me today."
                puts "Have a great night and drive safe!"
                puts "************************************************"
                begin
                    exit
                end
            end
        end
            
        
    end

    def self.ingredient_choice
        #asks user to pick which ingredient they want to use using ingredient list
        ingredient_prompt = TTY::Prompt.new
        $user_ingredient = ingredient_prompt.select("What ingredient do you want to use?", Ingredient.ingredient_list, filter: true)
        puts "You selected #{$user_ingredient}."
        puts "Let me search my recipe book..."
        API.new.drink_by_ingredient_fetch(Ingredient.find_url($user_ingredient))
                  
    end


    def self.drink_choice
        #asks user which drink they want to make based on ingredient choice using drink list by ingredient
        drink_prompt = TTY::Prompt.new
        $user_drink = drink_prompt.select("Which of these delicious drinks would you like to make?", Drink.drink_list_by_ingredient($user_ingredient), filter: true)
        puts "You selected #{$user_drink}."
        puts "Let me grab that recipe!"
        #returns drink information based on user drink choice
        Drink.make_drink($user_drink)     
       
    end
end
