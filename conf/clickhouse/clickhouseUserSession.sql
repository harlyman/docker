CREATE TABLE IF NOT EXISTS sessions (
  id Int64, 
  `date` datetime,
  country String, 
  school String, 
  schoolYear String, 
  educationLevel String, 
  educationYear String, 
  discipline String, 
  session String, 
  user String, 
  role Enum('R01'=1, 'R02'=2), 
  event Enum('login'=1, 'logout'=2)
) ENGINE = MergeTree() 
  PRIMARY KEY(id) 
  ORDER BY id;

CREATE TABLE IF NOT EXISTS sessions_kafka (
  `date` datetime, 
  country String, 
  school String, 
  schoolYear String, 
  educationLevel String, 
  educationYear String, 
  discipline String, 
  session String, 
  user String, 
  role Enum('R01'=1, 'R02'=2), 
  event Enum('login'=1, 'logout'=2)
) ENGINE = Kafka SETTINGS 
  kafka_broker_list = '192.168.10.4:9092', 
  kafka_topic_list = 'sessions', 
  kafka_format = 'JSONEachRow', 
  kafka_num_consumers = 1, 
  kafka_group_name = 'sessions_group';

CREATE MATERIALIZED VIEW IF NOT EXISTS sessions_consumer 
  TO sessions AS 
  SELECT 
    toYYYYMMDDhhmmss(`date`) as id, 
    `date`, 
    country, 
    school, 
    schoolYear, 
    educationLevel, 
    educationYear, 
    discipline, 
    session, 
    user, 
    role,
    event 
  FROM sessions_kafka;