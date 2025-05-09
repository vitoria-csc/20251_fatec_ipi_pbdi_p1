-- ----------------------------------------------------------------
-- 1 Base de dados e criação de tabela
--escreva a sua solução aqui
CREATE TABLE student_prediction(
STUDENTID SERIAL PRIMARY KEY,
MOTHER_EDU INT,
FATHER_EDU INT,
SALARY INT,
PREP_STUDY INT,
PREP_EXAM INT,
GRADE INT
);

-- ----------------------------------------------------------------
-- 2 Resultado em função da formação dos pais
--escreva a sua solução aqui
DO $$
DECLARE
    cur_alunos_aprovados REFCURSOR;
    v_student INT;
    v_grade INT := 0;
    v_mother_edu INT := 6;
    v_father_edu INT := 6;
    v_nome_tabela VARCHAR(200) := 'student_prediction';
    v_total_aprovados INT := 0;
BEGIN
    OPEN cur_alunos_aprovados FOR EXECUTE
    format(
        '
        SELECT
            studentid
        FROM
            %s
        WHERE
            grade > $1 AND (mother_edu >= $2 OR father_edu >= $3)
        ',
        v_nome_tabela
    ) USING v_grade, v_mother_edu, v_father_edu;

    LOOP
        FETCH cur_alunos_aprovados INTO v_student;
        EXIT WHEN NOT FOUND;
        v_total_aprovados := v_total_aprovados + 1;
    END LOOP;
    CLOSE cur_alunos_aprovados;
    RAISE NOTICE 'Aprovados: %', v_total_aprovados;
END;
$$;

-- ----------------------------------------------------------------
-- 3 Resultado em função dos estudos
--escreva a sua solução aqui
DO $$ 
DECLARE 
       alunos_aprovados REFCURSOR;
	   v_grade INT := 0;
	   v_student INT;
	   v_prep_study INT := 1;
	   v_nome_tabela VARCHAR(200) := 'student_prediction';
	   total_aprovados INT := 0;
BEGIN
      OPEN alunos_aprovados FOR EXECUTE
      format
      (
         '
           SELECT
           studentid
            FROM
            %s
            WHERE 
			grade > $1 AND prep_study = $2
          '
          ,
    v_nome_tabela
   )USING v_grade,v_prep_study;

  
    LOOP
      FETCH alunos_aprovados INTO v_student;
	  EXIT WHEN NOT FOUND;
	  total_aprovados:= total_aprovados + 1;
	 
    END LOOP;
    IF total_aprovados = 0 THEN
    RAISE NOTICE '-1';
    END IF;
    close alunos_aprovados;
    RAISE NOTICE '%',total_aprovados;
 END;
 $$;

-- ----------------------------------------------------------------
-- 4 Salário versus estudos
--escreva a sua solução aqui
DO $$
DECLARE
	v_salary INT := 5;
	v_prep_exam INT := 2;
	cur_preparacao CURSOR (salary INT, prep_exam INT) FOR SELECT studentid FROM
	student_prediction WHERE student_prediction.salary >= v_salary AND student_prediction.prep_exam = v_prep_exam;
	v_studentid INT;
	v_contagem INT := 0;
BEGIN
	OPEN cur_preparacao (prep_exam := v_prep_exam, salary := v_salary);
		LOOP
			FETCH cur_preparacao INTO v_studentid;
			EXIT WHEN NOT FOUND;
			v_contagem := v_contagem + 1;
		END LOOP;
		CLOSE cur_preparacao;
		RAISE NOTICE 'Total de alunos: %', v_contagem;
END;
$$

-- ----------------------------------------------------------------
-- 5. Limpeza de valores NULL
--escreva a sua solução aqui
DO $$
DECLARE
      cursor_null REFCURSOR;
	  tuplas RECORD;
BEGIN
    OPEN cursor_null SCROLL FOR
	SELECT 
	* 
	FROM 
	student_prediction;
	LOOP
	 FETCH cursor_null INTO tuplaS;
     EXIT WHEN NOT FOUND;
	 RAISE NOTICE '%',tuplas;
	 IF tuplas.grade IS NULL THEN
	 DELETE FROM student_prediction WHERE CURRENT OF cursor_null;
     ELSEIF tuplas.mother_edu IS NULL THEN
	 DELETE FROM student_prediction WHERE CURRENT OF cursor_null;
	 ELSEIF tuplas.father_edu IS NULL THEN
	 DELETE FROM student_prediction WHERE CURRENT OF cursor_null;
	 ELSEIF tuplas.salary IS NULL THEN
	 DELETE FROM student_prediction WHERE CURRENT OF cursor_null;
	 ELSEIF tuplas.prep_study IS NULL THEN
	 DELETE FROM student_prediction WHERE CURRENT OF cursor_null;
	 ELSEIF tuplas.prep_exam IS NULL THEN
	 DELETE FROM student_prediction WHERE CURRENT OF cursor_null;
	 ELSEIF tuplas.studentid IS NULL THEN
	 DELETE FROM student_prediction WHERE CURRENT OF cursor_null;
     END IF;
	 END LOOP;
     LOOP
     FETCH BACKWARD FROM cursor_null INTO tuplas;
     EXIT WHEN NOT FOUND;
     RAISE NOTICE '%', tuplas;
     END LOOP;
     CLOSE cursor_null;
     END;
     $$
     
-- ----------------------------------------------------------------