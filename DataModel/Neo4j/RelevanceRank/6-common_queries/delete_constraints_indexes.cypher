//delete all constraints and indexes
call apoc.schema.assert ({},{},true);