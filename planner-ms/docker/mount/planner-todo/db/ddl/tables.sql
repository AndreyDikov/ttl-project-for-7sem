CREATE SCHEMA todo;


CREATE TABLE IF NOT EXISTS todo.category
(
    title text COLLATE pg_catalog."default" NOT NULL,
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    completed_count bigint,
    uncompleted_count bigint,
    email text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT category_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS todo.category
    OWNER to postgres;

COMMENT ON TABLE todo.category
    IS '    название – обязательное значение
    к какому пользователю относится – обязательное значение';
-- Index: categorytitle_index

-- DROP INDEX IF EXISTS todo.categorytitle_index;

CREATE INDEX IF NOT EXISTS categorytitle_index
    ON todo.category USING btree
    (title COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;


CREATE TABLE IF NOT EXISTS todo.priority
(
    title text COLLATE pg_catalog."default" NOT NULL,
    color text COLLATE pg_catalog."default" NOT NULL,
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    email text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT priority_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS todo.priority
    OWNER to postgres;

COMMENT ON TABLE todo.priority
    IS '    название – обязательное значение
    цвет (для визуального разделения) – обязательное значение
    к какому пользователю относится – обязательное значение';


CREATE TABLE IF NOT EXISTS todo.stat
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    completed_total bigint,
    uncompleted_total bigint,
    email text COLLATE pg_catalog."default",
    CONSTRAINT stat_pkey PRIMARY KEY (id),
    CONSTRAINT userid_constr_stat UNIQUE (email)
        INCLUDE(email)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS todo.stat
    OWNER to postgres;



CREATE TABLE IF NOT EXISTS todo.task
(
    title text COLLATE pg_catalog."default" NOT NULL,
    completed smallint NOT NULL DEFAULT 0,
    task_date timestamp without time zone,
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    category_id bigint,
    priority_id bigint,
    email text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT task_pkey PRIMARY KEY (id),
    CONSTRAINT category_fkey FOREIGN KEY (category_id)
        REFERENCES todo.category (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT priority_fkey FOREIGN KEY (priority_id)
        REFERENCES todo.priority (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS todo.task
    OWNER to postgres;

COMMENT ON TABLE todo.task
    IS 'задачи пользователя
    название – обязательное значение
    статус (завершен или нет) – обязательное значение
    дата (срок) – НЕобязательное значение - без учета часового пояса
    приоритет – НЕобязательное значение
    категория – НЕобязательное значение
    к какому пользователю относится – обязательное значение';
-- Index: categoryid_index

-- DROP INDEX IF EXISTS todo.categoryid_index;

CREATE INDEX IF NOT EXISTS categoryid_index
    ON todo.task USING btree
    (category_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: title_index

-- DROP INDEX IF EXISTS todo.title_index;

CREATE INDEX IF NOT EXISTS title_index
    ON todo.task USING btree
    (title COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: add_task_trigger

-- DROP TRIGGER IF EXISTS add_task_trigger ON todo.task;

CREATE OR REPLACE FUNCTION todo.add_task()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

	/* можно было упаковать все условия в один if-else, но тогда он становится не очень читабельным */
    
    /*  категория НЕПУСТАЯ                и       статус задачи ЗАВЕРШЕН */
    if (coalesce(NEW.category_id, 0)>0 and NEW.completed=1     ) then
		update todo.category set completed_count = (coalesce(completed_count, 0)+1) where id = NEW.category_id and email=new.email;
	end if;
	
	
	/*  категория НЕПУСТАЯ                 и       статус задачи НЕЗАВЕРШЕН */
    if (coalesce(NEW.category_id, 0)>0      and      coalesce(NEW.completed, 0) = 0) then
		update todo.category set uncompleted_count = (coalesce(uncompleted_count, 0)+1) where id = NEW.category_id and email=new.email;
	end if;
	
	
	  /* общая статистика */
	if coalesce(NEW.completed, 0) = 1 then
		update todo.stat set completed_total = (coalesce(completed_total, 0)+1)  where email=new.email;
	else
		update todo.stat set uncompleted_total = (coalesce(uncompleted_total, 0)+1)  where email=new.email;
    end if;

   

	RETURN NEW;

END
$BODY$;

ALTER FUNCTION todo.add_task()
    OWNER TO postgres;



CREATE OR REPLACE FUNCTION todo.delete_task()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
	/* можно было упаковать все условия в один if-else, но тогда он становится не очень читабельным */

    /*  категория НЕПУСТАЯ                 и        статус задачи ЗАВЕРШЕН */
    if (coalesce(old.category_id, 0)>0       and       coalesce(old.completed, 0)=1) then
		update todo.category set completed_count = (coalesce(completed_count, 0)-1) where id = old.category_id and email=old.email;
	end if;
    
	/*  категория НЕПУСТАЯ                и         статус задачи НЕЗАВЕРШЕН */
    if (coalesce(old.category_id, 0)>0      and        coalesce(old.completed, 0)=0) then
		update todo.category set uncompleted_count = (coalesce(uncompleted_count, 0)-1) where id = old.category_id and email=old.email;
	end if;
	
	
	 /* общая статистика */
	if coalesce(old.completed, 0)=1 then
		update todo.stat set completed_total = (coalesce(completed_total, 0)-1)  where email=old.email;
	else
		update todo.stat set uncompleted_total = (coalesce(uncompleted_total, 0)-1)  where email=old.email;
    end if;
    

	RETURN OLD;
    
END
$BODY$;

ALTER FUNCTION todo.delete_task()
    OWNER TO postgres;


CREATE OR REPLACE FUNCTION todo.update_task()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

  /* изменили completed с 0 на 1, НЕ изменили категорию */
    IF ( coalesce(old.completed,0)=0 and new.completed=1      and     coalesce(old.category_id,0) = coalesce(new.category_id,0)     ) THEN    
    
		/* у неизмененной категории кол-во незавершенных уменьшится на 1,  кол-во завершенных увеличится на 1 */
		update todo.category set uncompleted_count = (coalesce(uncompleted_count, 0)-1), completed_count = (coalesce(completed_count,0)+1) where id = old.category_id and email=old.email; 
        
		 /* общая статистика */
		update todo.stat set uncompleted_total = (coalesce(uncompleted_total,0)-1), completed_total = (coalesce(completed_total,0)+1)  where email=old.email;

      
	END IF;
    
    
    /* изменили completed c 1 на 0, НЕ изменили категорию */
    IF (   coalesce(old.completed,1) =1 and new.completed=0       and   coalesce(old.category_id,0) = coalesce(new.category_id,0)   ) THEN    
    
		/* у неизмененной категории кол-во завершенных уменьшится на 1, кол-во незавершенных увеличится на 1 */
		update todo.category set completed_count = (coalesce(completed_count,0)-1), uncompleted_count = (coalesce(uncompleted_count,0)+1) where id = old.category_id and email=old.email; 
       
	      /* общая статистика */
		update todo.stat set completed_total = (coalesce(completed_total,0)-1), uncompleted_total = (coalesce(uncompleted_total,0)+1)  where email=old.email;

    
	END IF;
    
    
    
	/* изменили категорию, не изменили completed=1 */
    IF ( coalesce(old.category_id,0) <> coalesce(new.category_id,0)      	and      coalesce(old.completed,1) = 1 and new.completed=1   ) THEN    
    
		/* у старой категории кол-во завершенных уменьшится на 1 */
		update todo.category set completed_count = (coalesce(completed_count,0)-1) where id = old.category_id and email=old.email; 

        
		/* у новой категории кол-во завершенных увеличится на 1 */
		update todo.category set completed_count = (coalesce(completed_count,0)+1) where id = new.category_id and email=old.email; 
	
	
		/* общая статистика не изменяется */
 
	END IF;
    
    
    
    
        
    /* изменили категорию, не изменили completed=0 */
    IF (coalesce(old.category_id,0) <> coalesce(new.category_id,0)     and   coalesce(old.completed,0)= 0  and new.completed=0   ) THEN    
    
		/* у старой категории кол-во незавершенных уменьшится на 1 */
		update todo.category set uncompleted_count = (coalesce(uncompleted_count,0)-1) where id = old.category_id and email=old.email; 

		/* у новой категории кол-во незавершенных увеличится на 1 */
		update todo.category set uncompleted_count = (coalesce(uncompleted_count,0)+1) where id = new.category_id and email=old.email; 
       
    
	  	/* общая статистика не изменяется */
      
	END IF;
    
    
    
    
    
	
    /* изменили категорию, изменили completed с 1 на 0 */
    IF ( coalesce(old.category_id,0) <> coalesce(new.category_id,0)     and   coalesce(old.completed,1) =1 and new.completed=0   ) THEN    
    
		/* у старой категории кол-во завершенных уменьшится на 1 */
		update todo.category set completed_count = (coalesce(completed_count,0)-1) where id = old.category_id and email=old.email; 
        
		/* у новой категории кол-во незавершенных увеличится на 1 */
		update todo.category set uncompleted_count = (coalesce(uncompleted_count,0)+1) where id = new.category_id and email=old.email; 

  		/* общая статистика */
		update todo.stat set uncompleted_total = (coalesce(uncompleted_total,0)+1), completed_total = (coalesce(completed_total,0)-1)  where email=old.email;
       
	END IF;
    
    
            
    /* изменили категорию, изменили completed с 0 на 1 */
    IF (   coalesce(old.completed,0) =0 and new.completed=1      and   coalesce(old.category_id,0) <> coalesce(new.category_id,0)     ) THEN    
    
		/* у старой категории кол-во незавершенных уменьшится на 1 */
		update todo.category set uncompleted_count = (coalesce(uncompleted_count,0)-1) where id = old.category_id and email=old.email; 
        
		/* у новой категории кол-во завершенных увеличится на 1 */
		update todo.category set completed_count = (coalesce(completed_count,0)+1) where id = new.category_id and email=old.email; 
        
      /* общая статистика */
		update todo.stat set uncompleted_total = (coalesce(uncompleted_total,0)-1), completed_total = (coalesce(completed_total,0)+1)  where email=old.email;
	 	 
	END IF;
    
    
	

	
	RETURN NEW;
	
	END;
$BODY$;

ALTER FUNCTION todo.update_task()
    OWNER TO postgres;



CREATE OR REPLACE TRIGGER add_task_trigger
    AFTER INSERT
    ON todo.task
    FOR EACH ROW
    EXECUTE FUNCTION todo.add_task();

-- Trigger: delete_task_trigger

-- DROP TRIGGER IF EXISTS delete_task_trigger ON todo.task;

CREATE OR REPLACE TRIGGER delete_task_trigger
    BEFORE DELETE
    ON todo.task
    FOR EACH ROW
    EXECUTE FUNCTION todo.delete_task();

-- Trigger: update_task_trigger

-- DROP TRIGGER IF EXISTS update_task_trigger ON todo.task;

CREATE OR REPLACE TRIGGER update_task_trigger
    BEFORE UPDATE 
    ON todo.task
    FOR EACH ROW
    EXECUTE FUNCTION todo.update_task();
