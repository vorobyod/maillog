
--
-- Create full text search index
--
CREATE INDEX message_str_trgm ON message USING GIN (str gin_trgm_ops);

