class AddAuthorToSnippets < ActiveRecord::Migration[7.1]
  def change
    add_reference :snippets, :author, type: :string, polymorphic: true, null: false, index: true
  end
end
