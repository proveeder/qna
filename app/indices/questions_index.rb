ThinkingSphinx::Index.define :question, with: :real_time do
  # fields
  indexes title, sortable: true
  indexes body
  indexes user.email, as: :author

  # attributes
  has user_id, type: :integer
end
