#!/usr/bin/env sh

CLICKHOUSE_DB="${CLICKHOUSE_DB:-database}";
CLICKHOUSE_USER="${CLICKHOUSE_USER:-user}";
CLICKHOUSE_PASSWORD="${CLICKHOUSE_PASSWORD:-password}";

cat <<EOT >> /etc/clickhouse-server/users.d/user.xml
<yandex>
  <!-- Docs: <https://clickhouse.tech/docs/en/operations/settings/settings_users/> -->
  <users>
    <${CLICKHOUSE_USER}>
      <profile>default</profile>
      <networks>
        <ip>::/0</ip>
      </networks>
      <password>${CLICKHOUSE_PASSWORD}</password>
      <quota>default</quota>
    </${CLICKHOUSE_USER}>
  </users>
</yandex>
EOT
#cat /etc/clickhouse-server/users.d/user.xml;

clickhouse-client --query "CREATE DATABASE IF NOT EXISTS ${CLICKHOUSE_DB}";
# clickhouse-client --query "CREATE DATABASE IF NOT EXISTS test";
clickhouse-client -d ${CLICKHOUSE_DB} --query "CREATE TABLE IF NOT EXISTS sessions (id Int64, \`date\` datetime, country String, school String, schoolYear String, educationLevel String, educationYear String, schoolGroup String, discipline String, role Enum('R01'=1, 'R02'=2), user String, session String ) ENGINE = MergeTree() PRIMARY KEY(id) ORDER BY id;";
clickhouse-client -d ${CLICKHOUSE_DB} --query "CREATE TABLE IF NOT EXISTS sessions_kafka (\`date\` datetime, country String, school String, schoolYear String, educationLevel String, educationYear String, schoolGroup String, discipline String, role Enum('R01'=1, 'R02'=2), user String, session String ) ENGINE = Kafka SETTINGS kafka_broker_list = '192.168.10.4:9092', kafka_topic_list = 'wemaths_sessions', kafka_format = 'JSONEachRow', kafka_num_consumers = 3, kafka_group_name = 'sessions_group';";
clickhouse-client -d ${CLICKHOUSE_DB} --query "CREATE MATERIALIZED VIEW IF NOT EXISTS sessions_consumer TO sessions AS SELECT toYYYYMMDDhhmmss(\`date\`) as id, \`date\`, country, school, schoolYear, educationLevel, educationYear, schoolGroup, discipline, role, user, session FROM sessions_kafka;";

clickhouse-client -d ${CLICKHOUSE_DB} --query "CREATE TABLE IF NOT EXISTS assignments (id Int64, \`date\` datetime, country String, school String, schoolYear String, educationLevel String, educationYear String, schoolGroup String, discipline String, adventure String, lesson String, lessonType Enum('diagnosis'=1, 'progress'=2, 'verification'=3, 'evaluation'=4), role Enum('R01'=1, 'R02'=2), user String, assesment String, type Enum('evaluative'=1, 'formative'=2), score Float32 ) ENGINE = MergeTree() PRIMARY KEY(id) ORDER BY id;";
clickhouse-client -d ${CLICKHOUSE_DB} --query "CREATE TABLE IF NOT EXISTS assignments_kafka (\`date\` datetime, country String, school String, schoolYear String, educationLevel String, educationYear String, schoolGroup String, discipline String, adventure String, lesson String, lessonType Enum('diagnosis'=1, 'progress'=2, 'verification'=3, 'evaluation'=4), role Enum('R01'=1, 'R02'=2), user String, assesment String, type Enum('evaluative'=1, 'formative'=2), score Float32 ) ENGINE = Kafka SETTINGS kafka_broker_list = '192.168.10.4:9092', kafka_topic_list = 'wemaths_assignments', kafka_format = 'JSONEachRow', kafka_num_consumers = 3, kafka_group_name = 'assignments_group';";
clickhouse-client -d ${CLICKHOUSE_DB} --query "CREATE MATERIALIZED VIEW IF NOT EXISTS assignments_consumer TO assignments AS SELECT toYYYYMMDDhhmmss(\`date\`) as id, \`date\`, country, school, schoolYear, educationLevel, educationYear, schoolGroup, discipline, adventure, lesson, lessonType, role, user, assesment, type, score FROM assignments_kafka;";

# clickhouse-client -d ${CLICKHOUSE_DB} --query "CREATE TABLE IF NOT EXISTS jobs (id Int64, \`date\` datetime,country String, school String, schoolId Int32, schoolName String, schoolYear String, educationLevel String, educationLevelName String, educationYear String, educationYearName String, schoolGroup String, schoolGroupName String, discipline String, disciplineName String, adventure String, adventureName String, adventureOrder Int16, lesson String, lessonName String, lessonOrder Int16, lessonType Enum('diagnosis'=1, 'progress'=2, 'verification'=3, 'evaluation'=4), user String, userName String, job String, event Enum('created'=1, 'evaluated'=2), score Float32) ENGINE = MergeTree() PRIMARY KEY(id) ORDER BY id;";
# clickhouse-client -d ${CLICKHOUSE_DB} --query "CREATE TABLE IF NOT EXISTS jobs_kafka (\`date\` datetime, country String, school String, schoolId Int32, schoolName String, schoolYear String, educationLevel String, educationLevelName String, educationYear String, educationYearName String, schoolGroup String, schoolGroupName String, discipline String, disciplineName String, adventure String, adventureName String, adventureOrder Int16, lesson String, lessonName String, lessonOrder Int16, lessonType Enum('diagnosis'=1, 'progress'=2, 'verification'=3, 'evaluation'=4), user String, userName String, job String, event Enum('created'=1, 'evaluated'=2), score Float32) ENGINE = Kafka SETTINGS kafka_broker_list = '192.168.10.4:9092', kafka_topic_list = 'wemaths_jobs', kafka_format = 'JSONEachRow', kafka_num_consumers = 3, kafka_group_name = 'jobs_group';";
# clickhouse-client -d ${CLICKHOUSE_DB} --query "CREATE MATERIALIZED VIEW IF NOT EXISTS jobs_consumer TO jobs AS SELECT toYYYYMMDDhhmmss(\`date\`) as id, \`date\`, country, school, schoolId, schoolName, schoolYear, educationLevel, educationLevelName, educationYear, educationYearName, schoolGroup, schoolGroupName, discipline, disciplineName, adventure, adventureName, adventureOrder, lesson, lessonName, lessonOrder, lessonType, user, userName, job, event, score FROM jobs_kafka;";

# clickhouse-client -d ${CLICKHOUSE_DB} --query "CREATE TABLE IF NOT EXISTS consumptions (id Int64, \`date\` datetime, country String, school String, schoolYear String, educationLevel String, educationYear String, schoolGroup String, discipline String, adventure String, lesson String, role Enum('R01'=1, 'R02'=2), user String, assesment String, session String, \`format\` String, device String, event Enum('open'=1, 'close'=2) ) ENGINE = MergeTree() PRIMARY KEY(id) ORDER BY id;";
# clickhouse-client -d ${CLICKHOUSE_DB} --query "CREATE TABLE IF NOT EXISTS consumptions_kafka (\`date\` datetime, country String, school String, schoolYear String, educationLevel String, educationYear String, discipline String, adventure String, lesson String, role Enum('R01'=1, 'R02'=2), user String, assesment String, session String, \`format\` String, device String, event Enum('open'=1, 'close'=2) ) ENGINE = Kafka SETTINGS kafka_broker_list = '192.168.10.4:9092', kafka_topic_list = 'wemaths_consumptions', kafka_format = 'JSONEachRow', kafka_num_consumers = 3, kafka_group_name = 'consumptions_group';";
# clickhouse-client -d ${CLICKHOUSE_DB} --query "CREATE MATERIALIZED VIEW IF NOT EXISTS consumptions_consumer TO consumptions AS SELECT toYYYYMMDDhhmmss(\`date\`) as id, \`date\`, country, school, schoolYear, educationLevel, educationYear, discipline, adventure, lesson, role, user, assesment, session, \`format\`, device, event FROM consumptions_kafka;";
