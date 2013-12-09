class Attendant < ActiveRecord::Base
  attr_accessible :email, :full_name, :phone, :will_come, :comes_with, :permalink, :title

  belongs_to :user

  before_create :assign_permalink
  validates_presence_of :email, :full_name

  def assign_permalink
    self.permalink = Secure.hex(8) unless self.permalink.present?
  end
end
