-- SESSIONS
CREATE TABLE IF NOT EXISTS wemaths.sessions (
  id Int64, 
  `date` datetime,
  country String, 
  school String, 
  schoolYear String, 
  educationLevel String, 
  educationYear String, 
  schoolGroup String, 
  discipline String, 
  role Enum('R01'=1, 'R02'=2), 
  user String, 
  session String
) ENGINE = ReplicatedMergeTree()
PRIMARY KEY(id) ORDER BY id;

CREATE TABLE IF NOT EXISTS wemaths.sessions_kafka (
  `date` datetime,
  country String, 
  school String, 
  schoolYear String, 
  educationLevel String, 
  educationYear String, 
  schoolGroup String, 
  discipline String, 
  role Enum('R01'=1, 'R02'=2), 
  user String, 
  session String
) ENGINE = Kafka 
DEV
  SETTINGS kafka_broker_list = 'b-1.oneclick-dev-kafka.jf1jub.c1.kafka.eu-central-1.amazonaws.com:9094,b-2.oneclick-dev-kafka.jf1jub.c1.kafka.eu-central-1.amazonaws.com:9094', 
PROD
  SETTINGS kafka_broker_list = 'b-1.tangerine-prod-kafk.7n48p4.c1.kafka.eu-central-1.amazonaws.com:9094,b-2.tangerine-prod-kafk.7n48p4.c1.kafka.eu-central-1.amazonaws.com:9094,b-3.tangerine-prod-kafk.7n48p4.c1.kafka.eu-central-1.amazonaws.com:9094', 
  kafka_topic_list = 'wemaths_sessions', 
  kafka_format = 'JSONEachRow', 
  kafka_num_consumers = 3, 
  kafka_group_name = 'wemaths_sessions';

CREATE MATERIALIZED VIEW IF NOT EXISTS wemaths.sessions_consumer TO wemaths.sessions AS 
  SELECT toYYYYMMDDhhmmss(`date`) as id, `date`, country, school, schoolYear, educationLevel, educationYear, schoolGroup, discipline, role, user, session 
  FROM wemaths.sessions_kafka;

-- ASSIGNMENTS
CREATE TABLE IF NOT EXISTS wemaths.assignments (
  id Int64, 
  `date` datetime,
  country String, 
  school String, 
  schoolYear String, 
  educationLevel String, 
  educationYear String, 
  schoolGroup String, 
  discipline String, 
  role Enum('R01'=1, 'R02'=2), 
  user String, 
  assesment String, 
  type Enum('evaluative'=1, 'formative'=2),
  score Float32
) ENGINE = ReplicatedMergeTree()
PRIMARY KEY(id) ORDER BY id;

CREATE TABLE IF NOT EXISTS wemaths.assignments_kafka (
  `date` datetime,
  country String, 
  school String, 
  schoolYear String, 
  educationLevel String, 
  educationYear String, 
  schoolGroup String, 
  discipline String,
  role Enum('R01'=1, 'R02'=2), 
  user String, 
  assesment String, 
  type Enum('evaluative'=1, 'formative'=2), 
  score Float32
) ENGINE = Kafka 
  SETTINGS kafka_broker_list = 'b-1.oneclick-dev-kafka.jf1jub.c1.kafka.eu-central-1.amazonaws.com:9094,b-2.oneclick-dev-kafka.jf1jub.c1.kafka.eu-central-1.amazonaws.com:9094', 
  kafka_topic_list = 'wemaths_assignments', 
  kafka_format = 'JSONEachRow', 
  kafka_num_consumers = 3, 
  kafka_group_name = 'wemaths_assignments';

CREATE MATERIALIZED VIEW IF NOT EXISTS wemaths.assignments_consumer TO wemaths.assignments AS 
  SELECT toYYYYMMDDhhmmss(`date`) as id, `date`, country, school, schoolYear, educationLevel, educationYear, schoolGroup, discipline, role, user, assesment, type, score 
  FROM wemaths.assignments_kafka;

-- CONSUMPTIONS
-- CREATE TABLE IF NOT EXISTS wemaths.consumptions (
--   id Int64, 
--   `date` datetime,
--   country String, 
--   school String, 
--   schoolYear String, 
--   educationLevel String, 
--   educationYear String, 
--   discipline String,
--   role Enum('R01'=1, 'R02'=2), 
--   user String, 
--   assesment String, 
--   session String, 
--   `format` String, 
--   device String
-- ) ENGINE = ReplicatedMergeTree()
-- PRIMARY KEY(id) ORDER BY id;

-- CREATE TABLE IF NOT EXISTS wemaths.consumptions_kafka (
--   `date` datetime, 
--   country String, 
--   school String, 
--   schoolYear String, 
--   educationLevel String, 
--   educationYear String, 
--   discipline String,
--   role Enum('R01'=1, 'R02'=2), 
--   user String, 
--   assesment String, 
--   session String, 
--   `format` String, 
--   device String
-- ) ENGINE = Kafka 
--   SETTINGS kafka_broker_list = 'b-1.oneclick-dev-kafka.jf1jub.c1.kafka.eu-central-1.amazonaws.com:9094,b-2.oneclick-dev-kafka.jf1jub.c1.kafka.eu-central-1.amazonaws.com:9094', 
--   kafka_topic_list = 'wemaths_consumptions', 
--   kafka_format = 'JSONEachRow', 
--   kafka_num_consumers = 3, 
--   kafka_group_name = 'wemaths_consumptions';

-- CREATE MATERIALIZED VIEW IF NOT EXISTS wemaths.consumptions_consumer TO wemaths.consumptions AS 
--   SELECT toYYYYMMDDhhmmss(`date`) as id, `date`, country, school, schoolYear, educationLevel, educationYear, discipline, role, user, assesment, session, `format`, device 
--   FROM wemaths.consumptions_kafka;
