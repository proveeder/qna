ThinkingSphinx::Index.define :comment, with: :real_time do
  # fields
  indexes text, sortable: true
  indexes commentable_type
end
