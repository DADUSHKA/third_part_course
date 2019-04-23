RSpec.describe Vote, type: :model do
  it { should belong_to(:voteable) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:choice) }
  it { should validate_inclusion_of(:choice).in_range(-1..1) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:voteable_type, :voteable_id) }
end
