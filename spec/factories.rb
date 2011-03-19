Factory.define(:project) do |f|
  f.sequence(:name) {|n| "Project #{n}"}
  f.sequence(:start_date) { |n| n.years.ago }
  f.sequence(:priority) {|n| 40 + n }
end