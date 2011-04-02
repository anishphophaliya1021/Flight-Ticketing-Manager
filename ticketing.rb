class Flight
	def start(f)
	@filename = f
	@counter = 0
	@fl = ""
	while(1)
		puts "\n\n   ---------------------------------------------"
		puts "   |WELCOME TO THE FLIGHT RESERVATION SYSTEM|"
		puts "   ---------------------------------------------"
		puts "what would you like to do?"
		puts
		if (@fl == "")
			puts "1) would you like to book a seat?"
			puts "2) would you like to quit?"
		else
			puts "1) would you like to book a seat on the same flight?"
			puts "2) would you like to book a seat on another flight?"
			puts "3) would you like to quit?"
		end
		puts "\nenter a choice:"
		choice = gets
		ch = choice.to_i
		if(ch == 3 || (ch == 2 && @fl == ""))
			break
		elsif((@fl == "" && ch == 1) || (@fl !="" && ch == 2))
			@fl = flight_message
			@fl.strip!
			readfile
			ind = @flights.index(@fl)
			if(ind == nil)
				bad_message
				next
			else
				reservation(ind)
			end
		elsif(@fl != "" && ch == 1)
			readfile
			ind = @flights.index(@fl)
			if(ind == nil)
				bad_message
				next
			else
				reservation(ind)
			end
		else
			bad_message
		end		
	end
	puts "number of reservations made in this session: "+@counter.to_s
	puts "\nTHANK YOU FOR USING THE FLIGHT RESERVATION SYSTEM!"
	puts "                HAVE A GOOD DAY!"
	puts
	end
private
	def print_boarding_pass(seat_type,index)
		puts "\t================================================"
		puts "\t|              BOARDING PASS                   |"
		puts "\t================================================"
		puts "\t  flight number: "+@flights[index].to_s
		if(seat_type.eql?("n"))
			
			@non_smoking[index] = (@non_smoking[index].to_i + 1).to_s
			puts "\t  seat number: "+(@non_smoking[index].to_s)
			puts "\t  seat type: non-smoking"
		elsif(seat_type.eql?("s"))
			@smoking[index] = (@smoking[index].to_i + 1).to_s
			puts "\t  seat number: "+(@smoking[index].to_s)
			puts "\t  seat type: smoking"
		end
		puts "\t================================================"
		puts "\t  Flight status:"
		puts "\t  Flight number: "+(@flights[index].to_s)
		puts "\t  Non-smoking seats:"+(@non_smoking[index].to_s)
		puts "\t  Smoking seats:"+(@smoking[index].to_s)
		puts "\t================================================"
		@counter = @counter+1
		writefile
	end

	def reservation(index)
		if(@smoking[index].to_i == 5 && @non_smoking[index].to_i == 5)
			puts "Sorry but there are no more seats left on this flight!"
			find_flights
		elsif(@smoking[index].to_i == 5)
			puts "Would you be willing to take a non-smoking seat(y/n): "
			c = gets
			c.strip!
			if(c.eql?("y"))
				print_boarding_pass("n",index)
			elsif(c.eql?("n"))	
				find_flights
			end
			
		elsif(@non_smoking[index].to_i == 5)
			puts "Would you be willing to take a smoking seat(y/n): "
			c = gets
			c.strip!
			if(c.eql?("y"))
				print_boarding_pass("s",index)
			elsif(c.eql?("n"))
				find_flights
			end
		else
			puts "Which seat would you like? "
			puts "1) Press 's' for a smoking seat"
			puts "2) Press 'n' for a non-smoking seat"
			puts "3) Press any other key to exit"
			c = gets
			c.strip!
			if(c.eql?("s")|| c.eql?("n"))
				print_boarding_pass(c,index)
			end
		end
	end

	def find_flights
		puts "Would you like suggestions for other flights (y/n)"
		c = gets
		if(c.strip.eql?("y"))
			puts "would you like a smoking or a non-smoking seat (s/n)?"
			c = gets
			if(c.strip.eql?("s"))
				puts "searching for flights with available smoking seats.."
				puts "flight #  number of seats left"
				puts "--------  --------------------"
				(@flights.length).times do |i|
					if(@smoking[i].to_i < 5)
						puts @flights[i] +"      " + (5-(@smoking[i].to_i)).to_s
					end
				end
			elsif(c.strip.eql?("n"))
				puts "searching for flights with available non-smoking seats.."
				puts "flight #  number of seats"
				puts "--------  ---------------"
				(@flights.length).times do |i|
					if(@non_smoking[i].to_i < 5)
						puts @flights[i] +"      " + (5-(@non_smoking[i].to_i)).to_s
					end
				end
			end
		end
		@fl = ""
	end
	def readfile
		file = File.open(@filename, "r")
		@flights = Array.new
		@smoking = Array.new
		@non_smoking = Array.new
		i = 0
		while(line = file.gets)
			@flights[i],@smoking[i],@non_smoking[i] = line.split(/\t/)
			i = i+1
		end
		file.close
	end

	def writefile
		file = File.open(@filename, "w")
		s = String.new
		puts "\nupdating the database...\n"
		(@flights.length).times do |i|
			s = @flights[i] + "\t" + @smoking[i] + "\t" + @non_smoking[i]
			file.puts(s)
		end
		file.close
	end

	def flight_message
		puts "\nplease enter the flight number you would like to book a seat in"
		flight = gets
		return flight
	end

	def bad_message
		puts "\n The input is incorrect. Please try again."
	end
end

s = Flight.new
s.start("flight.txt")
