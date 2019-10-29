RSpec.describe Optimize do
  
  locations = [{:name=>"Location 1", :weight=>7.5},
               {:name=>"Location 2", :weight=>3.2},
               {:name=>"Location 3", :weight=>4.5},
               {:name=>"Location 4", :weight=>12.4},
               {:name=>"Location 5", :weight=>9.3},
               {:name=>"Location 6", :weight=>1.7},
               {:name=>"Location 7", :weight=>1.5},
               {:name=>"Location 8", :weight=>3.0},
               {:name=>"Location 9", :weight=>8.1},
               {:name=>"Location 10", :weight=>5.7},
               {:name=>"Location 11", :weight=>3.3},
               {:name=>"Location 12", :weight=>10.0},
               {:name=>"Location 13", :weight=>4.0}]
  
  all_combinations_result = [
    {:locations=>[{:name=>"Location 12", :weight=>10.0}], :rest=>0.0},
    {:locations=>[{:name=>"Location 3", :weight=>4.5}, {:name=>"Location 7", :weight=>1.5}, {:name=>"Location 13", :weight=>4.0}], :rest=>0.0},
    {:locations=>[{:name=>"Location 6", :weight=>1.7}, {:name=>"Location 9", :weight=>8.1}], :rest=>0.2},
    {:locations=>[{:name=>"Location 2", :weight=>3.2}, {:name=>"Location 8", :weight=>3.0},
    {:name=>"Location 11", :weight=>3.3}], :rest=>0.5},
    {:locations=>[{:name=>"Location 5", :weight=>9.3}], :rest=>0.7},
    {:locations=>[{:name=>"Location 1", :weight=>7.5}], :rest=>2.5},
    {:locations=>[{:name=>"Location 10", :weight=>5.7}], :rest=>4.3}]

  first_bigger_result = [
    {:locations=>[{:name=>"Location 12", :weight=>10.0, :id=>11}], :rest=>0.0},
    {:locations=>[{:name=>"Location 5", :weight=>9.3, :id=>4}], :rest=>0.7},
    {:locations=>[{:name=>"Location 1", :weight=>7.5, :id=>0}, {:name=>"Location 6", :weight=>1.7, :id=>5}], :rest=>0.8},
    {:locations=>[{:name=>"Location 2", :weight=>3.2, :id=>1}, {:name=>"Location 3", :weight=>4.5, :id=>2}, {:name=>"Location 7", :weight=>1.5, :id=>6}], :rest=>0.8},
    {:locations=>[{:name=>"Location 8", :weight=>3.0, :id=>7}, {:name=>"Location 10", :weight=>5.7, :id=>9}], :rest=>1.3},
    {:locations=>[{:name=>"Location 9", :weight=>8.1, :id=>8}], :rest=>1.9},
    {:locations=>[{:name=>"Location 11", :weight=>3.3, :id=>10}, {:name=>"Location 13", :weight=>4.0, :id=>12}], :rest=>2.7}]


  o = Optimize.new("./lib/test.txt")

  it "Trips Optimization for a Drone using all_combinations algorithm" do
    expect(o.optimize_trips(locations, 10, "all_combinations")).to eq(all_combinations_result)
  end

  it "Trips Optimization for a Drone using first_bigger algorithm" do
    expect(o.optimize_trips(locations, 10, "first_bigger")).to eq(first_bigger_result)
  end
end
