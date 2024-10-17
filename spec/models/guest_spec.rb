require "rails_helper"

RSpec.describe Guest do
  it { expect(subject).not_to be_registered }
  it { expect(subject).not_to be_persisted }

  it { expect(subject.can_edit?).to be false }
  it { expect(subject.can_edit?(:anything)).to be false }
end
