class Job < ApplicationRecord
  belongs_to :user

  validates :job_title, presence: true
  validates :company, presence: true
  validates :linkedin_profile, presence: true
end
