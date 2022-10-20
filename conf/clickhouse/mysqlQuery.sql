Select country, sum(students) students, sum(teachers) teachers
from (
select country, user, 1 students, 0 teachers, count(session) sessions
FROM (
SELECT 
    el.country_guid country, sg.school_guid school, sy.name schoolYear, 
    ey.education_level_guid educationLevel, ey.guid educationYear, 
    c.education_discipline_guid discipline,
    us.created_at login, coalesce(us.deleted_at, us.expires_at) logout, us.guid session, us.person_guid user, up.role_guid role
    FROM 
      i2c_v2_sessions.user_login_sessions us

      INNER JOIN user_persons up ON up.guid = us.person_guid 
      INNER JOIN lms_course_users cu ON up.guid = cu.person_guid
      INNER JOIN lms_courses c ON c.guid = cu.course_guid
        AND c.created_at <= us.created_at AND ((c.deleted_at IS NOT NULL AND c.deleted_at <= coalesce(us.deleted_at, us.expires_at)) OR c.deleted_at IS NULL)
      INNER JOIN school_groups sg ON sg.guid = c.school_group_guid
      INNER JOIN school_years sy ON sy.guid = sg.school_year_guid
      INNER JOIN education_years ey ON ey.guid = c.education_year_guid
      INNER JOIN education_levels el ON el.guid = ey.education_level_guid

    WHERE up.role_guid IN ('R01') 
     AND us.created_at >= '2021-09-01 00:00:00'
) s
group by country, user

UNION

select country, user, 0, 1, count(session) sessions
from (
  SELECT 
    el.country_guid country, sg.school_guid school, sy.name schoolYear, 
    ey.education_level_guid educationLevel, ey.guid educationYear, 
    c.education_discipline_guid discipline,
    us.created_at login, coalesce(us.deleted_at, us.expires_at) logout, us.guid session, us.person_guid user, up.role_guid role
    FROM 
      i2c_v2_sessions.user_login_sessions us

      INNER JOIN user_persons up ON up.guid = us.person_guid 
      INNER JOIN lms_course_users cu ON up.guid = cu.person_guid
      INNER JOIN lms_courses c ON c.guid = cu.course_guid
        AND c.created_at <= us.created_at AND ((c.deleted_at IS NOT NULL AND c.deleted_at <= coalesce(us.deleted_at, us.expires_at)) OR c.deleted_at IS NULL)
      INNER JOIN school_groups sg ON sg.guid = c.school_group_guid
      INNER JOIN school_years sy ON sy.guid = sg.school_year_guid
      INNER JOIN education_years ey ON ey.guid = c.education_year_guid
      INNER JOIN education_levels el ON el.guid = ey.education_level_guid

    WHERE up.role_guid IN ('R02') 
     AND us.created_at >= '2021-09-01 00:00:00'
) t
group by country, user
) u
where sessions > 1
group by country;