Simple query. I don't know what to comment on :)

An employee is considered to be working in the department on 1999-05-01, if StartDate ≤ ‘1999-05-01’ (has already started working by this date) and one of the following conditions:
1. EndDate ≥ ‘1999-05-01’ (has not yet finished working);
2. EndDate IS NULL (continues to work);

DISTINCT is used to exclude duplicates if an employee has multiple records in different shifts.

