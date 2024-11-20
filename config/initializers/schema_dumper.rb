ignore_tables = ActiveRecord::SchemaDumper.ignore_tables

# Ignore tables managed by the sqlite-vec extension
# matches tables like: page_embeddings_chunks, page_embeddings_chunks00, and
# page_embeddings_rowids
ignore_tables += [/_chunks\d*$/] + [/_rowids$/]

ActiveRecord::SchemaDumper.ignore_tables = ignore_tables
