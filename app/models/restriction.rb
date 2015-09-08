class Restriction < ActiveRecord::Base
  belongs_to :company
  belongs_to :user
  
  validates :problem, inclusion: { in: ["PP", "DP", "PDP"],
    message: "%{value} is not a valid priority, please use PP, DP, PDP" }
end
