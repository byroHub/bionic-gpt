-- migrate:up
-- Create the categories table with a description field
CREATE TABLE categories (
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY, 
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT
);

-- Insert categories with descriptions
INSERT INTO categories (name, description) VALUES 
('Writing', 'Prompts and content focused on creative and technical writing'), 
('Productivity', 'Tools and techniques to enhance personal and team productivity'), 
('Research', 'Guidance and support for academic and non-academic research'), 
('Education', 'Resources and prompts for learning and teaching'), 
('Lifestyle', 'Content that pertains to daily life, wellness, and hobbies'), 
('Uncategorized', 'Prompts that do not fit into a specific category'), 
('Programming', 'Prompts related to coding, software development, and algorithms');

-- Add a nullable category_id column to the prompts table
ALTER TABLE prompts ADD COLUMN category_id INTEGER;

-- Update existing prompts to point to 'Uncategorized'
UPDATE prompts 
SET category_id = (SELECT id FROM categories WHERE name = 'Uncategorized')
WHERE category_id IS NULL;

-- Make the category_id column NOT NULL after updating
ALTER TABLE prompts ALTER COLUMN category_id SET NOT NULL;


-- Give access to the application user.
GRANT SELECT, INSERT, UPDATE, DELETE ON categories TO bionic_application;
GRANT USAGE, SELECT ON categories_id_seq TO bionic_application;

-- Give access to the readonly user
GRANT SELECT ON categories TO bionic_readonly;
GRANT SELECT ON categories_id_seq TO bionic_readonly;

-- migrate:down
ALTER TABLE prompts DROP COLUMN category_id;
DROP TABLE categories;