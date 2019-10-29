#!/usr/bin/env ruby

class Optimize

  attr_accessor :optimize_trips, :find_best_fit_bigger, :create_all_combinations

  def initialize(file_name="test.txt")
    @input_data = File.open(file_name).readlines().map(&:chomp)
    @raw_drone_data = []
  end

  def parse_data
    current_drone = {:name => '', :max_weight => 0, :locations => []}
    locations = []
    @input_data.each {|d|      
      if d.include?("Drone")
        if current_drone[:name] != d.split(",").first && locations.size > 0
          @raw_drone_data << {:name => current_drone[:name],
            :max_weight => current_drone[:max_weight],
            :locations => locations.sort_by {|k| k[:weight] }.reverse}
          locations = []
        end
        current_drone[:name] = d.split(',').first
        current_drone[:max_weight] = d.split(',').last.to_f
      else
        locations << {:name => d.split(',').first, :weight => d.split(',').last.to_f}
      end
     };nil
    @raw_drone_data << {:name => current_drone[:name],
            :max_weight => current_drone[:max_weight],
            :locations => locations.sort_by {|k| k[:weight] }.reverse}
    #puts @raw_drone_data
  end

  def output_parsed_data
    puts "*"*10
    @raw_drone_data.each_with_index {|d, i|
      puts d[:name]
      puts "Trip #" + (i+1).to_s
      d[:locations].each_with_index {|l, ind|
        puts l[:name] + "(" + l[:weight].to_s + ")"
      }
    }
  end

  def verify_packages
    checked_drones = []
    @raw_drone_data.each{|drone|
      valid_packages = []
      invalid_packages = []
      drone[:locations].each_with_index {|loc, ind|
        loc[:id] = ind
        if loc[:weight] > drone[:max_weight]
          invalid_packages << loc
        else
          valid_packages << loc
        end
      }
      checked_drones << {
        :name => drone[:name], :max_weight => drone[:max_weight],
        :locations => valid_packages, :invalid_packages => invalid_packages}
    }
    return checked_drones
  end

  def optimize_drones(data=nil)
    @raw_drone_data = data if !data.nil?     
    parsed_data = parse_data()
    verified_drone_data = verify_packages()
    puts verified_drone_data.to_s
    verified_drone_data.each {|drone|
      trips = optimize_trips(drone[:locations], drone[:max_weight], "all_combinations")
      puts drone[:name]
      trips.each_with_index {|trip, i|
        puts "Trip %s" % [i + 1]
        puts trip[:locations].map {|t| t[:name]}.join(", ")
      };nil
      puts "invalid packages: %s" % [drone[:invalid_packages]] if drone[:invalid_packages] && drone[:invalid_packages].size > 0
    } 
  end

  def optimize_trips(locations, max_weight, alg="first_bigger")
    if alg == "first_bigger"
      # OPTION #1 - first bigger algorithm
      trips = []
      selected_location_ids = []
      if locations.map{|l|l[:id]}.compact.size == 0
        locations_with_ids = []
        locations.each_with_index {|l, i|
          l[:id] = i
          locations_with_ids << l
        }
      else
        locations_with_ids = locations
      end
      locations_with_ids.each {|loc|
        if !selected_location_ids.include?(loc[:id])
          unselected_locations = locations_with_ids.map {|l| l if !selected_location_ids.include?(l[:id])}.compact
          trip_locations = find_best_fit_bigger(unselected_locations, max_weight)  
          trip_locations.each{|tl|
            selected_location_ids << tl[:id]
          }          
          trips << {:locations => trip_locations, :rest => (max_weight - trip_locations.map{|tl|tl[:weight]}.sum).round(1)}
        end
      }
      # returning an array sorted so that most loaded goes first
      return trips.sort_by{|t|t[:rest]}

    elsif alg == "all_combinations"
      # OPTION #2 - all combinations and picking most loaded
      combs = create_all_combinations(locations, max_weight)
      selected_combs = []
      combs.each {|c|
        # check if trip is already in selected_combs
        already_presented = false
        c[:combs].each {|t|
          if selected_combs.map{|sc| sc[:locations].map{|l| l[:name]}}.flatten.include?(t[:name])
            already_presented = true
          end
        }
        # and if not - add it
        selected_combs << {:locations => c[:combs], :rest => (max_weight - c[:combs].map{|tl|tl[:weight]}.sum).round(1)} if !already_presented
      }    

      # have to be already sorted with bigger load first
      return selected_combs

    end
  end

  def find_best_fit_bigger(locations, limit)
    selected_packages = []
    while locations.map{|l| l[:weight]}.min <= limit do
      locations.each{|l|
        if l[:weight] <= limit
          selected_packages << l if !selected_packages.map{|sp| sp[:id]}.include?(l[:id])
          limit -= l[:weight]
        end
      }
    end
    return selected_packages
  end

  def create_all_combinations(locations, limit)
    combinations = []
    (0..locations.size).each {|s|
      locations.combination(s).to_a.each_with_index{|loc, ind|
        # but we are interested only in combinations where sum of weights <= than drone max load and are not empty
        combinations << {:rest => (limit - loc.map{|l| l[:weight]}.sum).round(1), :combs => loc, :id => ind} if (loc.map{|l| l[:weight]}.sum <= limit && loc.size > 0)
      }
    }

    # returning an array sorted so that most loaded goes first
    return combinations.sort_by{|t|t[:rest]}
  end
end



# o = Optimize.new
# o.parse_data
# #o.output_parsed_data
# o.verify_packages
# #o.output_verified_data
# o.optimize_drones