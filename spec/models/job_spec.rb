require 'rails_helper'

RSpec.describe Job, type: :model do
  it 'is valid with a user, a job_title, a company, a linkedin_profile' do
    job = build(:job)
    job.valid?
    expect(job).to be_valid
  end

  it 'is invalid without a user' do
    job = build(:job, user: nil)
    job.valid?
    expect(job.errors[:user]).to include('doit exister')
  end

  it 'is invalid without a job_title' do
    job = build(:job, job_title: nil)
    job.valid?
    expect(job.errors[:job_title]).to include('doit être rempli(e)')
  end

  it 'is invalid without a company' do
    job = build(:job, company: nil)
    job.valid?
    expect(job.errors[:company]).to include('doit être rempli(e)')
  end

  it 'is invalid without a linkedin_profile' do
    job = build(:job, linkedin_profile: nil)
    job.valid?
    expect(job.errors[:linkedin_profile]).to include('doit être rempli(e)')
  end
end
