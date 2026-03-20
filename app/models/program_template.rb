class ProgramTemplate < ApplicationRecord
  has_many :program_days, dependent: :destroy
  validates :name, :split_type, presence: true
end
