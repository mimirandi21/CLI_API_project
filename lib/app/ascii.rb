class ASCII

    def initialize
    end
    
    def self.logo
        puts ""
        puts Rainbow("      ........................................................................................    ").color(:white).bg(:indigo)
        puts Rainbow("      .#####....####...##..##..#####...######....##.....####...........#####....####...#####..    ").color(:white).bg(:indigo)
        puts Rainbow("      .##..##..##..##..###.##..##..##....##......##....##..............##..##..##..##..##..##.    ").color(:white).bg(:indigo)
        puts Rainbow("      .#####...######..##.###..##..##....##.......#.....####...........#####...######..#####..    ").color(:white).bg(:indigo)
        puts Rainbow("      .##..##..##..##..##..##..##..##....##................##..........##..##..##..##..##..##.    ").color(:white).bg(:indigo)
        puts Rainbow("      .##..##..##..##..##..##..#####...######...........####...........#####...##..##..##..##.    ").color(:white).bg(:indigo)
        puts Rainbow("      ........................................................................................    ").color(:white).bg(:indigo)

                      
        
    end

    def self.small_glass
        puts ""
        puts Rainbow("        o").teal
        puts "       o"
        puts Rainbow("      o  o").deeppink
        puts "       o o o"
        puts "      \\~~~~~/"
        puts "       \\   /"
        puts "        \\ /"
        puts "         V "
        puts "         |".blue
        puts "         |".blue
        puts "        ---"
        puts ""
        puts ""
    end

end