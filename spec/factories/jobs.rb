FactoryBot.define do
  factory :job do
    job_title "Développeur"
    company "Cookoon"
    linkedin_profile "https://www.linkedin.com/in/alice-fabre-676211182/"
    association :user, :with_job
  end
end
