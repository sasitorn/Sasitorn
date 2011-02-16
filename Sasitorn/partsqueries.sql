/*
Name  : Sasitorn Thongtan
Email : sasitorn@gwmail.gwu.edu
Date  : 1/12/2011
*/
/*1*/
SELECT P.pname
FROM parts P LEFT OUTER JOIN catalog C 
			 ON P.id = C.pid
WHERE C.sid IS NULL;

/*2*/
SELECT S.sname
FROM catalog C, suppliers S
WHERE C.sid = S.id
GROUP BY S.sname
HAVING COUNT (pid) = (SELECT COUNT (*)
					  FROM parts);

/*SELECT DISTINCT S.sname
FROM suppliers S, catalog C, parts P
WHERE	S.id = C.sid AND
	C.pid = P.id;
*/

/*3*/
SELECT DISTINCT S.sname
FROM suppliers S, catalog C, parts P
WHERE	S.id = C.sid AND
	C.pid = P.id AND
	P.color LIKE 'Red';

/*4*/
SELECT P.pname
FROM suppliers S, catalog C, parts P
WHERE	S.id = C.sid
	AND C.pid = P.id 
	AND S.sname LIKE 'Acme Widget Suppliers'
	AND C.pid IN (SELECT pid
		  	  FROM catalog
		  	  GROUP BY pid
		  	  HAVING COUNT(*) = 1);

/*5*/
SELECT c1.sid
FROM Catalog C1
WHERE C1.cost > (	SELECT AVG(cost)
  			FROM catalog C2
			WHERE C1.pid = C2.pid
			GROUP BY C2.pid);

/*6*/
SELECT S.sname, P.pname
FROM catalog C1, parts P, suppliers S
WHERE	C1.sid = S.id
	AND C1.pid = P.id
	AND cost = (SELECT MAX(cost)
			FROM catalog C2
			WHERE C1.pid = C2.pid
			GROUP BY C2.pid);
			
/*7*/
SELECT DISTINCT C1.sid
FROM catalog C1
WHERE C1.sid NOT IN (	SELECT DISTINCT C2.sid
				FROM parts P, catalog C2
				WHERE	P.id = C2.pid
					AND UPPER(P.color) <> 'RED');

/*8*/
SELECT DISTINCT C1.sid
FROM parts P1, catalog C1
WHERE	P1.id = C1.pid
	AND UPPER(P1.color) = 'RED'
INTERSECT						
SELECT DISTINCT C2.sid
FROM parts P2, catalog C2
WHERE	P2.id = C2.pid
	AND UPPER(P2.color) = 'GREEN';

/*9*/
SELECT DISTINCT C1.sid
FROM parts P1, catalog C1
WHERE	P1.id = C1.pid
		AND UPPER(P1.color) = 'RED'
UNION						
SELECT DISTINCT C2.sid
FROM parts P2, catalog C2
WHERE	P2.id = C2.pid
		AND UPPER(P2.color) = 'GREEN';
		
/*10*/
SELECT sname, COUNT (sname) AS "number of parts"
FROM suppliers S, catalog C1
WHERE	S.id = C1.sid
	AND C1.sid IN (	SELECT DISTINCT C2.sid
				FROM parts P, catalog C2
				WHERE	P.id = C2.pid
					AND UPPER(P.color) = 'GREEN')
GROUP BY S.sname;

/*11*/
WITH MIN_MAX_COST AS (	SELECT sid,MAX(cost) as max_cost,
                               MIN(cost) as min_cost
				FROM catalog
				GROUP BY sid )
SELECT M.sid, P1.pname as max_cost_part, M.max_cost, 
       P2.pname as min_cost_part, M.min_cost
FROM MIN_MAX_COST M, catalog C1, catalog C2, parts P1, parts P2
WHERE	M.sid = C1.sid
	AND M.max_cost = C1.cost
	AND C1.pid = P1.id
	AND M.sid = C2.sid
	AND M.min_cost = C2.cost
	AND C2.pid = P2.id
	AND M.sid = (SELECT DISTINCT C1.sid
			 FROM parts P1, catalog C1
			 WHERE P1.id = C1.pid
				 AND UPPER(P1.color) = 'RED'
			 INTERSECT						
			 SELECT DISTINCT C2.sid
			 FROM parts P2, catalog C2
			 WHERE P2.id = C2.pid
				 AND UPPER(P2.color) = 'GREEN');
