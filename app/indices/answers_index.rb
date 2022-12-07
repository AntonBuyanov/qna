ThinkingSphinx::Index.define :answer, with: :active_record do
  indexes body, sortable: true
  indexes author.email, as: :author

  has author_id, created_at, updated_at
end
