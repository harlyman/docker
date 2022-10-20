SELECT country, sum(students) students, sum(teachers) teachers 
  FROM (
    SELECT country, user, 1 students, 0 teachers, count(session) sessions
    FROM sessions 
    WHERE event = 'login' 
      AND role = 'R01' 
    GROUP BY country, user
    
    UNION ALL 
    
    SELECT country, user, 0, 1, count(session)
    FROM sessions 
    WHERE event = 'login' 
      AND role = 'R02' 
    GROUP BY country, user
  )
  WHERE sessions > 1 
  GROUP BY country 
  ORDER BY country