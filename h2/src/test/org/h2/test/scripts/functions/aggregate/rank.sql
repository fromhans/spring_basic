-- Copyright 2004-2019 H2 Group. Multiple-Licensed under the MPL 2.0,
-- and the EPL 1.0 (https://h2database.com/html/license.html).
-- Initial Developer: H2 Group
--

CREATE TABLE TEST(V INT) AS VALUES 1, 2, 3, 3, 4, 5, 6;
> ok

SELECT
    RANK(1) WITHIN GROUP (ORDER BY V) R1,
    RANK(3) WITHIN GROUP (ORDER BY V) R3,
    RANK(7) WITHIN GROUP (ORDER BY V) R7
    FROM TEST;
> R1 R3 R7
> -- -- --
> 1  3  8
> rows: 1

SELECT
    DENSE_RANK(1) WITHIN GROUP (ORDER BY V) R1,
    DENSE_RANK(3) WITHIN GROUP (ORDER BY V) R3,
    DENSE_RANK(7) WITHIN GROUP (ORDER BY V) R7
    FROM TEST;
> R1 R3 R7
> -- -- --
> 1  3  7
> rows: 1

SELECT
    ROUND(PERCENT_RANK(1) WITHIN GROUP (ORDER BY V), 2) R1,
    ROUND(PERCENT_RANK(3) WITHIN GROUP (ORDER BY V), 2) R3,
    ROUND(PERCENT_RANK(7) WITHIN GROUP (ORDER BY V), 2) R7
    FROM TEST;
> R1  R3   R7
> --- ---- ---
> 0.0 0.29 1.0
> rows: 1

SELECT
    ROUND(CUME_DIST(1) WITHIN GROUP (ORDER BY V), 2) R1,
    ROUND(CUME_DIST(3) WITHIN GROUP (ORDER BY V), 2) R3,
    ROUND(CUME_DIST(7) WITHIN GROUP (ORDER BY V), 2) R7
    FROM TEST;
> R1   R3   R7
> ---- ---- ---
> 0.25 0.63 1.0
> rows: 1

SELECT
    RANK(1, 1) WITHIN GROUP (ORDER BY V, V + 1) R11,
    RANK(1, 2) WITHIN GROUP (ORDER BY V, V + 1) R12,
    RANK(1, 3) WITHIN GROUP (ORDER BY V, V + 1) R13
    FROM TEST;
> R11 R12 R13
> --- --- ---
> 1   1   2
> rows: 1

SELECT
    RANK(1, 1) WITHIN GROUP (ORDER BY V, V + 1 DESC) R11,
    RANK(1, 2) WITHIN GROUP (ORDER BY V, V + 1 DESC) R12,
    RANK(1, 3) WITHIN GROUP (ORDER BY V, V + 1 DESC) R13
    FROM TEST;
> R11 R12 R13
> --- --- ---
> 2   1   1
> rows: 1

SELECT RANK(3) WITHIN GROUP (ORDER BY V) FILTER (WHERE V <> 2) FROM TEST;
>> 2

SELECT
    RANK(1) WITHIN GROUP (ORDER BY V) OVER () R1,
    RANK(3) WITHIN GROUP (ORDER BY V) OVER () R3,
    RANK(7) WITHIN GROUP (ORDER BY V) OVER () R7,
    V
    FROM TEST ORDER BY V;
> R1 R3 R7 V
> -- -- -- -
> 1  3  8  1
> 1  3  8  2
> 1  3  8  3
> 1  3  8  3
> 1  3  8  4
> 1  3  8  5
> 1  3  8  6
> rows (ordered): 7

SELECT
    RANK(1) WITHIN GROUP (ORDER BY V) OVER (ORDER BY V) R1,
    RANK(3) WITHIN GROUP (ORDER BY V) OVER (ORDER BY V) R3,
    RANK(7) WITHIN GROUP (ORDER BY V) OVER (ORDER BY V) R7,
    RANK(7) WITHIN GROUP (ORDER BY V) FILTER (WHERE V <> 2) OVER (ORDER BY V) F7,
    V
    FROM TEST ORDER BY V;
> R1 R3 R7 F7 V
> -- -- -- -- -
> 1  2  2  2  1
> 1  3  3  2  2
> 1  3  5  4  3
> 1  3  5  4  3
> 1  3  6  5  4
> 1  3  7  6  5
> 1  3  8  7  6
> rows (ordered): 7

SELECT
    RANK(1) WITHIN GROUP (ORDER BY V) FILTER (WHERE FALSE) R,
    DENSE_RANK(1) WITHIN GROUP (ORDER BY V) FILTER (WHERE FALSE) D,
    PERCENT_RANK(1) WITHIN GROUP (ORDER BY V) FILTER (WHERE FALSE) P,
    CUME_DIST(1) WITHIN GROUP (ORDER BY V) FILTER (WHERE FALSE) C
    FROM VALUES (1) T(V);
> R D P   C
> - - --- ---
> 1 1 0.0 1.0
> rows: 1

SELECT RANK(1) WITHIN GROUP (ORDER BY V, V) FROM TEST;
> exception SYNTAX_ERROR_2

SELECT RANK(1, 2) WITHIN GROUP (ORDER BY V) FROM TEST;
> exception SYNTAX_ERROR_2

SELECT RANK(V) WITHIN GROUP (ORDER BY V) FROM TEST;
> exception INVALID_VALUE_2

DROP TABLE TEST;
> ok