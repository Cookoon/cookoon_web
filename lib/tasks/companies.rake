# This task can safely be removed once new automatic mailers are set.
namespace :companies do
  desc 'Generate Stripe Account for companies with referent email'
  task stripe_prepare: :environment do
    companies = Company.where(stripe_customer_id:nil).where.not(referent_email: nil)
    companies.each { |company| company.send(:stripe_prepare) }
  end

  desc 'Refreshes BIC & IBAN from Stripe'
  task refresh_iban: :environment do
    companies = Company.where.not(stripe_customer_id:nil)
    companies.each { |company| company.send(:stripe_prepare) }
  end
end
