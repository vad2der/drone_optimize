# Test description

## Drone Delivery Service
A squad of drones have been tasked with delivering packages for a major online reseller in a world where time and distance do not matter.  Each drone can carry a specific weight, and can make multiple deliveries before returning to home base to pick up additional loads; however the goal is to make the fewest number of trips as each time the drone returns to home base it is extremely costly to refuel and reload the drone.
The purpose of the written software will be to accept input which will include the name of a single drone and the maximum weight it can carry, along with a series of locations and the total weight needed to be delivered to that specific location.  The software should highlight the most efficient deliveries for the drone to make on each trip.
Assume that time and distance to each drop off location do not matter, and that size of each package is also irrelevant.  It is also known that the maximum number of deliveries is a reasonable number.

## Given Input
`Line 1: [Drone #1 Name], [#1 Maximum Weight]
Line 2: [Location #1 Name], [Location #1 Package Weight]
Line 3: [Location #2 Name], [Location #2 Package Weight]
Line 4: [Location #3 Name], [Location #3 Package Weight]`
Etc.

## Expected Output
`[Drone #1 Name]
Trip #1
[Location #2 Name], [Location #3 Name]
Trip #2
[Location #1 Name]`


# Solution

## How to run

1. Import solution
`require "./optimize"

2. Initialize class into an instance

    `o = Optimize.new`

optionally, add a ref path to a data file as long as it is formatted properly

    `o = Optimize.new("./lib/test.txt")`

3. Run the Drone Trips optimization

    `o.optimize_drones() # first_bigger is picked by default` 
    `o.optimize_drones("first_bigger")`
    `o.optimize_drones("all_combinations")`

    2 options for optimization alorithms are provided:

    - *first_bigger*: Location sorted by weight [O(n2) as a worst case], then, starting with the bigger one, it tries to fit next possible biggest Location into a Trip [O(n)]. This one is a default. It is a quick algorithm, thought might be not the best for a big number and variety of packages.
    - *all_combinations*: All possible location combinations are created [O(n log n)]. Then we filter out those which have sum weight bigger then Drone can load and empty ones. Sort them by the most load [O(n2) as a worst case]. And iterate through them and while checking if they have not been already selected, add them to selected. Runs longer because of number of combinations for a sum of sizes from current_size = (0..number_of_locations) [locations.size! / ((location.size - current_size)! * current_size!)]. But can provide better Trip combinations, than the previous algorithm.

## Testing

run `bundle install` if rspec gem is not installed yet
run `rspec` from project root

## Prepared by

Vadim Deryabin

_vadim.deryabin@protonmail.com_
_+1 (587) 718-0725_
