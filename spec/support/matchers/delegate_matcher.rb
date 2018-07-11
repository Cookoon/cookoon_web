# RSpec matcher to spec delegations.
#
# Usage:
#
#     describe Post do
#       it { should delegate(:name).to(:author).with_prefix } # post.author_name
#       it { should delegate(:day).to(:created_at) }
#       it { should delegate(:month, :year).to(:created_at) }
#     end
#
# Built on https://gist.github.com/txus/807456 and https://gist.github.com/bparanj/4579700adca0b64e7ca0

RSpec::Matchers.define :delegate do |method|
  match do |delegator|
    # No point if the receiver method doesn't exist
    return false unless delegator.respond_to?(@to)

    @method = (@prefix ? :"#{@to}_#{method}" : method).to_sym
    @delegator = delegator

    # Make and insert a double for the receiver of the delegation
    @receiver = double('receiver', @method => :called)
    allow(@delegator).to receive(@to).and_return(@receiver)

    @delegator.send(@method) == :called
  end

  description do
    "delegate :#{@method} to its #{@to}#{@prefix ? ' with prefix' : ''}"
  end

  failure_message do
    "expected #{@delegator} to delegate :#{@method} to its #{@to}#{@prefix ? ' with prefix' : ''}"
  end

  failure_message_when_negated do
    "expected #{@delegator} not to delegate :#{@method} to its #{@to}#{@prefix ? ' with prefix' : ''}"
  end

  chain(:to) { |receiver| @to = receiver.to_sym }
  chain(:with_prefix) { @prefix = true }
end
