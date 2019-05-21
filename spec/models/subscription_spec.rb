RSpec.describe Subscription, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should have_db_index :question_id }
  it { should have_db_index :user_id }
  it { should have_db_index [:user_id, :question_id] }

  it { should validate_presence_of :question }
  it { should validate_presence_of :user }
end
