-- Creating the Database
CREATE DATABASE ChatbotDB;
USE ChatbotDB;

-- Creating the Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- Creating the Conversations Table
CREATE TABLE Conversations (
    conversation_id INT PRIMARY KEY,
    user_id INT,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Creating the Messages Table
CREATE TABLE Messages (
    message_id INT PRIMARY KEY,
    conversation_id INT,
    sender VARCHAR(10),
    message_text TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversation_id) REFERENCES Conversations(conversation_id)
);

-- Creating the Query Patterns Table
CREATE TABLE QueryPatterns (
    pattern_id INT PRIMARY KEY,
    pattern_text TEXT,
    frequency INT DEFAULT 0,
    last_occurred TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creating the Chatbot Responses Table
CREATE TABLE ChatbotResponses (
    response_id INT PRIMARY KEY,
    pattern_id INT,
    response_text TEXT,
    accuracy_score DECIMAL(5, 2),
    FOREIGN KEY (pattern_id) REFERENCES QueryPatterns(pattern_id)
);

-- Creating the AI Models Table
CREATE TABLE AIModels (
    model_id INT PRIMARY KEY,
    model_name VARCHAR(50),
    version VARCHAR(20),
    update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    change_log TEXT,
    is_default BOOLEAN DEFAULT FALSE
);

-- Inserting the four AI models into the AI Models Table
INSERT INTO AIModels (model_id, model_name, version, update_date, change_log, is_default)
VALUES 
(1, 'MicrosoftCopilot', '1.0', CURRENT_TIMESTAMP, 'Initial version', TRUE),
(2, 'ChatGPT', '3.5', CURRENT_TIMESTAMP, 'current version', FALSE),
(3, 'DeepSeek', 'V-3', CURRENT_TIMESTAMP, 'current version', FALSE),
(4, 'Gemini', '1.5', CURRENT_TIMESTAMP, 'free version', FALSE);

-- Creating the AI Model Integration Table
CREATE TABLE AIModelIntegration (
    integration_id INT PRIMARY KEY,
    model_id INT,
    integration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (model_id) REFERENCES AIModels(model_id)
);

-- Inserting sample users
INSERT INTO Users (user_id, username, email, created_at, last_login) VALUES
(1, 'JohnDoe', 'john@example.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 'JaneSmith', 'jane@example.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 'AliceWonder', 'alice@example.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 'BobBuilder', 'bob@example.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 'CharlieBrown', 'charlie@example.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Inserting sample conversations
INSERT INTO Conversations (conversation_id, user_id, started_at, ended_at) VALUES
(1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 5, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Inserting sample messages
INSERT INTO Messages (message_id, conversation_id, sender, message_text, timestamp) VALUES
(1, 1, 'User', 'Hello, how are you?', CURRENT_TIMESTAMP),
(2, 1, 'Chatbot', 'I am fine, thank you!', CURRENT_TIMESTAMP),
(3, 2, 'User', 'What is the weather like today?', CURRENT_TIMESTAMP),
(4, 2, 'Chatbot', 'It is sunny and warm.', CURRENT_TIMESTAMP),
(5, 3, 'User', 'Can you recommend a book?', CURRENT_TIMESTAMP),
(6, 3, 'Chatbot', 'Sure! How about "1984" by George Orwell?', CURRENT_TIMESTAMP),
(7, 4, 'User', 'What is 2+2?', CURRENT_TIMESTAMP),
(8, 4, 'Chatbot', '2+2 is 4.', CURRENT_TIMESTAMP),
(9, 5, 'User', 'Play some music.', CURRENT_TIMESTAMP),
(10, 5, 'Chatbot', 'Here is a song for you!', CURRENT_TIMESTAMP),
(11, 1, 'User', 'Good morning!', CURRENT_TIMESTAMP),
(12, 1, 'Chatbot', 'Good morning! How can I assist you today?', CURRENT_TIMESTAMP),
(13, 2, 'User', 'Tell me a joke.', CURRENT_TIMESTAMP),
(14, 2, 'Chatbot', 'Why don’t scientists trust atoms? Because they make up everything!', CURRENT_TIMESTAMP);

-- Inserting sample query patterns
INSERT INTO QueryPatterns (pattern_id, pattern_text, frequency, last_occurred) VALUES
(1, 'How are you?', 10, CURRENT_TIMESTAMP),
(2, 'Weather', 5, CURRENT_TIMESTAMP),
(3, 'Book recommendation', 7, CURRENT_TIMESTAMP),
(4, 'Math question', 12, CURRENT_TIMESTAMP),
(5, 'Play music', 5, CURRENT_TIMESTAMP),
(6, 'Capital city question', 10, CURRENT_TIMESTAMP);

-- Inserting sample chatbot responses
INSERT INTO ChatbotResponses (response_id, pattern_id, response_text, accuracy_score) VALUES
(1, 1, 'I am fine, thank you!', 95.0),
(2, 2, 'It is sunny and warm.', 90.0),
(3, 3, 'Sure! How about "1984" by George Orwell?', 95.0),
(4, 4, '2+2 is 4.', 99.0),
(5, 5, 'Here is a song for you!', 90.0),
(6, 6, 'The capital of France is Paris.', 98.0);

-- Inserting sample AI model integrations
INSERT INTO AIModelIntegration (integration_id, model_id, integration_date) VALUES
(1, 1, CURRENT_TIMESTAMP),
(2, 2, CURRENT_TIMESTAMP),
(3, 3, CURRENT_TIMESTAMP),
(4, 4, CURRENT_TIMESTAMP),
(5, 1, CURRENT_TIMESTAMP),
(6, 2, CURRENT_TIMESTAMP),
(7, 3, CURRENT_TIMESTAMP),
(8, 4, CURRENT_TIMESTAMP);
-- Retrieve all users
SELECT * FROM Users;

-- Get Conversations and Their Users
SELECT c.conversation_id, u.username, c.started_at 
FROM Conversations c 
JOIN Users u ON c.user_id = u.user_id;

-- Get All Messages for a Specific Conversation
SELECT m.message_id, m.sender, m.message_text, m.timestamp 
FROM Messages m 
WHERE m.conversation_id = 1;

-- Find Frequently Asked Queries (Last 10 Days)
SELECT pattern_text, frequency 
FROM QueryPatterns 
WHERE last_occurred >= DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 10 DAY)
ORDER BY frequency DESC 
LIMIT 5;
-- to change the ai model
SET SQL_SAFE_UPDATES = 0;
UPDATE AIModels
SET is_default = FALSE
WHERE is_default = TRUE;
UPDATE AIModels
SET is_default = TRUE
WHERE model_name = 'ChatGPT';
SELECT * FROM AIModels;

