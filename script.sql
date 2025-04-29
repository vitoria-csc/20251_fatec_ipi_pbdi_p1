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


-- ----------------------------------------------------------------
-- 5. Limpeza de valores NULL
--escreva a sua solução aqui

-- ----------------------------------------------------------------