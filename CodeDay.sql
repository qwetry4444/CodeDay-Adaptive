PGDMP                         {            CodeDay    14.7    15.2 S    �
           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �
           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �
           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �
           1262    16558    CodeDay    DATABASE     }   CREATE DATABASE "CodeDay" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE "CodeDay";
                postgres    false                        2615    16559    CodeDay    SCHEMA        CREATE SCHEMA "CodeDay";
    DROP SCHEMA "CodeDay";
                pg_database_owner    false            �
           0    0    SCHEMA "CodeDay"    COMMENT     9   COMMENT ON SCHEMA "CodeDay" IS 'standard public schema';
                   pg_database_owner    false    7                        2615    16560    pgagent    SCHEMA        CREATE SCHEMA pgagent;
    DROP SCHEMA pgagent;
                postgres    false            �
           0    0    SCHEMA pgagent    COMMENT     6   COMMENT ON SCHEMA pgagent IS 'pgAgent system tables';
                   postgres    false    8                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            �
           0    0 
   SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    5                        3079    16561    pgagent 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgagent WITH SCHEMA pgagent;
    DROP EXTENSION pgagent;
                   false    8            �
           0    0    EXTENSION pgagent    COMMENT     >   COMMENT ON EXTENSION pgagent IS 'A PostgreSQL job scheduler';
                        false    2            �            1255    16719    add_user_statistics(integer) 	   PROCEDURE     �   CREATE PROCEDURE "CodeDay".add_user_statistics(IN id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	INSERT INTO "CodeDay".user_progress(id)
	VALUES (id);
END;
$$;
 =   DROP PROCEDURE "CodeDay".add_user_statistics(IN id integer);
       CodeDay          postgres    false    7            �            1255    16720    change_complexity() 	   PROCEDURE       CREATE PROCEDURE "CodeDay".change_complexity()
    LANGUAGE plpgsql
    AS $$
BEGIN 
	UPDATE "CodeDay".tasks
	SET complexity = 'easy'
	WHERE description LIKE '%array%';

UPDATE "CodeDay".tasks
	SET complexity = 'middle'
	WHERE description LIKE '%tree%';
END;
$$;
 .   DROP PROCEDURE "CodeDay".change_complexity();
       CodeDay          postgres    false    7                       1255    16721    delete_task_statistics()    FUNCTION     �   CREATE FUNCTION "CodeDay".delete_task_statistics() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE FROM "CodeDay".task_statistics
	WHERE id_statistics = OLD.id_statistics;
	RETURN NEW;
END;
$$;
 2   DROP FUNCTION "CodeDay".delete_task_statistics();
       CodeDay          postgres    false    7                       1255    16722    delete_user_progress()    FUNCTION     �   CREATE FUNCTION "CodeDay".delete_user_progress() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE FROM "CodeDay".user_progress
	WHERE id = OLD.id_progress;
	RETURN NEW;
END;
$$;
 0   DROP FUNCTION "CodeDay".delete_user_progress();
       CodeDay          postgres    false    7                       1255    16723    delete_worst_tasks() 	   PROCEDURE     �  CREATE PROCEDURE "CodeDay".delete_worst_tasks()
    LANGUAGE plpgsql
    AS $$
DECLARE
	count_dislikes INTEGER := (SELECT count_like FROM "CodeDay".task_statistics WHERE id_statistics = "CodeDay".tasks.id);
	count_likes INTEGER := (SELECT count_dislike FROM "CodeDay".task_statistics WHERE id_statistics = "CodeDay".tasks.id);
BEGIN 

DELETE FROM "CodeDay".tasks
	WHERE  (count_dislikes) / (count_likes + 1) > 15;
END;
$$;
 /   DROP PROCEDURE "CodeDay".delete_worst_tasks();
       CodeDay          postgres    false    7            	           1255    16724 0   get_id_user_most_solved_tasks(character varying)    FUNCTION     �  CREATE FUNCTION "CodeDay".get_id_user_most_solved_tasks(pl character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE id_user_most_solved_tasks INTEGER;
BEGIN
	id_user_most_solved_tasks = 
	CASE WHEN pl = 'c' THEN 
	(SELECT id FROM "CodeDay".users WHERE 
	(SELECT user_progress.count_solved_tasks_with_c FROM "CodeDay".user_progress WHERE "CodeDay".user_progress.id = "CodeDay".users.id_progress) = 
	(SELECT MAX(user_progress.count_solved_tasks_with_c) FROM "CodeDay".user_progress) LIMIT 1)

	WHEN pl = 'cpp' THEN 
	(SELECT id FROM "CodeDay".users WHERE 
	 (SELECT user_progress.count_solved_tasks_with_cpp FROM "CodeDay".user_progress WHERE "CodeDay".user_progress.id = "CodeDay".users.id_progress) = 
	(SELECT MAX(user_progress.count_solved_tasks_with_cpp) FROM "CodeDay".user_progress) LIMIT 1)
	
	WHEN pl = 'python' THEN 
	(SELECT id FROM "CodeDay".users WHERE 
	 (SELECT user_progress.count_solved_tasks_with_python FROM "CodeDay".user_progress WHERE "CodeDay".user_progress.id = "CodeDay".users.id_progress) = 
	(SELECT MAX(user_progress.count_solved_tasks_with_python) FROM "CodeDay".user_progress) LIMIT 1)
	END;
	
	
	RAISE NOTICE 'ID = %', id_user_most_solved_tasks;
	RETURN id_user_most_solved_tasks;
END;
$$;
 M   DROP FUNCTION "CodeDay".get_id_user_most_solved_tasks(pl character varying);
       CodeDay          postgres    false    7            
           1255    16725    get_users_with_count_tasks() 	   PROCEDURE     �   CREATE PROCEDURE "CodeDay".get_users_with_count_tasks()
    LANGUAGE plpgsql
    AS $$
BEGIN 
	SELECT * FROM "CodeDay".users;
END;
$$;
 7   DROP PROCEDURE "CodeDay".get_users_with_count_tasks();
       CodeDay          postgres    false    7                       1255    16726    update_statistics()    FUNCTION     �  CREATE FUNCTION "CodeDay".update_statistics() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
	complexity CHARACTER VARYING := (SELECT complexity FROM "CodeDay".tasks WHERE "CodeDay".tasks.id = NEW.task_id);
BEGIN 
	UPDATE "CodeDay".task_statistics 
	SET solvability_percentage = ((count_successful_try + 1) * 100 / (count_try + 1)),
         count_try = count_try + 1,
	     count_successful_try = count_successful_try + 1
	WHERE "CodeDay".task_statistics.id_statistics = (SELECT id_statistics FROM "CodeDay".tasks WHERE tasks.id = NEW.task_id);
	
	UPDATE "CodeDay".user_progress SET
	count_solved_easy_tasks = (CASE WHEN complexity = 'easy'
  									THEN count_solved_easy_tasks + 1 ELSE count_solved_easy_tasks END),
							   	   
	count_solved_middle_tasks = (CASE WHEN complexity = 'middle'
									  THEN count_solved_middle_tasks + 1 ELSE count_solved_middle_tasks END),
									  
	count_solved_hard_tasks = (CASE WHEN complexity = 'hard'
									THEN count_solved_hard_tasks + 1 ELSE count_solved_hard_tasks END)
	WHERE user_progress.id = (SELECT id_progress FROM "CodeDay".users WHERE "CodeDay".users.id = NEW.user_id);
	RETURN NEW;
END;
$$;
 -   DROP FUNCTION "CodeDay".update_statistics();
       CodeDay          postgres    false    7            �            1259    16727    tasks    TABLE       CREATE TABLE "CodeDay".tasks (
    id integer NOT NULL,
    number smallint NOT NULL,
    task_name character varying(60) NOT NULL,
    topic character varying(40) NOT NULL,
    complexity character varying(10) NOT NULL,
    description text,
    id_statistics integer
);
    DROP TABLE "CodeDay".tasks;
       CodeDay         heap    postgres    false    7            �
           0    0    TABLE tasks    COMMENT     �  COMMENT ON TABLE "CodeDay".tasks IS 'Таблица с общей информацией о задачах.
id - идентификатор
number - порядковый номер
task_name - название
complexity - сложность(легкая, средняя, сложная)
description - описание
id_statistics - идентификатор статистики задачи, внешний ключ на таблицу task_statistic';
          CodeDay          postgres    false    227            �            1259    16732    count_task_in_complexity    VIEW     �   CREATE VIEW "CodeDay".count_task_in_complexity AS
 SELECT tasks.complexity,
    count(*) AS count
   FROM "CodeDay".tasks
  GROUP BY tasks.complexity;
 .   DROP VIEW "CodeDay".count_task_in_complexity;
       CodeDay          postgres    false    227    7            �            1259    17116    decision_process    TABLE     �   CREATE TABLE "CodeDay".decision_process (
    user_id integer NOT NULL,
    taks_id integer NOT NULL,
    attempts_count smallint DEFAULT 0 NOT NULL,
    programming_language character varying(16),
    code character varying(10000)
);
 '   DROP TABLE "CodeDay".decision_process;
       CodeDay         heap    postgres    false    7            �
           0    0    TABLE decision_process    COMMENT     �  COMMENT ON TABLE "CodeDay".decision_process IS 'Таблица содержащая информацию о процессе решения задачи пользователем.
user_id – идентификатор пользователя решающего задачу.
task_id – идентификатор решаемой задачи.
attempts_count – количество раз, сколько пользователь отправил на проверку свою программу
programming_language – язык программирования, на котором пользователь решает задачу.
code – Программный код написанный пользователем';
          CodeDay          postgres    false    242            �            1259    16736    task_statistics    TABLE     
  CREATE TABLE "CodeDay".task_statistics (
    id_statistics integer NOT NULL,
    count_try integer NOT NULL,
    count_successful_try integer NOT NULL,
    solvability_percentage smallint NOT NULL,
    count_like integer NOT NULL,
    count_dislike integer NOT NULL
);
 &   DROP TABLE "CodeDay".task_statistics;
       CodeDay         heap    pg_database_owner    false    7            �
           0    0    TABLE task_statistics    COMMENT     �  COMMENT ON TABLE "CodeDay".task_statistics IS 'Таблица с информацией о статистике задачи.
id_statistics - идентификатор
count_try - количество попыток решения
count_successful_try - количество успешных попыток решения
solvability_percentage - процент решаемости
count_like - количество лайков(поставленных пользователями данной задаче)
count_dislike - количество дизлайков(поставленных пользователями данной задаче)';
          CodeDay          pg_database_owner    false    229            �            1259    16739    task_statistics_id_seq    SEQUENCE     �   CREATE SEQUENCE "CodeDay".task_statistics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE "CodeDay".task_statistics_id_seq;
       CodeDay          pg_database_owner    false    229    7            �
           0    0    task_statistics_id_seq    SEQUENCE OWNED BY     b   ALTER SEQUENCE "CodeDay".task_statistics_id_seq OWNED BY "CodeDay".task_statistics.id_statistics;
          CodeDay          pg_database_owner    false    230            �            1259    16740    tasks_id_seq    SEQUENCE     �   CREATE SEQUENCE "CodeDay".tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE "CodeDay".tasks_id_seq;
       CodeDay          postgres    false    7    227            �
           0    0    tasks_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE "CodeDay".tasks_id_seq OWNED BY "CodeDay".tasks.id;
          CodeDay          postgres    false    231            �            1259    16741    tasks_with_statistics    VIEW     �  CREATE VIEW "CodeDay".tasks_with_statistics AS
 SELECT tasks.id_statistics,
    tasks.id,
    tasks.number,
    tasks.task_name,
    tasks.topic,
    tasks.complexity,
    tasks.description,
    task_statistics.count_try,
    task_statistics.count_successful_try,
    task_statistics.solvability_percentage,
    task_statistics.count_like,
    task_statistics.count_dislike
   FROM ("CodeDay".tasks
     JOIN "CodeDay".task_statistics USING (id_statistics));
 +   DROP VIEW "CodeDay".tasks_with_statistics;
       CodeDay          postgres    false    229    227    227    227    229    229    229    229    229    227    227    227    227    7            �            1259    16745 
   user_progress    TABLE     �  CREATE TABLE "CodeDay".user_progress (
    id integer NOT NULL,
    count_solved_easy_tasks smallint DEFAULT 0 NOT NULL,
    count_solved_middle_tasks smallint DEFAULT 0 NOT NULL,
    count_solved_hard_tasks smallint DEFAULT 0 NOT NULL,
    count_solved_tasks_with_c smallint DEFAULT 0 NOT NULL,
    count_solved_tasks_with_cpp smallint DEFAULT 0 NOT NULL,
    count_solved_tasks_with_python smallint DEFAULT 0 NOT NULL
);
 $   DROP TABLE "CodeDay".user_progress;
       CodeDay         heap    postgres    false    7            �
           0    0    TABLE user_progress    COMMENT     �  COMMENT ON TABLE "CodeDay".user_progress IS 'Таблица с информацией о прогрессе пользователя.
id - идентификатор
count_solved_easy_tasks - Количество решенных задач уровня сложности "easy"
count_solved_middle_tasks - Количество решенных задач уровня сложности "middle"
count_solved_hard_tasks - Количество решенных задач уровня сложности "hard"
count_solved_tasks_with_c - Количество задач решенных на языке программирования "C"
count_solved_tasks_with_cpp - Количество задач решенных на языке программирования "C++"
count_solved_tasks_with_python - Количество задач решенных на языке программирования "Python"';
          CodeDay          postgres    false    233            �            1259    16754    user_progress_id_seq    SEQUENCE     �   CREATE SEQUENCE "CodeDay".user_progress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE "CodeDay".user_progress_id_seq;
       CodeDay          postgres    false    233    7            �
           0    0    user_progress_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE "CodeDay".user_progress_id_seq OWNED BY "CodeDay".user_progress.id;
          CodeDay          postgres    false    234            �            1259    16755    user_solved_task    TABLE     h   CREATE TABLE "CodeDay".user_solved_task (
    user_id integer NOT NULL,
    task_id integer NOT NULL
);
 '   DROP TABLE "CodeDay".user_solved_task;
       CodeDay         heap    postgres    false    7            �
           0    0    TABLE user_solved_task    COMMENT     f  COMMENT ON TABLE "CodeDay".user_solved_task IS 'Таблица содержащая информацию о том, какой пользователь, какую задачу решил.
user_id – идентификатор пользователя решившего задачу.
task_id – идентификатор решенной задачи.';
          CodeDay          postgres    false    235            �            1259    16758    users    TABLE     P  CREATE TABLE "CodeDay".users (
    id integer NOT NULL,
    name character varying(80) NOT NULL,
    email character varying(320) NOT NULL,
    gender character varying(10),
    preferred_pl character varying(20),
    phone_number character varying(18),
    birthday date,
    id_progress integer,
    password character varying(32)
);
    DROP TABLE "CodeDay".users;
       CodeDay         heap    postgres    false    7            �
           0    0    TABLE users    COMMENT       COMMENT ON TABLE "CodeDay".users IS 'Таблица с общей информацией о пользователях.
id - идентификатор
name - имя
email - почта
gender - пол
preferred_pl - предпочитаемый язык программирования
phone_number - телефонный номер
birthday - дата дня рождения
password - MD5 хэг пароля
id_progress - идентификатор прогресса, внешний ключ на таблицу user_progress';
          CodeDay          postgres    false    236            �            1259    16761    users1    VIEW     �   CREATE VIEW "CodeDay".users1 AS
 SELECT users.id,
    users.name,
    users.email,
    users.gender,
    users.preferred_pl,
    users.phone_number,
    users.birthday,
    users.id_progress
   FROM "CodeDay".users;
    DROP VIEW "CodeDay".users1;
       CodeDay          postgres    false    236    236    236    236    236    236    236    236    7            �            1259    16765    users_id_seq    SEQUENCE     �   CREATE SEQUENCE "CodeDay".users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE "CodeDay".users_id_seq;
       CodeDay          postgres    false    236    7            �
           0    0    users_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE "CodeDay".users_id_seq OWNED BY "CodeDay".users.id;
          CodeDay          postgres    false    238            �            1259    16766 	   users_man    VIEW     %  CREATE VIEW "CodeDay".users_man AS
 SELECT users.id,
    users.name,
    users.email,
    users.gender,
    users.preferred_pl,
    users.phone_number,
    users.birthday,
    users.id_progress
   FROM "CodeDay".users
  WHERE ((users.gender)::text = 'Man'::text)
  WITH CASCADED CHECK OPTION;
    DROP VIEW "CodeDay".users_man;
       CodeDay          postgres    false    236    236    236    236    236    236    236    236    7            �            1259    16770    users_woman    VIEW     
  CREATE VIEW "CodeDay".users_woman AS
 SELECT users.id,
    users.name,
    users.email,
    users.gender,
    users.preferred_pl,
    users.phone_number,
    users.birthday,
    users.id_progress
   FROM "CodeDay".users
  WHERE (((users.gender)::text = 'Woman'::text) AND (( SELECT sum(((user_progress.count_solved_easy_tasks + user_progress.count_solved_middle_tasks) + user_progress.count_solved_hard_tasks)) AS sum
           FROM "CodeDay".user_progress
          WHERE (user_progress.id = users.id_progress)) <> 0));
 !   DROP VIEW "CodeDay".users_woman;
       CodeDay          postgres    false    233    236    236    233    236    236    236    236    233    233    236    236    7            �            1259    16775    worst_task_in_complexity    VIEW     �   CREATE VIEW "CodeDay".worst_task_in_complexity AS
 SELECT max(tasks.number) AS max,
    tasks.complexity
   FROM "CodeDay".tasks
  GROUP BY tasks.complexity;
 .   DROP VIEW "CodeDay".worst_task_in_complexity;
       CodeDay          postgres    false    227    227    7            �           2604    17109    task_statistics id_statistics    DEFAULT     �   ALTER TABLE ONLY "CodeDay".task_statistics ALTER COLUMN id_statistics SET DEFAULT nextval('"CodeDay".task_statistics_id_seq'::regclass);
 O   ALTER TABLE "CodeDay".task_statistics ALTER COLUMN id_statistics DROP DEFAULT;
       CodeDay          pg_database_owner    false    230    229            �           2604    17110    tasks id    DEFAULT     j   ALTER TABLE ONLY "CodeDay".tasks ALTER COLUMN id SET DEFAULT nextval('"CodeDay".tasks_id_seq'::regclass);
 :   ALTER TABLE "CodeDay".tasks ALTER COLUMN id DROP DEFAULT;
       CodeDay          postgres    false    231    227            �           2604    17111    user_progress id    DEFAULT     z   ALTER TABLE ONLY "CodeDay".user_progress ALTER COLUMN id SET DEFAULT nextval('"CodeDay".user_progress_id_seq'::regclass);
 B   ALTER TABLE "CodeDay".user_progress ALTER COLUMN id DROP DEFAULT;
       CodeDay          postgres    false    234    233            �           2604    17112    users id    DEFAULT     j   ALTER TABLE ONLY "CodeDay".users ALTER COLUMN id SET DEFAULT nextval('"CodeDay".users_id_seq'::regclass);
 :   ALTER TABLE "CodeDay".users ALTER COLUMN id DROP DEFAULT;
       CodeDay          postgres    false    238    236            �
          0    17116    decision_process 
   TABLE DATA           k   COPY "CodeDay".decision_process (user_id, taks_id, attempts_count, programming_language, code) FROM stdin;
    CodeDay          postgres    false    242   �~       �
          0    16736    task_statistics 
   TABLE DATA           �   COPY "CodeDay".task_statistics (id_statistics, count_try, count_successful_try, solvability_percentage, count_like, count_dislike) FROM stdin;
    CodeDay          pg_database_owner    false    229   �~       �
          0    16727    tasks 
   TABLE DATA           h   COPY "CodeDay".tasks (id, number, task_name, topic, complexity, description, id_statistics) FROM stdin;
    CodeDay          postgres    false    227   �~       �
          0    16745 
   user_progress 
   TABLE DATA           �   COPY "CodeDay".user_progress (id, count_solved_easy_tasks, count_solved_middle_tasks, count_solved_hard_tasks, count_solved_tasks_with_c, count_solved_tasks_with_cpp, count_solved_tasks_with_python) FROM stdin;
    CodeDay          postgres    false    233   �       �
          0    16755    user_solved_task 
   TABLE DATA           ?   COPY "CodeDay".user_solved_task (user_id, task_id) FROM stdin;
    CodeDay          postgres    false    235   O�       �
          0    16758    users 
   TABLE DATA           x   COPY "CodeDay".users (id, name, email, gender, preferred_pl, phone_number, birthday, id_progress, password) FROM stdin;
    CodeDay          postgres    false    236   ��       �          0    16562    pga_jobagent 
   TABLE DATA           I   COPY pgagent.pga_jobagent (jagpid, jaglogintime, jagstation) FROM stdin;
    pgagent          postgres    false    212   ؃       �          0    16571    pga_jobclass 
   TABLE DATA           7   COPY pgagent.pga_jobclass (jclid, jclname) FROM stdin;
    pgagent          postgres    false    214   ��       �          0    16581    pga_job 
   TABLE DATA           �   COPY pgagent.pga_job (jobid, jobjclid, jobname, jobdesc, jobhostagent, jobenabled, jobcreated, jobchanged, jobagentid, jobnextrun, joblastrun) FROM stdin;
    pgagent          postgres    false    216   �       �          0    16629    pga_schedule 
   TABLE DATA           �   COPY pgagent.pga_schedule (jscid, jscjobid, jscname, jscdesc, jscenabled, jscstart, jscend, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths) FROM stdin;
    pgagent          postgres    false    220   /�       �          0    16657 
   pga_exception 
   TABLE DATA           J   COPY pgagent.pga_exception (jexid, jexscid, jexdate, jextime) FROM stdin;
    pgagent          postgres    false    222   L�       �          0    16671 
   pga_joblog 
   TABLE DATA           X   COPY pgagent.pga_joblog (jlgid, jlgjobid, jlgstatus, jlgstart, jlgduration) FROM stdin;
    pgagent          postgres    false    224   i�       �          0    16605    pga_jobstep 
   TABLE DATA           �   COPY pgagent.pga_jobstep (jstid, jstjobid, jstname, jstdesc, jstenabled, jstkind, jstcode, jstconnstr, jstdbname, jstonerror, jscnextrun) FROM stdin;
    pgagent          postgres    false    218   ��       �          0    16687    pga_jobsteplog 
   TABLE DATA           |   COPY pgagent.pga_jobsteplog (jslid, jsljlgid, jsljstid, jslstatus, jslresult, jslstart, jslduration, jsloutput) FROM stdin;
    pgagent          postgres    false    226   ��       �
           0    0    task_statistics_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('"CodeDay".task_statistics_id_seq', 3, true);
          CodeDay          pg_database_owner    false    230            �
           0    0    tasks_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('"CodeDay".tasks_id_seq', 8, true);
          CodeDay          postgres    false    231            �
           0    0    user_progress_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('"CodeDay".user_progress_id_seq', 5, true);
          CodeDay          postgres    false    234            �
           0    0    users_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('"CodeDay".users_id_seq', 27, true);
          CodeDay          postgres    false    238            !
           2606    17123 &   decision_process decision_process_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY "CodeDay".decision_process
    ADD CONSTRAINT decision_process_pkey PRIMARY KEY (user_id);
 S   ALTER TABLE ONLY "CodeDay".decision_process DROP CONSTRAINT decision_process_pkey;
       CodeDay            postgres    false    242            
           2606    16784 $   task_statistics task_statistics_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY "CodeDay".task_statistics
    ADD CONSTRAINT task_statistics_pkey PRIMARY KEY (id_statistics);
 Q   ALTER TABLE ONLY "CodeDay".task_statistics DROP CONSTRAINT task_statistics_pkey;
       CodeDay            pg_database_owner    false    229            
           2606    16786    tasks tasks_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY "CodeDay".tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);
 =   ALTER TABLE ONLY "CodeDay".tasks DROP CONSTRAINT tasks_pkey;
       CodeDay            postgres    false    227            
           2606    16788     user_progress user_progress_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY "CodeDay".user_progress
    ADD CONSTRAINT user_progress_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY "CodeDay".user_progress DROP CONSTRAINT user_progress_pkey;
       CodeDay            postgres    false    233            
           2606    16790 &   user_solved_task user_solved_task_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY "CodeDay".user_solved_task
    ADD CONSTRAINT user_solved_task_pkey PRIMARY KEY (user_id, task_id);
 S   ALTER TABLE ONLY "CodeDay".user_solved_task DROP CONSTRAINT user_solved_task_pkey;
       CodeDay            postgres    false    235    235            
           2606    16792    users users_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY "CodeDay".users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 =   ALTER TABLE ONLY "CodeDay".users DROP CONSTRAINT users_pkey;
       CodeDay            postgres    false    236            )
           2620    16793 #   user_solved_task update_solved_task    TRIGGER     �   CREATE TRIGGER update_solved_task AFTER INSERT ON "CodeDay".user_solved_task FOR EACH ROW EXECUTE FUNCTION "CodeDay".update_statistics();
 ?   DROP TRIGGER update_solved_task ON "CodeDay".user_solved_task;
       CodeDay          postgres    false    235    267            (
           2620    16794 &   tasks update_task_statistics_on_delete    TRIGGER     �   CREATE TRIGGER update_task_statistics_on_delete AFTER DELETE ON "CodeDay".tasks FOR EACH ROW EXECUTE FUNCTION "CodeDay".delete_task_statistics();
 B   DROP TRIGGER update_task_statistics_on_delete ON "CodeDay".tasks;
       CodeDay          postgres    false    260    227            *
           2620    16795 $   users update_user_progress_on_delete    TRIGGER     �   CREATE TRIGGER update_user_progress_on_delete AFTER DELETE ON "CodeDay".users FOR EACH ROW EXECUTE FUNCTION "CodeDay".delete_user_progress();
 @   DROP TRIGGER update_user_progress_on_delete ON "CodeDay".users;
       CodeDay          postgres    false    236    263            &
           2606    17129 .   decision_process decision_process_taks_id_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY "CodeDay".decision_process
    ADD CONSTRAINT decision_process_taks_id_fkey FOREIGN KEY (taks_id) REFERENCES "CodeDay".tasks(id) NOT VALID;
 [   ALTER TABLE ONLY "CodeDay".decision_process DROP CONSTRAINT decision_process_taks_id_fkey;
       CodeDay          postgres    false    227    242    3351            '
           2606    17124 .   decision_process decision_process_user_id_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY "CodeDay".decision_process
    ADD CONSTRAINT decision_process_user_id_fkey FOREIGN KEY (user_id) REFERENCES "CodeDay".users(id) NOT VALID;
 [   ALTER TABLE ONLY "CodeDay".decision_process DROP CONSTRAINT decision_process_user_id_fkey;
       CodeDay          postgres    false    242    236    3359            "
           2606    16796    tasks tasks_id_statistics_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY "CodeDay".tasks
    ADD CONSTRAINT tasks_id_statistics_fkey FOREIGN KEY (id_statistics) REFERENCES "CodeDay".task_statistics(id_statistics) NOT VALID;
 K   ALTER TABLE ONLY "CodeDay".tasks DROP CONSTRAINT tasks_id_statistics_fkey;
       CodeDay          postgres    false    229    3353    227            #
           2606    16801 .   user_solved_task user_solved_task_task_id_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY "CodeDay".user_solved_task
    ADD CONSTRAINT user_solved_task_task_id_fkey FOREIGN KEY (task_id) REFERENCES "CodeDay".tasks(id) NOT VALID;
 [   ALTER TABLE ONLY "CodeDay".user_solved_task DROP CONSTRAINT user_solved_task_task_id_fkey;
       CodeDay          postgres    false    3351    227    235            $
           2606    16806 .   user_solved_task user_solved_task_user_id_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY "CodeDay".user_solved_task
    ADD CONSTRAINT user_solved_task_user_id_fkey FOREIGN KEY (user_id) REFERENCES "CodeDay".users(id) NOT VALID;
 [   ALTER TABLE ONLY "CodeDay".user_solved_task DROP CONSTRAINT user_solved_task_user_id_fkey;
       CodeDay          postgres    false    3359    235    236            %
           2606    16811    users users_id_progress_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY "CodeDay".users
    ADD CONSTRAINT users_id_progress_fkey FOREIGN KEY (id_progress) REFERENCES "CodeDay".user_progress(id) NOT VALID;
 I   ALTER TABLE ONLY "CodeDay".users DROP CONSTRAINT users_id_progress_fkey;
       CodeDay          postgres    false    3355    236    233            �
   
   x������ � �      �
   D   x�M���0c(�s��T����ȑ�-$S0,.�F�h�c�&�d��7�i.�����|I��      �
     x��T�n�0=�_�c�:Ff�ErҦ���(�$�E����@�g�/){��z�%n��O�����!YZ�&�!�Ai������
u�> hhz�����	6�9��߀��K�@��Hj�
��x�D?a��j	Y�I͊5W7��+������ƴi�a���0	�m��@}�� h�������n����������'T|^�H�d�I�9�fz�"�51/NՉtW네��|�G�?�5�P4�:Q���9�ej�J|Mܽ�:�^v�ҡ�`�b{���pu��ɯ�o��K���X��7�G�>�y[���L�JCkd)H�߱[a�����O���r����yX3������s��1�s1#��T
ֶ�VN�<�]�},��$�0O����ft���4�z>��i_X �_&�V��E��q���K����)����bs�oc����WpMq#��0=\lv|t&s�^u�E�=Ƈ���W	M�N�su��ھi��g_7�;�6f���v,��dŗ�����|��UU��T�r�����C��)8P��\}D\aL�5�3��=r�Yc@ާ��`aI�R@,����w�֮Ǭu�͘���E*u^�Wꎥ�����%����4�w��2CG�:�,ޖ��8�K)Y�,�õ'�f��3����Nk&n!�!��R�z#�0f��ݞʐP��VS�<�ȝ6�F�)�u	�G�q��m�u	��
,��I��ߚa�C���ȦJ]UQ� xb#n      �
   7   x�-��
  B�3cJ[����$�p�yBA�\�_n���[�qƼFrO��ʻH>J��      �
   =   x�ʱ 1��X�b�>�#
�Qr�V���B+���fc�0ޯa�^�F�|�.K      �
   ,  x����J1F�g_��L&��殢7"� �M���bC���?b����e%�$�/���s��M���E�a���T�����'�=k���
	d!m�>��a��e�kt����k�����1@�m�}�/�����2"H�Jؤ�L��C����q%���B�s*��k�I����yۉ�n<����x�wM-�l\AI
Z�Fi<���&$�e�۽(�m1��
5,�����u�m!�'���wE�)�L���$����C�wP�n����ؖü����Œ���&ĒWځ��Xγ,��t�1      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �     