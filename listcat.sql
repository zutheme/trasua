set @str1 = '';
#select @str1:= CONCAT(@str1,cs.namecat,',') as listcat from (SELECT * FROM `catehasproduct` where idproduct = 68 and idcategory > 0) as c JOIN categories as cs on c.idcategory = cs.idcategory;
#SELECT person_id, GROUP_CONCAT(hobbies SEPARATOR ', ')
#FROM peoples_hobbies
#GROUP BY person_id;
select GROUP_CONCAT(cat.namecat SEPARATOR ', ') as listcat from (select cs.idcategory,cs.namecat from (SELECT * FROM `catehasproduct` where idproduct = 68 and idcategory > 0) as c JOIN categories as cs on c.idcategory = cs.idcategory) as cat;
