--TRIGGER
--UN TIGGER que, si un niño tiene tres o mas faltas de conducta, no se le permita asistir a eventos 
--realizados por el orfanato 

Create or replace function dis_castigos() returns trigger
as
$dis_castigos$
declare
faltas int;
maximo int;
BEGIN
select count(*) into faltas from PROGRAMAS where FALTAS_DE_COMPORTAMIENTO = new.FALTAS_DE_COMPORTAMIENTO;
select FALTAS_MAXIMAS into maximo from COMPORTAMIENTO;
if (faltas >= maximo) then
RAISE EXCEPTION 'el niño o niña no se puede registrar a un evento por alcanzar el limite de faltas de comportamiento';
end if;
return new;
end;
$dis_castigos$
LANGUAGE plpgsql;

--BEFORE AFTER INSTEAD OF
create trigger dis_castigos before insert
on  PROGRAMAS for each row
execute procedure dis_castigos();


--COMPROBACION DEL TRIGGER
--INSERTAR PRIMERO UN NIÑO A UN PROGRAMA
INSERT INTO  programas (ID_PROGRAMA,ID_NINO,TEMA_PROGRAMA, VECES_QUE_SE_REALIZO, OBSERVACIONES ) 
VALUES (020,112,'san patricio','9 veces ', 'ninguna novedad');

--INSERTAR LAS FALTAS MAXIMAS EN LA TABLA COMPORTAMIENTO
INSERT INTO comportamiento (ID_COMPORTAMIENTO , ID_NINO , ID_PROGRAMA, FALTAS_MAXIMAS) 
VALUES (1235,112,020,3);
--TABLA PROGRAMAS, SUPONGAMOS QUE EL NIÑO VAYA A HACER 3 FALTAS, LA 4TA NO NOS DEJARA REGISTRARLO AL PROGRAMA
INSERT INTO  programas (ID_PROGRAMA,ID_NINO,TEMA_PROGRAMA, VECES_QUE_SE_REALIZO, OBSERVACIONES,FALTAS_DE_COMPORTAMIENTO ) 
VALUES (021,112,'carnaval','1 veces ', 'insulto a un señor',1);
INSERT INTO  programas (ID_PROGRAMA,ID_NINO,TEMA_PROGRAMA, VECES_QUE_SE_REALIZO, OBSERVACIONES,FALTAS_DE_COMPORTAMIENTO ) 
VALUES (022,112,'dia de muertos','1 vez ', 'falto al respeto',1);
INSERT INTO  programas (ID_PROGRAMA,ID_NINO,TEMA_PROGRAMA, VECES_QUE_SE_REALIZO, OBSERVACIONES,FALTAS_DE_COMPORTAMIENTO ) 
VALUES (023,112,'dia de camping','1 vez ', 'insulto a una señora',1);
--EN EL CUARTO INGRESO YA NO ME PERMITE INGRESARLO
INSERT INTO  programas (ID_PROGRAMA,ID_NINO,TEMA_PROGRAMA, VECES_QUE_SE_REALIZO, OBSERVACIONES,FALTAS_DE_COMPORTAMIENTO ) 
VALUES (024,112,'rezos ','1 vez ', 'insulto a una señora',1);

