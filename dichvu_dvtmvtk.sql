-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Máy chủ: localhost
-- Thời gian đã tạo: Th8 04, 2019 lúc 10:49 AM
-- Phiên bản máy phục vụ: 5.6.42
-- Phiên bản PHP: 7.2.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `dichvu_dvtmvtk`
--

DELIMITER $$
--
-- Thủ tục
--
CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `activity_interactive` (IN `_idimport` INT(11))  BEGIN
  DECLARE _parent_idpost_exp int;
  set _parent_idpost_exp = (select idpost from impposts where idimppost = _idimport);
	select p.body, ( select icon from post_types where idposttype = p.id_post_type) as icon , expp.id_status_type, expp.url_avatar, expp.firstname, expp.middlename, expp.lastname, expp.created_at from (select exp.*, pr.firstname, pr.lastname, pr.middlename, pr.url_avatar from (select * from expposts where parent_idpost_exp = _parent_idpost_exp) as exp join profile as pr on pr.iduser = exp.idemployee) as expp join posts as p on expp.idpost = p.idpost;
END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `AddMenuItemProcedure` (IN `_idmenu` INT(11), IN `_idcategory` INT(11), IN `_idparent` INT(11), IN `_depth` INT(11), IN `_reorder` INT(11), IN `_trash` INT(6))  BEGIN
               insert into menu_has_cate( idmenu, idcategory, idparent, depth, reorder, trash ) values ( _idmenu, _idcategory, _idparent, _depth, _reorder, _trash);
							 select LAST_INSERT_ID() as idmenuhascate;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `AddProductProcedure` (IN `_idproduct` INT(11), IN `_namestore` VARCHAR(255))  BEGIN
                declare _idstore int;
                set _idstore = (select idcategory from categories where shortname = _namestore);
                insert into exp_products(idproduct,iduser,amount,price,idstore,size,ice_water,sugar,topping) values(_idproduct,_iduser,_amount,_price,_idstore,_size,_ice_water,_sugar,_topping); 
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `CategoryByIdcatetype` (IN `_idcatetype` INT(11))  BEGIN
                select * from categories where idcattype = _idcatetype; 
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `CategoryHasProduct` (IN `_list_idcat` VARCHAR(255), IN `_idproduct` INT(11))  BEGIN
                declare list_idcat varchar(255);
                set @_sign = ",";
                call split_string(_list_idcat, _idproduct, @_sign, list_idcat); 
                SET @s = CONCAT("INSERT INTO catehasproduct (idproduct,idcategory) VALUES ", list_idcat); 
                PREPARE stmt1 FROM @s; 
                EXECUTE stmt1; 
                DEALLOCATE PREPARE stmt1;
								
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `CompleteListOrderProcedure` (IN `_ordernumber` INT(11))  BEGIN 
select  ordpro.*,(select urlfile from files where idfile = ordpro.idfile) as urlfile from (select p.namepro,p.short_desc,(select idfile from producthasfile where idproduct = p.idproduct and hastype="thumbnail" ORDER BY idproducthasfile desc limit 1) as idfile, ex.* from (select * from exp_products where ordernumber = _ordernumber) as ex join products as p on ex.idproduct = p.idproduct) as ordpro;  
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `CreateMenuHasIdCateProcedure` (IN `_str_query` VARCHAR(255))  BEGIN
                SET @sqlv=_str_query;
                PREPARE stmt FROM @sqlv;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;  
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `CreateProfileProcedure` (IN `_iduser` INT, IN `_firstname` VARCHAR(255), IN `_middlename` VARCHAR(255), IN `_lastname` VARCHAR(255), IN `_address` VARCHAR(255), IN `_idcitytown` INT, IN `_iddistrict` INT, IN `_mobile` VARCHAR(255), IN `_about` VARCHAR(255), IN `_facebook` VARCHAR(255), IN `_zalo` VARCHAR(255), IN `_url_avatar` VARCHAR(255))  BEGIN
                insert into profile(iduser, firstname, middlename, lastname, address, idcitytown, iddistrict, mobile, about, facebook , zalo, url_avatar) values (_iduser, _firstname, _middlename, _lastname, _address, _idcitytown, _iddistrict, _mobile, _about, _facebook , _zalo, _url_avatar);
            SELECT LAST_INSERT_ID() as idprofile;
						END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `CreatPostApiProcedure` (IN `_firstname` VARCHAR(255) CHARSET utf8mb4, IN `_body` TEXT CHARSET utf8mb4, IN `_nametype` VARCHAR(255), IN `_idfile` INT(11), IN `_namecat` VARCHAR(255), IN `_mobile` VARCHAR(255), IN `_email` VARCHAR(255), IN `_address` VARCHAR(255) CHARSET utf8mb4, IN `_name_status_type` VARCHAR(250), IN `_birthday` VARCHAR(255), IN `_job` VARCHAR(255) CHARSET utf8mb4, IN `_facebook` VARCHAR(255) CHARSET utf8mb4)  BEGIN
            DECLARE _idcategory INT;
            DECLARE _idposttype INT;
            DECLARE _idpost INT;
            DECLARE _idcattype INT;
            DECLARE _catnametype VARCHAR(255);
            DECLARE _hastype VARCHAR(255);
            DECLARE _idcustomer INT;
            DECLARE _percent_process INT;
            DECLARE _id_status_type INT;
            DECLARE _id_imppost INT;
            SET _percent_process = 0;
            SET _id_status_type = (SELECT id_status_type FROM status_types WHERE name_status_type = _name_status_type);
            SET _catnametype = "website";
            SET _idcattype = (SELECT idcattype FROM category_types WHERE catnametype=_catnametype); 
            SET _idposttype = (SELECT idposttype FROM post_types WHERE nametype = _nametype);
            SET _hastype = "image";
            IF EXISTS(SELECT _idcustomer FROM sv_customers WHERE mobile = _mobile LIMIT 1) THEN
                BEGIN
                SET _idcustomer = (SELECT idcustomer FROM sv_customers WHERE mobile = _mobile LIMIT 1);
                END;
            ELSE
                BEGIN
                INSERT INTO sv_customers(firstname, email, mobile, address, birthday, job, facebook) VALUES(_firstname,_email,_mobile,_address, _birthday, _job, _facebook);
                SET _idcustomer = LAST_INSERT_ID();
                END;
            END IF;
            IF EXISTS(SELECT idcategory FROM categories WHERE namecat = _namecat LIMIT 1) THEN
                BEGIN
                SET _idcategory = (SELECT idcategory FROM categories WHERE namecat = _namecat LIMIT 1);
                END;
            ELSE
                BEGIN
                INSERT INTO categories(namecat,idcattype,idparent) VALUES(_namecat,_idcattype,NULL); 
                SET _idcategory = LAST_INSERT_ID();
                END;
            END IF;
            INSERT INTO posts(body,id_post_type,idcategory) VALUES(_body,_idposttype,_idcategory);
            SET _idpost = LAST_INSERT_ID();
            INSERT INTO post_has_files (idpost,hastype,idfile) VALUES(_idpost,_hastype,_idfile);
            INSERT INTO impposts(idpost,id_status_type,percent_process,iduser_imp,address_reg) VALUES(_idpost,_id_status_type,_percent_process,_idcustomer,_address);
            SET _id_imppost = LAST_INSERT_ID();
            SELECT _id_imppost;
        END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `CrossProductHasFileProcedure` (IN `_idproduct` INT(11), IN `_cross_idproduct` INT(11), IN `_idfile` INT(11), IN `_crosstype` VARCHAR(255))  BEGIN
                insert into cross_product(idproduct,crosstype,idproduct_cross) values(_idproduct,_crosstype,_cross_idproduct);
                insert into producthasfile(idproduct,hastype,idfile,status_file) values(_cross_idproduct,"thumbnail",_idfile,1);
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `customer_interactive` (IN `_parent_idpost_exp` INT, IN `_body` TEXT CHARSET utf8mb4, IN `_id_post_type` INT, IN `_id_status_type` INT, IN `_idemployee` INT)  BEGIN
	DECLARE	_idpost INT;
	INSERT INTO posts(body,id_post_type) VALUES(_body,_id_post_type);
        SET _idpost = LAST_INSERT_ID();
        INSERT INTO expposts(idpost,id_status_type,idemployee,parent_idpost_exp) VALUES(_idpost,_id_status_type,_idemployee,_parent_idpost_exp);
	select LAST_INSERT_ID() as id_exppost;
END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `DeleteProducthasFileProcedure` (IN `_idproducthasfile` INT(11))  BEGIN
                UPDATE producthasfile set status_file = 0 where idproducthasfile = _idproducthasfile;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `DeleteUserProcedure` (IN `_iduser` INT)  BEGIN
                delete from users where id=_iduser;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `DetailByIdProductProcedure` (IN `_idproduct` INT(11))  BEGIN
                 DECLARE id_thumbnail int;
                                declare url_thumbnail varchar(255);
                                set id_thumbnail =  (SELECT idfile from producthasfile WHERE idproduct=_idproduct and hastype="thumbnail" ORDER BY idproducthasfile DESC LIMIT 1);
                                set url_thumbnail = (SELECT urlfile FROM files where idfile = id_thumbnail);
                                select p.idproduct,p.namepro,p.slug,p.short_desc,p.description,p.idsize,(select `value` from size where idsize=p.idsize) as _size, p.idcolor,p.id_post_type,p.created_at as created_pro,p.updated_at as updated_pro,imp.*,id_thumbnail, url_thumbnail from (select * FROM products WHERE idproduct=_idproduct) as p join (SELECT * from imp_products where idproduct=_idproduct ORDER BY idimp DESC LIMIT 1) as imp on p.idproduct = imp.idproduct;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `DetailCustomerProcedure` (IN `_iduser` INT(11))  BEGIN
    select cus.firstname,cus.middlename, cus.lastname,cus.mobile,cus.email, (CONCAT_WS(', ',address,(select namedist from district where iddistrict = cus.iddistrict),(select namecitytown from city_town where idcitytown = cus.idcitytown))) as address from sv_customers as cus where idcustomer = _iduser;
END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `DetailInteractive` (IN `_idimport` INT)  BEGIN
	select post_imp.*, cus.* from (select p.idpost, p.body, imp.iduser_imp from (select * from impposts where idimppost = _idimport) as imp left join posts as p on imp.idpost=p.idpost) as post_imp join
	 sv_customers as cus on cus.idcustomer = post_imp.iduser_imp;
    END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `Getparentidprocedure` (IN `id_post` INT(11))  BEGIN
                  DECLARE A INT;
                  DECLARE XYZ Varchar(50);
                  SET A = 1;
                  SET XYZ = "";
                  WHILE A <=10 DO
                  SET XYZ = CONCAT(XYZ,A,",");
                  SET A = A + 1;
                  END WHILE;
                  SELECT XYZ;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ImportProductProcedure` (IN `_idproduct` INT(11), IN `_idcustomer` INT(11), IN `_iduser` INT(11), IN `_amount` DOUBLE(20,0), IN `_price_import` DOUBLE(20,0), IN `_price` DOUBLE(20,0), IN `_price_sale_origin` DOUBLE(20,0), IN `_note` TEXT, IN `_idstore` INT(11), IN `_axis_x` INT(11), IN `_axis_y` INT(11), IN `_axis_z` INT(11), IN `_id_status_type` INT(11))  BEGIN
                INSERT INTO imp_products(idproduct, idcustomer, iduser, amount, price_import, price, price_sale_origin,  note, idstore, axis_x, axis_y, axis_z,id_status_type) VALUES ( _idproduct, _idcustomer, _iduser, _amount, _price_import, _price, _price_sale_origin, _note, _idstore, _axis_x, _axis_y, _axis_z,_id_status_type);             
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ImppermbyidProcedure` (IN `idimpperm` INT(11))  BEGIN
                SELECT imp.idimp_perm, imp.idperm, p.name as nameperm,p.description as desperm, imp.idrole, r.name as namerole,r.description as desrole,u.name as nameuser FROM (select * from imp_perms where idimp_perm = idimpperm) as imp left join permissions as p ON imp.idperm = p.idperm LEFT join roles as r on imp.idrole = r.idrole LEFT join users as u ON imp.iduserimp = u.id;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `InfoOrderProductProcedure` (IN `_ordernumber` INT(11))  BEGIN
                select inf.*, (inf.price_top+inf.price_parent) as unit_price, ((inf.price_top+inf.price_parent)*inf.amount_panent) as mountxprice from (select GROUP_CONCAT(info_order.l_topping SEPARATOR " ") as ltopping, sum(info_order.price) as price_top, info_order.parentidproduct, info_order.namepro, info_order.amount_panent,info_order.price_parent, info_order.urlparent, info_order.created_at from (select CONCAT("<li><lable>",info.topping,"</label> <span class=\"currency\">",info.price,"</span><span class=\"vnd\"></span></li>") as l_topping,info.idproduct, info.parentidproduct, info.price, info.namepro, price_parent, info.amount_panent,info.urlparent, info.created_at from (select cte1.namepro as topping, cte1.idproduct,cte1.parentidproduct, cte1.amount, cte1.price, cte1.urlfile ,cte2.namepro,cte2.price as price_parent,cte2.amount as amount_panent,cte2.urlfile as urlparent, cte2.created_at from (select  ordpro.namepro,ordpro.idproduct,parentidproduct,ordpro.amount,ordpro.price,(select urlfile from files where idfile = ordpro.idfile) as urlfile from (select p.namepro,(select idfile from producthasfile where idproduct = p.idproduct and hastype="thumbnail" ORDER BY idproducthasfile desc limit 1) as idfile, ex.* from (select * from exp_products where ordernumber =  _ordernumber) as ex join products as p on ex.idproduct = p.idproduct) as ordpro) as cte1 LEFT JOIN (select  ordpro.namepro,ordpro.idproduct,parentidproduct,ordpro.amount,ordpro.price,(select urlfile from files where idfile = ordpro.idfile) as urlfile, ordpro.created_at from (select p.namepro,(select idfile from producthasfile where idproduct = p.idproduct and hastype="thumbnail" ORDER BY idproducthasfile desc limit 1) as idfile, ex.* from (select * from exp_products where ordernumber =  _ordernumber and parentidproduct = 0) as ex join products as p on ex.idproduct = p.idproduct) as ordpro) as cte2 on cte1.parentidproduct = cte2.idproduct) as info) as info_order GROUP BY info_order.parentidproduct) as inf;    
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `InsertFilePath` (IN `_str_list_file` VARCHAR(255), OUT `_idfile` INT(11))  BEGIN
                
                SET @s = CONCAT('INSERT INTO files(urlfile,name_origin,namefile, typefile) VALUES ', _str_list_file); 
                PREPARE stmt1 FROM @s; 
                EXECUTE stmt1; 
                DEALLOCATE PREPARE stmt1;
                set _idfile = LAST_INSERT_ID();
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `InsertFilesProcedure` (IN `_urlfile` VARCHAR(255), IN `_name_origin` VARCHAR(255), IN `_namefile` VARCHAR(255), IN `_typefile` VARCHAR(255))  BEGIN
                INSERT INTO files(urlfile,name_origin,namefile, typefile) VALUES (_urlfile,_name_origin, _namefile, _typefile);
                SELECT LAST_INSERT_ID() as idfile;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `InsertPostProcedure` (IN `_title` VARCHAR(255), IN `_body` TEXT, IN `_slug` VARCHAR(255), IN `_id_post_type` INT(11), IN `_idcategory` INT(11), IN `_id_status_type` INT(11), IN `_processing` DECIMAL(6,2), IN `_iduser_imp` INT(11))  BEGIN
                INSERT INTO posts(title, body, slug, id_post_type, idcategory) VALUES ( _title, _body, _slug, _id_post_type, _idcategory);
                    SET @_idpost = LAST_INSERT_ID();
                    INSERT INTO impposts(idpost, id_status_type, processing, iduser_imp) VALUES ( @_idpost, _id_status_type, _processing, _iduser_imp);
                    select @_idpost as outidpost;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `InsertProductProcedure` (IN `_namepro` VARCHAR(255) CHARSET utf8mb4, IN `_description` TEXT CHARSET utf8mb4, IN `_short_desc` TEXT CHARSET utf8mb4, IN `_slug` VARCHAR(255) CHARSET utf8mb4, IN `_id_post_type` INT(11), IN `_idcustomer` INT(11), IN `_idemployee` INT(11), IN `_amount` FLOAT(10), IN `_price` FLOAT(10), IN `_note` TEXT CHARSET utf8mb4, IN `_idstore` INT(11), IN `_axis_x` INT(11), IN `_axis_y` INT(11), IN `_axis_z` INT(11), IN `_size` VARCHAR(10) CHARSET utf8mb4, IN `_ice_water` FLOAT(10), IN `_sugar` FLOAT(10), IN `_topping` VARCHAR(255) CHARSET utf8mb4, IN `_status_type` INT(11), IN `_list_idcat` VARCHAR(255) CHARSET utf8mb4, IN `_list_file` TEXT CHARSET utf8mb4, IN `_thumbnail` TEXT CHARSET utf8mb4)  BEGIN
                DECLARE _idproduct INT;
								DECLARE _idfile INT;
								DECLARE list_file VARCHAR(255);
								DECLARE list_idcat VARCHAR(255);
								DECLARE str_query VARCHAR(255);
								set _idproduct = 0;
								INSERT INTO products(namepro, description, short_desc, slug, id_post_type) VALUES ( _namepro, _description, _short_desc , _slug, _id_post_type );
                SET _idproduct = LAST_INSERT_ID();								
                INSERT INTO imp_products(idproduct, idcustomer, idemployee, amount, price, note, idstore, axis_x, axis_y, axis_z, size, ice_water, sugar, topping, status_type) VALUES ( _idproduct, _idcustomer, _idemployee, _amount, _price, _note, _idstore, _axis_x, _axis_y, _axis_z, _size, _ice_water, _sugar, _topping, _status_type);							
							  call CategoryHasProduct(_list_idcat, _idproduct);
								#call ProducthasFile(_thumbnail, ";","thumbnail", _idproduct);
								call ProducthasFile(_list_file, ";","gallery", _idproduct);				
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListAllCatByTypeProcedure` (IN `_namecattype` VARCHAR(255))  BEGIN
        DECLARE _idcattype INT;
        SET _idcattype = (SELECT idcattype FROM category_types WHERE catnametype = _namecattype);
        IF _idcattype > 0 THEN
        BEGIN
           SELECT c.idcategory, c.shortname, c.namecat, _namecattype as catnametype, c.idparent, (select namecat from categories WHERE idcategory = c.idparent) as parent FROM categories as c WHERE idcattype = _idcattype;
        END; 
        ELSE
        BEGIN
           SELECT c.* FROM categories as c;    
        END;
        END IF;
        END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListAllCateByIdcatetype` (IN `_idcatetype` INT(11))  BEGIN
               IF _idcatetype > 0 THEN
                    BEGIN
                       SELECT c.idcategory, c.shortname, c.namecat, c.idparent, (select namecat from categories WHERE idcategory = c.idparent) as parent FROM categories as c WHERE idcattype = _idcatetype;
                    END; 
                ELSE
                    BEGIN
                       SELECT c.* FROM categories as c;    
                    END;
                END IF;  
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListAllCategoryProcedure` ()  BEGIN
            SELECT idcategory,namecat,idparent FROM categories;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListCateByIdmenuProcedure` (IN `_idmenu` INT(11))  BEGIN
               SELECT * FROM menu_has_cate WHERE idmenu=_idmenu;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListCategoryByTypeProcedure` ()  BEGIN
	SELECT idcategory, namecat from categories;
    END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListCategoryProcedure` ()  BEGIN
                SELECT c1.idcategory, c1.namecat, c1.idcattype, (select catnametype from category_types where idcattype=c1.idcattype) as catnametype, c2.namecat as parent from categories as c1 left Join categories as c2 on c1.idparent = c2.idcategory;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListcatparentProcedure` ()  BEGIN
                SELECT c1.idcategory, c1.namecat from categories as c1 where c1.idparent = 0;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListCustomerRegister` (IN `_start_date` VARCHAR(255), IN `_end_date` VARCHAR(255), IN `_idcategory` INT(11), IN `_id_post_type` INT(11), IN `_id_status_type` INT(11), IN `_sel_receive` INT(11))  BEGIN
        DECLARE _now VARCHAR(255);
        DECLARE _str_start VARCHAR(255);
        DECLARE _now_time VARCHAR(255);
        SET _now_time = NOW();
        IF ( _start_date IS NULL OR _start_date ="") THEN
        BEGIN
            SET _now = DATE(_now_time);
            SET _str_start = CONCAT(_now," 00:00:00");
            SET _start_date = STR_TO_DATE(_str_start,"%Y-%m-%d %H:%i:%s");          
        END;
        END IF;
        IF ( _end_date IS NULL OR _end_date = "") THEN SET _end_date = _now_time;       
        END IF;
        if ( _sel_receive = 0 AND _id_post_type = 0) then
		begin
		    SELECT user_reg.idimppost,user_reg.idpost,(select ROW_COUNT() from expposts where parent_idpost_exp = user_reg.idpost) as count_interactive,user_reg.created_at,cus.mobile,cus.firstname,cus.email,user_reg.body,user_reg.address_reg FROM (SELECT imp.created_at,imp.idpost,imp.idimppost,imp.iduser_imp,po.body,imp.address_reg FROM (SELECT im.* FROM (SELECT * FROM impposts WHERE created_at >= _start_date AND  created_at < _end_date) AS im WHERE im.id_status_type = _id_status_type) AS imp JOIN
		    (SELECT pt.* FROM (SELECT p.* FROM (SELECT idpost,body,id_post_type,idcategory FROM posts WHERE created_at >= _start_date AND created_at < _end_date) AS p WHERE p.idcategory=_idcategory) AS pt WHERE pt.id_post_type = '1' OR pt.id_post_type = '2') AS po ON imp.idpost=po.idpost) AS user_reg JOIN
		    sv_customers AS cus ON user_reg.iduser_imp = cus.idcustomer;
		end;
	elseif ( _sel_receive = 1 AND _id_post_type = 0) then
		BEGIN
		    select user_join.idimppost,user_join.idpost,(select count(*) from expposts where parent_idpost_exp = user_join.idpost) as count_interactive,user_join.created_at,cus.mobile,cus.firstname,cus.email,user_join.body,user_join.address_reg  from (SELECT user_reg.idimppost,user_reg.idpost,user_reg.iduser_imp,user_reg.created_at,user_reg.body,user_reg.address_reg FROM (SELECT imp.created_at,imp.idpost,imp.idimppost,imp.iduser_imp,po.body,imp.address_reg FROM (SELECT im.* FROM (SELECT * FROM impposts WHERE created_at >= _start_date AND  created_at < _end_date) AS im WHERE im.id_status_type='1') AS imp JOIN
		    (SELECT pt.* FROM (SELECT p.* FROM (SELECT idpost,body,id_post_type,idcategory FROM posts WHERE created_at >= _start_date AND created_at < _end_date) AS p WHERE p.idcategory=_idcategory) AS pt WHERE pt.id_post_type = '1' OR pt.id_post_type = '2') AS po ON imp.idpost = po.idpost) AS user_reg LEFT JOIN expposts AS expp ON user_reg.idpost = expp.parent_idpost_exp WHERE expp.parent_idpost_exp IS NULL) as user_join join sv_customers as cus on cus.idcustomer = user_join.iduser_imp;
		end;
	ELSEIF ( _sel_receive = 2 AND _id_post_type = 0 ) then
		BEGIN
		    SELECT user_join.idimppost,user_join.idpost,(select count(*) from expposts where parent_idpost_exp = user_join.idpost) as count_interactive,user_join.created_at,cus.mobile,cus.firstname,cus.email,user_join.body,user_join.address_reg  FROM (SELECT user_reg.idimppost,user_reg.idpost,user_reg.iduser_imp,user_reg.created_at,user_reg.body,user_reg.address_reg FROM (SELECT imp.created_at,imp.idpost,imp.idimppost,imp.iduser_imp,po.body,imp.address_reg FROM (SELECT im.* FROM (SELECT * FROM impposts WHERE created_at >= _start_date AND  created_at < _end_date) AS im WHERE im.id_status_type='1') AS imp JOIN
		    (SELECT pt.* FROM (SELECT p.* FROM (SELECT idpost,body,id_post_type,idcategory FROM posts WHERE created_at >= _start_date AND created_at < _end_date) AS p WHERE p.idcategory=_idcategory) AS pt WHERE pt.id_post_type = '1' OR pt.id_post_type = '2') AS po ON imp.idpost = po.idpost) AS user_reg right JOIN ( select * from expposts GROUP BY parent_idpost_exp ) AS expp ON user_reg.idpost = expp.parent_idpost_exp) AS user_join JOIN sv_customers AS cus ON cus.idcustomer = user_join.iduser_imp;
		END;
	elseIF ( _sel_receive = 0 AND _id_post_type > 0) THEN
		BEGIN
		    SELECT user_reg.idimppost,user_reg.idpost,(select count(*) from expposts where parent_idpost_exp = user_reg.idpost) as count_interactive,user_reg.created_at,cus.mobile,cus.firstname,cus.email,user_reg.body,user_reg.address_reg FROM (SELECT imp.created_at,imp.idpost,imp.idimppost,imp.iduser_imp,po.body,imp.address_reg FROM (SELECT im.* FROM (SELECT * FROM impposts WHERE created_at >= _start_date AND  created_at < _end_date) AS im WHERE im.id_status_type = _id_status_type) AS imp JOIN
		    (SELECT pt.* FROM (SELECT p.* FROM (SELECT idpost,body,id_post_type,idcategory FROM posts WHERE created_at >= _start_date AND created_at < _end_date) AS p WHERE p.idcategory=_idcategory) AS pt WHERE pt.id_post_type = _id_post_type) AS po ON imp.idpost=po.idpost) AS user_reg JOIN
		    sv_customers AS cus ON user_reg.iduser_imp = cus.idcustomer;
		END;
	ELSEIF ( _sel_receive = 1 AND _id_post_type > 0) THEN
		BEGIN
		    SELECT user_join.idimppost,user_join.idpost,(select count(*) from expposts where parent_idpost_exp = user_join.idpost) as count_interactive,user_join.created_at,cus.mobile,cus.firstname,cus.email,user_join.body,user_join.address_reg  FROM (SELECT user_reg.idimppost,user_reg.idpost,user_reg.iduser_imp,user_reg.created_at,user_reg.body,user_reg.address_reg FROM (SELECT imp.created_at,imp.idpost,imp.idimppost,imp.iduser_imp,po.body,imp.address_reg FROM (SELECT im.* FROM (SELECT * FROM impposts WHERE created_at >= _start_date AND  created_at < _end_date) AS im WHERE im.id_status_type='1') AS imp JOIN
		    (SELECT pt.* FROM (SELECT p.* FROM (SELECT idpost,body,id_post_type,idcategory FROM posts WHERE created_at >= _start_date AND created_at < _end_date) AS p WHERE p.idcategory=_idcategory) AS pt WHERE pt.id_post_type = _id_post_type) AS po ON imp.idpost = po.idpost) AS user_reg LEFT JOIN expposts AS expp ON user_reg.idpost = expp.parent_idpost_exp WHERE expp.parent_idpost_exp IS NULL) AS user_join JOIN sv_customers AS cus ON cus.idcustomer = user_join.iduser_imp;
		END;
	ELSEIF ( _sel_receive = 2 AND _id_post_type > 0 ) THEN
		BEGIN
		    SELECT user_join.idimppost,user_join.idpost,(select count(*) from expposts where parent_idpost_exp = user_join.idpost) as count_interactive,user_join.created_at,cus.mobile,cus.firstname,cus.email,user_join.body,user_join.address_reg  FROM (SELECT user_reg.idimppost,user_reg.idpost,user_reg.iduser_imp,user_reg.created_at,user_reg.body,user_reg.address_reg FROM (SELECT imp.created_at,imp.idpost,imp.idimppost,imp.iduser_imp,po.body,imp.address_reg FROM (SELECT im.* FROM (SELECT * FROM impposts WHERE created_at >= _start_date AND  created_at < _end_date) AS im WHERE im.id_status_type='1') AS imp JOIN
		    (SELECT pt.* FROM (SELECT p.* FROM (SELECT idpost,body,id_post_type,idcategory FROM posts WHERE created_at >= _start_date AND created_at < _end_date) AS p WHERE p.idcategory=_idcategory) AS pt WHERE pt.id_post_type = _id_post_type) AS po ON imp.idpost = po.idpost) AS user_reg RIGHT JOIN expposts AS expp ON user_reg.idpost = expp.parent_idpost_exp) AS user_join JOIN sv_customers AS cus ON cus.idcustomer = user_join.iduser_imp;
		END;
        end if;  
        END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListDepartmentProcedure` ()  BEGIN
                SELECT c1.iddepart, c1.namedepart, c2.namedepart as parent from departments as c1 left Join departments as c2 on c1.idparent = c2.iddepart;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListDepartParentProcedure` ()  BEGIN
                SELECT c1.iddepart, c1.namedepart from departments as c1 where c1.idparent is null;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListgrantbyidProcedure` (IN `id_grant` INT(11))  BEGIN
                SELECT r.idrole, r.name as namerole, g.to_iduser,(select name from users where id = g.to_iduser) as touser, g.by_iduser,(select name from users where id = g.by_iduser) as byuser FROM (select * from grants where idgrant = id_grant) as g LEFT join roles as r on g.idrole = r.idrole;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListgrantProcedure` ()  BEGIN
                SELECT g.idgrant, r.idrole, r.name as namerole, (select name from users where id = g.to_iduser) as touser, (select name from users where id=g.by_iduser) as byuser from grants as g LEFT join roles as r on g.idrole = r.idrole;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListImppermProcedure` ()  BEGIN
                SELECT imp.idimp_perm, p.name as nameperm, r.name as namerole, u.name as nameuser FROM imp_perms as imp left join permissions as p ON imp.idperm = p.idperm LEFT join roles as r on imp.idrole = r.idrole LEFT join users as u ON imp.iduserimp = u.id;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListItemCateByIdMenuProcedure` (IN `_idmenu` INT(11))  BEGIN
               SELECT mnhas.idmenuhascate, mnhas.idmenu,mnhas.idcategory,(select namecat from categories where idcategory = mnhas.idcategory) as namemenu, mnhas.idparent, mnhas.reorder, mnhas.depth, mnhas.trash FROM menu_has_cate as mnhas WHERE idmenu=_idmenu ORDER BY reorder ASC;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListMenuProcedure` ()  BEGIN
               select * from menus;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListOrderProductProcedure` (IN `_start_date` VARCHAR(255), IN `_end_date` VARCHAR(255), IN `_idstore` INT(11), IN `_id_post_type` INT(11), IN `_id_status_type` INT(11), IN `_sel_receive` INT(11))  BEGIN
		    DECLARE _now VARCHAR(255);
        DECLARE _str_start VARCHAR(255);
        DECLARE _now_time VARCHAR(255);
        SET _now_time = NOW();
        IF ( _start_date IS NULL OR _start_date ="") THEN
        BEGIN
            SET _now = DATE(_now_time);
            SET _str_start = CONCAT(_now," 00:00:00");
            SET _start_date = STR_TO_DATE(_str_start,"%Y-%m-%d %H:%i:%s");          
        END;
        END IF;
        IF ( _end_date IS NULL OR _end_date = "") THEN SET _end_date = _now_time;       
        END IF;  
               select exp.ordernumber, exp.created_at, case when (exp.iduser > 0) THEN (select CONCAT_WS('</p> ',CONCAT_WS(' ',p.lastname, p.middlename, p.firstname),CONCAT_WS(' ',p.address, (select namedist from district where iddistrict = p.iddistrict), (select namecitytown from city_town where idcitytown = p.idcitytown)),p.mobile) from `profile` as p where iduser = exp.iduser) when (exp.idcustomer > 0) THEN  (select CONCAT_WS('</p>',CONCAT_WS(' ',cus.lastname,cus.middlename,cus.firstname),CONCAT_WS(', ',cus.address, (select namedist from district where iddistrict = cus.iddistrict), (select namecitytown from city_town where idcitytown = cus.idcitytown)),cus.mobile) from sv_customers as cus WHERE idcustomer = exp.idcustomer) END as customer, case when (exp.idrecipent > 0) THEN  (select CONCAT_WS('</p>',CONCAT_WS(' ',cus.lastname,cus.middlename,cus.firstname),CONCAT_WS(', ',cus.address, (select namedist from district where iddistrict = cus.iddistrict), (select namecitytown from city_town where idcitytown = cus.idcitytown)),cus.mobile) from sv_customers as cus WHERE idcustomer = exp.idrecipent)
                    when (exp.idcustomer > 0) THEN  (select CONCAT_WS('</p>',CONCAT_WS(' ',cus.lastname,cus.middlename,cus.firstname),CONCAT_WS(', ',cus.address, (select namedist from district where iddistrict = cus.iddistrict), (select namecitytown from city_town where idcitytown = cus.idcitytown)),cus.mobile) from sv_customers as cus WHERE idcustomer = exp.idcustomer) 
                    ELSE (select CONCAT_WS('</p> ',CONCAT_WS(' ',p.lastname, p.middlename, p.firstname),CONCAT_WS(' ',p.address, (select namedist from district where iddistrict = p.iddistrict), (select namecitytown from city_town where idcitytown = p.idcitytown)),p.mobile) from `profile` as p where iduser = exp.iduser) END as recipent, 
                    exp.iduser, exp.idcustomer, exp.idrecipent,exp.itemtotal from (select ex.ordernumber, sum((ex.amount*ex.price)) as itemtotal, ex.created_at, ex.idrecipent, ex.idcustomer, ex.iduser 
                    from (select * from exp_products where created_at >=_start_date and created_at <= _end_date AND idstore=_idstore) as ex GROUP BY ordernumber) as exp;  
                                END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListParentCatByTypeProcedure` (IN `_namecattype` VARCHAR(255))  BEGIN
	DECLARE _idcattype INT;
        SET _idcattype = (SELECT idcattype FROM category_types WHERE catnametype = _namecattype);
        IF _idcattype > 0 THEN
        BEGIN
           SELECT c.idcategory, c.namecat FROM categories as c WHERE c.idcattype = _idcattype and c.idparent is null;
        END; 
        ELSE
        BEGIN
           SELECT c.* FROM categories as c;    
        END;
        END IF;
END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListpostProcedure` ()  BEGIN
                SELECT * from posts;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListPostTypeByIdcatProcedure` (IN `_idcat` INT)  BEGIN
        IF _idcat > 0 THEN
        BEGIN
           SELECT * FROM post_types WHERE idparent = _idcat;
        END; 
        ELSE
        BEGIN
           SELECT * FROM post_types;    
        END;
        END IF;
        END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListProductByIdcateProcedure` (IN `_start_date` VARCHAR(255), IN `_end_date` VARCHAR(255), IN `_idcategory` INT(11), IN `_id_post_type` INT(11), IN `_id_status_type` INT(11), IN `_limit` INT(11))  BEGIN
        DECLARE _now VARCHAR(255);
        DECLARE _str_start VARCHAR(255);
        DECLARE _now_time VARCHAR(255);
        SET _now_time = NOW();
        IF ( _start_date IS NULL OR _start_date ="") THEN
        BEGIN
            SET _now = DATE(_now_time);
            SET _str_start = CONCAT(_now," 00:00:00");
            SET _start_date = STR_TO_DATE(_str_start,"%Y-%m-%d %H:%i:%s");          
        END;
        END IF;
        IF ( _end_date IS NULL OR _end_date = "") THEN SET _end_date = _now_time;       
        END IF;  
            select info.created_at,info.idproduct,info.namepro,info.short_desc, info.price_import, info.price, info.price_sale_origin,info.amount,(select urlfile from files where idfile = info.idfile) as urlfile from (select dtail.created_at,dtail.idproduct,dtail.namepro,dtail.short_desc, dtail.price_import, dtail.price, dtail.price_sale_origin, dtail.amount, dtail.idfile,dtail.author, (select namecat from categories WHERE idcategory = prohas.idcategory) as namecat from ( select detail.created_at,detail.idproduct,detail.namepro,detail.short_desc, detail.price_import, detail.price, detail.price_sale_origin,detail.amount,detail.idfile,(select `name` from users WHERE id = detail.iduser) as author from (select p.created_at,p.idproduct,p.namepro,p.short_desc, imp.price_import, imp.price, imp.price_sale_origin, imp.amount,imp.iduser,(select idfile from producthasfile WHERE idproduct = p.idproduct ORDER BY idproducthasfile DESC LIMIT 1) as idfile  FROM (select pr.* from products as pr left join cross_product as c on pr.idproduct = c.idproduct_cross where c.idcrossproduct is NULL) as p JOIN imp_products as imp on p.idproduct = imp.idproduct) as detail) as dtail JOIN (select cate.* from (select * from catehasproduct where idcategory > 0) as cate left join exclude_category as excat on cate.idcategory = excat.idcategory where excat.idcategory is null ) as prohas on prohas.idproduct = dtail.idproduct) as info GROUP BY info.idproduct DESC LIMIT _limit;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListProductProcedure` (IN `_start_date` VARCHAR(255), IN `_end_date` VARCHAR(255), IN `_idcategory` INT(11), IN `_id_post_type` INT(11), IN `_id_status_type` INT(11))  BEGIN
        DECLARE _now VARCHAR(255);
        DECLARE _str_start VARCHAR(255);
        DECLARE _now_time VARCHAR(255);
        SET _now_time = NOW();
        IF ( _start_date IS NULL OR _start_date ="") THEN
        BEGIN
            SET _now = DATE(_now_time);
            SET _str_start = CONCAT(_now," 00:00:00");
            SET _start_date = STR_TO_DATE(_str_start,"%Y-%m-%d %H:%i:%s");          
        END;
        END IF;
        IF ( _end_date IS NULL OR _end_date = "") THEN SET _end_date = _now_time;       
        END IF;  
            select info.created_at,info.idproduct,info.namepro,info.price,info.amount,(select urlfile from files where idfile = info.idfile) as urlfile,info.author,GROUP_CONCAT(info.namecat SEPARATOR ', ') as listcat from (select dtail.created_at,dtail.idproduct,dtail.namepro,dtail.price,dtail.amount,dtail.idfile,dtail.author, (select namecat from categories WHERE idcategory = prohas.idcategory AND prohas.idcategory is not null) as namecat from ( select detail.created_at,detail.idproduct,detail.namepro,detail.price,detail.amount,detail.idfile,(select `name` from users WHERE id = detail.iduser) as author from (select p.*,imp.price,imp.amount,imp.iduser,(select idfile from producthasfile WHERE idproduct = p.idproduct ORDER BY idproducthasfile DESC LIMIT 1) as idfile FROM (select pr.* from products as pr left join cross_product as c on pr.idproduct = c.idproduct_cross where c.idcrossproduct is NULL) as p JOIN imp_products as imp on p.idproduct = imp.idproduct) as detail) as dtail JOIN (select cate.* from (select * from catehasproduct where idcategory > 0) as cate left join exclude_category as excat on cate.idcategory = excat.idcategory where excat.idcategory is null ) as prohas on prohas.idproduct = dtail.idproduct) as info GROUP BY info.idproduct DESC LIMIT 100;
       END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListRoleIdpermProcedure` (IN `id_perm` INT(11))  BEGIN
                select r.idrole, r.name, p.idimp_perm, p.idrole as id_role from roles as r LEFT join (select * from imp_perms where idperm=id_perm) as p on r.idrole=p.idrole;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListSelEmpDepartProcedure` (IN `_iduser` INT(11))  BEGIN
                SELECT iddepart_employee, iddepart from depart_employees where iduser=_iduser;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListStatusTypeProcedure` (IN `_idparent` INT)  BEGIN
        IF _idparent > 0 THEN
        BEGIN
           SELECT * FROM status_types WHERE idparent = _idparent;
        END; 
        ELSE
        BEGIN
           SELECT * FROM status_types;    
        END;
        END IF;
        END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListTypeSelectedProcedure` (IN `id_post` INT(11))  BEGIN
                SELECT p.id_post_type as idposttype,(select nametype from post_types WHERE idposttype = p.id_post_type) as nameposttype,p.idcategory,(SELECT name FROM categories WHERE idcategory = p.idcategory) as namecate FROM posts as p WHERE p.idpost=id_post;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ListViewProductByIdCateProcedure` (IN `_idcategory` INT(11), IN `_id_post_type` INT(11), IN `_id_status_type` INT(11), IN `_limit` INT(11))  BEGIN
            select allpro.* from (SELECT alp.*,imp.price,imp.price_sale_origin from (select pro.*,(select urlfile from files WHERE idfile = pro.idfile) as url from (select chp.idproduct,p.namepro,p.slug,p.short_desc,p.description,p.idsize,p.idcolor,(select idfile from producthasfile where hastype = 'thumbnail' and idproduct = chp.idproduct ORDER BY idproducthasfile DESC LIMIT 1) as idfile from (SELECT * FROM catehasproduct WHERE idcategory=_idcategory) as chp JOIN products as p on chp.idproduct = p.idproduct) as pro) as alp JOIN (SELECT * from imp_products where idstore=31) as imp on alp.idproduct = imp.idproduct) as allpro order by allpro.idproduct DESC limit _limit;
        END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `MenuHasIdcateProcedure` (IN `_idmenu` INT(11), IN `_idcategory` INT(11), IN `_idparentmenu` INT(11))  BEGIN
               insert into menu_has_cate(idmenu,idcategory,idparentmenu) values (_idmenu,_idcategory,_idparentmenu);  
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `MostPopularProcedure` ()  BEGIN 
                select info.created_at,info.idproduct,info.namepro,info.short_desc, info.price,info.amount,info.urlfile from (select dtail.created_at,dtail.idproduct,dtail.namepro,dtail.short_desc, dtail.price,dtail.amount,dtail.urlfile,dtail.author, (select namecat from categories WHERE idcategory = prohas.idcategory) as namecat from ( select detail.created_at,detail.idproduct,detail.namepro,detail.short_desc, detail.price,detail.amount,f.urlfile,(select `name` from users WHERE id = detail.iduser) as author from (select p.created_at,p.idproduct,p.namepro,p.short_desc, imp.price,imp.amount,imp.iduser,(select idfile from producthasfile WHERE idproduct = p.idproduct ORDER BY idproducthasfile DESC LIMIT 1) as idfile  FROM products as p JOIN imp_products as imp on p.idproduct = imp.idproduct) as detail join files as f on detail.idfile = f.idfile) as dtail JOIN (select * from catehasproduct where idcategory > 0) as prohas on prohas.idproduct = dtail.idproduct) as info limit 8; 
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `OrderProductProcedure` (IN `_ordernumber` INT(11), IN `_idproduct` INT(11), IN `_parentidproduct` INT(11), IN `_idcustomer` INT(11), IN `_idrecipent` INT(11), IN `_iduser` INT(11), IN `_amount` DOUBLE(20,0), IN `_price` DOUBLE(20,0), IN `_note` TEXT CHARSET utf8mb4, IN `_namestore` VARCHAR(255), IN `_axis_x` INT(11), IN `_axis_y` INT(11), IN `_axis_z` INT(11), IN `_id_status_type` INT(11))  BEGIN
								 Declare _idcattype int;
								 DECLARE _idstore int;
								 set _idstore = 0;
                 set _idcattype = (select idcattype from category_types where catnametype="store");
								 set _idstore = (select cat.idcategory from (select idcategory,shortname from categories WHERE idcattype = _idcattype) as cat WHERE cat.shortname=_namestore);
								 INSERT into exp_products(ordernumber, idproduct, parentidproduct, idcustomer, idrecipent, iduser, amount, price, note, idstore, axis_x, axis_y, axis_z, id_status_type) VALUES( _ordernumber, _idproduct, _parentidproduct,_idcustomer, _idrecipent, _iduser, _amount, _price, _note, _idstore, _axis_x, _axis_y, _axis_z, _id_status_type);
								 select LAST_INSERT_ID() as ordernumber;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `PostByIdProcedure` (IN `id_post` INT(11))  BEGIN
                SELECT p.title,p.body,p.slug,p.id_post_type as idposttype,(select nametype from post_types WHERE idposttype = p.id_post_type) as nameposttype,p.idcategory,(SELECT namecat FROM categories WHERE idcategory = p.idcategory) as namecate FROM posts as p WHERE p.idpost=id_post;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `PostHasFileProcedure` (IN `_idpost` INT(11), IN `_idfile` INT(11))  BEGIN
                INSERT INTO post_has_files(idpost,idfile) VALUES (_idpost,_idfile);
                SELECT LAST_INSERT_ID() as idposthasfile;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ProductBelongCategoryProcedure` (IN `_list_idcat` TEXT CHARSET utf8mb4)  BEGIN
                SET @s = CONCAT("INSERT INTO catehasproduct (idproduct,idcategory) VALUES ", _list_idcat); 
                PREPARE stmt1 FROM @s; 
                EXECUTE stmt1; 
                DEALLOCATE PREPARE stmt1;             
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ProducthasFile` (IN `_list_file` TEXT, IN `_sign` VARCHAR(10), IN `_hastype` VARCHAR(255), IN `_idproduct` INT(11))  BEGIN
                DECLARE x INT;
								DECLARE _idfile INT;
                DECLARE str_item VARCHAR(255);
                DECLARE item VARCHAR(255);
                DECLARE result VARCHAR(255);
                DECLARE rs_split VARCHAR(255); 
                SET x = LENGTH(_list_file);
                set result = "";
                set str_item ="";
                SET item = "";
								set _idfile = 0;
                set rs_split = _list_file;
                WHILE x  > 0 DO
                set item = SUBSTRING_INDEX(rs_split, _sign, -1);
                set rs_split = SUBSTRING(_list_file, 1, (LENGTH(rs_split)-LENGTH(item)-1));
                set str_item = CONCAT("(",item,")");
                call InsertFilePath(str_item, _idfile);
								INSERT into producthasfile(idproduct,hastype,idfile) VALUES (_idproduct,_hastype,_idfile);
                set x = LENGTH(rs_split);
                END WHILE;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ProducthasFileProcedure` (IN `_urlfile` VARCHAR(255), IN `_name_origin` VARCHAR(255), IN `_namefile` VARCHAR(255), IN `_typefile` VARCHAR(255), IN `_idproduct` INT(11), IN `_hastype` VARCHAR(255))  BEGIN
               DECLARE _idfile INT(11);
               INSERT INTO files(urlfile,name_origin,namefile, typefile) VALUES (_urlfile,_name_origin, _namefile, _typefile);
               set _idfile = LAST_INSERT_ID();
               INSERT INTO producthasfile(idproduct,hastype,idfile) VALUES (_idproduct,_hastype,_idfile);
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `RelateProductProcedure` ()  BEGIN
                select info.created_at,info.idproduct,info.namepro,info.short_desc, info.price_import, info.price, info.price_sale_origin, info.amount,info.urlfile from (select dtail.created_at,dtail.idproduct,dtail.namepro,dtail.short_desc, dtail.price_import, dtail.price, dtail.price_sale_origin, dtail.amount,dtail.urlfile,dtail.author, (select namecat from categories WHERE idcategory = prohas.idcategory) as namecat from ( select detail.created_at,detail.idproduct,detail.namepro,detail.short_desc, detail.price_import, detail.price, detail.price_sale_origin, detail.amount,f.urlfile,(select `name` from users WHERE id = detail.iduser) as author from (select p.created_at,p.idproduct,p.namepro,p.short_desc, imp.price_import, imp.price, imp.price_sale_origin, imp.amount,imp.iduser,(select idfile from producthasfile WHERE idproduct = p.idproduct and hastype='thumbnail' ORDER BY idproducthasfile DESC LIMIT 1) as idfile  FROM (select pr.* from products as pr left join cross_product as c on pr.idproduct = c.idproduct_cross where c.idcrossproduct is NULL) as p JOIN imp_products as imp on p.idproduct = imp.idproduct) as detail join files as f on detail.idfile = f.idfile) as dtail JOIN (select * from catehasproduct where idcategory > 0) as prohas on prohas.idproduct = dtail.idproduct) as info limit 8; 
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelAllColorProcedure` ()  BEGIN
                select idcolor,value from color; 
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelAllSizeProcedure` ()  BEGIN
                select idsize,value from size; 
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelCategorybyIdProcedure` (IN `idcat` INT(11))  BEGIN
                SELECT c1.idcategory, c1.namecat, c1.idcattype, (select catnametype from category_types where idcattype=c1.idcattype) as catnametype, c1.idparent, c2.namecat as parent from (select * from categories where idcategory=idcat) as c1 left Join categories as c2 on c1.idparent = c2.idcategory;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelCateSelectedProcedure` (IN `_idproduct` INT(11))  BEGIN
                SELECT c.idcateproduct,c.idcategory from catehasproduct as c where c.idproduct = _idproduct;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelCityTownProcedure` ()  BEGIN
                 select idcitytown, namecitytown from city_town; 
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelCrossProductByIdProcedure` (IN `_idproduct` INT(11))  BEGIN
                select pd.*,f.urlfile from (select pro.idproduct,pro.namepro,(select idfile from producthasfile WHERE hastype="thumbnail" and idproduct = pro.idproduct ORDER BY idproducthasfile desc LIMIT 1) as idfile, pro.idsize,(select `value` from size where idsize = pro.idsize) as size,pro.idcolor,(select `value` from color where idcolor = pro.idcolor) as color,imp.price,imp.amount from (select p.* from (SELECT idproduct_cross FROM cross_product WHERE idproduct=_idproduct) as crp left join products as p on p.idproduct = crp.idproduct_cross) as pro join imp_products as imp on pro.idproduct = imp.idproduct) as pd join files f on pd.idfile = f.idfile;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelDepartmentByIdProcedure` (IN `_iddepart` INT(11))  BEGIN
                SELECT c1.iddepart, c1.namedepart, c1.idparent, c2.namedepart as parent from (select * from departments where iddepart=_iddepart) as c1 left Join departments as c2 on c1.idparent = c2.iddepart;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelDicstrictProcedure` (IN `_idcitytown` INT(11))  BEGIN
                 select iddistrict,namedist from district where idcitytown =_idcitytown; 
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelectProfileByIdProcedure` (IN `_idprofile` INT)  BEGIN
	select * from `profile` WHERE idprofile=_idprofile;
END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelectProfileProcedure` (IN `_iduser` INT(11))  BEGIN
                select u.*,p.* from (select id,email from users where id = _iduser) as u JOIN profile as p on u.id = p.iduser;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelGalleryProcedure` (IN `_idproduct` INT(11), IN `_hastype` VARCHAR(255))  BEGIN
                select pf.idproducthasfile,f.idfile,f.urlfile from (SELECT idproducthasfile,idfile from producthasfile  where idproduct = _idproduct and hastype = _hastype and status_file='1') as pf join files as f on pf.idfile = f.idfile;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SellistcategorybyidProcedure` (IN `_idcat` INT(11))  BEGIN
     SELECT idcategory, namecat from categories where idparent = _idcat;
END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelListDepartmentByIdProcedure` (IN `_iddepart` INT(11))  BEGIN
                SELECT c1.iddepart, c1.namedepart from departments as c1 where c1.idparent = _iddepart;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelParentCrossProductProcedure` (IN `_idproduct` INT(11))  BEGIN
                 select idproduct from cross_product where idproduct_cross = _idproduct;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelProductByIdProcedure` (IN `_idproduct` INT(11))  BEGIN
                DECLARE id_thumbnail int;
								declare url_thumbnail varchar(255);
								set id_thumbnail =  (SELECT idfile from producthasfile WHERE idproduct=_idproduct and hastype='thumbnail' ORDER BY idproducthasfile DESC LIMIT 1);
								set url_thumbnail = (SELECT urlfile FROM files where idfile = id_thumbnail);
								select p.namepro,p.slug,p.short_desc,p.description,p.idsize,p.idcolor,p.id_post_type,p.created_at as created_pro,p.updated_at as updated_pro,imp.*,id_thumbnail, url_thumbnail from (select * FROM products WHERE idproduct=_idproduct) as p join (SELECT * from imp_products where idproduct=_idproduct ORDER BY idimp DESC LIMIT 1) as imp on p.idproduct = imp.idproduct;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelRowCategoryByIdProcedure` (IN `_idcategory` INT(11))  BEGIN
                SELECT idcategory, namecat from categories where idcategory = _idcategory;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelSexProcedure` ()  BEGIN
                 select idsex, namesex from sex; 
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `SelToppingProcedure` (IN `_topping` VARCHAR(255))  BEGIN
                 declare _idcategory varchar(255);
                 set _idcategory = (select idcategory FROM categories WHERE shortname=_topping limit 1);
								 IF (_idcategory > 0) THEN
											BEGIN
												select protop.idproduct,protop.namepro,protop.price,protop.amount,(SELECT urlfile from files where idfile = protop.idfile) as url_thumbnail from (select pr.idproduct,(select idfile from producthasfile WHERE idproduct = pr.idproduct and hastype="thumbnail" ORDER BY idproducthasfile DESC LIMIT 1) as idfile,pr.namepro,imp.price,imp.amount from (select p.* from (select idproduct from catehasproduct where idcategory = _idcategory) as catep JOIN products as p on catep.idproduct = p.idproduct) as pr JOIN imp_products as imp on pr.idproduct = imp.idproduct) as protop;
											END;
									END IF;          
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `ShortTotalProcedure` (IN `_ordernumber` INT(11))  BEGIN
               select sum(p.amount * p.price) as total from exp_products as p where ordernumber = _ordernumber;  
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `split_string` (IN `string_split` VARCHAR(255), IN `_idextend` VARCHAR(255), IN `_sign` VARCHAR(10), OUT `outresult` VARCHAR(255))  BEGIN
		DECLARE x INT;
		DECLARE str_item VARCHAR(255);
		DECLARE item VARCHAR(255);
		DECLARE result VARCHAR(255);
		DECLARE rs_split VARCHAR(255); 
		SET x = LENGTH(string_split);
		set result = "";
		set str_item ="";
		SET item = "";
		set rs_split = string_split;
		WHILE x  > 0 DO
		set item = SUBSTRING_INDEX(rs_split,_sign, -1);
		set rs_split = SUBSTRING(string_split, 1, (LENGTH(rs_split)-LENGTH(item)-1));
		set str_item = CONCAT("(",_idextend,",", item,")");
		set result = CONCAT(result,",", str_item);
		set x = LENGTH(rs_split);
		END WHILE;
		set outresult = SUBSTRING(result,2); 
END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `TrashGelleryProcedure` (IN `_idproducthasfile` INT(11))  BEGIN
                update producthasfile set status_file = 0 where idproducthasfile = _idproducthasfile; 
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `UpdateCatehasproProcedure` (IN `_idcateproduct` INT(11))  BEGIN
                update catehasproduct set idcategory = 0 where idcateproduct = _idcateproduct;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `UpdateImportProductProcedure` (IN `_idimp` INT(11), IN `_idcustomer` INT(11), IN `_iduser` INT(11), IN `_amount` DOUBLE(11,2), IN `_price_import` DOUBLE(20,0), IN `_price` DOUBLE(20,0), IN `_price_sale_origin` DOUBLE(20,0), IN `_note` TEXT, IN `_idstore` INT(11), IN `_axis_x` INT(11), IN `_axis_y` INT(11), IN `_axis_z` INT(11), IN `_id_status_type` INT(11))  BEGIN
                update imp_products set idcustomer=_idcustomer, iduser = _iduser, amount = _amount, price_import = _price_import,price = _price, price_sale_origin = _price_sale_origin,note = _note, idstore = _idstore, axis_x = _axis_x, axis_y = _axis_y, axis_z = _axis_z, id_status_type = _id_status_type where idimp = _idimp;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `UpdateImppostByIdProcedure` (IN `id_imp_post` INT(11), IN `id_post` INT(11), IN `id_category` INT(11), IN `id_posttype` INT(11), IN `id_statustype` INT(11), IN `id_user_imp` INT(11))  if (id_imp_post > 0 )  then
                    update impposts set idpost=id_post,idcategory=id_category,id_post_type=id_posttype,id_status_type = id_statustype,iduser_imp = id_user_imp
                    where idimppost = id_imp_post;
                else
                    insert into impposts(idpost,idcategory,id_post_type,id_status_type,iduser_imp) values(id_post,id_category,id_posttype,id_statustype,id_user_imp);
                end if$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `UpdateMenuHasCateProcedure` (IN `_idmenuhascate` INT(11), IN `_idmenu` INT(11), IN `_idcategory` INT(11), IN `_idparent` INT(11), IN `_depth` INT(11), IN `_reorder` INT(11), IN `_trash` INT(11))  BEGIN
               update menu_has_cate set idmenu=_idmenu, idcategory = _idcategory, idparent = _idparent, depth = _depth, reorder = _reorder, trash = _trash where idmenuhascate=_idmenuhascate;
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `UpdateMenuItemByIdhasProcedure` (IN `_str_query` VARCHAR(255))  BEGIN
                SET @sqlv=_str_query;
                PREPARE stmt FROM @sqlv;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;  
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `UpdateOrderNumberProcedure` (IN `_ordernumber` INT(11))  BEGIN
                 update exp_products set ordernumber = _ordernumber where idexp = _ordernumber;  
            END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `UpdateProfileProcedure` (IN `_idprofile` INT, IN `_firstname` VARCHAR(255) CHARSET utf8mb4, IN `_lastname` VARCHAR(255) CHARSET utf8mb4, IN `_middlename` VARCHAR(255) CHARSET utf8mb4, IN `_idsex` INT, IN `_birthday` DATETIME, IN `_address` VARCHAR(255) CHARSET utf8mb4, IN `_mobile` VARCHAR(255) CHARSET utf8mb4, IN `_idcitytown` INT, IN `_iddistrict` INT)  BEGIN
	update `profile` set firstname = _firstname, lastname=_lastname, middlename=_middlename, idsex=_idsex, birthday = _birthday, address=_address, mobile=_mobile, idcitytown=_idcitytown, iddistrict=_iddistrict where idprofile = _idprofile;
END$$

CREATE DEFINER=`dichvu_dvtmvtk`@`localhost` PROCEDURE `UploadAvatarProcedure` (IN `_idprofile` INT, IN `_url_avatar` VARCHAR(255))  BEGIN
                update `profile` set url_avatar = _url_avatar where idprofile=_idprofile;
            END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cache`
--

CREATE TABLE `cache` (
  `key` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `categories`
--

CREATE TABLE `categories` (
  `idcategory` int(10) UNSIGNED NOT NULL,
  `shortname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `namecat` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idcattype` int(11) DEFAULT NULL,
  `idparent` int(11) DEFAULT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `guid` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` (`idcategory`, `shortname`, `namecat`, `idcattype`, `idparent`, `slug`, `guid`, `created_at`, `updated_at`) VALUES
(1, NULL, 'promotion-reg', 1, 0, NULL, NULL, '2019-04-17 01:49:08', '2019-07-14 15:28:26'),
(2, NULL, 'localhost', 2, 0, NULL, NULL, '2019-04-17 01:50:18', '2019-07-14 15:28:26'),
(3, NULL, 'thammyvienthienkhue.vn', 2, 0, NULL, NULL, '2019-04-17 03:35:14', '2019-07-14 15:28:26'),
(4, NULL, 'Tương tác', 3, 0, NULL, NULL, '2019-04-17 04:43:13', '2019-07-14 15:28:26'),
(5, NULL, 'cuocthigiambeo.thammyvienthienkhue.vn', 2, 0, NULL, NULL, '2019-05-15 09:11:49', '2019-07-14 15:28:26'),
(6, NULL, 'Trị nám tàn nhang', 4, 0, NULL, NULL, '2019-05-23 10:08:10', '2019-08-03 03:09:55'),
(7, NULL, 'Trị thâm bằng công nghệ Pelling Layer', 4, 29, NULL, NULL, '2019-05-24 01:52:47', '2019-07-14 14:58:10'),
(8, NULL, 'Trị thâm bằng công nghệ Yag Layer', 4, 29, NULL, NULL, '2019-05-24 03:29:18', '2019-07-14 14:58:44'),
(9, NULL, 'Trẻ hóa', 4, 0, NULL, NULL, '2019-05-24 03:41:11', '2019-07-14 15:29:16'),
(10, NULL, 'Xóa nhăn', 4, 0, NULL, NULL, '2019-05-24 03:43:06', '2019-07-14 15:28:26'),
(11, 'order', 'Đơn hàng', 5, 0, NULL, NULL, '2019-06-11 04:57:54', '2019-07-14 15:28:26'),
(12, 'process', 'Xử lý', 5, 0, NULL, NULL, '2019-06-11 04:58:28', '2019-07-14 15:28:26'),
(13, 'produce', 'Sản xuất', 5, 0, NULL, NULL, '2019-06-11 04:59:25', '2019-07-14 15:28:26'),
(14, 'transfer', 'Vận chuyển', 5, 0, NULL, NULL, '2019-06-11 04:59:38', '2019-07-14 15:28:26'),
(15, 'post', 'Giao hàng', 5, 0, NULL, NULL, '2019-06-11 05:01:00', '2019-07-14 15:28:26'),
(16, 'topping', 'Trị mụn', 4, 0, NULL, NULL, '2019-06-18 07:40:39', '2019-07-14 15:28:26'),
(17, NULL, 'Trị sẹo', 4, 0, NULL, NULL, '2019-07-08 10:25:44', '2019-07-14 15:28:26'),
(18, NULL, 'Giảm béo body slim', 4, 28, NULL, NULL, '2019-07-08 10:26:25', '2019-07-14 14:51:21'),
(19, NULL, 'Giảm béo siêu âm cao tần calivipo slim', 4, 28, NULL, NULL, '2019-07-08 14:58:16', '2019-07-14 14:51:41'),
(20, NULL, 'Giảm béo siêu âm hội tụ line-hifu', 4, 28, NULL, NULL, '2019-07-08 14:58:58', '2019-07-14 14:52:08'),
(21, NULL, 'Giảm béo siêu âm hội tụ sline-hiulther', 4, 28, NULL, NULL, '2019-07-08 14:59:47', '2019-07-14 14:52:30'),
(22, NULL, 'Siêu hủy mỡ hiulther-lipase', 4, 28, NULL, NULL, '2019-07-08 15:01:41', '2019-07-14 14:52:54'),
(23, NULL, 'Cây trắng da', 4, 9, NULL, NULL, '2019-07-08 15:02:03', '2019-07-14 14:54:41'),
(24, NULL, 'Thẩm mỹ nội khoa', 4, 0, NULL, NULL, '2019-07-08 15:02:32', '2019-07-14 15:28:26'),
(25, NULL, 'Cấy tinh chất HA làm đầy', 4, 9, NULL, NULL, '2019-07-08 15:03:13', '2019-07-14 14:54:22'),
(26, NULL, 'Cấy tinh chất collagen tươi xóa nhân', 4, 9, NULL, NULL, '2019-07-08 15:03:51', '2019-07-14 14:55:04'),
(27, NULL, 'Sản phẩm', 4, 0, NULL, NULL, '2019-07-09 04:41:38', '2019-07-14 15:28:26'),
(28, NULL, 'Giảm béo', 4, 0, NULL, NULL, '2019-07-14 14:50:28', '2019-07-14 15:28:26'),
(29, NULL, 'Trị thâm', 4, 0, NULL, NULL, '2019-07-14 14:57:55', '2019-07-14 15:28:26'),
(30, NULL, 'mgk.edu.vn', 2, 0, NULL, NULL, '2019-08-01 07:59:17', '2019-08-02 03:22:16'),
(31, NULL, 'Nhập hàng', 5, 0, NULL, NULL, '2019-08-02 03:08:41', '2019-08-02 03:08:41');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `category_types`
--

CREATE TABLE `category_types` (
  `idcattype` int(10) UNSIGNED NOT NULL,
  `catnametype` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `category_types`
--

INSERT INTO `category_types` (`idcattype`, `catnametype`, `created_at`, `updated_at`) VALUES
(1, 'post', '2019-02-27 03:36:11', '2019-02-27 03:36:11'),
(2, 'website', '2019-02-27 03:53:53', '2019-02-27 03:53:53'),
(3, 'interact', '2019-04-13 01:40:17', '2019-04-13 01:40:17'),
(4, 'product', '2019-05-23 09:06:55', '2019-05-23 09:06:55'),
(5, 'store', '2019-06-11 03:15:05', '2019-06-11 03:15:05'),
(6, 'Link', '2019-07-09 08:48:25', '2019-07-09 08:48:25');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `catehasproduct`
--

CREATE TABLE `catehasproduct` (
  `idcateproduct` bigint(20) UNSIGNED NOT NULL,
  `idproduct` bigint(20) DEFAULT NULL,
  `idcategory` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `catehasproduct`
--

INSERT INTO `catehasproduct` (`idcateproduct`, `idproduct`, `idcategory`, `created_at`, `updated_at`) VALUES
(194, 68, 0, '2019-06-07 08:58:34', '2019-06-07 09:02:39'),
(195, 68, 0, '2019-06-07 09:03:51', '2019-06-07 09:04:57'),
(196, 68, 0, '2019-06-07 09:04:24', '2019-06-07 09:06:25'),
(197, 68, 0, '2019-06-07 09:06:16', '2019-06-10 13:47:10'),
(198, 68, 0, '2019-06-07 09:07:56', '2019-08-03 15:39:45'),
(199, 68, 0, '2019-06-07 09:07:56', '2019-06-07 09:09:03'),
(200, 68, 0, '2019-06-07 14:40:28', '2019-06-08 07:16:24'),
(201, 69, 7, '2019-06-08 07:20:19', '2019-06-08 07:20:19'),
(202, 70, 0, '2019-06-08 07:23:37', '2019-06-10 13:49:23'),
(203, 70, 0, '2019-06-08 07:23:37', '2019-06-10 13:49:23'),
(204, 70, 0, '2019-06-10 13:49:23', '2019-08-03 15:36:29'),
(205, 71, 0, '2019-06-10 13:52:19', '2019-08-03 05:06:59'),
(206, 72, 0, '2019-06-10 13:58:31', '2019-08-03 05:01:57'),
(207, 73, 0, '2019-06-10 14:00:42', '2019-08-03 04:54:39'),
(208, 74, 0, '2019-06-10 14:02:49', '2019-08-03 04:47:12'),
(220, 91, 10, '2019-06-17 16:47:41', '2019-06-17 16:47:41'),
(221, 92, 6, '2019-06-17 16:49:20', '2019-06-17 16:49:20'),
(229, 94, 6, '2019-06-18 01:22:36', '2019-06-18 01:22:36'),
(230, 95, 6, '2019-06-18 01:52:14', '2019-06-18 01:52:14'),
(231, 96, 0, '2019-06-18 02:29:58', '2019-08-03 04:41:56'),
(232, 97, 0, '2019-06-18 02:32:14', '2019-08-03 04:29:16'),
(233, 98, 6, '2019-06-18 05:01:13', '2019-06-18 05:01:13'),
(234, 99, 16, '2019-06-19 02:19:23', '2019-06-19 02:19:23'),
(235, 100, 16, '2019-06-19 02:32:51', '2019-06-19 02:32:51'),
(236, 101, 16, '2019-06-19 02:59:08', '2019-06-19 02:59:08'),
(237, 102, 16, '2019-06-19 02:59:31', '2019-06-19 02:59:31'),
(238, 103, 0, '2019-07-02 04:19:44', '2019-08-03 04:16:18'),
(239, 104, 0, '2019-07-06 01:50:00', '2019-08-03 04:09:40'),
(240, 105, 0, '2019-07-06 01:54:02', '2019-08-03 04:01:17'),
(241, 106, 0, '2019-07-06 02:09:17', '2019-08-03 03:55:58'),
(242, 107, 0, '2019-07-06 02:44:15', '2019-08-03 03:14:41'),
(243, 107, 6, '2019-08-03 03:14:41', '2019-08-03 03:14:41'),
(244, 106, 6, '2019-08-03 03:55:58', '2019-08-03 03:55:58'),
(245, 105, 6, '2019-08-03 04:01:17', '2019-08-03 04:01:17'),
(246, 104, 6, '2019-08-03 04:09:40', '2019-08-03 04:09:40'),
(247, 103, 6, '2019-08-03 04:16:18', '2019-08-03 04:16:18'),
(248, 97, 6, '2019-08-03 04:29:16', '2019-08-03 04:29:16'),
(249, 96, 0, '2019-08-03 04:41:56', '2019-08-03 04:51:34'),
(250, 96, 7, '2019-08-03 04:41:56', '2019-08-03 04:41:56'),
(251, 74, 7, '2019-08-03 04:47:12', '2019-08-03 04:47:12'),
(252, 73, 29, '2019-08-03 04:54:39', '2019-08-03 04:54:39'),
(253, 73, 7, '2019-08-03 04:54:39', '2019-08-03 04:54:39'),
(254, 72, 29, '2019-08-03 05:01:57', '2019-08-03 05:01:57'),
(255, 72, 7, '2019-08-03 05:01:57', '2019-08-03 05:01:57'),
(256, 71, 9, '2019-08-03 05:06:59', '2019-08-03 05:06:59'),
(257, 70, 9, '2019-08-03 15:36:29', '2019-08-03 15:36:29'),
(258, 68, 9, '2019-08-03 15:39:45', '2019-08-03 15:39:45');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `city_town`
--

CREATE TABLE `city_town` (
  `idcitytown` int(10) UNSIGNED NOT NULL,
  `namecitytown` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idprovince` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `city_town`
--

INSERT INTO `city_town` (`idcitytown`, `namecitytown`, `idprovince`, `created_at`, `updated_at`) VALUES
(1, 'TP Hồ Chí Minh', 1, '2019-06-27 02:21:40', '2019-06-27 02:29:51');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `color`
--

CREATE TABLE `color` (
  `idcolor` int(10) UNSIGNED NOT NULL,
  `value` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `color`
--

INSERT INTO `color` (`idcolor`, `value`, `created_at`, `updated_at`) VALUES
(1, 'Trắng', NULL, NULL),
(2, 'Vàng', NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `country`
--

CREATE TABLE `country` (
  `idcountry` int(10) UNSIGNED NOT NULL,
  `namecountry` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idcontinent` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `country`
--

INSERT INTO `country` (`idcountry`, `namecountry`, `idcontinent`, `created_at`, `updated_at`) VALUES
(1, 'Việt nam', NULL, '2019-06-27 02:19:27', '2019-06-27 02:19:48');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cross_product`
--

CREATE TABLE `cross_product` (
  `idcrossproduct` int(10) UNSIGNED NOT NULL,
  `idproduct` int(11) DEFAULT NULL,
  `crosstype` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idproduct_cross` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `cross_product`
--

INSERT INTO `cross_product` (`idcrossproduct`, `idproduct`, `crosstype`, `idproduct_cross`, `created_at`, `updated_at`) VALUES
(12, 74, 'crosssize', 91, '2019-06-17 16:47:41', '2019-06-17 16:47:41'),
(13, 71, 'crosssize', 92, '2019-06-17 16:49:20', '2019-06-17 16:49:20'),
(14, 68, 'crosssize', 93, '2019-06-18 01:15:22', '2019-06-18 01:15:22'),
(15, 70, 'crosssize', 94, '2019-06-18 01:22:36', '2019-06-18 01:22:36'),
(16, 94, 'crosssize', 95, '2019-06-18 01:52:14', '2019-06-18 01:52:14'),
(17, 68, 'crosssize', 98, '2019-06-18 05:01:13', '2019-06-18 05:01:13');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `departments`
--

CREATE TABLE `departments` (
  `iddepart` int(10) UNSIGNED NOT NULL,
  `namedepart` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idparent` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `departments`
--

INSERT INTO `departments` (`iddepart`, `namedepart`, `idparent`, `created_at`, `updated_at`) VALUES
(1, 'Marketing', NULL, '2019-02-27 02:15:12', '2019-02-27 02:15:12'),
(2, 'IT', 1, '2019-02-27 02:15:25', '2019-02-27 02:15:25'),
(3, 'CSKH', 1, '2019-05-05 14:37:58', '2019-05-05 14:37:58'),
(4, 'Digital', 1, '2019-05-17 02:31:35', '2019-05-17 02:31:35'),
(5, 'Bình Dương', NULL, '2019-05-17 02:32:54', '2019-05-17 02:33:04'),
(6, 'Lể Tân', 5, '2019-05-17 02:33:26', '2019-05-17 02:33:50'),
(7, 'Đồng Nai', NULL, '2019-05-17 02:34:04', '2019-05-17 02:34:04'),
(8, 'Lể Tân', 7, '2019-05-17 02:34:17', '2019-05-17 02:34:17');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `depart_employees`
--

CREATE TABLE `depart_employees` (
  `iddepart_employee` int(10) UNSIGNED NOT NULL,
  `iduser` int(11) NOT NULL,
  `iddepart` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `depart_employees`
--

INSERT INTO `depart_employees` (`iddepart_employee`, `iduser`, `iddepart`, `created_at`, `updated_at`) VALUES
(1, 2, 2, '2019-02-27 03:14:16', '2019-02-27 03:14:16'),
(2, 3, 3, '2019-05-05 14:38:59', '2019-05-05 14:38:59'),
(7, 12, 3, '2019-05-07 15:47:21', '2019-05-07 15:47:21'),
(8, 13, 3, '2019-05-08 15:05:35', '2019-05-08 15:05:35'),
(9, 14, 3, '2019-05-08 15:11:57', '2019-05-08 15:11:57'),
(10, 15, 3, '2019-05-08 15:13:47', '2019-05-08 15:13:47'),
(11, 16, 8, '2019-05-17 02:36:04', '2019-05-17 02:36:04'),
(12, 17, 6, '2019-05-17 02:36:49', '2019-05-17 02:36:49'),
(13, 18, 4, '2019-05-17 02:39:23', '2019-05-17 02:39:23'),
(14, 23, 3, '2019-08-01 09:40:26', '2019-08-01 09:40:26'),
(15, 24, 3, '2019-08-01 09:49:22', '2019-08-01 09:49:22'),
(16, 25, 3, '2019-08-01 09:49:58', '2019-08-01 09:49:58'),
(17, 26, 3, '2019-08-01 09:50:55', '2019-08-01 09:50:55'),
(18, 27, 3, '2019-08-01 09:51:50', '2019-08-01 09:51:50'),
(19, 28, 3, '2019-08-01 09:56:43', '2019-08-01 09:56:43'),
(20, 29, 3, '2019-08-01 10:50:50', '2019-08-01 10:50:50');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `district`
--

CREATE TABLE `district` (
  `iddistrict` int(10) UNSIGNED NOT NULL,
  `namedist` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idcitytown` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `district`
--

INSERT INTO `district` (`iddistrict`, `namedist`, `idcitytown`, `created_at`, `updated_at`) VALUES
(1, 'Quận 1', 1, '2019-06-27 02:23:16', '2019-06-27 02:23:16'),
(2, 'Quận 2', 1, '2019-06-27 02:23:33', '2019-06-27 02:23:33'),
(3, 'Quận 3', 1, '2019-06-27 02:23:42', '2019-06-27 02:23:42'),
(4, 'Quận 4', 1, '2019-06-27 02:23:52', '2019-06-27 02:23:52'),
(5, 'Quận 5', 1, '2019-06-27 02:24:03', '2019-06-27 02:24:03'),
(6, 'Quận 6', 1, '2019-06-27 02:24:14', '2019-06-27 02:24:14'),
(7, 'Quận 7', 1, '2019-06-27 02:24:22', '2019-06-27 02:24:22'),
(8, 'Quận 8', 1, '2019-06-27 02:24:34', '2019-06-27 02:24:34'),
(9, 'Quận 9', 1, '2019-06-27 02:24:44', '2019-06-27 02:24:44'),
(10, 'Quận 10', 1, '2019-06-27 02:24:51', '2019-06-27 02:24:51'),
(11, 'Quận 11', 1, '2019-06-27 02:24:59', '2019-06-27 02:24:59'),
(12, 'Quận 12', 1, '2019-06-27 02:25:08', '2019-06-27 02:25:08'),
(13, 'Tân Bình', 1, '2019-06-27 02:25:22', '2019-06-27 02:25:22'),
(14, 'Gò Vấp', 1, '2019-06-27 02:25:48', '2019-06-27 02:25:48'),
(15, 'Tân Phú', 1, '2019-06-27 02:26:16', '2019-06-27 02:26:27'),
(16, 'Phú Nhuận', 1, '2019-06-27 02:26:25', '2019-06-27 02:26:40'),
(17, 'Bình Thạnh', 1, '2019-06-27 02:26:51', '2019-06-27 02:26:51'),
(18, 'Thủ Đức', 1, '2019-06-27 02:27:12', '2019-06-27 02:27:12');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `exclude_category`
--

CREATE TABLE `exclude_category` (
  `idexcludecate` int(10) UNSIGNED NOT NULL,
  `idcategory` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `exclude_category`
--

INSERT INTO `exclude_category` (`idexcludecate`, `idcategory`, `created_at`, `updated_at`) VALUES
(1, 16, '2019-06-19 03:51:19', '2019-06-19 03:51:19');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `expposts`
--

CREATE TABLE `expposts` (
  `idexppost` bigint(20) UNSIGNED NOT NULL,
  `idpost` bigint(20) DEFAULT NULL,
  `id_status_type` int(11) DEFAULT NULL,
  `iduser_exp` int(11) DEFAULT NULL,
  `idemployee` int(11) DEFAULT NULL,
  `address_reg` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `percent_process` decimal(8,2) DEFAULT NULL,
  `parent_idpost_exp` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `exp_products`
--

CREATE TABLE `exp_products` (
  `idexp` int(10) UNSIGNED NOT NULL,
  `ordernumber` int(11) DEFAULT NULL,
  `idproduct` bigint(20) NOT NULL,
  `parentidproduct` int(11) DEFAULT NULL,
  `idcustomer` int(11) DEFAULT NULL,
  `idrecipent` int(11) DEFAULT NULL,
  `iduser` int(11) DEFAULT NULL,
  `amount` double(20,0) DEFAULT NULL,
  `price` double(20,0) DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `idstore` int(11) DEFAULT NULL,
  `axis_x` int(11) DEFAULT NULL,
  `axis_y` int(11) DEFAULT NULL,
  `axis_z` int(11) DEFAULT NULL,
  `id_status_type` int(10) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `exp_products`
--

INSERT INTO `exp_products` (`idexp`, `ordernumber`, `idproduct`, `parentidproduct`, `idcustomer`, `idrecipent`, `iduser`, `amount`, `price`, `note`, `idstore`, `axis_x`, `axis_y`, `axis_z`, `id_status_type`, `created_at`, `updated_at`) VALUES
(1, 1, 107, 0, 0, 0, 2, 1, 25000, NULL, 11, 0, 0, 0, 0, '2019-07-09 08:22:55', '2019-07-09 08:22:55'),
(2, 1, 100, 107, 0, 0, 2, 1, 3000, '', 11, 0, 0, 0, 0, '2019-07-09 08:22:55', '2019-07-09 08:22:55'),
(3, 1, 99, 107, 0, 0, 2, 1, 3000, '', 11, 0, 0, 0, 0, '2019-07-09 08:22:55', '2019-07-09 08:22:55'),
(4, 4, 106, 0, 0, 0, 2, 2, 38500, NULL, 11, 0, 0, 0, 0, '2019-07-09 09:21:20', '2019-07-09 09:21:20'),
(5, 4, 100, 106, 0, 0, 2, 2, 3000, '', 11, 0, 0, 0, 0, '2019-07-09 09:21:20', '2019-07-09 09:21:20'),
(6, 4, 99, 106, 0, 0, 2, 2, 3000, '', 11, 0, 0, 0, 0, '2019-07-09 09:21:20', '2019-07-09 09:21:20'),
(7, 4, 74, 0, 0, 0, 2, 1, 29000, NULL, 11, 0, 0, 0, 0, '2019-07-09 09:21:20', '2019-07-09 09:21:20'),
(8, 4, 100, 74, 0, 0, 2, 1, 3000, '', 11, 0, 0, 0, 0, '2019-07-09 09:21:20', '2019-07-09 09:21:20'),
(9, 4, 99, 74, 0, 0, 2, 1, 3000, '', 11, 0, 0, 0, 0, '2019-07-09 09:21:20', '2019-07-09 09:21:20'),
(10, 10, 106, 0, 0, 0, 2, 1, 38500, NULL, 11, 0, 0, 0, 0, '2019-07-16 09:41:05', '2019-07-16 09:41:05'),
(11, 10, 100, 106, 0, 0, 2, 1, 3000, '', 11, 0, 0, 0, 0, '2019-07-16 09:41:05', '2019-07-16 09:41:05'),
(12, 10, 99, 106, 0, 0, 2, 1, 3000, '', 11, 0, 0, 0, 0, '2019-07-16 09:41:05', '2019-07-16 09:41:05');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `files`
--

CREATE TABLE `files` (
  `idfile` bigint(10) UNSIGNED NOT NULL,
  `urlfile` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_origin` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `namefile` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `typefile` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `files`
--

INSERT INTO `files` (`idfile`, `urlfile`, `name_origin`, `namefile`, `typefile`, `created_at`, `updated_at`) VALUES
(358, 'uploads/2019/06/03/20190603_1559574376_5cf537685f91a.jpeg', '', '20190603_1559574376_5cf537685f91a.jpeg', 'jpeg', '2019-06-03 15:06:16', '2019-06-03 15:06:16'),
(359, 'uploads/2019/06/03/20190603_1559574456_5cf537b8aa4e0.jpeg', '', '20190603_1559574456_5cf537b8aa4e0.jpeg', 'jpeg', '2019-06-03 15:07:36', '2019-06-03 15:07:36'),
(360, 'uploads/2019/06/03/20190603_1559574542_5cf5380ec6c36.png', '', '20190603_1559574542_5cf5380ec6c36.png', 'png', '2019-06-03 15:09:02', '2019-06-03 15:09:02'),
(361, 'uploads/2019/06/03/20190603_1559574783_5cf538ff9b4c9.png', '', '20190603_1559574783_5cf538ff9b4c9.png', 'png', '2019-06-03 15:13:03', '2019-06-03 15:13:03'),
(362, 'uploads/2019/06/03/20190603_1559574997_5cf539d51933c.png', '', '20190603_1559574997_5cf539d51933c.png', 'png', '2019-06-03 15:16:37', '2019-06-03 15:16:37'),
(363, 'uploads/2019/06/03/20190603_1559575038_5cf539fe8dac3.png', '', '20190603_1559575038_5cf539fe8dac3.png', 'png', '2019-06-03 15:17:18', '2019-06-03 15:17:18'),
(364, 'uploads/2019/06/03/20190603_1559576155_5cf53e5bf105c.png', '', '20190603_1559576155_5cf53e5bf105c.png', 'png', '2019-06-03 15:35:55', '2019-06-03 15:35:55'),
(365, 'uploads/2019/06/03/20190603_1559576190_5cf53e7e3bf9a.png', '', '20190603_1559576190_5cf53e7e3bf9a.png', 'png', '2019-06-03 15:36:30', '2019-06-03 15:36:30'),
(366, 'uploads/2019/06/03/20190603_1559576260_5cf53ec4538b6.png', '', '20190603_1559576260_5cf53ec4538b6.png', 'png', '2019-06-03 15:37:40', '2019-06-03 15:37:40'),
(367, 'uploads/2019/06/03/20190603_1559576273_5cf53ed10f9f3.png', '', '20190603_1559576273_5cf53ed10f9f3.png', 'png', '2019-06-03 15:37:53', '2019-06-03 15:37:53'),
(368, 'uploads/2019/06/03/20190603_1559576371_5cf53f33b5638.png', '', '20190603_1559576371_5cf53f33b5638.png', 'png', '2019-06-03 15:39:31', '2019-06-03 15:39:31'),
(369, 'uploads/2019/06/03/20190603_1559576378_5cf53f3a568d5.png', '', '20190603_1559576378_5cf53f3a568d5.png', 'png', '2019-06-03 15:39:38', '2019-06-03 15:39:38'),
(370, 'uploads/2019/06/03/20190603_1559576523_5cf53fcb00828.png', '', '20190603_1559576523_5cf53fcb00828.png', 'png', '2019-06-03 15:42:03', '2019-06-03 15:42:03'),
(371, 'uploads/2019/06/03/20190603_1559576528_5cf53fd0c4c31.png', '', '20190603_1559576528_5cf53fd0c4c31.png', 'png', '2019-06-03 15:42:08', '2019-06-03 15:42:08'),
(372, 'uploads/2019/06/03/20190603_1559576635_5cf5403b66330.png', '', '20190603_1559576635_5cf5403b66330.png', 'png', '2019-06-03 15:43:55', '2019-06-03 15:43:55'),
(373, 'uploads/2019/06/03/20190603_1559576798_5cf540deb89e3.png', '', '20190603_1559576798_5cf540deb89e3.png', 'png', '2019-06-03 15:46:38', '2019-06-03 15:46:38'),
(374, 'uploads/2019/06/03/20190603_1559576808_5cf540e8a3792.png', '', '20190603_1559576808_5cf540e8a3792.png', 'png', '2019-06-03 15:46:48', '2019-06-03 15:46:48'),
(375, 'uploads/2019/06/03/20190603_1559576909_5cf5414de858a.png', '', '20190603_1559576909_5cf5414de858a.png', 'png', '2019-06-03 15:48:29', '2019-06-03 15:48:29'),
(376, 'uploads/2019/06/03/20190603_1559577021_5cf541bd965e3.png', '', '20190603_1559577021_5cf541bd965e3.png', 'png', '2019-06-03 15:50:21', '2019-06-03 15:50:21'),
(377, 'uploads/2019/06/03/20190603_1559577089_5cf54201eaae1.png', '', '20190603_1559577089_5cf54201eaae1.png', 'png', '2019-06-03 15:51:29', '2019-06-03 15:51:29'),
(378, 'uploads/2019/06/03/20190603_1559577303_5cf542d7c1c95.jpg', 'hyundai_accent_600x426x1.jpg', '20190603_1559577303_5cf542d7c1c95.jpg', 'jpg', '2019-06-03 15:55:03', '2019-06-03 15:55:03'),
(379, 'uploads/2019/06/04/20190604_1559611131_5cf5c6fb8821d.png', '', '20190604_1559611131_5cf5c6fb8821d.png', 'png', '2019-06-04 01:18:51', '2019-06-04 01:18:51'),
(380, 'uploads/2019/06/04/20190604_1559611540_5cf5c89499bff.png', '', '20190604_1559611540_5cf5c89499bff.png', 'png', '2019-06-04 01:25:40', '2019-06-04 01:25:40'),
(381, 'uploads/2019/06/04/20190604_1559611628_5cf5c8ec760dd.png', '', '20190604_1559611628_5cf5c8ec760dd.png', 'png', '2019-06-04 01:27:08', '2019-06-04 01:27:08'),
(382, 'uploads/2019/06/04/20190604_1559611636_5cf5c8f4b746b.png', '', '20190604_1559611636_5cf5c8f4b746b.png', 'png', '2019-06-04 01:27:16', '2019-06-04 01:27:16'),
(383, 'uploads/2019/06/04/20190604_1559611708_5cf5c93cd9e7a.png', '', '20190604_1559611708_5cf5c93cd9e7a.png', 'png', '2019-06-04 01:28:28', '2019-06-04 01:28:28'),
(384, 'uploads/2019/06/04/20190604_1559611726_5cf5c94eb780b.png', '', '20190604_1559611726_5cf5c94eb780b.png', 'png', '2019-06-04 01:28:46', '2019-06-04 01:28:46'),
(385, 'uploads/2019/06/04/20190604_1559611881_5cf5c9e96916f.jpg', '2018-6-27-10-15-56.jpg', '20190604_1559611881_5cf5c9e96916f.jpg', 'jpg', '2019-06-04 01:31:21', '2019-06-04 01:31:21'),
(386, 'uploads/2019/06/05/20190605_1559702607_5cf72c4fe89de.png', '2018-6-30-11-28-46.png', '20190605_1559702607_5cf72c4fe89de.png', 'png', '2019-06-05 02:43:27', '2019-06-05 02:43:27'),
(387, 'uploads/2019/06/05/20190605_1559702608_5cf72c5017515.png', '2018-6-30-11-28-46.png', '20190605_1559702608_5cf72c5017515.png', 'png', '2019-06-05 02:43:28', '2019-06-05 02:43:28'),
(388, 'uploads/2019/06/05/20190605_1559702608_5cf72c5031b6d.jpg', '2018-6-24-16-29-15.jpg', '20190605_1559702608_5cf72c5031b6d.jpg', 'jpg', '2019-06-05 02:43:28', '2019-06-05 02:43:28'),
(389, 'uploads/2019/06/05/20190605_1559705312_5cf736e003e62.png', '', '20190605_1559705312_5cf736e003e62.png', 'png', '2019-06-05 03:28:32', '2019-06-05 03:28:32'),
(390, 'uploads/2019/06/05/20190605_1559705355_5cf7370bec0eb.png', '', '20190605_1559705355_5cf7370bec0eb.png', 'png', '2019-06-05 03:29:15', '2019-06-05 03:29:15'),
(391, 'uploads/2019/06/05/20190605_1559708951_5cf74517d4a4b.png', '', '20190605_1559708951_5cf74517d4a4b.png', 'png', '2019-06-05 04:29:11', '2019-06-05 04:29:11'),
(392, 'uploads/2019/06/06/20190606_1559791137_5cf88621f394c.png', 'chi-deo.png', '20190606_1559791137_5cf88621f394c.png', 'png', '2019-06-06 03:18:58', '2019-06-06 03:18:58'),
(393, 'uploads/2019/06/06/20190606_1559791138_5cf8862222d3a.png', 'chi-deo.png', '20190606_1559791138_5cf8862222d3a.png', 'png', '2019-06-06 03:18:58', '2019-06-06 03:18:58'),
(394, 'uploads/2019/06/07/20190607_1559894853_5cfa1b459b3b5.jpg', '45-report-writing.jpg', '20190607_1559894853_5cfa1b459b3b5.jpg', 'jpg', '2019-06-07 08:07:33', '2019-06-07 08:07:33'),
(395, 'uploads/2019/06/07/20190607_1559894853_5cfa1b45c10d7.png', 'businessman_reading_report_header.png', '20190607_1559894853_5cfa1b45c10d7.png', 'png', '2019-06-07 08:07:33', '2019-06-07 08:07:33'),
(396, 'uploads/2019/06/07/20190607_1559894853_5cfa1b45d56d8.jpg', 'dangky.jpg', '20190607_1559894853_5cfa1b45d56d8.jpg', 'jpg', '2019-06-07 08:07:33', '2019-06-07 08:07:33'),
(397, 'uploads/2019/06/07/20190607_1559895720_5cfa1ea8b11fe.jpg', 'annual-report.jpg', '20190607_1559895720_5cfa1ea8b11fe.jpg', 'jpg', '2019-06-07 08:22:00', '2019-06-07 08:22:00'),
(398, 'uploads/2019/06/07/20190607_1559895720_5cfa1ea8c2d65.jpg', '3ed4e9b52ca7c6f99fb6.jpg', '20190607_1559895720_5cfa1ea8c2d65.jpg', 'jpg', '2019-06-07 08:22:00', '2019-06-07 08:22:00'),
(399, 'uploads/2019/06/07/20190607_1559895720_5cfa1ea8d73cd.jpg', '5bf01a6d4335a96bf024.jpg', '20190607_1559895720_5cfa1ea8d73cd.jpg', 'jpg', '2019-06-07 08:22:00', '2019-06-07 08:22:00'),
(400, 'uploads/2019/06/07/20190607_1559896709_5cfa22851a3bf.jpg', '5bf01a6d4335a96bf024.jpg', '20190607_1559896709_5cfa22851a3bf.jpg', 'jpg', '2019-06-07 08:38:29', '2019-06-07 08:38:29'),
(401, 'uploads/2019/06/07/20190607_1559896709_5cfa228563651.jpg', 'fe5b04259c9a77c42e8b.jpg', '20190607_1559896709_5cfa228563651.jpg', 'jpg', '2019-06-07 08:38:29', '2019-06-07 08:38:29'),
(402, 'uploads/2019/06/07/20190607_1559897852_5cfa26fc9ea84.png', '', '20190607_1559897852_5cfa26fc9ea84.png', 'png', '2019-06-07 08:57:32', '2019-06-07 08:57:32'),
(403, 'uploads/2019/06/07/20190607_1559897914_5cfa273aea5c0.jpg', '5bf01a6d4335a96bf024.jpg', '20190607_1559897914_5cfa273aea5c0.jpg', 'jpg', '2019-06-07 08:58:34', '2019-06-07 08:58:34'),
(404, 'uploads/2019/06/07/20190607_1559897915_5cfa273b0574b.jpg', 'fe5b04259c9a77c42e8b.jpg', '20190607_1559897915_5cfa273b0574b.jpg', 'jpg', '2019-06-07 08:58:35', '2019-06-07 08:58:35'),
(405, 'uploads/2019/06/07/20190607_1559897915_5cfa273b18488.jpg', '5bf01a6d4335a96bf024.jpg', '20190607_1559897915_5cfa273b18488.jpg', 'jpg', '2019-06-07 08:58:35', '2019-06-07 08:58:35'),
(406, 'uploads/2019/06/07/20190607_1559901803_5cfa366b4e300.jpg', 'fe5b04259c9a77c42e8b.jpg', '20190607_1559901803_5cfa366b4e300.jpg', 'jpg', '2019-06-07 10:03:23', '2019-06-07 10:03:23'),
(407, 'uploads/2019/06/07/20190607_1559908538_5cfa50bae8747.png', '', '20190607_1559908538_5cfa50bae8747.png', 'png', '2019-06-07 11:55:38', '2019-06-07 11:55:38'),
(408, 'uploads/2019/06/08/20190608_1559968877_5cfb3c6d63b40.jpg', 'fe5b04259c9a77c42e8b.jpg', '20190608_1559968877_5cfb3c6d63b40.jpg', 'jpg', '2019-06-08 04:41:17', '2019-06-08 04:41:17'),
(409, 'uploads/2019/06/08/20190608_1559968889_5cfb3c794dc98.jpg', 'fe5b04259c9a77c42e8b.jpg', '20190608_1559968889_5cfb3c794dc98.jpg', 'jpg', '2019-06-08 04:41:29', '2019-06-08 04:41:29'),
(410, 'uploads/2019/06/08/20190608_1559969170_5cfb3d926b815.jpg', 'tanhau.jpg', '20190608_1559969170_5cfb3d926b815.jpg', 'jpg', '2019-06-08 04:46:10', '2019-06-08 04:46:10'),
(411, 'uploads/2019/06/08/20190608_1559969243_5cfb3ddb08df1.jpg', 'tanhau.jpg', '20190608_1559969243_5cfb3ddb08df1.jpg', 'jpg', '2019-06-08 04:47:23', '2019-06-08 04:47:23'),
(412, 'uploads/2019/06/08/20190608_1559969548_5cfb3f0c4f814.jpg', 'tanhau.jpg', '20190608_1559969548_5cfb3f0c4f814.jpg', 'jpg', '2019-06-08 04:52:28', '2019-06-08 04:52:28'),
(413, 'uploads/2019/06/08/20190608_1559970202_5cfb419ad73d6.jpg', 'mr_an1.jpg', '20190608_1559970202_5cfb419ad73d6.jpg', 'jpg', '2019-06-08 05:03:22', '2019-06-08 05:03:22'),
(414, 'uploads/2019/06/08/20190608_1559970202_5cfb419af0157.jpg', 'update_avatar.jpg', '20190608_1559970202_5cfb419af0157.jpg', 'jpg', '2019-06-08 05:03:22', '2019-06-08 05:03:22'),
(415, 'uploads/2019/06/08/20190608_1559975638_5cfb56d600ec4.jpg', 'fe5b04259c9a77c42e8b.jpg', '20190608_1559975638_5cfb56d600ec4.jpg', 'jpg', '2019-06-08 06:33:58', '2019-06-08 06:33:58'),
(416, 'uploads/2019/06/08/20190608_1559977172_5cfb5cd4f03f7.jpg', '199k-chuyengia.jpg', '20190608_1559977172_5cfb5cd4f03f7.jpg', 'jpg', '2019-06-08 06:59:32', '2019-06-08 06:59:32'),
(417, 'uploads/2019/06/08/20190608_1559978121_5cfb60899d8e0.jpg', '199k-chuyengia.jpg', '20190608_1559978121_5cfb60899d8e0.jpg', 'jpg', '2019-06-08 07:15:21', '2019-06-08 07:15:21'),
(418, 'uploads/2019/06/08/20190608_1559978419_5cfb61b365b84.jpg', '199k-chuyengia.jpg', '20190608_1559978419_5cfb61b365b84.jpg', 'jpg', '2019-06-08 07:20:19', '2019-06-08 07:20:19'),
(419, 'uploads/2019/06/08/20190608_1559978419_5cfb61b381ae3.jpg', '199k-chuyengia.jpg', '20190608_1559978419_5cfb61b381ae3.jpg', 'jpg', '2019-06-08 07:20:19', '2019-06-08 07:20:19'),
(420, 'uploads/2019/06/08/20190608_1559978617_5cfb6279598e9.jpg', '199k-chuyengia.jpg', '20190608_1559978617_5cfb6279598e9.jpg', 'jpg', '2019-06-08 07:23:37', '2019-06-08 07:23:37'),
(421, 'uploads/2019/06/08/20190608_1559978741_5cfb62f56a2b0.jpg', 'hinh2.jpg', '20190608_1559978741_5cfb62f56a2b0.jpg', 'jpg', '2019-06-08 07:25:41', '2019-06-08 07:25:41'),
(422, 'uploads/2019/06/10/20190610_1560174430_5cfe5f5e6653f.png', 'tra-matcha.png', '20190610_1560174430_5cfe5f5e6653f.png', 'png', '2019-06-10 13:47:10', '2019-06-10 13:47:10'),
(423, 'uploads/2019/06/10/20190610_1560174430_5cfe5f5e817a8.png', 'Layer-2.png-3.png', '20190610_1560174430_5cfe5f5e817a8.png', 'png', '2019-06-10 13:47:10', '2019-06-10 13:47:10'),
(424, 'uploads/2019/06/10/20190610_1560174563_5cfe5fe3d4aa9.png', 'Layer-2.png', '20190610_1560174563_5cfe5fe3d4aa9.png', 'png', '2019-06-10 13:49:23', '2019-06-10 13:49:23'),
(425, 'uploads/2019/06/10/20190610_1560174563_5cfe5fe3ec7e0.png', 'chanh-quat-han-thien.png', '20190610_1560174563_5cfe5fe3ec7e0.png', 'png', '2019-06-10 13:49:23', '2019-06-10 13:49:23'),
(426, 'uploads/2019/06/10/20190610_1560174739_5cfe60931d9f4.png', 'Layer-1.png', '20190610_1560174739_5cfe60931d9f4.png', 'png', '2019-06-10 13:52:19', '2019-06-10 13:52:19'),
(427, 'uploads/2019/06/10/20190610_1560175111_5cfe620720a04.png', 'TRA-BUOI-HOANG-KIM.png', '20190610_1560175111_5cfe620720a04.png', 'png', '2019-06-10 13:58:31', '2019-06-10 13:58:31'),
(428, 'uploads/2019/06/10/20190610_1560175242_5cfe628a82533.png', 'chanh-quat-han-thien.png', '20190610_1560175242_5cfe628a82533.png', 'png', '2019-06-10 14:00:42', '2019-06-10 14:00:42'),
(429, 'uploads/2019/06/10/20190610_1560175369_5cfe63096e958.png', 'Layer-2.png', '20190610_1560175369_5cfe63096e958.png', 'png', '2019-06-10 14:02:49', '2019-06-10 14:02:49'),
(430, 'uploads/2019/06/10/20190610_1560175448_5cfe6358bd611.png', 'chanh-quat-han-thien.png', '20190610_1560175448_5cfe6358bd611.png', 'png', '2019-06-10 14:04:08', '2019-06-10 14:04:08'),
(431, 'uploads/2019/06/10/20190610_1560175650_5cfe64228999a.png', 'KEM-TUYET-XOAI.png', '20190610_1560175650_5cfe64228999a.png', 'png', '2019-06-10 14:07:30', '2019-06-10 14:07:30'),
(432, 'uploads/2019/06/10/20190610_1560175741_5cfe647dd12a2.png', 'sua-tuoi-tran-chau-duong-den.png', '20190610_1560175741_5cfe647dd12a2.png', 'png', '2019-06-10 14:09:01', '2019-06-10 14:09:01'),
(433, 'uploads/2019/06/10/20190610_1560175773_5cfe649dd4ce1.png', 'Layer-21.png', '20190610_1560175773_5cfe649dd4ce1.png', 'png', '2019-06-10 14:09:33', '2019-06-10 14:09:33'),
(434, 'uploads/2019/06/12/20190612_1560323827_5d00a6f3708da.png', 'chanh-quat-han-thien.png', '20190612_1560323827_5d00a6f3708da.png', 'png', '2019-06-12 07:17:07', '2019-06-12 07:17:07'),
(435, 'uploads/2019/06/12/20190612_1560323827_5d00a6f385ac3.png', 'KEM-TUYET-XOAI.png', '20190612_1560323827_5d00a6f385ac3.png', 'png', '2019-06-12 07:17:07', '2019-06-12 07:17:07'),
(436, 'uploads/2019/06/12/20190612_1560323827_5d00a6f393f2d.png', 'Layer-2.png', '20190612_1560323827_5d00a6f393f2d.png', 'png', '2019-06-12 07:17:07', '2019-06-12 07:17:07'),
(437, 'uploads/2019/06/12/20190612_1560329214_5d00bbfeb0ff8.jpg', '_MG_9364.jpg', '20190612_1560329214_5d00bbfeb0ff8.jpg', 'jpg', '2019-06-12 08:46:54', '2019-06-12 08:46:54'),
(438, 'uploads/2019/06/12/20190612_1560329567_5d00bd5f64b29.jpg', '_MG_9049.jpg', '20190612_1560329567_5d00bd5f64b29.jpg', 'jpg', '2019-06-12 08:52:47', '2019-06-12 08:52:47'),
(439, 'uploads/2019/06/12/20190612_1560329864_5d00be8843134.jpg', '_MG_9281.jpg', '20190612_1560329864_5d00be8843134.jpg', 'jpg', '2019-06-12 08:57:44', '2019-06-12 08:57:44'),
(440, 'uploads/2019/06/12/20190612_1560329864_5d00be8857029.jpg', '_MG_9212.jpg', '20190612_1560329864_5d00be8857029.jpg', 'jpg', '2019-06-12 08:57:44', '2019-06-12 08:57:44'),
(441, 'uploads/2019/06/12/20190612_1560329864_5d00be887830f.jpg', '_MG_9331.jpg', '20190612_1560329864_5d00be887830f.jpg', 'jpg', '2019-06-12 08:57:44', '2019-06-12 08:57:44'),
(442, 'uploads/2019/06/12/20190612_1560329916_5d00bebcc0124.jpg', '_MG_9281.jpg', '20190612_1560329916_5d00bebcc0124.jpg', 'jpg', '2019-06-12 08:58:36', '2019-06-12 08:58:36'),
(443, 'uploads/2019/06/12/20190612_1560329952_5d00bee025501.jpg', '_MG_9331.jpg', '20190612_1560329952_5d00bee025501.jpg', 'jpg', '2019-06-12 08:59:12', '2019-06-12 08:59:12'),
(444, 'uploads/2019/06/12/20190612_1560329968_5d00bef0085e7.jpg', '_MG_9281.jpg', '20190612_1560329968_5d00bef0085e7.jpg', 'jpg', '2019-06-12 08:59:28', '2019-06-12 08:59:28'),
(445, 'uploads/2019/06/12/20190612_1560329988_5d00bf0412b17.jpg', '_MG_9049.jpg', '20190612_1560329988_5d00bf0412b17.jpg', 'jpg', '2019-06-12 08:59:48', '2019-06-12 08:59:48'),
(446, 'uploads/2019/06/12/20190612_1560330016_5d00bf20e75d3.jpg', '_MG_9212.jpg', '20190612_1560330016_5d00bf20e75d3.jpg', 'jpg', '2019-06-12 09:00:16', '2019-06-12 09:00:16'),
(447, 'uploads/2019/06/12/20190612_1560330099_5d00bf73acd3d.jpg', '_MG_9410.jpg', '20190612_1560330099_5d00bf73acd3d.jpg', 'jpg', '2019-06-12 09:01:39', '2019-06-12 09:01:39'),
(448, 'uploads/2019/06/12/20190612_1560330179_5d00bfc3620ff.jpg', '_MG_9074.jpg', '20190612_1560330179_5d00bfc3620ff.jpg', 'jpg', '2019-06-12 09:02:59', '2019-06-12 09:02:59'),
(449, 'uploads/2019/06/12/20190612_1560330252_5d00c00c02f7e.jpg', '_MG_9432.jpg', '20190612_1560330252_5d00c00c02f7e.jpg', 'jpg', '2019-06-12 09:04:12', '2019-06-12 09:04:12'),
(450, 'uploads/2019/06/12/20190612_1560330326_5d00c0565dee7.jpg', '_MG_9357.jpg', '20190612_1560330326_5d00c0565dee7.jpg', 'jpg', '2019-06-12 09:05:26', '2019-06-12 09:05:26'),
(451, 'uploads/2019/06/12/20190612_1560330412_5d00c0ac713b4.jpg', '_MG_9398.jpg', '20190612_1560330412_5d00c0ac713b4.jpg', 'jpg', '2019-06-12 09:06:52', '2019-06-12 09:06:52'),
(452, 'uploads/2019/06/17/20190617_1560764960_5d076220da65d.jpg', '_MG_9364.jpg', '20190617_1560764960_5d076220da65d.jpg', 'jpg', '2019-06-17 09:49:20', '2019-06-17 09:49:20'),
(453, 'uploads/2019/06/17/20190617_1560765233_5d07633172cc9.jpg', '_MG_904912.jpg', '20190617_1560765233_5d07633172cc9.jpg', 'jpg', '2019-06-17 09:53:53', '2019-06-17 09:53:53'),
(454, 'uploads/2019/06/17/20190617_1560765259_5d07634b0a911.jpg', '_MG_9398.jpg', '20190617_1560765259_5d07634b0a911.jpg', 'jpg', '2019-06-17 09:54:19', '2019-06-17 09:54:19'),
(455, 'uploads/2019/06/18/20190618_1560824998_5d084ca6db820.jpg', '_MG_9410.jpg', '20190618_1560824998_5d084ca6db820.jpg', 'jpg', '2019-06-18 02:29:58', '2019-06-18 02:29:58'),
(456, 'uploads/2019/06/18/20190618_1560825134_5d084d2e5f2eb.jpg', '_MG_9357.jpg', '20190618_1560825134_5d084d2e5f2eb.jpg', 'jpg', '2019-06-18 02:32:14', '2019-06-18 02:32:14'),
(457, 'uploads/2019/06/18/20190618_1560834049_5d0870010cccc.jpg', '_MG_904912.jpg', '20190618_1560834049_5d0870010cccc.jpg', 'jpg', '2019-06-18 05:00:49', '2019-06-18 05:00:49'),
(458, 'uploads/2019/06/18/20190618_1560834093_5d08702d26293.jpg', '_MG_9410.jpg', '20190618_1560834093_5d08702d26293.jpg', 'jpg', '2019-06-18 05:01:33', '2019-06-18 05:01:33'),
(459, 'uploads/2019/06/18/20190618_1560841073_5d088b71a6a02.jpg', '_MG_9432.jpg', '20190618_1560841073_5d088b71a6a02.jpg', 'jpg', '2019-06-18 06:57:53', '2019-06-18 06:57:53'),
(460, 'uploads/2019/06/19/20190619_1560911571_5d099ed31863d.jpg', '_MG_9432.jpg', '20190619_1560911571_5d099ed31863d.jpg', 'jpg', '2019-06-19 02:32:51', '2019-06-19 02:32:51'),
(461, 'uploads/2019/06/19/20190619_1560911609_5d099ef94131b.jpg', '_MG_9432.jpg', '20190619_1560911609_5d099ef94131b.jpg', 'jpg', '2019-06-19 02:33:29', '2019-06-19 02:33:29'),
(462, 'uploads/2019/06/27/20190627_1561628546_5d148f829034c.png', '', '20190627_1561628546_5d148f829034c.png', 'png', '2019-06-27 09:42:26', '2019-06-27 09:42:26'),
(463, 'uploads/2019/06/27/20190627_1561628641_5d148fe1d0be9.png', '', '20190627_1561628641_5d148fe1d0be9.png', 'png', '2019-06-27 09:44:01', '2019-06-27 09:44:01'),
(464, 'uploads/2019/07/02/20190702_1562041184_5d1adb6046308.jpg', 'tra-xoai-x-quên.jpg', '20190702_1562041184_5d1adb6046308.jpg', 'jpg', '2019-07-02 04:19:44', '2019-07-02 04:19:44'),
(465, 'uploads/2019/07/06/20190706_1562377800_5d1ffe4845ca8.jpg', 'kemtuyetxoai.jpg', '20190706_1562377800_5d1ffe4845ca8.jpg', 'jpg', '2019-07-06 01:50:00', '2019-07-06 01:50:00'),
(466, 'uploads/2019/07/06/20190706_1562378042_5d1fff3a38890.jpg', 'yakulkchanh.jpg', '20190706_1562378042_5d1fff3a38890.jpg', 'jpg', '2019-07-06 01:54:02', '2019-07-06 01:54:02'),
(467, 'uploads/2019/07/06/20190706_1562378957_5d2002cdc458f.jpg', 'tradaohoanhai.jpg', '20190706_1562378957_5d2002cdc458f.jpg', 'jpg', '2019-07-06 02:09:17', '2019-07-06 02:09:17'),
(468, 'uploads/2019/07/06/20190706_1562381055_5d200aff53cda.jpg', 'kem-tuyet-matcha-dau-do.jpg', '20190706_1562381055_5d200aff53cda.jpg', 'jpg', '2019-07-06 02:44:15', '2019-07-06 02:44:15'),
(469, 'uploads/2019/08/01/20190801_1564654544_5d42bbd010d66.png', '', '20190801_1564654544_5d42bbd010d66.png', 'png', '2019-08-01 10:15:44', '2019-08-01 10:15:44'),
(470, 'uploads/2019/08/03/20190803_1564802526_5d44fdde510c4.jpg', 'congnghelaser.jpg', '20190803_1564802526_5d44fdde510c4.jpg', 'jpg', '2019-08-03 03:22:06', '2019-08-03 03:22:06'),
(471, 'uploads/2019/08/03/20190803_1564802773_5d44fed577dc6.jpg', 'congnghelaser.jpg', '20190803_1564802773_5d44fed577dc6.jpg', 'jpg', '2019-08-03 03:26:13', '2019-08-03 03:26:13'),
(472, 'uploads/2019/08/03/20190803_1564802802_5d44fef24bae4.jpg', 'congnghelaser1.jpg', '20190803_1564802802_5d44fef24bae4.jpg', 'jpg', '2019-08-03 03:26:42', '2019-08-03 03:26:42'),
(473, 'uploads/2019/08/03/20190803_1564802846_5d44ff1ebd290.png', 'congnghelaser1.png', '20190803_1564802846_5d44ff1ebd290.png', 'png', '2019-08-03 03:27:26', '2019-08-03 03:27:26'),
(474, 'uploads/2019/08/03/20190803_1564804499_5d45059395548.jpg', 'platanium.jpg', '20190803_1564804499_5d45059395548.jpg', 'jpg', '2019-08-03 03:54:59', '2019-08-03 03:54:59'),
(475, 'uploads/2019/08/03/20190803_1564804989_5d45077dc0ee7.jpg', 'relief-laser.jpg', '20190803_1564804989_5d45077dc0ee7.jpg', 'jpg', '2019-08-03 04:03:09', '2019-08-03 04:03:09'),
(476, 'uploads/2019/08/03/20190803_1564805380_5d45090435c93.jpg', 'triphasic.jpg', '20190803_1564805380_5d45090435c93.jpg', 'jpg', '2019-08-03 04:09:40', '2019-08-03 04:09:40'),
(477, 'uploads/2019/08/03/20190803_1564805778_5d450a92920d4.jpg', 'cay-nguyen-bao-phoi-nam.jpg', '20190803_1564805778_5d450a92920d4.jpg', 'jpg', '2019-08-03 04:16:18', '2019-08-03 04:16:18'),
(478, 'uploads/2019/08/03/20190803_1564806202_5d450c3a529c5.jpg', 'mblanc.jpg', '20190803_1564806202_5d450c3a529c5.jpg', 'jpg', '2019-08-03 04:23:22', '2019-08-03 04:23:22'),
(479, 'uploads/2019/08/03/20190803_1564807316_5d4510948c673.jpg', 'enzym.jpg', '20190803_1564807316_5d4510948c673.jpg', 'jpg', '2019-08-03 04:41:56', '2019-08-03 04:41:56'),
(480, 'uploads/2019/08/03/20190803_1564807615_5d4511bf85791.jpg', 'Peel-3-1.jpg', '20190803_1564807615_5d4511bf85791.jpg', 'jpg', '2019-08-03 04:46:55', '2019-08-03 04:46:55'),
(481, 'uploads/2019/08/03/20190803_1564808190_5d4513feb7f28.jpg', 'Peel-2-1.jpg', '20190803_1564808190_5d4513feb7f28.jpg', 'jpg', '2019-08-03 04:56:30', '2019-08-03 04:56:30'),
(482, 'uploads/2019/08/03/20190803_1564808517_5d4515450c22f.jpg', 'YAG-3.jpg', '20190803_1564808517_5d4515450c22f.jpg', 'jpg', '2019-08-03 05:01:57', '2019-08-03 05:01:57'),
(483, 'uploads/2019/08/03/20190803_1564808819_5d451673c4757.jpg', 'sieuvikim.jpg', '20190803_1564808819_5d451673c4757.jpg', 'jpg', '2019-08-03 05:06:59', '2019-08-03 05:06:59'),
(484, 'uploads/2019/08/03/20190803_1564811535_5d45210f8911a.jpg', 'Peel-3-1.jpg', '20190803_1564811535_5d45210f8911a.jpg', 'jpg', '2019-08-03 05:52:15', '2019-08-03 05:52:15'),
(485, 'uploads/2019/08/03/20190803_1564811553_5d45212120bf6.jpg', 'YAG-3.jpg', '20190803_1564811553_5d45212120bf6.jpg', 'jpg', '2019-08-03 05:52:33', '2019-08-03 05:52:33');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `grants`
--

CREATE TABLE `grants` (
  `idgrant` int(10) UNSIGNED NOT NULL,
  `idrole` int(11) NOT NULL,
  `to_iduser` int(11) NOT NULL,
  `by_iduser` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `grants`
--

INSERT INTO `grants` (`idgrant`, `idrole`, `to_iduser`, `by_iduser`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 2, '2019-04-13 01:30:20', '2019-04-13 01:30:20');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `impposts`
--

CREATE TABLE `impposts` (
  `idimppost` bigint(20) UNSIGNED NOT NULL,
  `idpost` bigint(20) DEFAULT NULL,
  `id_status_type` int(11) DEFAULT NULL,
  `percent_process` decimal(8,2) DEFAULT NULL,
  `iduser_imp` int(11) DEFAULT NULL,
  `idemployee` int(11) DEFAULT NULL,
  `address_reg` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_idpost_imp` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `imp_perms`
--

CREATE TABLE `imp_perms` (
  `idimp_perm` int(10) UNSIGNED NOT NULL,
  `idperm` int(11) NOT NULL,
  `idrole` int(11) NOT NULL,
  `iduserimp` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `imp_perms`
--

INSERT INTO `imp_perms` (`idimp_perm`, `idperm`, `idrole`, `iduserimp`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 2, '2019-04-13 01:30:03', '2019-04-13 01:30:03');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `imp_products`
--

CREATE TABLE `imp_products` (
  `idimp` int(10) UNSIGNED NOT NULL,
  `idproduct` bigint(20) NOT NULL,
  `idcustomer` int(11) DEFAULT NULL,
  `iduser` int(11) DEFAULT NULL,
  `amount` double(20,0) DEFAULT '0',
  `price_import` double(20,0) DEFAULT NULL,
  `price` double(20,0) DEFAULT '0',
  `price_sale_origin` double(20,0) DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `idstore` int(11) DEFAULT NULL,
  `axis_x` int(11) DEFAULT NULL,
  `axis_y` int(11) DEFAULT NULL,
  `axis_z` int(11) DEFAULT NULL,
  `id_status_type` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `imp_products`
--

INSERT INTO `imp_products` (`idimp`, `idproduct`, `idcustomer`, `iduser`, `amount`, `price_import`, `price`, `price_sale_origin`, `note`, `idstore`, `axis_x`, `axis_y`, `axis_z`, `id_status_type`, `created_at`, `updated_at`) VALUES
(62, 68, 0, 2, 0, 0, 10000000, 0, '', 0, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-03 15:39:45'),
(63, 70, 0, 2, 0, 10000, 8000000, NULL, '', 0, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-03 15:36:29'),
(64, 71, 0, 2, 0, 19500, 3000000, NULL, '', 0, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-03 15:31:26'),
(65, 72, 0, 2, 0, 15000, 10000000, NULL, '', 31, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-03 05:56:30'),
(66, 73, 0, 2, 0, 18000, 10000000, NULL, '', 31, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-03 05:56:30'),
(67, 74, 0, 2, 0, 0, 4000000, NULL, '', 31, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-03 05:56:30'),
(68, 75, 0, 2, 0, 10000, 29000, NULL, '', 31, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-02 03:33:09'),
(74, 91, 0, 2, 0, 10000, 66000, NULL, '', 31, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-02 03:33:12'),
(75, 92, 0, 2, 0, NULL, 2015, NULL, '', 31, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-02 03:33:15'),
(77, 94, 0, 2, 0, NULL, 40000, NULL, '', 31, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-02 03:33:18'),
(78, 95, 0, 2, 0, NULL, 50000, NULL, '', 31, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-02 03:33:20'),
(79, 96, 0, 2, 0, 25000, 8000000, NULL, '', 31, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-03 05:56:30'),
(80, 97, 0, 2, 0, 20000, 10500000, 15000000, '', 31, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-03 05:56:30'),
(81, 98, 0, 2, 0, NULL, 50000, NULL, '', 31, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-02 03:33:28'),
(82, 99, 0, 2, 0, NULL, 3000, NULL, '', 31, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-02 03:33:30'),
(83, 100, 0, 2, 0, NULL, 3000, NULL, '', 31, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-02 03:33:33'),
(84, 102, 0, 2, 0, NULL, 3000, NULL, '', 31, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-02 03:33:35'),
(85, 103, 0, 2, 0, 19000, 7000000, 10000000, '', 31, 0, 0, 0, 3, '2019-07-05 02:59:59', '2019-08-03 05:56:30'),
(86, 104, 0, 2, 0, NULL, 3900000, 4000000, '', 31, 0, 0, 0, 3, '2019-07-06 01:50:00', '2019-08-03 05:56:30'),
(87, 105, 0, 2, 0, NULL, 350000, 1000000, '', 31, 0, 0, 0, 3, '2019-07-06 01:54:02', '2019-08-03 05:56:30'),
(88, 106, 0, 2, 0, NULL, 199000, 2000000, '', 31, 0, 0, 0, 3, '2019-07-06 02:09:17', '2019-08-03 05:56:30'),
(89, 107, 0, 2, 0, NULL, 350000, 1000000, '', 31, 0, 0, 0, 3, '2019-07-06 02:44:15', '2019-08-03 05:56:30');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `menus`
--

CREATE TABLE `menus` (
  `idmenu` int(10) UNSIGNED NOT NULL,
  `namemenu` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `menus`
--

INSERT INTO `menus` (`idmenu`, `namemenu`, `created_at`, `updated_at`) VALUES
(1, 'menu-primary', '2019-07-09 10:43:25', '2019-07-09 10:43:25');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `menu_has_cate`
--

CREATE TABLE `menu_has_cate` (
  `idmenuhascate` int(10) UNSIGNED NOT NULL,
  `idmenu` int(11) NOT NULL,
  `idcategory` int(11) NOT NULL,
  `idparent` int(11) DEFAULT NULL,
  `depth` int(10) DEFAULT NULL,
  `reorder` int(11) DEFAULT NULL,
  `trash` int(5) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `menu_has_cate`
--

INSERT INTO `menu_has_cate` (`idmenuhascate`, `idmenu`, `idcategory`, `idparent`, `depth`, `reorder`, `trash`, `created_at`, `updated_at`) VALUES
(129, 1, 9, 0, 0, 1, 0, '2019-07-29 01:55:25', '2019-08-03 03:01:20'),
(130, 1, 23, 129, 1, 2, 0, '2019-07-29 01:55:25', '2019-08-03 03:01:20'),
(131, 1, 25, 129, 1, 3, 0, '2019-07-29 01:55:25', '2019-08-03 03:01:20'),
(132, 1, 26, 129, 1, 4, 0, '2019-07-29 01:55:25', '2019-08-03 03:01:20'),
(133, 1, 28, 0, 0, 5, 0, '2019-07-29 01:55:44', '2019-08-03 03:01:20'),
(134, 1, 18, 133, 1, 6, 0, '2019-07-29 01:55:44', '2019-08-03 03:01:20'),
(135, 1, 19, 133, 1, 9, 0, '2019-07-29 01:55:44', '2019-08-03 03:01:20'),
(136, 1, 20, 133, 1, 10, 0, '2019-07-29 01:55:44', '2019-08-03 03:01:20'),
(142, 1, 24, 0, 0, 11, 0, '2019-08-02 10:07:01', '2019-08-03 03:01:20'),
(143, 1, 21, 133, 1, 7, 0, '2019-08-02 10:07:01', '2019-08-03 03:01:20'),
(144, 1, 22, 133, 1, 8, 0, '2019-08-02 10:07:01', '2019-08-03 03:01:20'),
(145, 1, 29, 0, 0, 12, 0, '2019-08-02 10:08:56', '2019-08-02 10:33:51'),
(146, 1, 6, 0, 0, 0, 0, '2019-08-02 10:08:56', '2019-08-03 03:01:20'),
(147, 1, 7, 145, 1, 13, 0, '2019-08-02 10:08:56', '2019-08-03 04:35:31'),
(148, 1, 8, 145, 1, 14, 0, '2019-08-02 10:08:56', '2019-08-03 04:35:31');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2016_06_01_000001_create_oauth_auth_codes_table', 1),
(4, '2016_06_01_000002_create_oauth_access_tokens_table', 1),
(5, '2016_06_01_000003_create_oauth_refresh_tokens_table', 1),
(6, '2016_06_01_000004_create_oauth_clients_table', 1),
(7, '2016_06_01_000005_create_oauth_personal_access_clients_table', 1),
(8, '2018_09_28_071047_create_sv_customers_table', 1),
(9, '2018_09_28_071406_create_sv_sends_table', 1),
(10, '2018_09_28_071547_create_sv_receives_table', 1),
(11, '2018_09_28_071605_create_sv_campaigns_table', 1),
(12, '2018_09_28_092221_create_sv_post_types_table', 1),
(13, '2018_10_01_070557_create_sv_posts_table', 1),
(14, '2018_10_28_070541_create_products_table', 1),
(15, '2018_10_28_070821_create_imp_products_table', 1),
(16, '2018_10_28_070834_create_exp_products_table', 1),
(17, '2018_11_29_134641_create_permissions_table', 1),
(18, '2018_11_29_135338_create_roles_table', 1),
(19, '2018_11_29_135505_create_imp_perms_table', 1),
(20, '2018_11_29_135523_create_grants_table', 1),
(21, '2018_12_14_132905_listgrantbyid_procedure', 1),
(22, '2018_12_15_032820_listpost_procedure', 1),
(23, '2018_12_16_102228_create_post_types_table', 1),
(24, '2018_12_16_125347_create_category_types_table', 1),
(25, '2018_12_18_081612_listcatparent_procedure', 1),
(26, '2018_12_18_094626_sellistcategorybyid_procedure', 1),
(27, '2018_12_20_042704_create_status_types_table', 1),
(28, '2018_12_23_092920_update_imppost_by_id_procedure', 1),
(29, '2019_01_03_084802_creat_files_table', 1),
(30, '2019_01_03_085744_insert_files_procedure', 1),
(31, '2019_01_06_144658_sel_department_by_id_procedure', 1),
(32, '2019_01_06_174759_create_depart_employees_table', 1),
(33, '2019_01_06_175900_create_profiles_table', 1),
(34, '2019_01_06_204904_list_depart_parent_procedure', 1),
(35, '2019_01_06_212731_sel_list_department_by_id_procedure', 1),
(36, '2019_01_06_223105_list_department_procedure', 1),
(37, '2019_01_06_225258_create_departments_table', 1),
(38, '2019_01_08_233801_list_sel_emp_depart_procedure', 1),
(39, '2019_02_11_091036_create_post_has_files_table', 1),
(40, '2019_02_11_095450_create_posts_table', 1),
(41, '2019_02_11_100541_post_has_file_procedure', 1),
(42, '2019_02_11_114745_list_type_selected_procedure', 1),
(43, '2019_02_11_154503_getparentidprocedure', 1),
(44, '2019_02_11_172247_post_by_id_procedure', 1),
(45, '2019_02_11_231226_create_impposts_table', 1),
(46, '2019_02_11_231546_create_expposts_table', 1),
(47, '2019_02_12_042124_create_categories_table', 1),
(48, '2019_02_12_044223_list_category_procedure', 1),
(49, '2019_02_12_234640_sel_categoryby_id_procedure', 1),
(50, '2019_02_13_000954_insert_post_procedure', 1),
(51, '2019_02_17_142125_list_impperm_procedure', 1),
(52, '2019_02_17_142536_imppermbyid_procedure', 1),
(53, '2019_02_17_142814_listgrant_procedure', 1),
(57, '2019_02_26_222724_list_role_idperm_procedure', 2),
(58, '2019_02_28_153458_create_post_has_file_table', 2),
(59, '2019_02_28_171709_creat_post_api_procedure', 3),
(60, '2019_03_01_234312_creat_api_post_procedure', 4),
(61, '2019_04_09_173504_filter_user_reg', 5),
(62, '2019_04_11_085120_customer_reg_procedure', 6),
(63, '2019_04_14_151243_list_all_category_procedure', 7),
(64, '2019_04_14_152226_create_post_types_table', 8),
(65, '2019_04_14_202707_creat_post_api_procedure', 9),
(66, '2019_04_14_205408_create_impposts_table', 10),
(67, '2019_04_14_220123_list_customer_register_procedure', 11),
(68, '2019_04_15_215628_create_categories_table', 12),
(69, '2019_04_16_113436_list_all_cat_by_type', 12),
(70, '2019_04_16_221907_list_post_type_procedure', 12),
(71, '2019_04_18_135716_list_status_type_procedure', 13),
(72, '2019_04_18_171344_create_expposts_table', 14),
(73, '2019_05_01_221732_create_table_profile', 15),
(74, '2019_05_07_195350_creat_profile_procedure', 16),
(75, '2019_05_08_211922_create_cache_table', 17),
(76, '2019_05_08_214108_delete_user_procedure', 17),
(77, '2019_05_08_215614_create_profile_procedure', 18),
(78, '2019_05_08_222732_select_profile_procedure', 19),
(79, '2019_05_09_163643_update_profile_procedure', 20),
(80, '2019_05_10_164806_upload_avatar_procedure', 20),
(81, '2019_05_27_104911_catehasproduct', 21),
(82, '2019_05_27_152435_insert_product_procedure', 22),
(83, '2019_05_28_114143_sel_row_category_by_id_procedure', 23),
(84, '2019_05_28_134126_create_table_producthas_file', 24),
(85, '2019_05_28_170738_string_split_procedure', 25),
(86, '2019_05_29_102104_producthas_file', 26),
(87, '2019_05_29_110136_insert_file_path', 27),
(88, '2019_05_29_153414_category_has_product', 28),
(89, '2019_05_30_140614_list_product_procedure', 29),
(90, '2019_06_01_144224_product_belong_category_procedure', 30),
(91, '2019_06_02_210958_import_product_procedure', 31),
(92, '2019_06_03_093621_producthas_file_procedure', 32),
(93, '2019_06_04_134808_sel_product_by_id_procedure', 33),
(94, '2019_06_04_172642_sel_cate_selected_procedure', 34),
(95, '2019_06_05_104747_sel_gallery_procedure', 35),
(96, '2019_06_07_095122_update_catehaspro_procedure', 36),
(97, '2019_06_07_164035_update_import_product_procedure', 37),
(98, '2019_06_08_092425_delete_producthas_file_procedure', 38),
(99, '2019_06_08_112052_trash_gellery_procedure', 39),
(100, '2019_06_09_202259_list_product_by_idcate_procedure', 40),
(101, '2019_06_10_082603_create_option_table', 41),
(102, '2019_06_11_165955_add_product_procedure', 42),
(103, '2019_06_12_162710_relate_product_procedure', 43),
(104, '2019_06_12_170254_most_popular_procedure', 44),
(105, '2019_06_13_095459_create_size_table', 44),
(106, '2019_06_13_095534_create_color_table', 44),
(107, '2019_06_13_103656_sel_all_size_procedure', 45),
(108, '2019_06_13_104318_sel_all_color_procedure', 46),
(109, '2019_06_13_110756_create_cross_product_table', 47),
(110, '2019_06_13_151846_sel_cross_product_procedure', 48),
(111, '2019_06_17_143326_cross_product_has_file_procedure', 49),
(112, '2019_06_18_100206_sel_cross_product_by_id_procedure', 50),
(113, '2019_06_18_141119_sel_parent_cross_product_procedure', 51),
(114, '2019_06_18_212706_detail_by_id_product_procedure', 52),
(115, '2019_06_19_103953_create_exclude_category_table', 53),
(116, '2019_06_19_112758_sel_topping_procedure', 54),
(117, '2019_06_24_112322_order_product_procedure', 55),
(118, '2019_06_27_082956_create_district_table', 56),
(119, '2019_06_27_083752_create_city_town_table', 56),
(120, '2019_06_27_083811_create_ward_table', 56),
(121, '2019_06_27_083919_create_province_table', 56),
(122, '2019_06_27_091046_create_country_tablec', 57),
(123, '2019_06_27_091607_create_country_table', 58),
(124, '2019_06_27_093255_sel_dicstrict_procedure', 59),
(125, '2019_06_27_095338_create_sex_table', 60),
(126, '2019_06_27_114710_sel_city_town_procedure', 60),
(127, '2019_06_27_120047_sel_sex_procedure', 61),
(128, '2019_06_29_103605_update_order_number_procedure', 62),
(129, '2019_06_29_112040_complete_list_order_procedure', 63),
(130, '2019_06_30_195404_detail_customer_procedure', 64),
(131, '2019_07_01_085148_short_total_procedure', 65),
(132, '2019_07_01_160129_info_order_product_procedure', 65),
(133, '2019_07_01_204528_info_order_product_procedure', 66),
(134, '2019_07_02_150311_list_order_product_procedure', 67),
(135, '2019_07_09_142546_category_by_idcatetype', 68),
(136, '2019_07_09_161441_create_menu_table', 69),
(137, '2019_07_09_163201_create_menu_has_cate_table', 70),
(138, '2019_07_09_170403_list_menu_procedure', 71),
(139, '2019_07_09_221448_menu_has_idcate_procedure', 72),
(140, '2019_07_15_110803_list_all_cate_by_idcatetype', 72),
(141, '2019_07_25_165403_create_menu_has_id_cate_procedure', 73),
(142, '2019_07_26_133757_add_menu_item_procedure', 74),
(143, '2019_07_27_150609_list_item_cate_by_id_menu_procedure', 75),
(144, '2019_07_27_211645_update_menu_item_by_idhas_procedure', 75),
(145, '2019_07_28_182139_update_menu_has_cate_procedure', 75),
(146, '2019_07_30_084741_list_cate_by_idmenu_procedure', 76),
(147, '2019_08_02_110003_list_view_product_by_id_cate_procedure', 77);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `oauth_access_tokens`
--

CREATE TABLE `oauth_access_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `client_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `oauth_access_tokens`
--

INSERT INTO `oauth_access_tokens` (`id`, `user_id`, `client_id`, `name`, `scopes`, `revoked`, `created_at`, `updated_at`, `expires_at`) VALUES
('003723079dbfc44ccefb659f10ce82088af4a85acfa796120115edd55ed28aeaf3e1be9d8acf2951', 16, 1, 'MyApp', '[]', 0, '2019-05-21 02:45:33', '2019-05-21 02:45:33', '2020-05-21 09:45:33'),
('00f813966a46c4c2eab2bb1ad8a9beb34242627ebd07167cc0f8c26d35bfb4f430ebba94f527cfb2', 2, 1, 'MyApp', '[]', 0, '2019-07-14 04:28:07', '2019-07-14 04:28:07', '2020-07-14 11:28:07'),
('017151f6e3594e400be8f361d5561be19d1b646c45cb23edc42050f1fcfeaacdad30f26332e7bf3c', 2, 1, 'MyApp', '[]', 0, '2019-07-22 07:05:39', '2019-07-22 07:05:39', '2020-07-22 14:05:39'),
('01cfd3163ee5705287574a0cf78d7959a7190bbc214871e84bf528f7a856073916a9d4ba90660e02', 21, 1, 'MyApp', '[]', 0, '2019-06-24 03:43:23', '2019-06-24 03:43:23', '2020-06-24 10:43:23'),
('0255d773a919658141315d3d111e177b15a17d57a8d5b04ecbaf09be6789c7a22c64e6e2a9c99a6b', 2, 1, 'MyApp', '[]', 0, '2019-06-28 01:23:12', '2019-06-28 01:23:12', '2020-06-28 08:23:12'),
('02c5eb6246239dc8c502a00f04cd968d914088f56382271351eaa125d81d96bc05cef22fa727ac2e', 2, 1, 'MyApp', '[]', 0, '2019-02-27 08:50:47', '2019-02-27 08:50:47', '2020-02-27 15:50:47'),
('04efc9ed5af1655c64c2590bc9f572b32eb7eca07e429129cb9efd1baca6c0ec2e5ff66746fee23f', 2, 1, 'MyApp', '[]', 0, '2019-05-10 03:38:18', '2019-05-10 03:38:18', '2020-05-10 10:38:18'),
('04f344456a751f13528e8617784360e9bb2ce58dc9268a91707aa468aba479b212f12573574c3d1b', 2, 1, 'MyApp', '[]', 0, '2019-07-15 04:02:02', '2019-07-15 04:02:02', '2020-07-15 11:02:02'),
('058b761ebb5c44442216c31bde2d03760794215a28345c0944207b7a001d52aefaed7d7b36ab7d78', 2, 1, 'MyApp', '[]', 0, '2019-05-16 07:40:12', '2019-05-16 07:40:12', '2020-05-16 14:40:12'),
('067dac3746bfb9865589ab25f53533f9f3eed249169d635653c218b448f75bf1cac28cbb8eca3250', 2, 1, 'MyApp', '[]', 0, '2019-05-01 10:33:54', '2019-05-01 10:33:54', '2020-05-01 17:33:54'),
('0932576f7ac4ca702fd83f9c0d1181b2bb4ca461c52af492bcde5e1cf5fdbe3ac2170f23c2364a6f', 3, 1, 'MyApp', '[]', 0, '2019-05-05 14:38:59', '2019-05-05 14:38:59', '2020-05-05 21:38:59'),
('096218f4c8508b93d23381d4d757b6a898a5f7f57d775802d3c7781cb095559f9c710fcbaa7f88f2', 2, 1, 'MyApp', '[]', 0, '2019-04-26 02:06:09', '2019-04-26 02:06:09', '2020-04-26 09:06:09'),
('0a38cac016fe0b4a9addb193b5f3d823ba868c4bcbb702fe8ee8f5875654325bda145ba9f6b210be', 2, 1, 'MyApp', '[]', 0, '2019-08-03 03:43:57', '2019-08-03 03:43:57', '2020-08-03 10:43:57'),
('0a4c7a79b0a3f46cd45270bb3473c86f1c8f55fdf1ca06a038722871509ec00d9a6c5ddd7db3c097', 2, 1, 'MyApp', '[]', 0, '2019-06-24 09:23:04', '2019-06-24 09:23:04', '2020-06-24 16:23:04'),
('0b60a19cd4c3ba274cb06a8ae770000add99ba97d47448883fd4c44f84e7f588ea40eb7fa3ec1795', 2, 1, 'MyApp', '[]', 0, '2019-05-16 14:38:22', '2019-05-16 14:38:22', '2020-05-16 21:38:22'),
('0c4180dee3e171b7f1cbec9e01101d1e92d26832430d1e1641434ae24fd31c45569db9ff726ffb75', 18, 1, 'MyApp', '[]', 0, '2019-08-01 01:30:02', '2019-08-01 01:30:02', '2020-08-01 08:30:02'),
('0f756d73a4677ca66d5ac5ccf63c56c39f2a0fc36a40b78bebe93604cf4bf291f7afbfcfdf9cda0f', 18, 1, 'MyApp', '[]', 0, '2019-05-17 02:39:23', '2019-05-17 02:39:23', '2020-05-17 09:39:23'),
('10efb86325f09f6027e678077a974b501933c092c6a33c6c22e1f00865f85ac350f9228e25a6a1ff', 17, 1, 'MyApp', '[]', 0, '2019-05-20 01:56:22', '2019-05-20 01:56:22', '2020-05-20 08:56:22'),
('114792509f5c33ac5ae710663876d91eeea6885676508e9e22b0c6b41f1d287451383592a789d6e7', 2, 1, 'MyApp', '[]', 0, '2019-05-13 08:16:00', '2019-05-13 08:16:00', '2020-05-13 15:16:00'),
('117a3ac930a04e89fbcd898cadbc6520751ce821af16fd5e3db6002f0cc5f475d6d68ed9037fc17b', 2, 1, 'MyApp', '[]', 0, '2019-06-24 10:01:40', '2019-06-24 10:01:40', '2020-06-24 17:01:40'),
('1184348ed15b1be44e047f7fc4601940afd89b47522feb2214e52bbfc416fee3dd1ce24d3bb31fa3', 2, 1, 'MyApp', '[]', 0, '2019-07-05 06:38:25', '2019-07-05 06:38:25', '2020-07-05 13:38:25'),
('119c6356e35dad14eecb5673189c6c23f267980e190608a2cb7e9d620e78a91731a54de034ab2167', 2, 1, 'MyApp', '[]', 0, '2019-07-17 01:10:12', '2019-07-17 01:10:12', '2020-07-17 08:10:12'),
('11fd90efa8b1ffc1780c3899af04cc6ef25df8b30a97508a9e7aca7ee6e37dab12c2e62fe532c6a8', 2, 1, 'MyApp', '[]', 0, '2019-04-23 01:09:32', '2019-04-23 01:09:32', '2020-04-23 08:09:32'),
('129d09689dc82206833403e3855a89b985d6f90463516b28b3aa496509dad671adf2f9c8da040218', 2, 1, 'MyApp', '[]', 0, '2019-05-01 14:45:08', '2019-05-01 14:45:08', '2020-05-01 21:45:08'),
('12c7eb54fd88206c647ec1a9018e4f870c367356d040270d7c68ebd7f6f236543747b3a591b0954f', 2, 1, 'MyApp', '[]', 0, '2019-07-19 01:24:33', '2019-07-19 01:24:33', '2020-07-19 08:24:33'),
('132273c7c1c6c977a2f62bf0ee7d1d9dd8cac7bf07808d3efbe0000e01e3a2f1c1739f6ce7e2ab90', 2, 1, 'MyApp', '[]', 0, '2019-07-04 05:00:01', '2019-07-04 05:00:01', '2020-07-04 12:00:01'),
('14fadc8eb48e6f841b30759cd1619ff57deb7ffb0367940679e96a3c6b0a204ed138576e294b04d1', 2, 1, 'MyApp', '[]', 0, '2019-04-25 04:28:06', '2019-04-25 04:28:06', '2020-04-25 11:28:06'),
('15bdcc909e0762864865a6b43e54606a85174db18475ad51a94f3ad6a51131dba8bbd7a2726f11ec', 17, 1, 'MyApp', '[]', 0, '2019-05-18 03:00:03', '2019-05-18 03:00:03', '2020-05-18 10:00:03'),
('16fe0af2ab1657be8e59aca0b4008d8eb9abbc6afdcc722dd0132c98888149e5e9dec2a4e726cda9', 2, 1, 'MyApp', '[]', 0, '2019-08-01 01:29:57', '2019-08-01 01:29:57', '2020-08-01 08:29:57'),
('1794dcd211c487d12089c4edde48cb58c0aec2fcfb794f1efefdd6005c1867c6bd964d8872b8d635', 2, 1, 'MyApp', '[]', 0, '2019-06-22 06:36:52', '2019-06-22 06:36:52', '2020-06-22 13:36:52'),
('17b21775cf6079c603283918bb55014cb927a5d2a6b997667f583498cb6301635ace8c2f39f15360', 2, 1, 'MyApp', '[]', 0, '2019-04-27 01:36:55', '2019-04-27 01:36:55', '2020-04-27 08:36:55'),
('1965204fe3ef4e6e544b64b1ecb76d6e15f8a9a48139d910616d35f7107a44f12057969a6b7aa4a1', 2, 1, 'MyApp', '[]', 0, '2019-07-06 01:36:46', '2019-07-06 01:36:46', '2020-07-06 08:36:46'),
('1a0d2c5b55c8eae6c89a0768a6042d6f3edbed863d9c28852b0b76566134a1970a6f90fe678befb9', 2, 1, 'MyApp', '[]', 0, '2019-05-30 02:21:00', '2019-05-30 02:21:00', '2020-05-30 09:21:00'),
('1c924153c83792025006713f21e037468db18b2c724ff404b83420811845eabf57a1d256c5f630c6', 2, 1, 'MyApp', '[]', 0, '2019-05-17 07:04:51', '2019-05-17 07:04:51', '2020-05-17 14:04:51'),
('1e5c53b47c5a38423ae1c7fe3ff4f004bcd25d8f2a10b1170f445a89baa598efb0252afd18b940ae', 2, 1, 'MyApp', '[]', 0, '2019-07-09 06:36:07', '2019-07-09 06:36:07', '2020-07-09 13:36:07'),
('1ec13bac250e8c2dde5c65ff9f6cd2a50e84531737a31947c2e494c7f204442284d6c7d61b9a64ba', 18, 1, 'MyApp', '[]', 0, '2019-08-01 01:35:39', '2019-08-01 01:35:39', '2020-08-01 08:35:39'),
('1f736237bd5b2795b3fe4d67c70c259a800187d1262f7a682e12dc709b1255b8876529cce09fc6c4', 2, 1, 'MyApp', '[]', 0, '2019-04-25 08:15:20', '2019-04-25 08:15:20', '2020-04-25 15:15:20'),
('209cb88bfa7ffebf236395e2a39de20ffe42c65d0524b7df9e45ddf9002ffe9a1c1c3c31a0312fbb', 2, 1, 'MyApp', '[]', 0, '2019-06-22 01:20:30', '2019-06-22 01:20:30', '2020-06-22 08:20:30'),
('21705ddc701941ec0030e51556d727d2aba54641c93fdb9dae38e1426884f313801ebfde1bb73d76', 24, 1, 'MyApp', '[]', 0, '2019-08-01 09:49:22', '2019-08-01 09:49:22', '2020-08-01 16:49:22'),
('232b3cb564badeb91709bedac2c338dad144890e9d51a39055ac0d497a4f47fb11eed976da0f7907', 2, 1, 'MyApp', '[]', 0, '2019-07-26 01:13:34', '2019-07-26 01:13:34', '2020-07-26 08:13:34'),
('241b17895075f84cc18f380d036d7e5840e61f826db14c36d1397a096fc7b4782655a4b5d9f8da90', 2, 1, 'MyApp', '[]', 0, '2019-03-26 06:54:32', '2019-03-26 06:54:32', '2020-03-26 13:54:32'),
('256d309a276e1b2156417da67697796a42945156e38384fbb6ae0acf7215dd7d0a22fc8d7027f913', 2, 1, 'MyApp', '[]', 0, '2019-07-05 01:30:46', '2019-07-05 01:30:46', '2020-07-05 08:30:46'),
('25e20610a63c42679ee3d08e368b7ce5c6740ca4d24ced15330cacf90e7ab1f51690d40c2918f15e', 2, 1, 'MyApp', '[]', 0, '2019-07-14 09:14:19', '2019-07-14 09:14:19', '2020-07-14 16:14:19'),
('28a0fcfa1ade07d20ac6da7747bbf31d7435d18a48a2110bd201ac5d337dd9b83e4d47f2b2f21a91', 2, 1, 'MyApp', '[]', 0, '2019-05-05 13:59:14', '2019-05-05 13:59:14', '2020-05-05 20:59:14'),
('29f32cd7e62afccec2f43fb5df42b2a7f48a38a4e0c8ea56a728d2fdaba864deea206834784167fe', 2, 1, 'MyApp', '[]', 0, '2019-02-27 03:15:01', '2019-02-27 03:15:01', '2020-02-27 10:15:01'),
('2a1c77e9b2f2ab04ab04abbb8e33587a187d9b8a2bd2364b86791e8e7bc0346463ab29770a6bdcaa', 2, 1, 'MyApp', '[]', 0, '2019-07-03 01:50:54', '2019-07-03 01:50:54', '2020-07-03 08:50:54'),
('2d437e02c4ffd98fd86eae21d0e9f0ea1f6556db5dd7290001f02575ccc773766d855857bb2182a8', 2, 1, 'MyApp', '[]', 0, '2019-07-25 15:22:26', '2019-07-25 15:22:26', '2020-07-25 22:22:26'),
('2d48e6079962345f9fb322fbafd7e55a933c0384b2c281786f8f92e8e98af187d60e2f9c229d61c8', 2, 1, 'MyApp', '[]', 0, '2019-07-27 01:17:11', '2019-07-27 01:17:11', '2020-07-27 08:17:11'),
('2d4e4f6c487aeb65d97a4c1ca61110c68d53de18a7b459c9c7b9f3ccbfa13ed883a35eb07ca4cbc9', 2, 1, 'MyApp', '[]', 0, '2019-05-14 01:05:49', '2019-05-14 01:05:49', '2020-05-14 08:05:49'),
('2de3bc5849bd7d366c6998ea24c4a3e1fbd9cbdb0252d7c07f5e1e1cabd6dda51a3fe8af55745dbf', 2, 1, 'MyApp', '[]', 0, '2019-05-21 06:35:38', '2019-05-21 06:35:38', '2020-05-21 13:35:38'),
('2e8a8d2f07b4942ef9c795e50d2bef662fda0e7d4e096dc0d8e2290dbc1eefa310374a0e8456ac52', 2, 1, 'MyApp', '[]', 0, '2019-06-08 09:33:16', '2019-06-08 09:33:16', '2020-06-08 16:33:16'),
('3089e07e48e983d117508033bdb4638a080f6ffa9a5ff51efb5933a2973ee32ff4196fa1c6673a73', 2, 1, 'MyApp', '[]', 0, '2019-05-10 03:02:47', '2019-05-10 03:02:47', '2020-05-10 10:02:47'),
('325cdc3ca68af589fe22ec144c335c3b95e833cf51dd38e8aa830a9d0f4abfe80cde9458953d9af6', 2, 1, 'MyApp', '[]', 0, '2019-05-11 01:10:02', '2019-05-11 01:10:02', '2020-05-11 08:10:02'),
('327b2c1e59dd29fb99ab2e3481d0d172cc2977c4b6b5fd55b0934b04344caa470ca0a5bce949e673', 2, 1, 'MyApp', '[]', 0, '2019-07-08 12:33:10', '2019-07-08 12:33:10', '2020-07-08 19:33:10'),
('32b0f24fbab58f05d16edd12d80d4f010e88cb28fd104fcbc1b56e6dd7c55d7d8f396bf205f53162', 2, 1, 'MyApp', '[]', 0, '2019-04-22 01:10:07', '2019-04-22 01:10:07', '2020-04-22 08:10:07'),
('340f7abe85cc72a813f1b8cfdde06734c551a5013fe4ea3ff91c8af4760e1625968c3594619296f9', 2, 1, 'MyApp', '[]', 0, '2019-06-10 13:19:57', '2019-06-10 13:19:57', '2020-06-10 20:19:57'),
('34264f67b892acd309407bf9f54fff37cc9dd0469168db9afa520e758657a693defc6539eae5f2b3', 2, 1, 'MyApp', '[]', 0, '2019-05-21 01:10:13', '2019-05-21 01:10:13', '2020-05-21 08:10:13'),
('34a74ab1625693d9e64d772dddc35a6aad295a47c079d1b4d963726ce816393e95f3437efdc3d152', 2, 1, 'MyApp', '[]', 0, '2019-05-01 14:05:29', '2019-05-01 14:05:29', '2020-05-01 21:05:29'),
('36e48d91998df9621f6e9833f5ba424dcbdfeb69c193813c4ff947797920ea3c0794015a4490c9f5', 2, 1, 'MyApp', '[]', 0, '2019-06-04 01:17:17', '2019-06-04 01:17:17', '2020-06-04 08:17:17'),
('3853eedd8cdad69da0d2604dd6ac6704067111d15cf4460beccd98ac39d98c40f3b24d8f8ba1fd2b', 10, 1, 'MyApp', '[]', 0, '2019-05-07 13:27:10', '2019-05-07 13:27:10', '2020-05-07 20:27:10'),
('38ec2a406a32277bb6e0076a6676027854606083ee8f7c341144664bf5d4ca455eb95480c8e09e72', 17, 1, 'MyApp', '[]', 0, '2019-05-17 02:48:00', '2019-05-17 02:48:00', '2020-05-17 09:48:00'),
('3cdb41f9872fdb5710cf0868782fce853b4407eefb29b07fc556dab6ee401b6801f23aeff8aacf02', 2, 1, 'MyApp', '[]', 0, '2019-05-23 01:14:00', '2019-05-23 01:14:00', '2020-05-23 08:14:00'),
('3d191b70ea87fa97ceeb18df926d48ce8f5b0c1e9b6b7310d76b5112f5a50b40062e1d8066a1ab7c', 2, 1, 'MyApp', '[]', 0, '2019-05-18 08:14:36', '2019-05-18 08:14:36', '2020-05-18 15:14:36'),
('3f16c297a4305998873ead59276f56653df2ad9ecf17e0c238d3fc7f726d0cfd4a5a0897fc652557', 2, 1, 'MyApp', '[]', 0, '2019-02-28 06:33:42', '2019-02-28 06:33:42', '2020-02-28 13:33:42'),
('40b67f3d0f979692b672b5c94557e81f8a9995e7bad153b842f273f7be7fd637f61558da2f9e1071', 2, 1, 'MyApp', '[]', 0, '2019-05-15 04:35:50', '2019-05-15 04:35:50', '2020-05-15 11:35:50'),
('40f1c0c6f10bad82cffed7d95de01c3fab09d34cdd57e4583c649c3cc449f11bc27d19978c649595', 2, 1, 'MyApp', '[]', 0, '2019-07-14 13:21:59', '2019-07-14 13:21:59', '2020-07-14 20:21:59'),
('41db00424c7394500406d3e66a780faeff697ee15b2edee5fee1c513c5cdcd171b94689efbd789b3', 2, 1, 'MyApp', '[]', 0, '2019-07-20 01:10:36', '2019-07-20 01:10:36', '2020-07-20 08:10:36'),
('4329c2b81a028ba21a9afbd2529bfa00aa397b4855e82a9c77e8f73cc42781e58c74d61bed0102b0', 2, 1, 'MyApp', '[]', 0, '2019-07-31 08:34:24', '2019-07-31 08:34:24', '2020-07-31 15:34:24'),
('434881af631f2459939d5f9685fe752f8c226d47bfec2d0a3910b9c37527760e0255230781934e3d', 2, 1, 'MyApp', '[]', 0, '2019-07-12 14:59:32', '2019-07-12 14:59:32', '2020-07-12 21:59:32'),
('43b9ed78e7c9778bfc62b2241119bd7e966de4b148a481282325daf5b666da51994c56e10a5563cc', 2, 1, 'MyApp', '[]', 0, '2019-05-03 13:00:48', '2019-05-03 13:00:48', '2020-05-03 20:00:48'),
('43d805f5102cbb4fceed27e90da0391cc3c71749643b6f09bbaef304a24fa01992c52979f2daee3d', 2, 1, 'MyApp', '[]', 0, '2019-05-28 01:16:19', '2019-05-28 01:16:19', '2020-05-28 08:16:19'),
('44ec7b99efd12d73fa64e6fff946edc47a34262246fcbe95baa9eee84e924cfc71e90e1f954516dc', 2, 1, 'MyApp', '[]', 0, '2019-07-05 10:32:54', '2019-07-05 10:32:54', '2020-07-05 17:32:54'),
('45a885012978aaf183fd066168f2c6f23a197bbe222bbfe6f83ad34b033f614c1a357f7fb5c0d04e', 2, 1, 'MyApp', '[]', 0, '2019-05-04 15:54:03', '2019-05-04 15:54:03', '2020-05-04 22:54:03'),
('473786458558c1d7c54f830b15808d3d8b56aecfbf81bb0beacad8ce730bfbdc05ce5c409a8d5e39', 2, 1, 'MyApp', '[]', 0, '2019-07-09 04:41:08', '2019-07-09 04:41:08', '2020-07-09 11:41:08'),
('49d6ad9b80eaaf693979d23bf4273779225ce6f6fa9bee6af07a3119f8b9a94a283f666cf6fa421b', 2, 1, 'MyApp', '[]', 0, '2019-05-27 01:32:34', '2019-05-27 01:32:34', '2020-05-27 08:32:34'),
('4d2751acf180655de73b09f0350704f25a85967e58fd9a98a39d1822ecd8bd78b6ba8cc2ccf78e67', 2, 1, 'MyApp', '[]', 0, '2019-06-24 03:05:09', '2019-06-24 03:05:09', '2020-06-24 10:05:09'),
('4d4caf5f40e26b4a72f0297d52614c3e7eaccad48968f92f2b70213cafe88292f27c7a7c45d6e0ed', 2, 1, 'MyApp', '[]', 0, '2019-04-19 08:14:57', '2019-04-19 08:14:57', '2020-04-19 15:14:57'),
('4deb216e03e4291942c85ee92fc219914125b5855a8919b97c39ed3d426b1b94e4722c73cd50fc52', 22, 1, 'MyApp', '[]', 0, '2019-06-24 03:46:31', '2019-06-24 03:46:31', '2020-06-24 10:46:31'),
('4e45c1047743a7b6dc94130846bbaee0fd9ca8458e2d771fe9fdc411b698479789053ed901e53b28', 2, 1, 'MyApp', '[]', 0, '2019-07-18 03:21:58', '2019-07-18 03:21:58', '2020-07-18 10:21:58'),
('4ec448ec95893522cf9a40681e0d207f242aa4860d3000b1318a8809964904b393cbefb2ff582627', 2, 1, 'MyApp', '[]', 0, '2019-08-03 02:41:53', '2019-08-03 02:41:53', '2020-08-03 09:41:53'),
('4f056d2e9cd72c9ad50e8aea6433897ee11c07cd759a9774543bb897c527ccf17b62ad0ac96f69f7', 12, 1, 'MyApp', '[]', 0, '2019-05-07 15:47:20', '2019-05-07 15:47:20', '2020-05-07 22:47:20'),
('4fbd8497ab1161001d1233a3cb1ffc6d49e2da41460f608b476b2888d66efab58e761b8c9a19f75c', 2, 1, 'MyApp', '[]', 0, '2019-04-30 15:32:09', '2019-04-30 15:32:09', '2020-04-30 22:32:09'),
('4fc48a84bd46657b32ef030f4e9db4e469279a9ec80e3e329bdc2521ac248e835fd71cc587b19486', 2, 1, 'MyApp', '[]', 0, '2019-06-30 09:06:38', '2019-06-30 09:06:38', '2020-06-30 16:06:38'),
('52e0d3f219394e03b94eb6e91f432b8a8ea903a5a398222ede074f08f6fc5943294d512f8edb43cf', 28, 1, 'MyApp', '[]', 0, '2019-08-01 10:02:19', '2019-08-01 10:02:19', '2020-08-01 17:02:19'),
('534218dcfefb2bfed9eccaf5a3fa1065f7a3a465193b06d6bb8f24d2cc2cc5656dc3335969a66f20', 2, 1, 'MyApp', '[]', 0, '2019-06-03 14:28:59', '2019-06-03 14:28:59', '2020-06-03 21:28:59'),
('54e6e5cfbd0547753525f23e7923a5e2d115f4c5fa87753ec185a22a93178a4d1f8a4c17d2c0f92a', 15, 1, 'MyApp', '[]', 0, '2019-05-11 02:27:34', '2019-05-11 02:27:34', '2020-05-11 09:27:34'),
('553abd13018c51106fb3245db77b36274db4b95eddb1c61a73b1722a3dd9a312cca093c7702c8e66', 2, 1, 'MyApp', '[]', 0, '2019-05-07 11:59:18', '2019-05-07 11:59:18', '2020-05-07 18:59:18'),
('5639c1e5da120bafe52a049a60419412e477a1608c1e9fa6682d40bb903d5d252697fdb7635d0f9b', 2, 1, 'MyApp', '[]', 0, '2019-04-25 01:23:43', '2019-04-25 01:23:43', '2020-04-25 08:23:43'),
('583779a215b8d1595d880c603b0d8e461d06f8ff55cb92b32c04d5f6645a9d584c498e14d7af61c1', 2, 1, 'MyApp', '[]', 0, '2019-08-02 08:15:45', '2019-08-02 08:15:45', '2020-08-02 15:15:45'),
('583a27a7b3b79ad1ead6e24564de574903441a703a1208587bfa4fa968b8be20a738082377b78add', 2, 1, 'MyApp', '[]', 0, '2019-05-29 10:13:17', '2019-05-29 10:13:17', '2020-05-29 17:13:17'),
('587fb93867dfa81b135fe374883068761a46d74293461a0f7fbe30e5077753a3e87c48dfa6be90db', 2, 1, 'MyApp', '[]', 0, '2019-04-12 04:12:38', '2019-04-12 04:12:38', '2020-04-12 11:12:38'),
('5db6b13492643a9a462c0dce4ce04a3d96df00ed18edbf0d26a1dac7d74271f69a084235734392ed', 2, 1, 'MyApp', '[]', 0, '2019-04-26 06:34:58', '2019-04-26 06:34:58', '2020-04-26 13:34:58'),
('603880efe258e0f330f18c1c3c7191736e04202a77e7639a02ab078889ff25becb9a30f0c77f4990', 15, 1, 'MyApp', '[]', 0, '2019-05-10 06:57:54', '2019-05-10 06:57:54', '2020-05-10 13:57:54'),
('6124e86b611137ff840c94d75140df3b9a9b5cb78b14eb54e216edf860ccc2f2b1a87c7a56068a6f', 16, 1, 'MyApp', '[]', 0, '2019-05-18 08:13:23', '2019-05-18 08:13:23', '2020-05-18 15:13:23'),
('612e0eccbd4da857db0825ff3aab22f4dd86c6a6d184c460341fd716ae2b5b7990cbc326d9effcfa', 2, 1, 'MyApp', '[]', 0, '2019-06-07 01:24:19', '2019-06-07 01:24:19', '2020-06-07 08:24:19'),
('62466961de48886a17f532889b3dc96ab4fcce3e13b524cd69acc6170eb867a69d3a3cde5e8b2c33', 2, 1, 'MyApp', '[]', 0, '2019-03-18 04:44:22', '2019-03-18 04:44:22', '2020-03-18 11:44:22'),
('637979837d6b444ddb73d3167055561ba2e8dd00d00c4c4825a5534a8d6e652388f6e612f41c886b', 2, 1, 'MyApp', '[]', 0, '2019-04-29 04:01:47', '2019-04-29 04:01:47', '2020-04-29 11:01:47'),
('63dfa383a47cfa371afc20909d422671e19543c81e9d40854f0c51d889e76040a670f38f773f2ebe', 2, 1, 'MyApp', '[]', 0, '2019-04-09 01:08:54', '2019-04-09 01:08:54', '2020-04-09 08:08:54'),
('64388e16751f491255693a2c8dc3138269820ee1b1e764abd125ca1fb2d808a738f92153c76931b5', 2, 1, 'MyApp', '[]', 0, '2019-03-22 07:11:53', '2019-03-22 07:11:53', '2020-03-22 14:11:53'),
('64c77bdb8b11ef53adf99644e1b761241347a9932d944a27f0d981d0b1d0988d92b02c54e218db3c', 17, 1, 'MyApp', '[]', 0, '2019-08-02 01:47:12', '2019-08-02 01:47:12', '2020-08-02 08:47:12'),
('67306fcdc22aa5b8443942722784fc32d985baf4151f4bcada00a8969c0a6c4ea9bc6b9a801f1b45', 2, 1, 'MyApp', '[]', 0, '2019-04-18 08:18:25', '2019-04-18 08:18:25', '2020-04-18 15:18:25'),
('676d86f257186c95b4e61ef514c27bf1733b2d350dc1e0c6d404e38278c6373e085dd2a8aeeb2100', 2, 1, 'MyApp', '[]', 0, '2019-04-24 04:58:28', '2019-04-24 04:58:28', '2020-04-24 11:58:28'),
('67f937dc145cbf594bd03cf24db669a8420c13a360875c64f16f62aa9f07c71b1ff2d9d14851d30c', 2, 1, 'MyApp', '[]', 0, '2019-06-09 06:55:30', '2019-06-09 06:55:30', '2020-06-09 13:55:30'),
('69fb3f0f3d90f7f0c5fc8af0756a85974185ea7b721383b42532f440e3ef2dd9ae3ea7e4b3123c88', 2, 1, 'MyApp', '[]', 0, '2019-05-14 07:37:07', '2019-05-14 07:37:07', '2020-05-14 14:37:07'),
('6a5a881e83886e5de150d404f9837b5ecd784e385ae3c9ddfc20b93f0204e227f59ded804375d79c', 2, 1, 'MyApp', '[]', 0, '2019-06-10 04:21:47', '2019-06-10 04:21:47', '2020-06-10 11:21:47'),
('6a8cf12646ba3a01aec38b23a3d8e898b3caa2ebc4585da90150eb9642964c77be8dccdc6d1c745f', 2, 1, 'MyApp', '[]', 0, '2019-05-29 07:54:40', '2019-05-29 07:54:40', '2020-05-29 14:54:40'),
('6a8e04a0c74f204ed1225d7c19b13b15b7bee1afd94db125397ea001ebd7ae96d3643558695617a6', 2, 1, 'MyApp', '[]', 0, '2019-04-30 08:10:04', '2019-04-30 08:10:04', '2020-04-30 15:10:04'),
('6dfcc3bdabe0e793737bb463b23b24d5eb7ff5207ef421c01d6fc402bbf7e8ca696e1e067661e2c1', 25, 1, 'MyApp', '[]', 0, '2019-08-01 09:49:58', '2019-08-01 09:49:58', '2020-08-01 16:49:58'),
('6e98729a0c4e1e54fce7a96777dc287817a54f87519e047c0cc13b5aabe8f0df857446b0a9496fc0', 2, 1, 'MyApp', '[]', 0, '2019-04-12 08:45:29', '2019-04-12 08:45:29', '2020-04-12 15:45:29'),
('6ed887714edb952c96143b8c9d33e5c545e960e24be63dcc78be6b34ed18636033e0cd11c88deda5', 2, 1, 'MyApp', '[]', 0, '2019-06-17 15:40:16', '2019-06-17 15:40:16', '2020-06-17 22:40:16'),
('6f83e3687c1daaa2049f6832e39f265f2b2e59789cd56b93826e9acdcaee2e0fa9bb8b384e681c9b', 2, 1, 'MyApp', '[]', 0, '2019-07-14 12:26:08', '2019-07-14 12:26:08', '2020-07-14 19:26:08'),
('724a3a57298275991328f300077a559155fa445f52fe0b6b018131702870446c3034d8ae86e1aedc', 2, 1, 'MyApp', '[]', 0, '2019-06-04 07:18:40', '2019-06-04 07:18:40', '2020-06-04 14:18:40'),
('731868eada1e734c46875d5f8cd9aa7dc9ce09d010a319c3120d8e0db5b8574c7e6c199ae4b28c1c', 2, 1, 'MyApp', '[]', 0, '2019-06-06 01:19:55', '2019-06-06 01:19:55', '2020-06-06 08:19:55'),
('737a7e77bd8fd489f65d343a4fdf6e0f274b709c2f543196fef2bce4bd3daf54dfa581e7dfbbe6f8', 15, 1, 'MyApp', '[]', 0, '2019-05-08 15:13:47', '2019-05-08 15:13:47', '2020-05-08 22:13:47'),
('73d00ac92ef83e5ebd65713545efaaca63dc704d013c2c03e1a64b3e6cd77399c369fe17a79ce08e', 28, 1, 'MyApp', '[]', 0, '2019-08-01 10:03:32', '2019-08-01 10:03:32', '2020-08-01 17:03:32'),
('77155dd2d0ecd79c4847de3822b861f1773255e1067f8fdce0ccc60ee6588cfd67069813e74d309b', 2, 1, 'MyApp', '[]', 0, '2019-05-01 01:55:11', '2019-05-01 01:55:11', '2020-05-01 08:55:11'),
('796cf6d7b08cfd5dd3573bd9ca4357982b396a3a167831a97c51c5623d78b761cb29188f06a6ef29', 2, 1, 'MyApp', '[]', 0, '2019-06-17 07:20:04', '2019-06-17 07:20:04', '2020-06-17 14:20:04'),
('79ff6ff67b3805dcc8e95f5e802b20a5137884f7ae51ad058b0f8480f071c6c72a6e8c1e5f08ab49', 2, 1, 'MyApp', '[]', 0, '2019-06-19 01:18:32', '2019-06-19 01:18:32', '2020-06-19 08:18:32'),
('7b9982592a0313da930390fcad1015b7351edf510915e3cad09dcc41e73bde7b4d19f4b59ca78bdb', 2, 1, 'MyApp', '[]', 0, '2019-06-25 09:14:09', '2019-06-25 09:14:09', '2020-06-25 16:14:09'),
('7d88adeac7bcb9c2af82229d4c4763b4e3859fb434f7a7d30851fe751ab917a2987229b085325550', 2, 1, 'MyApp', '[]', 0, '2019-07-08 07:41:34', '2019-07-08 07:41:34', '2020-07-08 14:41:34'),
('7f0d3e0dde161325a88968a0e6ac03fb4c212d9af85e7592ffc34e969882c07f2b03b478aaacb368', 15, 1, 'MyApp', '[]', 0, '2019-05-10 06:58:35', '2019-05-10 06:58:35', '2020-05-10 13:58:35'),
('8082575ad3affa2f8fd574a6b89ea9c780beb27597c595792f95d569d6b948024f6c236892887fdb', 2, 1, 'MyApp', '[]', 0, '2019-05-08 14:07:41', '2019-05-08 14:07:41', '2020-05-08 21:07:41'),
('809d8aa479d04d48e514eb5374d4f74f447ebc0e8fef2096706f879bddde25029300ba89038aea0e', 2, 1, 'MyApp', '[]', 0, '2019-06-17 01:22:18', '2019-06-17 01:22:18', '2020-06-17 08:22:18'),
('826e068d775d21d4a42be19cfa3b7442952e2dc15c6d9348c1ac5aa2e3167f9ac2939ed404043d5d', 2, 1, 'MyApp', '[]', 0, '2019-05-11 07:49:54', '2019-05-11 07:49:54', '2020-05-11 14:49:54'),
('830b9b811bde283b7424f529c43531f008d032684d49c41990ef9d124c9a241184d28781b9590517', 2, 1, 'MyApp', '[]', 0, '2019-06-26 06:51:23', '2019-06-26 06:51:23', '2020-06-26 13:51:23'),
('83870b82718ef447c79c7e9db8790703bdf0329fb1e613c304f0f99b2bf4593bad36d2a782eab02e', 2, 1, 'MyApp', '[]', 0, '2019-06-05 01:11:10', '2019-06-05 01:11:10', '2020-06-05 08:11:10'),
('8582a0c2d267710eb00d2d4bd3e8cc64bea8bec6ec487da07d17ab417461f2167c6a06c0e77b7584', 2, 1, 'MyApp', '[]', 0, '2019-06-12 06:58:18', '2019-06-12 06:58:18', '2020-06-12 13:58:18'),
('870922a6bf84220acb1de1b4982f8cef476e390083b1c2360427e5c9cec76fb16e94d6d2c180aa99', 26, 1, 'MyApp', '[]', 0, '2019-08-01 09:50:55', '2019-08-01 09:50:55', '2020-08-01 16:50:55'),
('876e654cceb60a716206813893c111a0b7672ff9964d11cea3354474b82fc0b602bcf7c6e3952d82', 2, 1, 'MyApp', '[]', 0, '2019-06-25 09:19:17', '2019-06-25 09:19:17', '2020-06-25 16:19:17'),
('87ebdd53ca407b004d09e3f2d1ffff6303130d3021ab06fe76604be837445cb72319de1ab339dab9', 2, 1, 'MyApp', '[]', 0, '2019-07-16 04:24:33', '2019-07-16 04:24:33', '2020-07-16 11:24:33'),
('884df25b8d2d8f07c6f719da19f57485fb3be7e149fb1389890d0fe6f6daf674085200985f258dbb', 29, 1, 'MyApp', '[]', 0, '2019-08-01 10:50:50', '2019-08-01 10:50:50', '2020-08-01 17:50:50'),
('893cde9fc94d443660ba6b1d87a11fb01d34df8e8e9c593b3edc565cb55a80ab33b26823f49fc2fa', 16, 1, 'MyApp', '[]', 0, '2019-05-18 01:56:34', '2019-05-18 01:56:34', '2020-05-18 08:56:34'),
('8b5f83c4e18dee6cb0f4233f1416c202cda6d7b9a8d175c7bbdc1126a3493d15e25d18faf96ea047', 2, 1, 'MyApp', '[]', 0, '2019-05-15 08:08:05', '2019-05-15 08:08:05', '2020-05-15 15:08:05'),
('8bf073bfb40c8f26daf32885f13fb64bad31f87d630b4cba4ad99cdcd242c7a3393946ccbc96961c', 2, 1, 'MyApp', '[]', 0, '2019-07-14 12:14:55', '2019-07-14 12:14:55', '2020-07-14 19:14:55'),
('8c55d72f2cac537f3bcef521be4ae2e14f3cb4975f89ae7848ec9e3be343a7fc2822c350fe079d16', 2, 1, 'MyApp', '[]', 0, '2019-08-01 10:49:38', '2019-08-01 10:49:38', '2020-08-01 17:49:38'),
('8d34e83c73e0dd3f8fb699b696a90ef7b292d24cba6394d48affc01774b6654b483bf904c6e620b8', 17, 1, 'MyApp', '[]', 0, '2019-05-17 02:42:32', '2019-05-17 02:42:32', '2020-05-17 09:42:32'),
('8d50b826dacc986631f6304d16bde3a67224475800f3fe352915ce7c9e1208c90c53d7fb40d85446', 2, 1, 'MyApp', '[]', 0, '2019-06-11 13:27:25', '2019-06-11 13:27:25', '2020-06-11 20:27:25'),
('8d8ec8fb690211ecf871b5357e0614a0c8dcd59d7b7b6feb02a67073f002f206a806c994c864cb93', 2, 1, 'MyApp', '[]', 0, '2019-06-08 15:40:03', '2019-06-08 15:40:03', '2020-06-08 22:40:03'),
('8d8f42f3196d79e6d7a5f3df2dc3b1fe23965b534fda8f24e34aee9636e2c417658c0efd6eef68da', 2, 1, 'MyApp', '[]', 0, '2019-07-08 09:49:58', '2019-07-08 09:49:58', '2020-07-08 16:49:58'),
('9046bc10022bc3fe333c454a67c0ad3f25ea3a6994d4cdb4b8dadcb37063eb027fa9e2493ba8bb55', 2, 1, 'MyApp', '[]', 0, '2019-06-27 06:36:37', '2019-06-27 06:36:37', '2020-06-27 13:36:37'),
('93e3e9cc1d1dda63d76de5c82ac892695cfa728b2441d8d8e96cba0557f243bff7a31e28c208d749', 28, 1, 'MyApp', '[]', 0, '2019-08-01 09:56:43', '2019-08-01 09:56:43', '2020-08-01 16:56:43'),
('991932e8988494f0559e93420d89944b3eb7ad7ad9046048915b19268abab6bb5cc1c62ee4cefca8', 2, 1, 'MyApp', '[]', 0, '2019-05-04 11:03:10', '2019-05-04 11:03:10', '2020-05-04 18:03:10'),
('9a694520f6b84a7b83a6726a349cffa9dff332dec8d46fa0a8eca9395f152f61b622dcd7df980182', 24, 1, 'MyApp', '[]', 0, '2019-08-01 10:46:20', '2019-08-01 10:46:20', '2020-08-01 17:46:20'),
('9b96e18443e36eb25a504938349045ab1a01ece7337b890779e6a61ae34ec4540a9a360c7811d30f', 2, 1, 'MyApp', '[]', 0, '2019-07-24 06:32:05', '2019-07-24 06:32:05', '2020-07-24 13:32:05'),
('9bba88e9d87e0ec78a35d5257ca44a10e77506eb4cfb606041ce3d3db9520067a5767ec9f150fb1c', 2, 1, 'MyApp', '[]', 0, '2019-04-17 01:46:50', '2019-04-17 01:46:50', '2020-04-17 08:46:50'),
('9da2db5f94161b541c8d644a7bbb0d3e24a9071e4af6254819690614d4e6eb720bdb87f7ea4ae47b', 2, 1, 'MyApp', '[]', 0, '2019-06-05 03:24:05', '2019-06-05 03:24:05', '2020-06-05 10:24:05'),
('a06ad6bc9ebe165b2b4302af7e716d0296b00b418511335d92fd92169581a1c75fb5858810dbc021', 2, 1, 'MyApp', '[]', 0, '2019-07-22 01:44:59', '2019-07-22 01:44:59', '2020-07-22 08:44:59'),
('a079e3f003ea2847b1f53a00528b009d982dde864f8d3e4fea0c3aafa967f0694084d956aac112ba', 2, 1, 'MyApp', '[]', 0, '2019-05-13 01:08:57', '2019-05-13 01:08:57', '2020-05-13 08:08:57'),
('a0fbfb03a0d8eb10f3baa098b6cae6e8df9c1b03095cba56d9c8393360d7231c8838bbda4e63ecc7', 16, 1, 'MyApp', '[]', 0, '2019-05-20 02:27:16', '2019-05-20 02:27:16', '2020-05-20 09:27:16'),
('a28a87583b0af205b6171128af5616c51edef53433f61162f145258a7951f081a160022914f60304', 2, 1, 'MyApp', '[]', 0, '2019-06-05 07:30:32', '2019-06-05 07:30:32', '2020-06-05 14:30:32'),
('a3298a5df2ee219b30885500eb88dde4c825f8e90809c79dcc074eb13568ee39899fcd27f4c997c6', 2, 1, 'MyApp', '[]', 0, '2019-03-05 07:43:40', '2019-03-05 07:43:40', '2020-03-05 14:43:40'),
('a3ca726af4a336a81e728b7a9700a2813ba0eab9879cda175d0d2cbfa4c963f1afb12c136781a4bb', 2, 1, 'MyApp', '[]', 0, '2019-06-18 13:27:24', '2019-06-18 13:27:24', '2020-06-18 20:27:24'),
('a4098adffd428a36ea6900bafba5da43b526d5c40ac7c35038321191e5688b2a6a7ea39de7bf23bf', 2, 1, 'MyApp', '[]', 0, '2019-07-04 14:12:12', '2019-07-04 14:12:12', '2020-07-04 21:12:12'),
('a467a9d63cd99dd6e4c2de12e6730d10454fc36a5239c38d7e6663aec773db73a16b8b6c4681c6ac', 2, 1, 'MyApp', '[]', 0, '2019-07-30 01:21:13', '2019-07-30 01:21:13', '2020-07-30 08:21:13'),
('a4a0d89cfacd2e4fa4ff8247f7a30acd12fb5adac78acb13f00cb1f66b2440f3dfd1616a8143abf4', 2, 1, 'MyApp', '[]', 0, '2019-03-06 01:23:41', '2019-03-06 01:23:41', '2020-03-06 08:23:41'),
('a513e9b3e2f1079d416a65a1d94e4884c70c05621ecb0abdbef460283c0edef03555735fae3fe0b6', 24, 1, 'MyApp', '[]', 0, '2019-08-01 09:52:49', '2019-08-01 09:52:49', '2020-08-01 16:52:49'),
('a7a8eae946a69943cd354815a800cd8823a8a3289b1b9b3f75bb1c7cf432546e0f9b065666e75da9', 2, 1, 'MyApp', '[]', 0, '2019-05-07 13:36:13', '2019-05-07 13:36:13', '2020-05-07 20:36:13'),
('a83ee22ce98c9b1ee513e504ffce7a672c535f4eb868d7804a5660945f88dbec61d8fb8f856fb28b', 23, 1, 'MyApp', '[]', 0, '2019-08-01 09:40:25', '2019-08-01 09:40:25', '2020-08-01 16:40:25'),
('a869cba2e864239b3fd7b0d8edbbc2be087267822ea3bcb4d9348f59225aca932af8f40745fc8a93', 18, 1, 'MyApp', '[]', 0, '2019-08-01 01:29:52', '2019-08-01 01:29:52', '2020-08-01 08:29:52'),
('aaa4922e63eaef2d316628fa41754a6ea34bde6c4998dc25c77d17fcdf9c4878d3d971b24dabf735', 2, 1, 'MyApp', '[]', 0, '2019-04-17 08:11:02', '2019-04-17 08:11:02', '2020-04-17 15:11:02'),
('aaad744270954488bca3097f31100a6db3e515a992982e33a868915cbe68bfe46437e8763b3ee497', 16, 1, 'MyApp', '[]', 0, '2019-05-17 09:04:59', '2019-05-17 09:04:59', '2020-05-17 16:04:59'),
('ab868f37953c95ff2fe4eba6f02138cda88889d957d0e0d1fbcb6e3f7035ba4cfce82f5de6e6e275', 2, 1, 'MyApp', '[]', 0, '2019-04-08 08:11:24', '2019-04-08 08:11:24', '2020-04-08 15:11:24'),
('ac72613869d4ae3e97a12b669f475f018845bac34378a7b4845011b7de543251bb1b8b3c7c15c567', 2, 1, 'MyApp', '[]', 0, '2019-08-01 15:52:54', '2019-08-01 15:52:54', '2020-08-01 22:52:54'),
('b34a24a2b8c978632ec7c8cd362f41f0cd5037b8750e49401aa431751290bf418f54fd0539ff24cb', 16, 1, 'MyApp', '[]', 0, '2019-05-17 10:27:34', '2019-05-17 10:27:34', '2020-05-17 17:27:34'),
('b45aaed65e12443d8460c6a8edb9a3da27db514ca07aecd2cc8057a47ed8d6f52460d50624ddedad', 2, 1, 'MyApp', '[]', 0, '2019-06-26 08:00:44', '2019-06-26 08:00:44', '2020-06-26 15:00:44'),
('b45ae5222c4aa29bebf06a47f1f8451cad862cbededcebc663caa2dbb270ba58a9e6443faf4e81f3', 2, 1, 'MyApp', '[]', 0, '2019-06-01 01:07:35', '2019-06-01 01:07:35', '2020-06-01 08:07:35'),
('b572c6a2b427344728bfa8150882dd9a74feceee56846ca16d9e2218517628afbb153887fc8350c7', 2, 1, 'MyApp', '[]', 0, '2019-06-13 01:10:12', '2019-06-13 01:10:12', '2020-06-13 08:10:12'),
('b65902c224481a8cc80e985d8a19a8d355e027c60d7d248cd06788fca8a94d27e0bee5ffa01d9548', 2, 1, 'MyApp', '[]', 0, '2019-06-20 01:18:24', '2019-06-20 01:18:24', '2020-06-20 08:18:24'),
('b68fc76b4cf8ab066dc1f93f6339f07ccb349b3735a2e2c4838e086d9ca9873f35349347fbbc6ab6', 2, 1, 'MyApp', '[]', 0, '2019-05-31 01:12:06', '2019-05-31 01:12:06', '2020-05-31 08:12:06'),
('b72a19b2ca359e6b1f19e385c9fc7788193520b1e8ee36ae6043416f0cc9df206189ad189f8a72ff', 2, 1, 'MyApp', '[]', 0, '2019-06-05 07:59:33', '2019-06-05 07:59:33', '2020-06-05 14:59:33'),
('b78dc4d321e2c1918e4c9f0ab6342742369464c3e6a83c8cdae4e6ff6588a3d8b6c80b21a536eba0', 2, 1, 'MyApp', '[]', 0, '2019-05-16 12:00:23', '2019-05-16 12:00:23', '2020-05-16 19:00:23'),
('b832fe9b7abbe886c3d5b9d2bb96d31b9f4c9b189fddf206b0472eebec1672a01b28711f2724c700', 2, 1, 'MyApp', '[]', 0, '2019-06-27 01:21:03', '2019-06-27 01:21:03', '2020-06-27 08:21:03'),
('b8501e0320a46169a7dc8903e396f9301006a380db27d6af94129aac90c3f52a6e899de9fb558366', 2, 1, 'MyApp', '[]', 0, '2019-06-24 09:58:32', '2019-06-24 09:58:32', '2020-06-24 16:58:32'),
('b8df5d41e814fe0747f1e4055f7a3616ea8b53c28c3f1ad51cfb66146666a1e451573b2838f287cd', 2, 1, 'MyApp', '[]', 0, '2019-07-25 01:12:34', '2019-07-25 01:12:34', '2020-07-25 08:12:34'),
('b9d2f38ce6f67e2fc94907bd3382f20b84e79fa3050a4e9614aa329ea6d6599fa39a7811ab942bca', 18, 1, 'MyApp', '[]', 0, '2019-05-20 03:10:42', '2019-05-20 03:10:42', '2020-05-20 10:10:42'),
('ba863d122de17d4aaf1ba38733c0da9cf955f1fc3301376fc516fec0bc043e7646fffea88845eba3', 23, 1, 'MyApp', '[]', 0, '2019-08-02 01:48:46', '2019-08-02 01:48:46', '2020-08-02 08:48:46'),
('bb4f29906f22c4a681daa5ab02ac0dd7169f7c2478fa29ee3055b3c7849e361d3372d26ee01fa851', 15, 1, 'MyApp', '[]', 0, '2019-05-10 06:59:50', '2019-05-10 06:59:50', '2020-05-10 13:59:50'),
('bc770cf7927b373b75211a1c39489e6147cc4d9dabf35e708ff7c5a0bc8382e322992a739a4c3b67', 2, 1, 'MyApp', '[]', 0, '2019-04-24 07:44:39', '2019-04-24 07:44:39', '2020-04-24 14:44:39'),
('bcbed5ab3f6e097d6ad36bf6703f098f4954617ea8ca4946f4e9092267041d24430038e4f2bcc131', 2, 1, 'MyApp', '[]', 0, '2019-02-27 03:14:16', '2019-02-27 03:14:16', '2020-02-27 10:14:16'),
('bd478e91b3fedca43b66d583ad09c3e1613763c3e344f55c66c4a0a4ccfec7e0ce38b4a0f9942c3a', 17, 1, 'MyApp', '[]', 0, '2019-05-17 02:36:49', '2019-05-17 02:36:49', '2020-05-17 09:36:49'),
('be295188193163a7864d4368da2e87b8448b4933495a5d6d5b4e5f93a978081f8f9aae9cb5c860fb', 2, 1, 'MyApp', '[]', 0, '2019-04-24 01:08:03', '2019-04-24 01:08:03', '2020-04-24 08:08:03'),
('c04addffdc549131b92bdf5f2c8d1276c68e5ba0f9601eedfb5462f676b6a5693431ff4b4267da36', 2, 1, 'MyApp', '[]', 0, '2019-05-15 01:15:03', '2019-05-15 01:15:03', '2020-05-15 08:15:03'),
('c0ebcd2a5cdc1c24eb78c811a8e31a3a1bff8023390e89292cc29a3f74e12c83d78b6e48fe5b64e2', 2, 1, 'MyApp', '[]', 0, '2019-06-07 11:53:50', '2019-06-07 11:53:50', '2020-06-07 18:53:50'),
('c17e88138ef64e461aef135263cb60766aae95f140bcc78272426656926c269486dec96fa9548e79', 2, 1, 'MyApp', '[]', 0, '2019-07-29 01:22:05', '2019-07-29 01:22:05', '2020-07-29 08:22:05'),
('c336413a1a7b614f9c3b1cc542fc26ba33568881af0ca5a238696c6c4186005a7b8889096dbbe5dd', 2, 1, 'MyApp', '[]', 0, '2019-05-24 01:12:32', '2019-05-24 01:12:32', '2020-05-24 08:12:32'),
('c37225ef1539303153ec7e3625f3c4c5c47f7c5183b2b32c208452a4d559dd66dfdc72580782022a', 2, 1, 'MyApp', '[]', 0, '2019-04-09 04:01:23', '2019-04-09 04:01:23', '2020-04-09 11:01:23'),
('c66bf89ed3c15e4b92ab86d63b707d7b5d3b2d0e8d73b77b3d9c2e176ea0e7f35675d1ad56ff60a4', 2, 1, 'MyApp', '[]', 0, '2019-05-17 01:45:50', '2019-05-17 01:45:50', '2020-05-17 08:45:50'),
('c71c50272f464e51f02d0bfe55b937675318351fa2f0bc367d2acd201e27b983becd59f4dd518abe', 14, 1, 'MyApp', '[]', 0, '2019-05-08 15:11:56', '2019-05-08 15:11:56', '2020-05-08 22:11:56'),
('ca0830b60fdd6ff23e8068066fe3592922922871622dd9e3bdaded4e6d0af13de5215963242e453b', 2, 1, 'MyApp', '[]', 0, '2019-06-27 04:42:44', '2019-06-27 04:42:44', '2020-06-27 11:42:44'),
('ca9087419ae0358f575af4a602fcecc0f2f54ebff8294f5c99e72d0b3d48e307e17f581b1eb80a15', 2, 1, 'MyApp', '[]', 0, '2019-04-18 01:32:48', '2019-04-18 01:32:48', '2020-04-18 08:32:48'),
('caa5829e589e32b969468fae1ad69e03ecdd69b997018399dd9fd21910838e943e0d0658f6f033e0', 11, 1, 'MyApp', '[]', 0, '2019-05-07 13:30:27', '2019-05-07 13:30:27', '2020-05-07 20:30:27'),
('caf233061a79e92ec8f62209dc61fee142f30200459f63c6101d56f83bdbf3a7aaaba99b39cf38fb', 2, 1, 'MyApp', '[]', 0, '2019-07-15 14:38:05', '2019-07-15 14:38:05', '2020-07-15 21:38:05'),
('cb0ffa7026ddc4a9259a29276d4d1b57e197070cefe238148fa7d0132a2057392ef71aecd3af6f61', 2, 1, 'MyApp', '[]', 0, '2019-07-02 03:40:45', '2019-07-02 03:40:45', '2020-07-02 10:40:45'),
('cb694bfb52d361c2bef04d22bd8eca368f6889fbda88e1237b31841eab18ffae7f3c894d7d527fcf', 2, 1, 'MyApp', '[]', 0, '2019-04-20 01:22:12', '2019-04-20 01:22:12', '2020-04-20 08:22:12'),
('ccdd05d158c5d97cd5658b2a653465e7a7562d4ab6e9e8dfb5485a61461b22e4f7da556ef81af426', 2, 1, 'MyApp', '[]', 0, '2019-06-18 01:14:28', '2019-06-18 01:14:28', '2020-06-18 08:14:28'),
('cea0de1545baa2a5ea628ac3b342551f11148de095c54674f73b0c4495d96362c149485e48d18e8c', 2, 1, 'MyApp', '[]', 0, '2019-07-17 04:48:02', '2019-07-17 04:48:02', '2020-07-17 11:48:02'),
('cf918b59b9a43555ab4f6e5b84e875962d123c549652d28071e013ea6c48681fe30d54221f43ddae', 2, 1, 'MyApp', '[]', 0, '2019-06-19 06:32:12', '2019-06-19 06:32:12', '2020-06-19 13:32:12'),
('d02caadbe84fd28b0aa4211e62994ca49301e0262629b9ad5782f207df349048fdf60856309f9e1a', 27, 1, 'MyApp', '[]', 0, '2019-08-01 09:51:49', '2019-08-01 09:51:49', '2020-08-01 16:51:49'),
('d09fe90b308eda2daac310b0eb9cdbc739b91fd9ffe51244f405fed15e77d197aba610704b72ec16', 2, 1, 'MyApp', '[]', 0, '2019-07-26 12:04:12', '2019-07-26 12:04:12', '2020-07-26 19:04:12'),
('d13f0c2e4c697c9d7b266da46569f284d4b6dc87ae1a512b0afa005205e85a1ce2a2cc966684a4f4', 2, 1, 'MyApp', '[]', 0, '2019-04-13 01:19:03', '2019-04-13 01:19:03', '2020-04-13 08:19:03'),
('d16f6d3038c011fb84bf52e54fe91bcb2af735135184c67aefb5cdac4040857cc4edad45f9706244', 2, 1, 'MyApp', '[]', 0, '2019-08-02 02:13:57', '2019-08-02 02:13:57', '2020-08-02 09:13:57'),
('d2c8ca5403cc73031fc6f7fa1790164a9ebd28ec2603e4c5b24aa88c05cf3b043fbc7d953ea2066b', 2, 1, 'MyApp', '[]', 0, '2019-07-04 07:34:53', '2019-07-04 07:34:53', '2020-07-04 14:34:53'),
('d54d9f21ea288de0d6177acf95a6c449bf591ad9a18e606950084437b54052f1602d7a9ea395beea', 18, 1, 'MyApp', '[]', 0, '2019-08-01 09:35:57', '2019-08-01 09:35:57', '2020-08-01 16:35:57'),
('d5a2198f95ff44e5489155d375ff56a2b76a8ad74dc269ffa14eaa7f6e9298f5492a0b21da638837', 9, 1, 'MyApp', '[]', 0, '2019-05-07 12:17:11', '2019-05-07 12:17:11', '2020-05-07 19:17:11'),
('d6a04bb62fee99a1c1caf96009a1e00a376a48fc772a1e7cf6c708bf3425f072b5cd16f0e84c6af9', 2, 1, 'MyApp', '[]', 0, '2019-05-05 09:24:06', '2019-05-05 09:24:06', '2020-05-05 16:24:06'),
('d836e80f293b2fd237cab37db22dd7f18c9686084094ccffb02c22dc88c1f391d33ddd34bb90e14a', 16, 1, 'MyApp', '[]', 0, '2019-05-17 02:36:04', '2019-05-17 02:36:04', '2020-05-17 09:36:04'),
('d8a7b0ea0070cc35b5a07d42d6df6e2926eda9100cc5ef6a467762daeae19adf69f3df298802ab6a', 2, 1, 'MyApp', '[]', 0, '2019-05-13 08:28:54', '2019-05-13 08:28:54', '2020-05-13 15:28:54'),
('d932de0315dd2f36c812034d2205b4049a0057b245cc342b4eb57c12b821ed4ca42681ac12cc3ee2', 2, 1, 'MyApp', '[]', 0, '2019-03-06 08:07:14', '2019-03-06 08:07:14', '2020-03-06 15:07:14'),
('da27db48423af44a0c53bfda9c76dff9f2395c1a176c9ecc821108b5b66a9c9a729f43864af50056', 2, 1, 'MyApp', '[]', 0, '2019-07-24 01:59:45', '2019-07-24 01:59:45', '2020-07-24 08:59:45'),
('daa11ebf2597b97605e25aacb3e8c02d97d87c38c0d0b8f67897f86cdd4c22c50affc007038031a5', 17, 1, 'MyApp', '[]', 0, '2019-05-21 02:36:24', '2019-05-21 02:36:24', '2020-05-21 09:36:24'),
('dc6d13628502f05582be719561fd6ca4d11b3df28370afece4fd9fedbae2c2c07548941b7a7c2efa', 2, 1, 'MyApp', '[]', 0, '2019-05-25 04:59:20', '2019-05-25 04:59:20', '2020-05-25 11:59:20'),
('de33d617088f439eff8047790a638319db10e5480f541fe15e1214998ab469ecc3e45da83855d4a6', 13, 1, 'MyApp', '[]', 0, '2019-05-08 15:05:35', '2019-05-08 15:05:35', '2020-05-08 22:05:35'),
('df45fc915774d70657e7aafd768e88407f0f7286146b0b802b0646a0a3bffc5ddb01d64d63615465', 2, 1, 'MyApp', '[]', 0, '2019-06-13 06:36:07', '2019-06-13 06:36:07', '2020-06-13 13:36:07'),
('df99239b883b868d17e70c88a2de5a2efadd07e9cd5bee7702562d0fd736a4ff6055694e11f916d0', 2, 1, 'MyApp', '[]', 0, '2019-06-27 08:32:16', '2019-06-27 08:32:16', '2020-06-27 15:32:16'),
('e4b9c34997f907f1d754dc13e2b2df744ba7e298a94eec05e2e14cce6e08532efd41b84a911d0421', 2, 1, 'MyApp', '[]', 0, '2019-07-12 01:36:29', '2019-07-12 01:36:29', '2020-07-12 08:36:29'),
('e4fcd3c507c33197236ee600fbfae1890b5a381fc33d975f25d75637e37d17d743365529d69553bf', 2, 1, 'MyApp', '[]', 0, '2019-05-16 01:13:16', '2019-05-16 01:13:16', '2020-05-16 08:13:16'),
('ea941ba89a58f6f69ffbfb65dbe8102486e5aee43526e3cc9ecc54db4dcfe71fb8db3d52882594de', 2, 1, 'MyApp', '[]', 0, '2019-02-28 01:53:52', '2019-02-28 01:53:52', '2020-02-28 08:53:52'),
('eb199816de787761c0fd652f6de4ec75f903776d07c6b194692d121e399de87f979af0f20380331c', 18, 1, 'MyApp', '[]', 0, '2019-08-01 01:30:20', '2019-08-01 01:30:20', '2020-08-01 08:30:20'),
('ec900d3d79ea229f630aec2aed91b68d07adedb5696c67b9be3312ec21c57b4d2952723e7dd7aafa', 2, 1, 'MyApp', '[]', 0, '2019-06-25 09:24:42', '2019-06-25 09:24:42', '2020-06-25 16:24:42'),
('edd8592520c0805f08f3f4cb50be68a5dc7341d4061acdaada73e547da129b06e5553c1211d2051f', 2, 1, 'MyApp', '[]', 0, '2019-03-02 01:09:02', '2019-03-02 01:09:02', '2020-03-02 08:09:02'),
('ee516afb3890478cad4d40604f06275ec5afdb0b7e2c3cb4d10b33e892e4a734d93d5a1415e1c818', 29, 1, 'MyApp', '[]', 0, '2019-08-01 10:51:07', '2019-08-01 10:51:07', '2020-08-01 17:51:07'),
('ee9116e8e468f48e97d04ab45d5af40e24cbcb8ac12964c3a2db78f280a30aee8435aca20621761a', 2, 1, 'MyApp', '[]', 0, '2019-07-15 01:30:54', '2019-07-15 01:30:54', '2020-07-15 08:30:54'),
('eebcb8b6c0881d51285f1b3175057a4d91c17aa90281daee2bf4b3fb622847bb7f493f11e12e601c', 2, 1, 'MyApp', '[]', 0, '2019-03-21 10:01:19', '2019-03-21 10:01:19', '2020-03-21 17:01:19'),
('ef38df2fbf3c6ca485ce4e4b9f495d5653f0acedb9688d773dddf91572f84889879eecdd99f1b9c5', 2, 1, 'MyApp', '[]', 0, '2019-06-07 07:03:20', '2019-06-07 07:03:20', '2020-06-07 14:03:20'),
('efc8814ca3968510c60966734ac3ab76fb7927067c231b055663351d5bb15eaa07a219527c10e33a', 2, 1, 'MyApp', '[]', 0, '2019-08-03 15:04:13', '2019-08-03 15:04:13', '2020-08-03 22:04:13'),
('f440d733d86874bd55e90f565f8122efa04c3cb5f89a3cab2dda3c626a2ac803a1c7cfabe4e86592', 2, 1, 'MyApp', '[]', 0, '2019-05-10 07:00:20', '2019-05-10 07:00:20', '2020-05-10 14:00:20'),
('f4cf186493094c0baa9ea5b4d3f149de3de2961b7963272064e540537dfe7d98db76601e6345af07', 2, 1, 'MyApp', '[]', 0, '2019-07-14 13:28:06', '2019-07-14 13:28:06', '2020-07-14 20:28:06'),
('f5e2b2f0195eb9946ada086c63c04d82b8e94d3015d4594f0b19659ef043f8966699c000faab1bd0', 2, 1, 'MyApp', '[]', 0, '2019-05-10 01:23:58', '2019-05-10 01:23:58', '2020-05-10 08:23:58'),
('f66ca15e94fd11f4fa3b5e497355be704e3ba4a7b7bed055d0d543fea64fbcd3e16f51bf90090567', 2, 1, 'MyApp', '[]', 0, '2019-04-23 06:36:16', '2019-04-23 06:36:16', '2020-04-23 13:36:16'),
('f867dd75382d40379874b24a53ecf5272cb6696d47fa8331452cf0a43cd5bdb24e0339908f3f3aab', 2, 1, 'MyApp', '[]', 0, '2019-04-22 10:26:22', '2019-04-22 10:26:22', '2020-04-22 17:26:22'),
('f8d5092db08fe0e67fc640afab3eac8626ac3fb579fd8a04d8ecd707c064db967658b14d848c6bf2', 2, 1, 'MyApp', '[]', 0, '2019-06-29 03:45:12', '2019-06-29 03:45:12', '2020-06-29 10:45:12'),
('f9de553db938cbc7df3a7da7c509510a66d507f5f7cb3b3ac39ab50445aeb42f5de1a7afff0b74ca', 2, 1, 'MyApp', '[]', 0, '2019-07-22 01:12:38', '2019-07-22 01:12:38', '2020-07-22 08:12:38'),
('fb1085609dd53df7a1b0bc7ffddc0a27552da0681ca83dccdc3856f03b478022f666d8a5e79d331d', 17, 1, 'MyApp', '[]', 0, '2019-05-17 02:41:27', '2019-05-17 02:41:27', '2020-05-17 09:41:27'),
('fb452856dc1b66b6002da8863caef9b17730072341ad6c5fbd0b716f61abf8792b4b9b0dcc6e44ee', 5, 1, 'MyApp', '[]', 0, '2019-05-05 14:54:13', '2019-05-05 14:54:13', '2020-05-05 21:54:13'),
('fbaa68275cea65ecfd5a751325b78ac0bb015655f6c35e33e2b84b05301fad770a178811924eada1', 2, 1, 'MyApp', '[]', 0, '2019-06-11 02:06:22', '2019-06-11 02:06:22', '2020-06-11 09:06:22'),
('fc06b29579a37f34c51a2b6923e2ed73bcb8b6e61ceba59714131a142cc0dc3f03d30deddce7ba8a', 2, 1, 'MyApp', '[]', 0, '2019-05-17 09:59:24', '2019-05-17 09:59:24', '2020-05-17 16:59:24'),
('fd183820538e61fce86c656fa1d51e83b6d0138c80c4408e6c656447ca363529840f0fdc7d4af0e7', 2, 1, 'MyApp', '[]', 0, '2019-07-27 07:08:34', '2019-07-27 07:08:34', '2020-07-27 14:08:34'),
('fdda24a96ad12020fd4fc444397dd86c7a7997a639922aa5989b173a22b767ece966e9db886043eb', 2, 1, 'MyApp', '[]', 0, '2019-07-26 09:20:09', '2019-07-26 09:20:09', '2020-07-26 16:20:09'),
('fdeba7fd61f711165e9eb468e7951e8f8acffae5795c6fee7e37c83b26fde606a58acff245e9fff2', 2, 1, 'MyApp', '[]', 0, '2019-06-19 15:14:22', '2019-06-19 15:14:22', '2020-06-19 22:14:22');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `oauth_auth_codes`
--

CREATE TABLE `oauth_auth_codes` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `client_id` int(10) UNSIGNED NOT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `oauth_clients`
--

CREATE TABLE `oauth_clients` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secret` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `redirect` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `personal_access_client` tinyint(1) NOT NULL,
  `password_client` tinyint(1) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `oauth_clients`
--

INSERT INTO `oauth_clients` (`id`, `user_id`, `name`, `secret`, `redirect`, `personal_access_client`, `password_client`, `revoked`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Laravel Personal Access Client', 'pKAxvNpKupq4MXxptmzvuT38ByuPIWyKv87fuiQt', 'http://localhost', 1, 0, 0, '2019-02-27 02:46:34', '2019-02-27 02:46:34'),
(2, NULL, 'Laravel Password Grant Client', '4Djvc7dyJChiOr3UGmcYTjI0OrpCFenogIdusJDM', 'http://localhost', 0, 1, 0, '2019-02-27 02:46:34', '2019-02-27 02:46:34');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `oauth_personal_access_clients`
--

CREATE TABLE `oauth_personal_access_clients` (
  `id` int(10) UNSIGNED NOT NULL,
  `client_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `oauth_personal_access_clients`
--

INSERT INTO `oauth_personal_access_clients` (`id`, `client_id`, `created_at`, `updated_at`) VALUES
(1, 1, '2019-02-27 02:46:34', '2019-02-27 02:46:34');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `oauth_refresh_tokens`
--

CREATE TABLE `oauth_refresh_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_token_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `option`
--

CREATE TABLE `option` (
  `option_id` int(10) UNSIGNED NOT NULL,
  `option_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `option_value` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `autoload` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `permissions`
--

CREATE TABLE `permissions` (
  `idperm` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `permissions`
--

INSERT INTO `permissions` (`idperm`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'root', 'Quản trị hệ thống', '2019-04-13 01:30:03', '2019-04-13 01:30:03');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `posts`
--

CREATE TABLE `posts` (
  `idpost` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8mb4_unicode_ci,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_post_type` int(11) DEFAULT NULL,
  `idcategory` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `posts`
--

INSERT INTO `posts` (`idpost`, `title`, `body`, `slug`, `id_post_type`, `idcategory`, `created_at`, `updated_at`) VALUES
(1, NULL, 'http://localhost/thammy/tiem-cang-bong-da-mat-baby-face/', NULL, 2, 2, '2019-08-01 04:44:32', '2019-08-01 04:44:32'),
(2, NULL, 'đã gọi điện', NULL, 4, NULL, '2019-08-01 05:04:11', '2019-08-01 05:04:11'),
(3, NULL, 'http://localhost/thammy/#', NULL, 1, 2, '2019-08-01 06:58:36', '2019-08-01 06:58:36'),
(4, NULL, 'http://localhost/thammy/#', NULL, 1, 2, '2019-08-01 07:14:35', '2019-08-01 07:14:35'),
(5, NULL, 'https://thammyvienthienkhue.vn/tri-tan-nhang-yellow-laser-dieu-tri-nhanh-hieu-qua-toi-80/', NULL, 2, 3, '2019-08-01 07:17:28', '2019-08-01 07:17:28'),
(6, NULL, 'https://thammyvienthienkhue.vn/tri-tan-nhang-yellow-laser-dieu-tri-nhanh-hieu-qua-toi-80/#', NULL, 1, 3, '2019-08-01 07:18:10', '2019-08-01 07:18:10'),
(7, NULL, 'không bắt máy', NULL, 4, NULL, '2019-08-01 07:18:43', '2019-08-01 07:18:43'),
(8, NULL, 'đặt lịch', NULL, 7, NULL, '2019-08-01 07:19:18', '2019-08-01 07:19:18'),
(9, NULL, 'https://mgk.edu.vn/khai-giang/ ,khoa hoc chon: Phun thiêu thẩm mỹ', NULL, 2, 30, '2019-08-01 07:59:17', '2019-08-01 07:59:17'),
(10, NULL, 'https://mgk.edu.vn/ ,khoa hoc chon: Chăm sóc da', NULL, 1, 30, '2019-08-01 08:40:52', '2019-08-01 08:40:52'),
(11, NULL, 'khong bat mat', NULL, 4, NULL, '2019-08-01 10:04:38', '2019-08-01 10:04:38'),
(12, NULL, 'k tl', NULL, 5, NULL, '2019-08-01 10:05:56', '2019-08-01 10:05:56'),
(13, NULL, 'khòn bat mat', NULL, 4, NULL, '2019-08-01 10:47:22', '2019-08-01 10:47:22'),
(14, NULL, 'ghgh', NULL, 8, NULL, '2019-08-01 10:52:19', '2019-08-01 10:52:19');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post_has_files`
--

CREATE TABLE `post_has_files` (
  `idhasfile` int(10) UNSIGNED NOT NULL,
  `idpost` bigint(20) DEFAULT NULL,
  `hastype` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idfile` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `post_has_files`
--

INSERT INTO `post_has_files` (`idhasfile`, `idpost`, `hastype`, `idfile`, `created_at`, `updated_at`) VALUES
(1, 1, 'image', 0, '2019-08-01 04:44:32', '2019-08-01 04:44:32'),
(2, 3, 'image', 0, '2019-08-01 06:58:36', '2019-08-01 06:58:36'),
(3, 4, 'image', 0, '2019-08-01 07:14:35', '2019-08-01 07:14:35'),
(4, 5, 'image', 0, '2019-08-01 07:17:28', '2019-08-01 07:17:28'),
(5, 6, 'image', 0, '2019-08-01 07:18:10', '2019-08-01 07:18:10'),
(6, 9, 'image', 0, '2019-08-01 07:59:17', '2019-08-01 07:59:17'),
(7, 10, 'image', 0, '2019-08-01 08:40:52', '2019-08-01 08:40:52');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post_types`
--

CREATE TABLE `post_types` (
  `idposttype` int(10) UNSIGNED NOT NULL,
  `nametype` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idparent` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `post_types`
--

INSERT INTO `post_types` (`idposttype`, `nametype`, `icon`, `idparent`, `created_at`, `updated_at`) VALUES
(1, 'consultant', NULL, 1, '2019-04-17 01:49:25', '2019-04-17 01:49:25'),
(2, 'promotion', NULL, 1, '2019-04-17 01:49:41', '2019-04-17 01:49:41'),
(3, 'post', NULL, NULL, '2019-04-17 03:06:34', '2019-04-17 03:06:34'),
(4, 'phone', '<i class=\"fa fa-phone-square\"></i>', 4, '2019-04-17 04:44:28', '2019-04-17 04:44:28'),
(5, 'sms', '<i class=\"fa fa-send-o\"></i>', 4, '2019-04-17 04:44:44', '2019-04-17 04:44:44'),
(6, 'email', '<i class=\"fa fa-envelope-square\"></i>', 4, '2019-04-17 08:37:20', '2019-04-17 08:37:20'),
(7, 'booking', '<i class=\"fa fa-calendar-o\"></i>', 4, '2019-04-25 04:36:00', '2019-04-25 04:36:00'),
(8, 'note', '<i class=\"fa fa-sticky-note-o\"></i>', 4, '2019-05-13 08:17:17', '2019-05-13 08:17:17'),
(9, 'game', NULL, 1, '2019-05-16 01:15:16', '2019-05-16 01:15:16'),
(10, 'product', NULL, NULL, '2019-05-23 09:07:07', '2019-05-23 09:07:07');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `producthasfile`
--

CREATE TABLE `producthasfile` (
  `idproducthasfile` bigint(20) NOT NULL,
  `idproduct` bigint(20) DEFAULT NULL,
  `hastype` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idfile` bigint(20) DEFAULT NULL,
  `status_file` int(11) UNSIGNED NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `producthasfile`
--

INSERT INTO `producthasfile` (`idproducthasfile`, `idproduct`, `hastype`, `idfile`, `status_file`, `created_at`, `updated_at`) VALUES
(72, 68, 'thumbnail', 403, 1, '2019-06-07 08:58:34', '2019-06-07 10:27:35'),
(73, 68, 'gallery', 404, 0, '2019-06-07 08:58:35', '2019-06-08 03:30:51'),
(74, 68, 'gallery', 405, 0, '2019-06-07 08:58:35', '2019-06-08 07:15:21'),
(75, 68, 'thumbnail', 406, 1, '2019-06-07 10:03:23', '2019-06-07 10:27:45'),
(76, 68, 'thumbnail', 412, 1, '2019-06-08 04:52:28', '2019-06-08 04:52:28'),
(77, 68, 'gallery', 413, 0, '2019-06-08 05:03:22', '2019-06-08 05:04:18'),
(78, 68, 'gallery', 414, 0, '2019-06-08 05:03:23', '2019-06-08 06:32:32'),
(79, 68, 'thumbnail', 415, 1, '2019-06-08 06:33:58', '2019-06-08 06:33:58'),
(80, 68, 'gallery', 416, 0, '2019-06-08 06:59:33', '2019-06-08 07:14:52'),
(81, 68, 'gallery', 417, 0, '2019-06-08 07:15:21', '2019-06-10 13:47:10'),
(82, 69, 'thumbnail', 418, 1, '2019-06-08 07:20:19', '2019-06-08 07:20:19'),
(83, 69, 'gallery', 419, 1, '2019-06-08 07:20:19', '2019-06-08 07:20:19'),
(84, 70, 'thumbnail', 420, 1, '2019-06-08 07:23:37', '2019-06-08 07:23:37'),
(85, 70, 'gallery', 421, 0, '2019-06-08 07:25:41', '2019-06-10 13:49:23'),
(86, 68, 'thumbnail', 422, 1, '2019-06-10 13:47:10', '2019-06-10 13:47:10'),
(87, 68, 'gallery', 423, 0, '2019-06-10 13:47:10', '2019-06-12 08:46:54'),
(88, 70, 'thumbnail', 424, 1, '2019-06-10 13:49:23', '2019-06-10 13:49:23'),
(89, 70, 'gallery', 425, 0, '2019-06-10 13:49:23', '2019-06-12 07:42:41'),
(90, 71, 'thumbnail', 426, 1, '2019-06-10 13:52:19', '2019-06-10 13:52:19'),
(91, 72, 'thumbnail', 427, 1, '2019-06-10 13:58:31', '2019-06-10 13:58:31'),
(92, 73, 'thumbnail', 428, 1, '2019-06-10 14:00:42', '2019-06-10 14:00:42'),
(93, 74, 'thumbnail', 429, 1, '2019-06-10 14:02:49', '2019-06-10 14:02:49'),
(94, 75, 'thumbnail', 430, 1, '2019-06-10 14:04:08', '2019-06-10 14:04:08'),
(98, 68, 'gallery', 434, 0, '2019-06-12 07:17:07', '2019-06-12 08:55:16'),
(99, 68, 'gallery', 435, 0, '2019-06-12 07:17:07', '2019-06-12 08:57:44'),
(100, 68, 'gallery', 436, 0, '2019-06-12 07:17:07', '2019-06-12 07:52:24'),
(101, 68, 'gallery', 437, 0, '2019-06-12 08:46:54', '2019-06-12 08:55:26'),
(102, 68, 'thumbnail', 438, 1, '2019-06-12 08:52:47', '2019-06-12 08:52:47'),
(103, 68, 'gallery', 439, 1, '2019-06-12 08:57:44', '2019-06-12 08:57:44'),
(104, 68, 'gallery', 440, 1, '2019-06-12 08:57:44', '2019-06-12 08:57:44'),
(106, 70, 'thumbnail', 442, 1, '2019-06-12 08:58:36', '2019-06-12 08:58:36'),
(107, 71, 'thumbnail', 443, 1, '2019-06-12 08:59:12', '2019-06-12 08:59:12'),
(108, 71, 'thumbnail', 444, 1, '2019-06-12 08:59:28', '2019-06-12 08:59:28'),
(109, 71, 'thumbnail', 445, 1, '2019-06-12 08:59:48', '2019-06-12 08:59:48'),
(110, 72, 'thumbnail', 446, 1, '2019-06-12 09:00:16', '2019-06-12 09:00:16'),
(111, 73, 'thumbnail', 447, 1, '2019-06-12 09:01:39', '2019-06-12 09:01:39'),
(112, 74, 'thumbnail', 448, 1, '2019-06-12 09:02:59', '2019-06-12 09:02:59'),
(117, 75, 'thumbnail', 452, 1, '2019-06-17 09:49:20', '2019-06-17 09:49:20'),
(118, 75, 'thumbnail', 453, 1, '2019-06-17 09:53:53', '2019-06-17 09:53:53'),
(129, 91, 'thumbnail', 448, 1, '2019-06-17 16:47:41', '2019-06-17 16:47:41'),
(130, 92, 'thumbnail', 445, 1, '2019-06-17 16:49:20', '2019-06-17 16:49:20'),
(132, 94, 'thumbnail', 442, 1, '2019-06-18 01:22:36', '2019-06-18 01:22:36'),
(133, 95, 'thumbnail', 442, 1, '2019-06-18 01:52:14', '2019-06-18 01:52:14'),
(134, 96, 'thumbnail', 455, 1, '2019-06-18 02:29:58', '2019-06-18 02:29:58'),
(135, 97, 'thumbnail', 456, 1, '2019-06-18 02:32:14', '2019-06-18 02:32:14'),
(136, 92, 'thumbnail', 457, 1, '2019-06-18 05:00:49', '2019-06-18 05:00:49'),
(137, 98, 'thumbnail', 438, 1, '2019-06-18 05:01:13', '2019-06-18 05:01:13'),
(138, 98, 'thumbnail', 458, 1, '2019-06-18 05:01:33', '2019-06-18 05:01:33'),
(139, 91, 'thumbnail', 459, 1, '2019-06-18 06:57:53', '2019-06-18 06:57:53'),
(140, 100, 'thumbnail', 460, 1, '2019-06-19 02:32:51', '2019-06-19 02:32:51'),
(141, 99, 'thumbnail', 461, 1, '2019-06-19 02:33:29', '2019-06-19 02:33:29'),
(142, 103, 'thumbnail', 464, 1, '2019-07-02 04:19:44', '2019-07-02 04:19:44'),
(143, 104, 'thumbnail', 465, 1, '2019-07-06 01:50:00', '2019-07-06 01:50:00'),
(144, 105, 'thumbnail', 466, 1, '2019-07-06 01:54:02', '2019-07-06 01:54:02'),
(145, 106, 'thumbnail', 467, 1, '2019-07-06 02:09:17', '2019-07-06 02:09:17'),
(146, 107, 'thumbnail', 468, 1, '2019-07-06 02:44:15', '2019-07-06 02:44:15'),
(147, 107, 'thumbnail', 470, 1, '2019-08-03 03:22:06', '2019-08-03 03:22:06'),
(148, 107, 'thumbnail', 471, 1, '2019-08-03 03:26:13', '2019-08-03 03:26:13'),
(149, 107, 'thumbnail', 472, 1, '2019-08-03 03:26:42', '2019-08-03 03:26:42'),
(150, 107, 'thumbnail', 473, 1, '2019-08-03 03:27:26', '2019-08-03 03:27:26'),
(151, 106, 'thumbnail', 474, 1, '2019-08-03 03:54:59', '2019-08-03 03:54:59'),
(152, 105, 'thumbnail', 475, 1, '2019-08-03 04:03:09', '2019-08-03 04:03:09'),
(153, 104, 'thumbnail', 476, 1, '2019-08-03 04:09:40', '2019-08-03 04:09:40'),
(154, 103, 'thumbnail', 477, 1, '2019-08-03 04:16:18', '2019-08-03 04:16:18'),
(155, 97, 'thumbnail', 478, 1, '2019-08-03 04:23:22', '2019-08-03 04:23:22'),
(156, 96, 'thumbnail', 479, 1, '2019-08-03 04:41:56', '2019-08-03 04:41:56'),
(157, 74, 'thumbnail', 480, 1, '2019-08-03 04:46:55', '2019-08-03 04:46:55'),
(158, 73, 'thumbnail', 481, 1, '2019-08-03 04:56:30', '2019-08-03 04:56:30'),
(159, 72, 'thumbnail', 482, 1, '2019-08-03 05:01:57', '2019-08-03 05:01:57'),
(160, 71, 'thumbnail', 483, 1, '2019-08-03 05:06:59', '2019-08-03 05:06:59'),
(161, 70, 'thumbnail', 484, 1, '2019-08-03 05:52:15', '2019-08-03 05:52:15'),
(162, 68, 'thumbnail', 485, 1, '2019-08-03 05:52:33', '2019-08-03 05:52:33');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `products`
--

CREATE TABLE `products` (
  `idproduct` int(10) UNSIGNED NOT NULL,
  `namepro` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `short_desc` text COLLATE utf8mb4_unicode_ci,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_post_type` int(11) NOT NULL,
  `idsize` tinyint(3) DEFAULT NULL,
  `idcolor` tinyint(3) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`idproduct`, `namepro`, `slug`, `short_desc`, `description`, `id_post_type`, `idsize`, `idcolor`, `created_at`, `updated_at`) VALUES
(68, 'Babyface noãn hoàn cá tuyết', 'babyface-noan-hoan-ca-tuyet', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.', '&nbsp;is used to remove element from the array. The unset function is used to destroy any other variable and same way use to delete any element of an array. This unset command takes the array key as input and removed that element from the array. After removal the associated key and value does not change.', 10, 0, 0, '2019-06-07 08:58:34', '2019-08-03 15:39:45'),
(70, 'LASER REVICE & PRP', 'laser-revice-prp', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.', '<blockquote class=\"wp-block-quote\" style=\"padding-top: 15px; padding-bottom: 5px; padding-left: 40px; font-size: 14px; border-left-width: 7px; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; position: relative; line-height: 1.2; color: rgb(204, 153, 0); box-shadow: rgb(204, 204, 204) 2px 2px 15px; border-right-style: solid; border-right-width: 2px; font-family: &quot;Open Sans&quot;, sans-serif;\"><p style=\"line-height: 1.6em; color: rgb(0, 0, 0);\"><em>Nếp nhăn, sạm da, lỗ chân lông to là những dấu hiệu của quá trình lão hóa da thường gặp ở phái đẹp khi lớn tuổi hoặc chịu tác động tiêu cực của môi trường bên ngoài. Nguyên nhân là vì sự yếu đi của hệ thống nâng đỡ da do thiếu hụt collagen, elastin. Với mong muốn giúp các chị em “thoát khỏi được cơn ám ảnh về tuổi già” này. Hệ thống thẩm mỹ quốc tế Thiên Khuê nay đã cập nhật thêm một công nghệ trẻ hóa da mới – LASER REVICE &amp; PRP – Công nghệ mang lại hiệu quả tối ưu trong việc hồi sinh liên kết tế bào, khắc chế các dấu hiệu lão hóa, giữ cho làn da luôn tươi trẻ, mịn màng.</em><br></p></blockquote><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/REVICE-1.jpg\" alt=\"\" class=\"wp-image-7333\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><div class=\"quick-reg\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><ul style=\"margin-right: auto; margin-bottom: 0px; margin-left: auto; list-style: none; padding: 0px; text-align: center; max-width: 30%;\"><li style=\"display: inline; text-align: center;\"><a href=\"tel:19001768\" style=\"color: rgb(21, 21, 143); display: inline-block; padding: 0px;\"><img class=\"hotline\" src=\"http://thammyvienthienkhue.vn/wp-content/uploads/2018/10/hotline.png\" alt=\"\" style=\"width: 200px; height: auto;\"></a></li><li style=\"display: inline; text-align: center;\"><a class=\"dlp199 k5000 reg-survey\" admicro-data-event=\"100281\" admicro-data-auto=\"1\" admicro-data-order=\"true\" style=\"color: rgb(21, 21, 143); display: inline-block; padding: 0px;\"><img class=\"reg\" src=\"http://thammyvienthienkhue.vn/wp-content/uploads/2018/10/dang-ky-ngay-1.png\" style=\"width: 250px; height: auto;\"></a></li><li style=\"display: inline; text-align: center;\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">(Thông tin bảo mật an toàn)</span></span></li></ul></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">TRẺ HÓA DA VỚI LASER REVICE &amp; PRP – CÔNG NGHỆ ĐỈNH CAO TRONG CHỐNG LÃO HÓA<br></h2><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Công nghệ LASER REVICE là phiên bản cải tiến mới nhất 2018 và hoàn thiện của Laser CO2 Fractional, được coi là thế hệ Laser vi phân “tiêu chuẩn vàng” với nhiều tính năng ưu việt mới trong điều trị các vấn đề về da như xóa sẹo, làm sáng da, tái tạo và trẻ hóa da.<br></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Với các ánh sáng hồng ngoại có bước sóng 10.600nm, phát ra các tia laser tác động trực tiếp lên da và đi sâu vào trong lớp hạ bì của da, các tế bào da được tái tạo, các nguyên bào sợi tạo ra collagen và eslastin cũng như các chất nền để tái tạo lớp da mới, giúp làm đầy sẹo, tăng độ đàn hồi. Bên cạnh đó với năng lượng mạnh với tốc độ chiếu cao có thể loại bỏ sắc tố Melanin – nguyên nhân gây thâm da, sạm da, trả lại làn da mịn màng, trắng sáng.<br></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Bên cạnh đó, dưỡng chất PRP chính là Huyết Tương Giầu Tiểu Cầu được tách triết từ trong huyết tương của bản thân, quá trình đưa PRP vào khu vực da đã lăn kim sẽ tác động trực tiếp vào lớp hạ bì, kích thích cơ thể sản sinh collagen và elastin mới, thúc đẩy tế bào da phát triển, sửa chữa và thay thế những tế bào bị tổn thương. Tỷ lệ hấp thụ dưỡng chất PRP đạt trên 90% (trong khi các sản phâm khác chỉ đạt tối đa 60%). Nhờ đó, chỉ sau 1 liệu trình, sẹo lõm sẽ được san phẳng, làn da trắng sáng, láng mịn và khỏe mạnh hơn.<br></p><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/REVICE-2.jpg\" alt=\"\" class=\"wp-image-7335\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">CÒN GÌ VUI HƠN KHI LÀN DA ĐẸP CHÍNH LÀ NIỀM TỰ TIN CỦA CÁC CHỊ EM<br></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Tìm lại được làn da thời con gái 20 son sắc: trắng mịn sáng hồng</li><li>Tự tin đứng cạnh một chị hàng xóm bằng tuổi nhưng trông mình trẻ hơn</li><li>Được chồng khen vợ mình da lúc nào cũng tưới mới, trẻ trung</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">CHỈ VỚI 1 LIỆU TRÌNH NHẸ NHÀNG – AN TOÀN – KHÔNG NGHỈ DƯỠNG<br></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>TÁI TẠO, PHỤC HỒI cấu trúc da chùng, yếu</li><li>KÍCH THÍCH collagen và tế bào mới hình thành</li><li>PHÁ HỦY các hắc sắc tố gây thâm sạm, xỉn màu</li><li>LÀM SẠCH nang lông, điều tiết bã nhờn giúp lỗ chân lông se khít</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">CÁCH CHĂM SÓC DA SAU TRỊ LIỆU<br></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Không dùng các chất tẩy rửa mạnh tiếp xúc với da mặt</li><li>Thoa kem dưỡng theo chỉ định của bác sĩ để da duy trì độ tươi trẻ tốt hơn</li><li>Bảo vệ da khi ra ngoài trời, đặc biệt là trời nắng. Thoa kem chống nắng có độ SPF từ 30 trở lên</li><li>Sử dụng sữa rửa mặt dịu nhẹ, lành tính, không chà xát mạnh với da khi rửa mặt trong 1 tuần đầu sau khi sử dụng dịch vụ</li></ul><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/REVICE-3.jpg\" alt=\"\" class=\"wp-image-7336\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">QUY TRÌNH THỰC HIỆN<br></h2><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 1: Chuyên gia, bác sỹ thăm khám</span></p><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Lấy bệnh sử KH</li><li>Phân tích các chỉ số nội tiết</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 2: Lên phác đồ điều trị</span></p><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Chuyên gia, bác sỹ hội chuẩn đưa ra pháp đồ phù hợp</li><li>Phân tích các kết quả dự báo, đưa ra cam kết hiệu quả với KH</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 3: Vệ sinh, chụp hình lưu hình ảnh điều trị</span></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 4: Tiến hành điều trị</span></p><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Ủ tê &amp; Tách chiết PRP (30 phút)</li><li>Làm sạch, Sát khuẩn vùng điều</li><li>Tách sẹo ( nếu cần thiết)</li><li>Chạy máy laser revice</li><li>Cấy siêu noãn tiểu cầu PRP</li><li>Đắp mặt nạ PRP và chiếu ánh sáng sinh học</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 5: Chuyên gia, bác sỹ thăm khám lại sau khi điều trị và căn dặn chế độ sinh hoạt</span><br></p><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">HÌNH ẢNH KHÁCH HÀNG TRƯỚC VÀ SAU KHI TRẢI NGHIỆM LIỆU TRÌNH<br></h2><div class=\"wp-block-columns has-2-columns\" style=\"display: flex; flex-wrap: nowrap; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word;\"><p class=\"has-text-color\" style=\"line-height: 1.6em; color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">Chị Thanh Trà (Đồng Nai) chia sẻ:</span></p><p style=\"line-height: 1.6em;\">“Thời gian vừa rồi làn da tôi bị nhăn nheo, đặc biệt là vùng mắt. Tưởng rằng không có cách nào khắc phục nhưng sau khi trải nghiệm công nghệ trẻ hóa da bằng công nghệ Laser Revice &amp; PRP trên tôi cảm thấy rất hài lòng. Da mặt của tôi trở nên săn chắc và trẻ trung hơn, đặc biệt lỗ chân lông được se khít khiến da trở nên mịn màng hơn.”<br></p></div><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word; margin-left: 32px;\"><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px;\"><figure class=\"aligncenter is-resized\" style=\"display: table; margin-right: auto; margin-left: auto; width: 407px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/2-2.jpg\" alt=\"\" class=\"wp-image-6915\" width=\"375\" height=\"287\" style=\"width: 407px; height: auto; max-width: 100%;\"></figure></div></div></div>', 10, 0, 0, '2019-06-08 07:23:37', '2019-08-03 15:36:29'),
(71, 'Siêu vi kim PRP', 'sieu-vi-kim-prp', 'siêu vi kim sẽ được bôi tế bào gốc đặc trị để giúp da được lành lại và sản sinh collgen cùng elastin nhanh chóng hơn', '<blockquote class=\"wp-block-quote\" style=\"padding-top: 15px; padding-bottom: 5px; padding-left: 40px; font-size: 14px; border-left-width: 7px; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; position: relative; line-height: 1.2; color: rgb(204, 153, 0); box-shadow: rgb(204, 204, 204) 2px 2px 15px; border-right-style: solid; border-right-width: 2px; font-family: &quot;Open Sans&quot;, sans-serif;\"><p style=\"line-height: 1.6em; color: rgb(0, 0, 0);\"><em>Siêu vi kim PRP hay còn gọi là lăn kim tế bào gốc trên da là phương pháp giúp lấy lại nét xuân cho làn da nhanh chóng và không gây đau đớn khi sử dụng công nghệ tế bào gốc khá mới mẻ trong những năm gần đây. Vi điểm hoạt động dựa trên nguyên tắc tận dụng tối đa cơ chế tự làm lành vết thương của cơ thể, hỗ trợ việc kích thích hình thành mô da mới, phục hồi kết cấu da từ sâu trên trong, giúp da căng mịn, sáng hồng, cải thiện tình trạng mụn và sẹo không mong muốn.</em></p></blockquote><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/01a79eb11e22fd7ca433.jpg\" alt=\"\" class=\"wp-image-6856\" style=\"width: 847px; height: auto; max-width: 100%;\"><figcaption style=\"display: table-caption; margin-top: 0.5em; margin-bottom: 1em; color: rgb(85, 93, 102); font-size: 13px; caption-side: bottom;\"><em>Trẻ hóa da công nghệ Siêu Vi Kim</em></figcaption></figure></div><div class=\"quick-reg\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><ul style=\"margin-right: auto; margin-bottom: 0px; margin-left: auto; list-style: none; padding: 0px; text-align: center; max-width: 30%;\"><br></ul></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">SIÊU VI KIM PRP LÀ CÔNG NGHỆ GÌ?<br></h2><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Đây là một công nghệ sử dụng một thiết bị siêu vi kim để tác động lực lên làn da có kiểm soát. Công nghệ siêu vi kim còn được gọi là liệu pháp tăng sinh collagen, bởi liệu pháp này hình thành dựa trên cơ chế tự làm lành vết thương của da thông qua việc tác động lên da và kích thích sản sinh collagen và elastin mạnh mẽ, như vậy da sẽ được khắc phục những khuyết điểm một cách an toàn theo một cách hoàn toàn tự nhiên. Công nghệ siêu vi kim sẽ sử dụng một loại máy mà ở đầu có khoảng 200 đầu kim rất bén, rất nhỏ (khoảng 0.07mm), dài từ 0.2 – 0.3mm, được làm bằng loại thép tốt, không rỉ, được chỉ định dùng trong y khoa. Khi thực hiện trên da, loại máy này giúp tác động&nbsp; và làm làn da phản ứng với những vết kim này như là những vết thương, sau đó da sẽ tự phản ứng lại một cách tự nhiên bằng cơ chế làm lành da.</p><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">CƠ CHẾ HOẠT ĐỘNG ĐẶC BIỆT CỦA SIÊU VI KIM PRP<br></h2><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Khi đầu kim kích thích vào da và gây ra “những tổn thương giả” cực nhỏ, điều đấy giúp thúc đẩy hoạt động của tế bào mà không phá hủy chúng do “những vết thương giả” đó không quá sâu, việc đó giúp kích thích và biến đổi tế bào da phát triển tới tế bào sừng – lớp trên cùng của biểu bì. Toàn bộ quá trình này kích thích sản sinh ra tế bào thượng bì và sợi collagen cả về số lượng lẫn chất lượng, nhờ vậy da sẽ được mịn màng hơn, và tái tạo lại một làn da mới đẹp hơn. Sau khi thực hiện siêu vi kim sẽ được bôi tế bào gốc đặc trị để giúp da được lành lại và sản sinh collgen cùng elastin nhanh chóng hơn.</p><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">1 LIỆU TRÌNH SIÊU VI KIM PRP – CẢM NHẬN RÕ SỰ THAY ĐỔI TRÊN GƯƠNG MẶT!<br></h2><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Làm sáng hồng, căng mịn một cách tự nhiên.</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Giúp se khít lỗ chân lông nhanh chóng.</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Cải thiện cấu trúc da, nuôi dưỡng da mới khỏe mạnh và vững chắc.</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Tăng sinh collagen, duy trì vẻ đẹp của da nhiều tháng.</li></ul><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/7562004af6d915874cc8.jpg\" alt=\"\" class=\"wp-image-6885\" style=\"width: 847px; height: auto; max-width: 100%;\"><figcaption style=\"display: table-caption; margin-top: 0.5em; margin-bottom: 1em; color: rgb(85, 93, 102); font-size: 13px; caption-side: bottom;\"><em>Siêu vi kim PRP – Phục hồi làn da đến 90%</em></figcaption></figure></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">CAM KẾT TỪ THIÊN KHUÊ<br></h2><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Chi phí điều trị thấp, phù hợp túi tiền của mọi người.</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Hiệu quả dài lâu (căn cứ vào tình trạng da và môi trường sinh hoạt của mỗi người).</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Không động dao kéo phẫu thuật nên an toàn.</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Không mất quá nhiều thời gian nghỉ dưỡng.</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Không gây phản ứng phụ kể cả với da nhạy cảm.</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Không tạo tổn thương cho cơ thể</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">PHƯƠNG PHÁP SIÊU VI KIM PRP CÓ ĐAU KHÔNG?<br></h2><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Phương pháp hoạt động chính với 2000 đầu kim với kích thước rất nhỏ và sắc với tác động làm lành nhanh sẽ làm không phá vỡ mô và lớp màng trên da. Các vi tổn thương sẽ đóng lại sau 15 phút lăm kim nên các chị em không cần lo lắng về tình trạng đau rát, khó chịu hay ửng đỏ trên da hay nhiễm trùng trên da. Tuy nhiên, sau 3 giờ thực hiện lăn kim vi điểm hoặc chậm nhất là sáng hôm sau, chị em nên bảo vệ da với kem chống nắng và sử dụng các sản phẩm dưỡng da khác.</p><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/884bde5e5ecdbd93e4dc.jpg\" alt=\"\" class=\"wp-image-6886\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><div class=\"quick-reg\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><ul style=\"margin-right: auto; margin-bottom: 0px; margin-left: auto; list-style: none; padding: 0px; text-align: center; max-width: 30%;\"><br></ul></div><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Tẩy trang</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Rửa mặt làm sạch da</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Tẩy da chết&nbsp;</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">xông hơi , hút dầu , lấy mụn cám ( nếu có )</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Ủ tê&nbsp;</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Tách chiết PRP&nbsp;</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Sát khuẩn vùng điều trị&nbsp;</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Lăn siêu vi kim +&nbsp; đưa dưỡng chất vào da</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Thoa tinh chất&nbsp;&nbsp;</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Chiếu ánh sang sinh học</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Kết thúc điều trị</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Hướng dẫn chăm sóc tại nhà&nbsp;</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">BẢNG GIÁ DỊCH VỤ<br></h2><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><br>HÌNH ẢNH KHÁCH HÀNG TRƯỚC VÀ SAU KHI TRẢI NGHIỆM DỊCH VỤ<br></h2><div class=\"wp-block-columns has-2-columns\" style=\"display: flex; flex-wrap: nowrap; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word;\"><p class=\"has-text-color\" style=\"line-height: 1.6em; color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">Chị Thùy Loan (Bình Dương) chia sẻ:</span></p><p style=\"line-height: 1.6em;\">Trước đây mình sống khá rụt rè, ngại giao tiếp và rất ít khi ra đường, lý do chính là do mình bị không tự tin với làn da của mình lắm, da mình nói đúng hơn là bị sẹo rỗ, không được sáng và rất sần sùi luôn. Như thế là ai mà không tự tin đúng không, nhưng có độ thời gian mình nghĩ lại, không sẽ sống tự tin cả đời, vậy nên mình quyết định tìm hiểu về công nghệ Siêu vi kim PRP, cũng may mắn là mình có ông anh đã từng làm liệu trình này rồi, ông giới thiệu mình đến Thiên Khuê. Vì thấy da mặt ãnh đẹp lên trông thấy nên mình cũng yên tâm đến xem sao, và rồi kết quả hơn cả mình mong đợi luôn, cảm ơn Thiên Khuê rất nhiều!<br></p></div><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word; margin-left: 32px;\"><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 407px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/khung-before_after.jpg\" alt=\"\" class=\"wp-image-6884\" style=\"width: 407px; height: auto; max-width: 100%;\"><figcaption style=\"display: table-caption; margin-top: 0.5em; margin-bottom: 1em; color: rgb(85, 93, 102); font-size: 13px; caption-side: bottom;\"><em>(*) Kết quả có thể khác nhau tuỳ theo cơ địa của mỗi ngườ<br>i</em></figcaption></figure></div></div></div>', 10, 0, 1, '2019-06-10 13:52:19', '2019-08-03 15:31:26'),
(72, 'Trị thâm bikini', 'tri-tham-bikini', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.', '<blockquote class=\"wp-block-quote\" style=\"padding-top: 15px; padding-bottom: 5px; padding-left: 40px; font-size: 14px; border-left-width: 7px; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; position: relative; line-height: 1.2; color: rgb(204, 153, 0); box-shadow: rgb(204, 204, 204) 2px 2px 15px; border-right-style: solid; border-right-width: 2px;\"><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; color: rgb(0, 0, 0);\"><em>Thâm vùng kín là tình trạng phổ biến, rất thường gặp ở nhiều chị em phụ nữ, khiến chị em tự ti, mất đi sự hấp dẫn và quyến rũ với bạn đời, ảnh hưởng không nhỏ đến chất lượng “cuộc yêu”.. Một nghiên cứu y khoa cho thấy rằng,</em><a href=\"https://berylbeauty.com.vn/\" style=\"color: rgb(21, 21, 143);\"><em>&nbsp;</em></a><em>có hơn 90% Eva đang phải đối mặt với tình trạng “cô bé” thâm đen sau khi trưởng thành, nhất là giai đoạn mang thai, sinh em bé. Hầu hết các chị em đều quan tâm đến vấn đề này, nhưng lại ngại “đối diện” hay áp dụng các cách làm hồng cô bé không hiệu quả.</em><br></p></blockquote><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/32a5571ac9bf2ae173ae.jpg\" alt=\"\" class=\"wp-image-7282\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><div class=\"quick-reg\"><ul style=\"margin-right: auto; margin-bottom: 0px; margin-left: auto; list-style: none; padding: 0px; text-align: center; max-width: 30%;\"><li style=\"display: inline; text-align: center;\"><a href=\"tel:19001768\" style=\"color: rgb(21, 21, 143); display: inline-block; padding: 0px;\"><img class=\"hotline\" src=\"http://thammyvienthienkhue.vn/wp-content/uploads/2018/10/hotline.png\" alt=\"\" style=\"width: 200px; height: auto;\"></a></li><li style=\"display: inline; text-align: center;\"><a class=\"dlp199 k5000 reg-survey\" admicro-data-event=\"100281\" admicro-data-auto=\"1\" admicro-data-order=\"true\" style=\"color: rgb(21, 21, 143); display: inline-block; padding: 0px;\"><img class=\"reg\" src=\"http://thammyvienthienkhue.vn/wp-content/uploads/2018/10/dang-ky-ngay-1.png\" style=\"width: 250px; height: auto;\"></a></li><li style=\"display: inline; text-align: center;\"><span style=\"font-family: &quot;Open Sans&quot;, sans-serif; color: rgb(204, 153, 0); font-size: 14px !important;\"><span style=\"font-weight: 700;\">(Thông tin bảo mật an toàn)</span></span></li></ul></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">CƠ CHẾ HOẠT ĐỘNG CỦA CÔNG NGHỆ TRỊ THÂM ENZYM PEELING<br></h2><ul><li>Loại bỏ các lớp sừng thâm đen, sạm màu trên bề mặt da. Thay vào đó là màu sắc vùng kín hồng hào, tươi tắn.<br></li><li>Giúp tăng sinh Collagen và tái tạo bề mặt vùng kín giúp trẻ hóa da.<br></li><li>Tinh chất trong liệu trình điều trị chứa các thành phần từ tự nhiên, đảm bảo thân thiện cho da, được tổ chức FDA Hoa Kỳ chứng nhận về độ an toàn và hiệu quả khi sử dụng.<br></li><li>Không chỉ làm cho vùng kín hồng hào gợi cảm mà còn giúp cho vùng da ở đây săn chắc hơn, đàn hồi hơn, tăng cảm giác do khả năng kích thích tuần hoàn máu.<br></li><li>Xử lý tốt nhiều trường hợp khác nhau để giúp cho “cô bé” của bạn luôn rực rỡ, gợi cảm và căng tràn sức sống.<br></li><li>Phương pháp này giúp hạn chế tối đa tổn thương, xâm lấn nên khách hàng sẽ không mất thời gian chăm sóc cũng như kiêng khem “chuyện ấy” sau điều trị.<br></li><li>Ức chế sự sản sinh hắc sắc tố gây thâm vùng kín, duy trì được hiệu quả trong thời gian dài.<br></li><li>Môi lớn môi bé săn chắc, cải thiện tình trạng chùng nhão, chảy xệ.<br></li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">CAM KẾT TỪ THIÊN KHUÊ</h2><ul><li>Không mất thời gian nghĩ dưỡng.<br></li><li>Không phẫu thuật, hạn chế được tình trạng viêm nhiễm phụ khoa.<br></li><li>Không gây tổn thương lên da, không ảnh hưởng đến cấu trúc da và không đau rát, không kích ứng.</li></ul><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/Peel-3-1.jpg\" alt=\"\" class=\"wp-image-7287\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">ĐỐI TƯỢNG ÁP DỤNG</h2><ul><li>Với các trường hợp vùng kín bị thâm đen, do tần suất quan hệ quá lớn.<br></li><li>Vùng kín bị sẫm màu do sinh đẻ nhiều lần – làm hồng vùng kín sau sinh.<br></li><li>Với các trường hợp vùng kín bị thâm đen, sẫm màu do bẩm sinh hoặc luyện tập thể thao cường độ lớn, mặc đồ bó sát quá chật.<br></li><li>Các trường hợp đã áp dụng những biện pháp khác tại nhà nhưng không đem lại hiệu quả cao.<br></li><li>Bạn đã từng điều trị làm hồng vùng kín tại các địa chỉ thẩm mỹ khác nhưng không đạt hiệu quả cao.<br></li><li>Chị em muốn cải thiện sắc tố da vùng nhạy cảm – làm hồng vùng kín và nhũ hoa.<br></li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">NHỮNG LƯU Ý SAU KHI TRỊ LIỆU BẠN CẦN BIẾT ĐỂ DUY TRÌ HIỆU QUẢ<br></h2><ul><li>Giữ gìn vệ sinh khu vực điều trị theo hướng dẫn của chuyên gia&nbsp;<br></li><li>Không dùng các loại sữa tắm có chất tẩy rửa mạnh.<br></li><li>Vệ sinh vùng kín ít nhất 2 lần/ngày, để “cô bé” luôn sạch sẽ, không cho vi khuẩn phát triển.<br></li><li>Nên mặc đồ vừa vặn với cơ thể, và làm từ cotton để “cô bé” thoải mái, không bị cọ xát.<br></li><li>Hạn chế “yêu” với tần xuất nhiều trong thời gian dài, khiến cô bé bị chà xát, dễ sạm đen.<br></li><li>Trong quá trình trị liệu làm hồng vùng kín, bạn hãy thực hiện thoa sản phẩm và tái điều trị theo đúng hướng dẫn của kỹ thuật viên.<br></li></ul><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/Peel-2.jpg\" alt=\"\" class=\"wp-image-7283\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">QUY TRÌNH LÀM HỒNG “CÔ BÉ” BẰNG SẢN PHẨM ENZYM PEELING KẾT HỢP MÁY CÔNG NGHỆ CAO<br></h2><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px !important;\"><span style=\"font-weight: 700;\">Giai đoạn 1: Chuyên gia, bác sỹ thăm khám</span></p><ul><li>Lấy bệnh sử KH</li><li>Phân tích các dấu hiệu lão hóa</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px !important;\"><span style=\"font-weight: 700;\">Giai đoạn 2: Lên phác đồ điều trị</span></p><ul><li>Chuyên gia, bác sỹ hội chuẩn đưa ra pháp đồ phù hợp</li><li>Phân tích các kết quả dự báo, đưa ra cam kết hiệu quả với KH</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px !important;\"><span style=\"font-weight: 700;\">Giai đoạn 3: Vệ sinh, chụp hình lưu hình ảnh điều trị</span></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px !important;\"><span style=\"font-weight: 700;\">Giai đoạn 4: Tiến hành điều trị</span></p><ul><li>Xác định vùng điều trị</li><li>Tiến hành đi tinh chất Peeling</li><li>Sát khuẩn vùng điều trị</li><li>Chiếu ánh sáng sinh học</li><li>Bôi tinh chất</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px !important;\"><span style=\"font-weight: 700;\">Giai đoạn 5: Chuyên gia, bác sỹ thăm khám lại sau điều trị và căn dặn chế độ sinh hoạt</span><br></p><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">HÌNH ẢNH KHÁCH HÀNG TRƯỚC VÀ SAU KHI TRẢI NGHIỆM LIỆU TRÌNH&nbsp;<br></h2><div class=\"wp-block-columns has-2-columns\" style=\"display: flex; flex-wrap: nowrap;\"><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><p class=\"has-text-color\" style=\"line-height: 1.6em; color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">Chị Kim Hoa (Bình Dương) chia sẻ:</span></p><p style=\"line-height: 1.6em;\">Giờ nhắc lại hồi đó cũng thấy tủi thân lắm, mình sinh em bé xong vùng kín của mình trở nên thâm đen, vừa buồn vừa sợ chồng hững hờ. Thế là mình quyết định đi “trẻ hóa cô bé” tại Thiên Khuê, mình hài lòng về kết quả lắm, giờ cứ phải nói là tự tin hẳn ra, chồng cứ mê mệt thôi (cười lớn)&nbsp;<br></p><div><br></div></div></div>', 10, 1, 0, '2019-06-10 13:58:31', '2019-08-03 05:01:56'),
(73, 'Trị thâm vùng bẹn', 'tri-tham-vung-ben', 'Với sự kiểm soát của các phân tử hoạt hóa thông minh giúp tác động loại bỏ các lớp tế bào sạm màu, thâm đen trên bề mặt da để tái sinh làn da mới.', '<blockquote class=\"wp-block-quote\" style=\"padding-top: 15px; padding-bottom: 5px; padding-left: 40px; font-size: 14px; border-left-width: 7px; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; position: relative; line-height: 1.2; color: rgb(204, 153, 0); box-shadow: rgb(204, 204, 204) 2px 2px 15px; border-right-style: solid; border-right-width: 2px; font-family: &quot;Open Sans&quot;, sans-serif;\"><p style=\"line-height: 1.6em; color: rgb(0, 0, 0);\"><em>Hầu như 99% phụ nữ đều gặp tình trạng bị thâm bẹn do thói quen mặc quần lót không đúng cách. Hơn nữa thâm ở vùng bẹn cực kì khó chữa mà mất nhiều thời gian. Bị thâm bẹn khiến nhiều người cảm thấy xấu hổ tự ti nhất là các chị em.&nbsp;</em><br></p></blockquote><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/32a5571ac9bf2ae173ae-1.jpg\" alt=\"\" class=\"wp-image-7290\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><div class=\"quick-reg\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><ul style=\"margin-right: auto; margin-bottom: 0px; margin-left: auto; list-style: none; padding: 0px; text-align: center; max-width: 30%;\"><li style=\"display: inline; text-align: center;\"><a href=\"tel:19001768\" style=\"color: rgb(21, 21, 143); display: inline-block; padding: 0px;\"><img class=\"hotline\" src=\"http://thammyvienthienkhue.vn/wp-content/uploads/2018/10/hotline.png\" alt=\"\" style=\"width: 200px; height: auto;\"></a></li><li style=\"display: inline; text-align: center;\"><a class=\"dlp199 k5000 reg-survey\" admicro-data-event=\"100281\" admicro-data-auto=\"1\" admicro-data-order=\"true\" style=\"color: rgb(21, 21, 143); display: inline-block; padding: 0px;\"><img class=\"reg\" src=\"http://thammyvienthienkhue.vn/wp-content/uploads/2018/10/dang-ky-ngay-1.png\" style=\"width: 250px; height: auto;\"></a></li><li style=\"display: inline; text-align: center;\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">(Thông tin bảo mật an toàn)</span></span></li></ul></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">NGUYÊN NHÂN GÂY THÂM Ở BẸN<br></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Ma sát lâu ngày: là do sự ma sát lâu ngày với vùng da này gây nên.<br></li><li>Tác dụng phụ một số loại thuốc. Một số loại thuốc để lại tác dụng phụ bằng việc làm tăng sắc tố da khiến vùng bẹn hay vùng bikini dễ bị thâm xỉn.</li><li>Do hormone. Thâm do hormone có thể gặp ở bất kì đối tượng nào. Điều này rất khó tránh khỏi.<br></li><li>Dung dịch vệ sinh: Sử dụng dung dịch vệ sinh không hợp hoặc loại rẻ tiền không rõ nguồn gốc những thành phần trong đó sẽ làm vùng tam giác bị thâm theo thời gian.<br></li><li>Mặc quần lót quá chật: Lựa chọn quần lót vừa với body để tránh những ma sát làm thâm vùng háng. Và thói quen mặc quần lót tam giác dễ làm háng bị thâm.<br></li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">ENZYM PEELING TRỊ THÂM BẸN LÀ GÌ?<br></h2><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Enzym Peeling là sự kết hợp giữa tinh chất Peel và các acid trái cây. Trong đó tinh chất Peel sẽ đi sâu vào trong da, bóc tách và làm mờ dần các vết thâm trên bẹn. Với sự kiểm soát của các phân tử hoạt hóa thông minh giúp tác động loại bỏ các lớp tế bào sạm màu, thâm đen trên bề mặt da để tái sinh làn da mới.<br></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Công nghệ Enzym Peeling sử dụng các chất đặc biệt ức chế hoạt động của các tế bào melanocytes, hạn chế tốc độ và số lượng melanin sinh ra, kích thích tăng sinh chuỗi liên kết chuỗi collagen, giúp các lớp đáy của biểu bì sản sinh ra lớp tế bào mới. Lớp da mới và các tế bào mới tái tạo sẽ trắng sáng và mịn màng hơn.<br></p><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/Peel-3.jpg\" alt=\"\" class=\"wp-image-7284\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">HIỆU QUẢ NHẬN ĐƯỢC KHI BẠN TRỊ THÂM BẸN BẰNG CÔNG NGHỆ ENZYM PEELING</h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Cho bạn làn da trắng hồng tự nhiên chỉ sau 5-10 lần điều trị</li><li>Trị vết thâm an toàn hiệu quả</li><li>Không gây ngứa rát hoặc kích ứng da</li><li>Thoải mái diện những bộ cánh siêu gợi cảm.</li><li>An toàn, không ảnh hưởng đến vùng da xung quanh.</li><li>Kết quả duy trì lâu dài, ngăn ngừa sự hình thành quay trở lại.</li><li>Sở hữu làn da căng mịn, trăng sáng và tươi trẻ tự nhiên.</li><li>Hỗ trợ làm giảm nếp nhăn giúp trẻ hóa làn da.</li><li>Tăng sinh collagen tái tạo da khỏe khoắn.</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">ĐỐI TƯỢNG PHÙ HỢP VỚI PHƯƠNG PHÁP ENZYM PEELING TRỊ THÂM<br></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Thực hiện điều trị thâm bẹn phù hợp với nữ giới&nbsp;<br></li><li>Trường hợp thâm nặng, nhẹ, mới hình thành hoặc thâm bẩm sinh.<br></li><li>Bạn đã từng điều trị ở nhiều nơi nhưng không đạt hiệu quả cao.<br></li><li>Trường hợp da sần sùi, bị lão hóa.<br></li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">NHỮNG LƯU Ý BẠN CẦN BIẾT ĐỂ DUY TRÌ HIỆU QUẢ&nbsp;<br></h2><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Muốn hết thâm vùng bẹn, trước tiên bạn nên mặc quần rộng thoải mái, không bó sát, không tạo nhiều ma sát quanh khu vực “nhạy cảm” để da không bị biến màu. Bên cạnh đó cần thường xuyên rửa và chà nhẹ để ngăn ngừa sự tích tụ của bụi bẩn và tế bào da chết. Sử dụng xà phòng không chứa chất hóa học và miếng bọt biển mềm để làm sạch đùi của bạn. Hạn chế cạo/wax lông thường xuyên vì có thể dẫn đến việc làm đen hơn phần đùi bên trong của bạn.<br></p><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/Peel-2-1.jpg\" alt=\"\" class=\"wp-image-7292\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">QUY TRÌNH THỰC HIỆN<br></h2><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 1: Chuyên gia, bác sỹ thăm khám</span></p><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Lấy bệnh sử KH</li><li>Phân tích các dấu hiệu lão hóa</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 2: Lên phác đồ điều trị</span></p><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Chuyên gia, bác sỹ hội chuẩn đưa ra pháp đồ phù hợp</li><li>Phân tích các kết quả dự báo, đưa ra cam kết hiệu quả với KH</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 3: Vệ sinh, chụp hình lưu hình ảnh điều trị</span></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 4: Tiến hành điều trị</span></p><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Xác định vùng điều trị</li><li>Tiến hành đi tinh chất Peeling</li><li>Sát khuẩn vùng điều trị</li><li>Chiếu ánh sáng sinh học</li><li>Bôi tinh chất</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 5: Chuyên gia, bác sỹ thăm khám lại sau điều trị và căn dặn chế độ sinh hoạt</span></p><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">HÌNH ẢNH KHÁCH HÀNG TRƯỚC VÀ SAU KHI TRẢI NGHIỆM LIỆU TRÌNH&nbsp;<br></h2><div class=\"wp-block-columns has-2-columns\" style=\"display: flex; flex-wrap: nowrap; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word;\"><p class=\"has-text-color\" style=\"line-height: 1.6em; color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">Chị Huỳnh Nhi (Quận 2, TP.HCM) chia sẻ:</span></p><p style=\"line-height: 1.6em;\">Lỡ mấy cái hẹn mặc bikini đi chơi biển cùng đám bạn thân cũng trên dưới chục lần rồi vì mình tự ti về phần bẹn của mình lắm, thâm nhìn chán lắm kìa. Xong rồi mình nghĩ, không lẽ đi biển mà cứ phải mặc quần đùi jean quài để che đi khuyết điểm, thế là mình quyết định đến Thiên Khuê để “giải quyết nỗi niềm” này. Đúng là không uổng công mong đợi của mình, sau 1 liệu trình da vùng bẹn của mình không những trắng mà còn mịn màng nữa, thích lắm luôn.</p></div></div>', 10, 0, 0, '2019-06-10 14:00:42', '2019-08-03 04:54:38');
INSERT INTO `products` (`idproduct`, `namepro`, `slug`, `short_desc`, `description`, `id_post_type`, `idsize`, `idcolor`, `created_at`, `updated_at`) VALUES
(74, 'Trị thâm vùng nách', 'tri-tham-vung-nach', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.', '<blockquote class=\"wp-block-quote\" style=\"padding-top: 15px; padding-bottom: 5px; padding-left: 40px; font-size: 14px; border-left-width: 7px; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; position: relative; line-height: 1.2; color: rgb(204, 153, 0); box-shadow: rgb(204, 204, 204) 2px 2px 15px; border-right-style: solid; border-right-width: 2px; font-family: &quot;Open Sans&quot;, sans-serif;\"><p style=\"line-height: 1.6em; color: rgb(0, 0, 0);\"><em>Phụ nữ dù có gợi cảm, xinh đẹp đến mấy nhưng chỉ vì những khuyết điểm nhỏ như thâm vùng nách cũng có thể gây ảnh hưởng đáng kể, nhất là khi phụ nữ diện những bộ đồ sexy. Những khuyết điểm này khiến chị em xấu hổ, mất tự tin. Peel trị thâm nách là một trong những giải pháp giúp xóa sổ thâm nách triệt để, trả lại làn da trắng mịn hoàn toàn.</em><br></p></blockquote><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/32a5571ac9bf2ae173ae-1.jpg\" alt=\"\" class=\"wp-image-7290\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">NGUYÊN NHÂN GÂY THÂM VÙNG&nbsp;CÁNH<br></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Nách bị thâm đen do cạo, nhổ lông nách thường xuyên khiến da xuất hiện các vết trầy xước và bị tổn thương. Dần dần vùng nách trở nên sậm màu, thâm đen.</li><li>Nách bị thâm đen do các tế bào da chết tích tụ lại trong một thời gian dài tạo một lớp sừng khá dày trên bề mặt da. Khiến cho da thâm đen, sạm xịt.</li><li>Sử dụng áo quá chật gây ra ma sát dẫn đến thích ứng da và khiến vùng da nách đổi màu.<br></li><li>Sử dụng lăn khử mùi là một trong những nguyên nhân chính gây thâm nách ở chị em, trong lăn khử mùi có chứa hóa chất mạnh, gây thích ứng lâu dần sẽ khiến vùng da bị thâm đen, tối màu.<br></li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">ENZYM PEELING TRỊ THÂM VÙNG CÁNH LÀ GÌ?<br></h2><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Enzym Peeling là sự kết hợp giữa tinh chất Peel và các acid trái cây. Trong đó tinh chất Peel sẽ đi sâu vào trong da, bóc tách và làm mờ dần các vết thâm trên bẹn. Với sự kiểm soát của các phân tử hoạt hóa thông minh giúp tác động loại bỏ các lớp tế bào sạm màu, thâm đen trên bề mặt da để tái sinh làn da mới.<br></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Công nghệ Enzym Peeling sử dụng các chất đặc biệt ức chế hoạt động của các tế bào melanocytes, hạn chế tốc độ và số lượng melanin sinh ra, kích thích tăng sinh chuỗi liên kết chuỗi collagen, giúp các lớp đáy của biểu bì sản sinh ra lớp tế bào mới. Lớp da mới và các tế bào mới tái tạo sẽ trắng sáng và mịn màng hơn.<br></p><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/Peel-3-1.jpg\" alt=\"\" class=\"wp-image-7287\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">HIỆU QUẢ NHẬN ĐƯỢC KHI BẠN TRỊ THÂM VÙNG CÁNH BẰNG CÔNG NGHỆ ENZYM PEELING</h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Cho bạn làn da trắng hồng tự nhiên chỉ sau 5 -10 lần điều trị</li><li>Trị vết thâm an toàn hiệu quả</li><li>Không gây ngứa rát hoặc kích ứng da</li><li>Thoải mái diện những bộ cánh siêu gợi cảm.</li><li>An toàn, không ảnh hưởng đến vùng da xung quanh.</li><li>Kết quả duy trì lâu dài, ngăn ngừa sự hình thành quay trở lại.</li><li>Sở hữu làn da căng mịn, trăng sáng và tươi trẻ tự nhiên.</li><li>Hỗ trợ làm giảm nếp nhăn giúp trẻ hóa làn da.</li><li>Tăng sinh collagen tái tạo da khỏe khoắn.</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">ĐỐI TƯỢNG PHÙ HỢP VỚI PHƯƠNG PHÁP ENZYM PEELING TRỊ THÂM<br></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Thực hiện điều trị thâm vùng cánh phù hợp với cả nam lẫn nữ</li><li>Trường hợp thâm nặng nhẹ, mới hình thành hoặc thâm bẩm sinh.</li><li>Bạn đã từng điều trị ở nhiều nơi nhưng không đạt hiệu quả cao.</li><li>Trường hợp da sần sùi, bị lão hóa.</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">NHỮNG LƯU Ý BẠN CẦN BIẾT ĐỂ DUY TRÌ HIỆU QUẢ&nbsp;<br></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Cần duy trì một chế độ ăn uống, sinh hoạt lành mạnh. Hạn chế dùng các chất kích thích như coffe, chè, thuốc lá, không nên thức khuya.<br></li><li>Thường xuyên làm sạch tế bào chết và dưỡng ẩm những vùng da bị thâm hằng ngày.<br></li><li>Sử dụng hỗ trợ kem trị thâm, kem dưỡng sáng da những vùng vừa trị thâm cũng là những biện pháp hữu hiệu trong việc duy trì kết quả điều trị.<br></li><li>Sau quá trình điều trị thâm, bạn nên mặc đồ thoáng mát, không cọ xát vào da vì đó cũng là nguyên nhân gây nên các vết lằn, vết thâm.<br></li><li>Bôi kem dưỡng lên vùng davừa điều trị theo hướng dẫn của kỹ thuật viên.<br></li><li>Không lạm dụng mỹ phẩm một cách bừa bãi sau điều trị.<br></li><li>Tránh ánh nắng trực tiếp hoặc bôi kem chống nắng để bảo vệ<br></li><li>Tuân thủ đầy đủ các hướng dẫn của chuyên gia điều trị để có kết quả cao nhất.<br></li></ul><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/Peel-2-2.jpg\" alt=\"\" class=\"wp-image-7300\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">QUY TRÌNH THỰC HIỆN<br></h2><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 1: Chuyên gia, bác sỹ thăm khám</span></p><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Lấy bệnh sử KH</li><li>Phân tích các dấu hiệu lão hóa</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 2: Lên phác đồ điều trị</span></p><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Chuyên gia, bác sỹ hội chuẩn đưa ra pháp đồ phù hợp</li><li>Phân tích các kết quả dự báo, đưa ra cam kết hiệu quả với KH</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 3: Vệ sinh, chụp hình lưu hình ảnh điều trị</span></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 4: Tiến hành điều trị</span></p><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Xác định vùng điều trị</li><li>Tiến hành đi tinh chất Peeling</li><li>Sát khuẩn vùng điều trị</li><li>Chiếu ánh sáng sinh học</li><li>Bôi tinh chất</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 5: Chuyên gia, bác sỹ thăm khám lại sau điều trị và căn dặn chế độ sinh hoạt</span></p><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">HÌNH ẢNH KHÁCH HÀNG TRƯỚC VÀ SAU KHI TRẢI NGHIỆM LIỆU TRÌNH&nbsp;<br></h2><div class=\"wp-block-columns has-2-columns\" style=\"display: flex; flex-wrap: nowrap; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word;\"><p class=\"has-text-color\" style=\"line-height: 1.6em; color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">Chị Minh Anh (Quận Phú Nhuận) chia sẻ:</span><br></p><p style=\"line-height: 1.6em;\">Chắc không nói thì chị em nhà mình đều hiểu về sự tự tin khi vùng bikini bị thâm đen đúng không, mình là một trong những số đó, ngại gần gũi với chồng, sợ chồng chán chồng chê. Nhưng giờ thì khác rồi, nhờ liệu trình trị thâm Peeling tại Thiên Khuê, mình nay đã tự tin hơn nhiều lần, chẳng còn sợ điều chi nữa hết! Cảm ơn Thiên Khuê rất nhiều!<br></p></div><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word; margin-left: 32px;\"><p style=\"line-height: 1.6em;\"></p></div></div><div class=\"quick-reg\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div>', 10, 0, 0, '2019-06-10 14:02:49', '2019-08-03 04:46:55'),
(75, 'Chanh quất hàn thiên', 'chanh-quat-han-thien', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.', 'Chanh quất hàn thiên&nbsp;Chanh quất hàn thiên Chanh quất hàn thiên&nbsp;Chanh quất hàn thiên Chanh quất hàn thiên&nbsp;Chanh quất hàn thiên Chanh quất hàn thiên&nbsp;Chanh quất hàn thiên Chanh quất hàn thiên&nbsp;Chanh quất hàn thiên Chanh quất hàn thiên&nbsp;Chanh quất hàn thiên Chanh quất hàn thiên&nbsp;Chanh quất hàn thiên Chanh quất hàn thiên&nbsp;Chanh quất hàn thiên Chanh quất hàn thiên&nbsp;Chanh quất hàn thiên Chanh quất hàn thiên&nbsp;Chanh quất hàn thiên Chanh quất hàn thiên&nbsp;Chanh quất hàn thiên Chanh quất hàn thiên&nbsp;Chanh quất hàn thiên Chanh quất hàn thiên&nbsp;Chanh quất hàn thiên&nbsp;', 10, 1, 1, '2019-06-10 14:04:08', '2019-06-17 02:33:51'),
(91, 'Bưởi bá vương legend', 'buoi-ba-vuong-legend', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.', 'Bưởi bá vương legend&nbsp;Bưởi bá vương legend&nbsp;Bưởi bá vương legend&nbsp;Bưởi bá vương legend&nbsp;Bưởi bá vương legend&nbsp;Bưởi bá vương legend&nbsp;Bưởi bá vương legend&nbsp;Bưởi bá vương legend&nbsp;Bưởi bá vương legend&nbsp;Bưởi bá vương legend&nbsp;Bưởi bá vương legend&nbsp;Bưởi bá vương legend&nbsp;Bưởi bá vương legend&nbsp;Bưởi bá vương legend&nbsp;Bưởi bá vương legend&nbsp;Bưởi bá vương legend&nbsp;Bưởi bá vương legend', 10, 2, 0, '2019-06-17 16:47:41', '2019-06-18 13:38:04'),
(92, 'Trà assam sữa trân châu', 'tra-assam-sua-tran-chau', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.', '<span style=\"font-size: medium;\">Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;Trà assam sữa trân châu&nbsp;</span>', 10, 2, 2, '2019-06-17 16:49:20', '2019-06-17 16:49:20'),
(94, 'Trà hoa nhài sữa', 'tra-hoa-nhai-sua', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.', '<font size=\"3\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.&nbsp;Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.&nbsp;Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.&nbsp;Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.</font><br>', 10, 2, 1, '2019-06-18 01:22:36', '2019-06-18 01:22:36'),
(95, 'Trà hoa nhài sữa', 'tra-hoa-nhai-sua', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.', '<font size=\"3\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.&nbsp;Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.&nbsp;Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.&nbsp;Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.</font><br>', 10, 1, 2, '2019-06-18 01:52:14', '2019-06-18 01:52:14'),
(96, 'Trị thâm vùng cổ', 'tri-tham-vung-co', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.', '<blockquote class=\"wp-block-quote\" style=\"padding-top: 15px; padding-bottom: 5px; padding-left: 40px; font-size: 14px; border-left-width: 7px; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; position: relative; line-height: 1.2; color: rgb(204, 153, 0); box-shadow: rgb(204, 204, 204) 2px 2px 15px; border-right-style: solid; border-right-width: 2px; font-family: &quot;Open Sans&quot;, sans-serif;\"><p style=\"line-height: 1.6em; color: rgb(0, 0, 0);\"><em>Việc làm đẹp, chăm sóc da mặt là công việc hằng ngày của nhiều chị em phụ nữ. Đời sống con người được nâng cao, kéo theo nhu cầu làm đẹp cũng tăng theo. Tuy nhiên, hầu hết mọi người đều chỉ chú trọng đến vùng da mặt mà không quan tâm đến vùng da cổ nhạy cảm không kém cũng thường xuyên tiếp xúc với các tác nhân gây hại và môi trường. Do đó, hiện tượng mặt trắng mịn còn da cổ bị thâm đen và nhăn nheo là điều cũng không có gì khó hiểu.</em><br></p></blockquote><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/32a5571ac9bf2ae173ae-2.jpg\" alt=\"\" class=\"wp-image-7295\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">NGUYÊN NHÂN KHIẾN DA CỔ BỊ THÂM ĐEN<br></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Do yếu tố di truyền: Vùng da cổ thâm đen, xạm màu từ bé do cơ thể có chứa gen xấu, ghen lão hóa sớm.<br></li><li>Do ánh nắng mặt trời: Ánh nắng mặt trời có hại cho da, kích thích các hocmon gây thâm nám da phát triển, từ đó gây nên hiện tượng da thâm nám, xạm đen.<br></li><li>Do môi trường: Việc tiếp xúc thường xuyên với bụi bẩn, các tác nhân gây hại cho da có trong không khí làm đẩy nhanh quá trình lão hóa ở da, giúp các hắc tố melanin ở da phát triển làm biến đổi màu da thiếu thẩm mỹ.<br></li><li>Do chế độ ăn uống và lối sống không hợp lý: Sinh hoạt và ăn uống không hợp lý làm thúc đẩy quá trình phát triển của các hắc tố gây hại cho da có trong cơ thể, đồng thời &nbsp;làm rối loạn nội tiết tố, làm giảm chức năng của tế bào bảo vệ dẫn đến việc thâm nám, chảy xệ ở da.<br></li><li>Sử dụng mỹ phẩm không đạt chất lượng: Sử dụng mỹ phẩm bừa bãi, không đạt chất lượng khiến cho da bạn bị bào &nbsp;mòn và bắt nắng dễ hơn. Thúc đẩy quá trình lão hóa và giúp các tác nhân gây hại xâm nhập vào da một cách dễ dàng<br></li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">ENZYM PEELING TRỊ THÂM CỔ LÀ GÌ?<br></h2><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Enzym Peeling là sự kết hợp giữa tinh chất Peel và các acid trái cây. Trong đó tinh chất Peel sẽ đi sâu vào trong da, bóc tách và làm mờ dần các vết thâm trên bẹn. Với sự kiểm soát của các phân tử hoạt hóa thông minh giúp tác động loại bỏ các lớp tế bào sạm màu, thâm đen trên bề mặt da để tái sinh làn da mới.<br></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Công nghệ Enzym Peeling sử dụng các chất đặc biệt ức chế hoạt động của các tế bào melanocytes, hạn chế tốc độ và số lượng melanin sinh ra, kích thích tăng sinh chuỗi liên kết chuỗi collagen, giúp các lớp đáy của biểu bì sản sinh ra lớp tế bào mới. Lớp da mới và các tế bào mới tái tạo sẽ trắng sáng và mịn màng hơn.<br></p><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/Peel-3-1.jpg\" alt=\"\" class=\"wp-image-7287\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">HIỆU QUẢ NHẬN ĐƯỢC KHI BẠN TRỊ THÂM CỔ BẰNG CÔNG NGHỆ ENZYM PEELING</h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Cho bạn làn da trắng hồng tự nhiên chỉ sau 5 -10 lần điều trị</li><li>Trị vết thâm an toàn hiệu quả</li><li>Không gây ngứa rát hoặc kích ứng da</li><li>Thoải mái diện những bộ cánh siêu gợi cảm.</li><li>An toàn, không ảnh hưởng đến vùng da xung quanh.</li><li>Kết quả duy trì lâu dài, ngăn ngừa sự hình thành quay trở lại.</li><li>Sở hữu làn da căng mịn, trăng sáng và tươi trẻ tự nhiên.</li><li>Hỗ trợ làm giảm nếp nhăn giúp trẻ hóa làn da.</li><li>Tăng sinh collagen tái tạo da khỏe khoắn.</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">ĐỐI TƯỢNG PHÙ HỢP VỚI PHƯƠNG PHÁP ENZYM PEELING TRỊ THÂM<br></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Thực hiện điều trị thâm cổ phù hợp với cả nam lẫn nữ</li><li>Trường hợp thâm nặng nhẹ, mới hình thành hoặc thâm bẩm sinh.</li><li>Bạn đã từng điều trị ở nhiều nơi nhưng không đạt hiệu quả cao.</li><li>Trường hợp da sần sùi, bị lão hóa.</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">NHỮNG LƯU Ý BẠN CẦN BIẾT ĐỂ DUY TRÌ HIỆU QUẢ&nbsp;<br></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Cần duy trì một chế độ ăn uống, sinh hoạt lành mạnh. Hạn chế dùng các chất kích thích như coffe, chè, thuốc lá, không nên thức khuya.</li><li>Thường xuyên làm sạch tế bào chết và dưỡng ẩm những vùng da bị thâm hằng ngày.</li><li>Sử dụng hỗ trợ kem trị thâm, kem dưỡng sáng da những vùng vừa trị thâm cũng là những biện pháp hữu hiệu trong việc duy trì kết quả điều trị.</li><li>Sau quá trình điều trị thâm, bạn nên mặc đồ thoáng mát, không cọ xát vào da vì đó cũng là nguyên nhân gây nên các vết lằn, vết thâm.</li><li>Bôi kem dưỡng lên vùng davừa điều trị theo hướng dẫn của kỹ thuật viên.</li><li>Không lạm dụng mỹ phẩm một cách bừa bãi sau điều trị.</li><li>Tránh ánh nắng trực tiếp hoặc bôi kem chống nắng để bảo vệ</li><li>Tuân thủ đầy đủ các hướng dẫn của chuyên gia điều trị để có kết quả cao nhất.</li></ul><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/Peel-2-1.jpg\" alt=\"\" class=\"wp-image-7292\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">QUY TRÌNH THỰC HIỆN<br></h2><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 1: Chuyên gia, bác sỹ thăm khám</span></p><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Lấy bệnh sử KH</li><li>Phân tích các dấu hiệu lão hóa</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 2: Lên phác đồ điều trị</span></p><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Chuyên gia, bác sỹ hội chuẩn đưa ra pháp đồ phù hợp</li><li>Phân tích các kết quả dự báo, đưa ra cam kết hiệu quả với KH</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 3: Vệ sinh, chụp hình lưu hình ảnh điều trị</span></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 4: Tiến hành điều trị</span></p><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Xác định vùng điều trị</li><li>Tiến hành đi tinh chất Peeling</li><li>Sát khuẩn vùng điều trị</li><li>Chiếu ánh sáng sinh học</li><li>Bôi tinh chất</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"font-weight: 700;\">Giai đoạn 5: Chuyên gia, bác sỹ thăm khám lại sau điều trị và căn dặn chế độ sinh hoạt</span></p><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\">HÌNH ẢNH KHÁCH HÀNG TRƯỚC VÀ SAU KHI TRẢI NGHIỆM LIỆU TRÌNH&nbsp;<br></h2><div class=\"wp-block-columns has-2-columns\" style=\"display: flex; flex-wrap: nowrap; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word;\"><p class=\"has-text-color\" style=\"line-height: 1.6em; color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">Chị Thanh Hoan (Đồng Nai) chia sẻ:</span></p><p style=\"line-height: 1.6em;\">“Sao suốt ngày mặc áo sơ mi có cổ thế, Sao suốt ngày mặc áo cổ lọ thế không thấy nóng à?” đó là những lời chọc ghẹo cứ tưởng đùa nhưng hóa ra lại là thật vì trước đây mình bị thâm vùng cổ chả biết mặc áo bẹt vai, hở xương quai xanh là gì. Nhưng giờ thì khác rồi, kiểu áo nào mình cũng mặc được vì Thiên Khuê đã giúp mình lấy lại được làn da sáng mịn hồng hào với công nghệ siêu hiện đại Peeling. Thật sự cảm ơn Thiên Khuê rất nhiều&nbsp;<br></p></div><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word; margin-left: 32px;\"><p style=\"line-height: 1.6em;\"></p></div></div><div class=\"quick-reg\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div>', 10, 0, 0, '2019-06-18 02:29:58', '2019-08-03 04:49:41'),
(97, 'Trị nám siêu cấp M-Blance', 'tri-nam-sieu-cap-m-blance', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.', '<h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">I</span>&nbsp;ĐẶC TÍNH CÔNG NGHỆ</h2><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">1</span>&nbsp;Công nghệ hiện đại bậc nhất</h3><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Công nghệ điều trị Nám M – Blanc là công nghệ được chuyển giao độc quyền từ Viện Da Liễu – Kopeck Hàn Quốc. Là một công nghệ khoa học dựa trên cơ chế và nguyên lý về da, bên cạnh xử lý phá vỡ &amp; đào thải triệt để các hắc tố đen (melanin) thì việc phục hồi giúp da khỏe mạnh căng bóng và cung cấp đủ độ ẩm, cùng với việc ổn định hoàn toàn chân Nám (tế bào melanocyte).</p><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/07/b2dda538af054b5b1214.jpg\" alt=\"\" class=\"wp-image-11604\" style=\"width: 847px; height: auto; max-width: 100%;\"><figcaption style=\"display: table-caption; margin-top: 0.5em; margin-bottom: 1em; color: rgb(85, 93, 102); font-size: 13px; caption-side: bottom;\"><em>Bác sĩ thực hiện bước cấy tinh chất M-Blanc điều trị nám cho khách hàng</em></figcaption></figure></div><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">2</span>&nbsp;Hiệu quả chỉ với 1 liệu trình</h3><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Đánh bật nám chân sâu, nám lâu năm, nám sau sinh</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Giải quyết rối loạn sắc tố da, da không đều màu</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Phục hồi làn da mịn màng khỏe mạnh sau khi điều trị nám, không làm mỏng và yếu đi</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Phác đồ hỗ trợ điều trị nám toàn diện, khoa học được kiểm soát nghiêm ngặt bởi hội đồng cố vấn chuyên môn là những Y Bác Sỹ có nhiều năm kinh nghiệm tại phòng khám da liễu Thiên Khuê</li></ul><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">3</span>&nbsp;Đội ngũ Chuyên Gia/bác sỹ được đào tạo chuyên nghiệp và bài bản và đạt chứng nhận tiêu chuẩn ISO 9001:2015 về quản lý quy trình và chất lượng</h3><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Ngoài thế mạnh và sự vượt trội về công nghệ, một yếu tố quan trọng hàng đầu tạo dựng nên niềm tin và thương hiệu của Thiên Khuê đó chính là đội ngũ Bác sĩ uy tín, có trình độ tay nghề cao, nhiều năm kinh nghiệm trong ngành thẩm mỹ, mang lại sự hài lòng và yên tâm tuyệt đối cho mọi khách hàng.</p><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/12/24A6497-1299x866.jpg\" alt=\"\" class=\"wp-image-5656\" srcset=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/12/24A6497-1299x866.jpg 1299w, https://thammyvienthienkhue.vn/wp-content/uploads/2018/12/24A6497-100x67.jpg 100w, https://thammyvienthienkhue.vn/wp-content/uploads/2018/12/24A6497-650x433.jpg 650w, https://thammyvienthienkhue.vn/wp-content/uploads/2018/12/24A6497-768x512.jpg 768w\" sizes=\"(max-width: 1299px) 100vw, 1299px\" style=\"width: 847px; height: auto; max-width: 100%;\"><figcaption style=\"display: table-caption; margin-top: 0.5em; margin-bottom: 1em; color: rgb(85, 93, 102); font-size: 13px; caption-side: bottom;\"><em>Đội ngũ chuyên gia giàu kinh nghiệm</em></figcaption></figure></div><div id=\"section2\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">II</span>&nbsp;GIÁ TRỊ CÔNG NGHỆ MANG LẠI</h2><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">1</span>&nbsp;Hiệu quả</h3><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Da sáng hơn 1-2 tone&nbsp;</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Tự tin để mặt mộc không cần dặm phấn&nbsp;</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Trẻ trung trong một diện mạo hoàn toàn mới: Da sáng hồng, chắc khỏe&nbsp;</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Không đau, Không để lại seo, Không mất thời gian nghỉ dưỡng</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Yên tâm về kết quả sau khi được Thiên Khuê hỗ trợ điều trị với công nghệ 100% chuyển giao từ Hàn Quốc&nbsp;</li></ul><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">2</span>An toàn</h3><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Phù hợp cho mọi loại da kể cả da kích ứng</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Cải thiện cấu trúc da, giúp da trẻ hóa giảm nhăn, se khít lỗ chân lông</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Phác đồ hỗ trợ điều trị rõ ràng, linh hoạt.</li></ul><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">3</span>Cam kết</h3><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Khả năng tái nám rất thấp</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Sạch nám, da sáng hồng mịn màng</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Rút ngắn thời gian điều trị chỉ so với các phương pháp thông thường</li></ul><div id=\"section3\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">III</span>&nbsp;VÌ CHÚNG TÔI HIỂU, SỰ TỰ TIN VỀ KHUÔN MẶT KHÔNG NÁM LÀ KHI</h2><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Chẳng phải dặm ngàn lớp phấn khi ra đường</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Chẳng phải ghen tị với làn da đẹp của người ta</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Chẳng phải buồn rầu khi đứng trước gương nhìn ngắm gương mặt mình</li></ul><div id=\"section3\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">IV</span>&nbsp;QUY TRÌNH THỰC HIỆN</h2><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/07/36f6e56ea052440c1d43.jpg\" alt=\"\" class=\"wp-image-11664\" srcset=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/07/36f6e56ea052440c1d43.jpg 1418w, https://thammyvienthienkhue.vn/wp-content/uploads/2019/07/36f6e56ea052440c1d43-768x614.jpg 768w\" sizes=\"(max-width: 1418px) 100vw, 1418px\" style=\"width: 847px; height: auto; max-width: 100%;\"><figcaption style=\"display: table-caption; margin-top: 0.5em; margin-bottom: 1em; color: rgb(85, 93, 102); font-size: 13px; caption-side: bottom;\"><em>Quy trình hỗ trợ điều trị nám với công nghệ M-Blanc</em></figcaption></figure></div><div class=\"quick-reg\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><ul style=\"margin-right: auto; margin-bottom: 0px; margin-left: auto; list-style: none; padding: 0px; text-align: center; max-width: 30%;\"><li style=\"display: inline; text-align: center;\"><a href=\"tel:19001768\" style=\"color: rgb(21, 21, 143); display: inline-block; padding: 0px;\"><img class=\"hotline\" src=\"http://thammyvienthienkhue.vn/wp-content/uploads/2018/10/hotline.png\" alt=\"\" style=\"width: 200px; height: auto;\"></a></li><li style=\"display: inline; text-align: center;\"><a class=\"d0 reg-survey\" admicro-data-event=\"100281\" admicro-data-auto=\"1\" admicro-data-order=\"true\" style=\"color: rgb(21, 21, 143); display: inline-block; padding: 0px;\"><img class=\"reg\" src=\"http://thammyvienthienkhue.vn/wp-content/uploads/2018/10/dang-ky-ngay-1.png\" style=\"width: 250px; height: auto;\"></a></li><li style=\"display: inline; text-align: center;\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">(Thông tin bảo mật an toàn)</span></span></li></ul></div><div id=\"section4\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">V</span>&nbsp;BẠN MUỐN TỰ TIN VỚI MỘT DIỆN MẠO MỚI?</h2><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Tìm vô vàn cách, đặt niềm tin ở nhiều spa khác nhau những nám vẫn “bám mãi chẳng rời”. Vậy đã đến lúc tin tưởng TMV Thiên Khuê chúng tôi và trải nghiệm ngay công nghệ “CẤY NÁM M-BLANC” ngay trong hôm nay để cảm nhận được sự hiệu quả chỉ sau 1/3 liệu trình nhé!</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Quy trình và tiêu chuẩn ISO 9001:2015 sẽ được áp dụng và thực hiện “triệt để” nhất khi khách hàng đến trải nghiệm công nghệ của chúng tôi sẽ có được sự thoải mái và tin tưởng tuyệt đối.</li></ul><div id=\"section5\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">VI</span>&nbsp;CẢM NHẬN CỦA KHÁCH HÀNG KHI ĐƯỢC HỖ TRỢ ĐIỀU TRỊ NÁM</h2><br style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><iframe id=\"video\" width=\"100%\" height=\"400\" src=\"https://www.youtube.com/embed/aFakj532k-M?rel=0\" frameborder=\"0\" allowfullscreen=\"\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></iframe><span style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></span><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51); text-align: center;\"></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><br></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51); text-align: center;\"><em>Khách hàng chia sẻ cảm nhận sau khi điều trị nám tại Thiên Khuê</em></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"></p><div id=\"section5\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">VII</span>&nbsp;BẢNG GIÁ DỊCH VỤ</h2><div class=\"col-sm-6 tb\" style=\"padding: 15px; width: 423.75px; background: rgb(241, 241, 241); border: 1px solid rgb(221, 221, 221); margin-bottom: 20px; margin-top: 15px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><ul class=\"stick\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Cấy nám M-Blanc</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">THÁNG 7 NÀY, ƯU ĐÃI 70% BUỔI ĐẦU TIÊN</li></ul></div><div class=\"col-sm-6 tb\" style=\"padding: 15px; width: 423.75px; background: rgb(241, 241, 241); border: 1px solid rgb(221, 221, 221); margin-bottom: 20px; margin-top: 15px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><ul class=\"stick\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Giá gốc 15 TRIỆU</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Thời hạn ưu đãi: 31/7/2019</li></ul></div><div id=\"section6\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">VIII</span>&nbsp;HÌNH ẢNH KHÁCH HÀNG TRƯỚC VÀ SAU KHI ĐƯƠC HỖ TRỢ ĐIỀU TRỊ</h2><div class=\"wp-block-columns has-2-columns\" style=\"display: flex; flex-wrap: nowrap; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word;\"><br><p style=\"line-height: 1.6em;\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">Chị Nguyễn Thị Hằng (Quận 4, TP.HCM) chia sẻ:&nbsp;</span></span>“Sau khi sinh, da chị xuất hiện nhiều vết nám nâu ở 2 bên má khiến chị rất buồn. Chị đã điều trị ở một số nơi khác, càng làm nám không biến mất mà còn đậm màu và lan rộng hơn. Chị được bạn giới thiệu tới Hệ thống thẩm mỹ quốc tế Thiên Khuê, ban đầu chị đến trải nghiệm mang tâm lý chưa tin. Chị nghĩ có bệnh thì vái tứ phương, cứ thử xem sao. Thế mà điều trị xong, kết quả hơn cả chị mong đợi nữa.”</p></div><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word; margin-left: 32px;\"><p style=\"line-height: 1.6em;\"><img class=\"size-full wp-image-3956 aligncenter\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/z1131421613612_293ae7e202c609b081ed30d23e8aad4f.jpg\" alt=\"\" width=\"500\" height=\"368\" style=\"width: 407.75px; height: auto;\"></p><p style=\"line-height: 1.6em; text-align: center;\"><em>Tác dụng có thể khác nhau tuỳ cơ địa của người dùng</em></p></div></div>', 10, 0, 0, '2019-06-18 02:32:14', '2019-08-03 04:23:22');
INSERT INTO `products` (`idproduct`, `namepro`, `slug`, `short_desc`, `description`, `id_post_type`, `idsize`, `idcolor`, `created_at`, `updated_at`) VALUES
(98, 'Trà assam sữa', 'tra-assam-sua', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum nibh pharetra ligula rhoncus, nec iaculis nulla semper.', '&nbsp;is used to remove element from the array. The unset function is used to destroy any other variable and same way use to delete any element of an array. This unset command takes the array key as input and removed that element from the array. After removal the associated key and value does not change.', 10, 2, 2, '2019-06-18 05:01:13', '2019-06-18 09:13:56'),
(99, 'Thạch QQ sữa tươi', 'thach-qq-sua-tuoi', 'Thạch QQ sữa tươi Thạch QQ sữa tươi Thạch QQ sữa tươi', 'Thạch QQ sữa tươi&nbsp;Thạch QQ sữa tươi&nbsp;Thạch QQ sữa tươi', 10, 0, 0, '2019-06-19 02:19:23', '2019-06-19 02:33:29'),
(100, 'Thạch QQ cà phê', 'thach-qq-ca-phe', 'Thạch QQ cà phê, Thạch QQ cà phê Thạch QQ cà phê Thạch QQ cà phê, Thạch QQ cà phê Thạch QQ cà phê', 'Thạch QQ cà phê,&nbsp;Thạch QQ cà phê Thạch QQ cà phê Thạch QQ cà phê,&nbsp;Thạch QQ cà phê Thạch QQ cà phê', 10, NULL, NULL, '2019-06-19 02:32:51', '2019-06-19 02:32:51'),
(101, 'QQ sương sáo', 'qq-suong-sao', 'QQ sương sáo QQ sương sáo QQ sương sáo QQ sương sáo QQ sương sáo QQ sương sáo', 'QQ sương sáo&nbsp;QQ sương sáo QQ sương sáo&nbsp;QQ sương sáo QQ sương sáo&nbsp;QQ sương sáo&nbsp;', 10, NULL, NULL, '2019-06-19 02:59:08', '2019-06-19 02:59:08'),
(102, 'QQ sương sáo', 'qq-suong-sao', 'QQ sương sáo QQ sương sáo QQ sương sáo QQ sương sáo QQ sương sáo QQ sương sáo', 'QQ sương sáo QQ sương sáo QQ sương sáo QQ sương sáo QQ sương sáo QQ sương sáo&nbsp;', 10, NULL, NULL, '2019-06-19 02:59:31', '2019-06-19 02:59:31'),
(103, 'Cấy nguyên bào phôi nám', 'cay-nguyen-bao-phoi-nam', 'Chỉ sau 1 liệu trình, làn da của bạn sẽ được tái tạo sáng mịn, thay đổi hoàn toàn bởi cơ chế xây dựng tế bào mới khỏe mạnh để thay thế thế hệ tế bào cũ yếu.', '<p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51); text-align: justify;\">Hiện nay, để điều trị nám da hiệu quả có rất nhiều cách. Tuy nhiên, lựa chọn phương pháp điều trị nám da như thế nào mới mang lại hiệu quả cao và nhanh chóng phải nhờ đến sự hỗ trợ của bác sĩ chuyên khoa.</p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51); text-align: justify;\">Tại TMV Thiên Khuê, Công nghệ cấy nguyên bào phôi Nám là giải pháp đặc trị Nám hỏng, nám chân sâu tận gốc được nhiều khách hàng lựa chọn.&nbsp;Chỉ sau 1 liệu trình, làn da của bạn sẽ được tái tạo sáng mịn, thay đổi hoàn toàn bởi cơ chế xây dựng tế bào mới khỏe mạnh để thay thế thế hệ tế bào cũ yếu.</p><table border=\"0\" style=\"background-color: rgb(255, 245, 190); color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px; height: 24px; width: 847px;\"><tbody><tr style=\"height: 24px;\"><td style=\"width: 847px; height: 24px;\">&nbsp;<p style=\"line-height: 1.6em;\"></p><p style=\"line-height: 1.6em;\"><img class=\"alignnone wp-image-2737\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/04/hot.gif\" alt=\"\" width=\"30\" height=\"12\" style=\"width: 24px; height: auto; max-width: 24px;\">&nbsp;<span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">ƯU ĐÃI&nbsp;</span></span><span style=\"font-weight: 700;\"><span style=\"color: rgb(204, 153, 0);\">ĐẶC QUYỀN PHÁI ĐEP – VÌ PHỤ NỮ XỨNG ĐÁNG</span>&nbsp;<img class=\"alignnone size-full wp-image-2737\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/04/hot.gif\" alt=\"\" width=\"30\" height=\"12\" style=\"width: 24px; height: auto; position: relative; max-width: 24px;\"></span></p><ul><li><span style=\"font-weight: 700;\"><span style=\"font-size: 16px; color: rgb(204, 153, 0);\">Giảm 30%</span>&nbsp;</span>khi đăng kí Cấy nguyên bào phôi nám</li><li>Thêm nhiều ưu đãi khi thanh toán online.</li><li>Thời hạn đăng kí:&nbsp;<span style=\"font-size: 16px; color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">31/12/2018</span></span></li></ul><p style=\"line-height: 1.6em;\"><img class=\"size-full wp-image-4118 aligncenter\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/nam-hong3.jpg\" alt=\"\" width=\"1200\" height=\"628\" srcset=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/nam-hong3.jpg 1200w, https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/nam-hong3-740x387.jpg 740w, https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/nam-hong3-768x402.jpg 768w\" sizes=\"(max-width: 1200px) 100vw, 1200px\" style=\"width: 847px; height: auto;\"></p><br><p style=\"line-height: 1.6em; text-align: center;\"></p></td></tr></tbody></table><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">&nbsp;</p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51); text-align: justify;\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">ƯU ĐIỂM CỦA CÔNG NGHỆ</span></span></p><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px; text-align: justify;\"><li>Hiệu quả nhanh chóng chỉ sau 1 lần điều trị</li><li>Có tác dụng trẻ hóa da toàn diện</li><li>Kích thích tái tạo collagen mới giúp tái cấu trúc da, giúp da căng mịn, làm săn chắc da, se khít lỗ chân lông, da sáng màu, tăng độ đàn hồi, điều trị sẹo mụn. Da mịn màng, khỏe mạnh sau khi kết thúc liệu trình.</li><li>Không gây xâm lấn, không làm tổn thương da</li><li>Được trực tiếp điều trị từ bác sỹ, chuyên gia hàng đầu tại Thiên Khuê</li><li>85% khách hàng hài lòng ngay từ lần điều trị đầu tiên.</li><li>Liệu trình chuẩn Y Khoa</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">&nbsp;</p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51); text-align: justify;\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">QUY TRÌNH THỰC HIỆN:</span>&nbsp;</span>Thực hiện một liệu trình điều trị gồm 7 bước, tổng thời gian 60 phút.</p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><img class=\"size-full wp-image-4976 aligncenter\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/cay-nguyen-bao-phoi-nam.jpg\" alt=\"\" width=\"800\" height=\"160\" srcset=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/cay-nguyen-bao-phoi-nam.jpg 800w, https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/cay-nguyen-bao-phoi-nam-740x148.jpg 740w, https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/cay-nguyen-bao-phoi-nam-768x154.jpg 768w\" sizes=\"(max-width: 800px) 100vw, 800px\" style=\"width: 847.5px; height: auto;\"></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">&nbsp;</p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51); text-align: justify;\"><span style=\"font-family: arial, helvetica, sans-serif; font-size: 16px; color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">HÌNH ẢNH KHÁCH HÀNG TRỊ LIỆU TẠI THIÊN KHUÊ</span></span></p><table border=\"0\" style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px; width: 847px; height: 264px;\"><tbody><tr style=\"height: 264px;\"><td style=\"width: 424px; height: 264px;\"><p style=\"line-height: 1.6em; text-align: justify;\"><span style=\"font-family: arial, helvetica, sans-serif; color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">Chị Tô Thị Thanh Tuyền chia sẻ:</span></span></p><p style=\"line-height: 1.6em; text-align: justify;\"><span style=\"font-family: arial, helvetica, sans-serif;\">“Chị đã điều trị Nám tại một số nơi khác, càng làm thì Nám càng đậm và lan rộng, thậm chí còn để lại sẹo trên mặt, làm chị mất Niềm Tin. Chị có đọc thông tin trên hệ thống thẩm mỹ Quốc Tế Thiên Khuê, ban đầu chị không tin, chị chỉ tò mò đến trải nghiệm, khi được Chuyên gia/ Bác Sĩ tại Thiên khuê tư vấn làm chị lấy lại niềm tin, chị quyết định thử sử dụng và điều tuyệt vời là sau 5 lần điều trị thì kết quả thật tuyệt vời”</span></p></td><td style=\"width: 423px; height: 264px;\"><img class=\"alignright size-full wp-image-4128\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/z1136996915060_9093a9220ed60aaa4b8f3edb5799b32b.jpg\" alt=\"\" width=\"500\" height=\"359\" style=\"width: 423px; height: auto;\"></td></tr></tbody></table><table border=\"0\" style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px; width: 847px;\"><tbody><tr><td style=\"width: 424px;\"><p style=\"line-height: 1.6em; text-align: justify;\"><span style=\"font-weight: 700;\"><span style=\"font-family: arial, helvetica, sans-serif; color: rgb(204, 153, 0);\">Chị Hoàng Ngọc Hà chia sẻ:</span></span></p><p style=\"line-height: 1.6em; text-align: justify;\"><span style=\"font-family: arial, helvetica, sans-serif;\">“Sau khi 18 tuổi thì tàn nhang mọc ra rất nhiều đặc biệt gò má tự nhiên thâm sạm lại, mình rất hoang mang, đã nghe bạn bè hướng dẫn mua thuốc đông y về bôi, sau khoảng 3 tháng dùng kem thì 2 gò mà trở lên thâm sạm hơn. Qua một người bạn giới thiệu mình biết đến Thiên Khuê, đã quyết định đến thăm khám, được biết nám đã đi sâu vào trong. Sau khi nghe Bác Sỹ tại Thiên Khuê đưa pháp đồ điều trị, sau 6 tháng thì da chị đã cải thiện rõ rệt được hơn 80%. Tôi chân thành cám ơn Thiên Khuê”.</span></p></td><td style=\"width: 423px;\"><img class=\"alignright size-full wp-image-4127\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/z1136996914852_5a81dde3797289d4078de7f128f12a33.jpg\" alt=\"\" width=\"500\" height=\"359\" style=\"width: 423px; height: auto;\"></td></tr></tbody></table>', 10, 0, 0, '2019-07-02 04:19:44', '2019-08-03 04:16:18'),
(104, 'Triphasic spot', 'triphasic-spot', 'Vua trị nám Triphasic Spot. Với sự cố vấn, chuyển giao và kiểm soát chất lượng trực tiếp từ các Chuyên gia, Bác Sỹ từ viện Opteck Korea', '<ul class=\"menu-blog\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; width: 847.5px; border-bottom: 1px solid rgb(241, 241, 241); padding: 5px 10px;\"><br><br></li></ul><blockquote class=\"wp-block-quote\" style=\"padding-top: 15px; padding-bottom: 5px; padding-left: 40px; font-size: 14px; border-left-width: 7px; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; position: relative; line-height: 1.2; color: rgb(204, 153, 0); box-shadow: rgb(204, 204, 204) 2px 2px 15px; border-right-style: solid; border-right-width: 2px; font-family: &quot;Open Sans&quot;, sans-serif;\"><p style=\"line-height: 1.6em; color: rgb(0, 0, 0);\"><em>Tiếp nối thành công của công nghệ trị nám Relief Laser trong năm 2018. Hệ thống thẩm mỹ quôc tế Thiên Khuê tiếp tục công bố phác đồ điều trị nám toàn năng: Vua trị nám Triphasic Spot. Với sự cố vấn, chuyển giao và kiểm soát chất lượng trực tiếp từ các Chuyên gia, Bác Sỹ từ viện Opteck Korea, chúng tôi tin rằng, đây sẽ là một công nghệ trị nám được hàng triệu chị em phụ nữ tin tưởng sử dụng.</em></p></blockquote><article id=\"video-container\" class=\"video-desc\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><div class=\"thumbnail-player\"><iframe id=\"player\" frameborder=\"0\" allowfullscreen=\"1\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" title=\"YouTube video player\" width=\"100%\" height=\"644\" src=\"https://www.youtube.com/embed/?color=white&amp;rel=0&amp;playlist=_7UHJJgN1rM&amp;enablejsapi=1&amp;origin=https%3A%2F%2Fthammyvienthienkhue.vn&amp;widgetid=1\"></iframe></div></article><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51); text-align: center;\"><br><em>Thạc sĩ khoa học Ngô Văn An chia sẻ về công nghệ trị nám Triphasic Spot</em></p><div class=\"quick-reg\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><ul style=\"margin-right: auto; margin-bottom: 0px; margin-left: auto; list-style: none; padding: 0px; text-align: center; max-width: 30%;\"><br></ul></div><div id=\"section1\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">I</span>&nbsp;ĐẶC TÍNH CÔNG NGHỆ</h2><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"></h2><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">1</span>&nbsp;Công nghệ chuyển giao độc quyền từ viện Opteck Korea</h3><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Với tiêu chí mang đến dịch vụ thẩm mỹ đẳng cấp quốc tế, khách hàng sẽ được trải nghiệm sự vượt bậc của các phương pháp, công nghệ thẩm mỹ mới trên thế giới, nổi bật là công nghệ, quy trình chuẩn Hàn Quốc. Chính vì thế,&nbsp;Hệ thống thẩm mỹ Quốc tế Thiên Khuê đã và đang ứng dụng các công nghệ thẩm mỹ ưu việt – độc quyền vào quá trình điều trị đem đến những hiệu quả tối ưu và đảm bảo an toàn cho khách hàng.<br></p><iframe id=\"video1\" width=\"100%\" height=\"400\" src=\"https://www.youtube.com/embed/4NJIu4dEsvY?rel=0\" frameborder=\"0\" allowfullscreen=\"\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></iframe><span style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></span><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51); text-align: center;\"><br><em>Lễ chuyển giao công nghệ Triphasic Spot tại HTTMQT Thiên Khuê</em></p><p class=\"has-text-color\" style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(204, 153, 0);\"></p><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">2</span>&nbsp;Công nghệ hiện đại 4.0</h3><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Với hệ thấu kính hiện đại được chia làm 81 điểm, giúp cho việc lựa chọn định hình vùng bị nám được chính xác, đối với khu vực mô lành năng lượng laser sẽ giảm xuống và ở trạng thái trẻ hóa, giúp da khỏe và sáng hơn, còn những vùng bị nhiêm sắc tố, năng lượng tăng lên gấp 40 lần, giúp cho khả năng phá vỡ tăng lên gấp đôi.</p><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/03/cabf36916545871bde54-1.jpg\" alt=\"\" class=\"wp-image-8497\" style=\"width: 847px; height: auto; max-width: 100%;\"><figcaption style=\"display: table-caption; margin-top: 0.5em; margin-bottom: 1em; color: rgb(85, 93, 102); font-size: 13px; caption-side: bottom;\"><em>Tia Laser có hệ thấu kính được chia làm 81 điểm hiện&nbsp;đại</em></figcaption></figure></div><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">3</span>&nbsp;Khả năng thông minh siêu vượt trội</h3><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Là một trong những công nghệ laser thông minh, chỉ với 60 giây đầu tiên tiếp xúc với da, Triphasic Laser tự động phân tích cấu trúc và mức độ nám, đưa ra những thông số gợi ý phù hợp với làn da thực giúp cho việc trị nám trở nên dễ dàng hơn hết đó chính là mang lại độ an toàn và hiệu quả cao nhất.</p><figure class=\"wp-block-image\" style=\"margin-bottom: 1em; width: 847.5px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center; max-width: 100%; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/03/9c828caddf793d276468.jpg\" alt=\"\" class=\"wp-image-8485\" style=\"width: 847.5px; height: auto; max-width: 100%;\"><figcaption style=\"margin-top: 0.5em; margin-bottom: 1em; color: rgb(85, 93, 102); font-size: 13px;\"><br><em>Công nghệ tự động phân tích cấu trúc và mức độ nám siêu thông minh</em></figcaption></figure><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">4</span>&nbsp;Đội ngũ Chuyên Gia/bác sỹ được đào tạo chuyên nghiệp và bài bản từ Viện Laser Opteck Korea, và đạt chứng nhận tiêu chuẩn ISO 9001:2015 về quản lý quy trình và chất lượng</h3><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Ngoài thế mạnh và sự vượt trội về công nghệ, một yếu tố quan trọng hàng đầu tạo dựng nên niềm tin và thương hiệu của Thiên Khuê đó chính là đội ngũ Bác sĩ uy tín, có trình độ tay nghề cao, nhiều năm kinh nghiệm trong ngành thẩm mỹ, mang lại sự hài lòng và yên tâm tuyệt đối cho mọi khách hàng.<br></p><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/03/df8436416c958ecbd784.jpg\" alt=\"\" class=\"wp-image-8487\" style=\"width: 847px; height: auto; max-width: 100%;\"><figcaption style=\"display: table-caption; margin-top: 0.5em; margin-bottom: 1em; color: rgb(85, 93, 102); font-size: 13px; caption-side: bottom;\"><em>Đội ngũ Bác sĩ có trình độ tay nghề cao, nhiều năm kinh nghiệm trong ngành thẩm mỹ&nbsp;</em><br></figcaption></figure></div><div class=\"quick-reg\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><ul style=\"margin-right: auto; margin-bottom: 0px; margin-left: auto; list-style: none; padding: 0px; text-align: center; max-width: 30%;\"><br></ul></div><div id=\"section2\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">II</span>&nbsp;GIÁ TRỊ CÔNG NGHỆ MANG LẠI</h2><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">1</span>&nbsp;An toàn</h3><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Với sự thông minh 4.0 của công nghệ Triphasic Spot trong việc tự điều chỉnh năng lượng cho phù hợp với từng tình trạng và đăc điểm của da kết hợp với đội ngũ chuyên gia /bác sỹ chuyên biệt (1 bác sỹ trực tiếp trị liệu và theo dõi 1 khách hàng) sẽ mang đến cho khách hàng sự an tâm, tin tưởng và đặc biệt một quy trình trị liệu rất an toàn.</p><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">2</span>&nbsp;Hiệu quả</h3><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Với việc cung cấp đầy đủ các thành phần cần thiết (22 axit amin, 13 vitamin, 7 loại khoáng chất) kết hợp cùng sản phẩm hỗ trợ điều trị nội tiết và công nghệ laser có hệ thấu kính hiện đại được chia làm 81 điểm, giúp cho việc lựa chọn định hình vùng bị nám được chính xác.</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Rút ngắn thời gian trị liệu chỉ còn 1/3 so với công nghệ trị nám thông thường vì sức công phá Melanin của Triphasic Spot cao gấp 40 lần so với những công nghệ khác.<br></li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">&nbsp;Nám rất khó tái tại vì đối với khu vực mô lành năng lượng laser sẽ giảm xuống ở trạng thái trẻ hóa, giúp da khỏe và sáng hơn, còn những vùng bị nhiêm sắc tố, năng lượng tăng lên gấp 40 lần, giúp cho khả năng phá vỡ tăng lên gấp đôi giúp loại bỏ nám tận gốc.</li></ul><p class=\"has-text-color\" style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(204, 153, 0);\"></p><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">3</span>&nbsp;Kinh tế</h3><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"></p><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Chỉ phải chi trả chi phí hỗ trợ điều trị một lần duy nhất, không phát sinh thêm bất kì một khoản nào khác.</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Thời gian hỗ trợ điều trị ngắn chỉ còn 1/3 so với các công nghệ thông thường giúp tiết kiệm chi phí đi lại.</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Không phải mua nhiều sản phẩm hỗ trợ giúp da khỏe do sự tổn thương như công nghệ thông thường.</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Không phải nghỉ dưỡng do hiện tượng tổn thương giống như công nghệ thường.</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"></h2><iframe id=\"video2\" width=\"100%\" height=\"400\" src=\"https://www.youtube.com/embed/6S7lxL_RYbA?rel=0\" frameborder=\"0\" allowfullscreen=\"\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></iframe><span style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></span><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51); text-align: center;\"><br><em>Cận cảnh quy trình loại bỏ nám với công nghệ Triphasic Spot</em></p><div id=\"section3\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">III</span>&nbsp;LỢI ÍCH KHÁCH HÀNG NHẬN ĐƯỢC</h2><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Thiên Khuê cam kết mang đến một diện mạo mới cho khách hàng với làn da trắng sáng với hiệu quả mờ mám lên đến 80%.</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Cam kết bảo dưỡng làn da 5 năm, việc tái nám rất thấp</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Với chất lượng dịch vụ chăm sóc khách hàng đạt chuẩn ISO, đảm bảo sự hài lòng tối đa cho khách hàng.</li></ul><div id=\"section4\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">IV</span>&nbsp;QUY TRÌNH THỰC HIỆN</h2><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">Giai Đoạn 1: Phân đoạn kiếm tra, phân tích và chuẩn đoán để đưa ra pháp đồ phù hợp với từng loại da</span></span></p><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Bệnh Sử</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Phân tích các chỉ số nội bào bằng công nghệ…</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Hội chuẩn đưa ra pháp đồ phù hợp</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Phân tích các kết quả dự báo, đưa ra CAM KẾT VỚI KHÁCH HÀNG</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">Giai Đoạn 2: Phục hồi lại làn da</span></span></p><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Phục hồi lại làn da đã bị hư tổn, nhiễm bệnh bằng công nghệ&nbsp;Ipeel</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Tái lập cấu trúc da bằng công nghệ&nbsp;Baby Face</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">Giai Đoạn 3: Giai đoạn phá hủy hắc tố Nám</span></span></p><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Sử dụng Công nghệ Pico smart laser</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">Giai Đoạn 4: Phân đoạn ổn định</span></span></p><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Tăng cường khả năng đề kháng cho da với công nghệ Whitening</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Ổn định nội tiết tố với phương pháp thực dưỡng Newglow C</li></ul><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><figure class=\"aligncenter\" style=\"display: table; margin-right: auto; margin-left: auto; width: 847px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/03/ebf10858488caad2f39d.jpg\" alt=\"\" class=\"wp-image-8510\" style=\"width: 847px; height: auto; max-width: 100%;\"></figure></div><div id=\"section5\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">V</span>&nbsp;TRỊ NÁM LÀ KHÔNG CHẦN CHỪ</h2><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Nếu thực sự bạn mong muốn tìm được giải pháp tốt nhất cho làn da đầy nám của mình, hãy tin tưởng TMV Thiên Khuê chúng tôi và trải nghiệm ngay công nghệ “VUA TRỊ NÁM TRIPHASIC SPOT” cùng với hơn 9863 khách hàng trị nám thành công và tự tin hơn về một diện mạo mới.</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Quy trình và tiêu chuẩn ISO 9001:2015 sẽ được áp dụng và thực hiện “triệt để” nhất khi khách hàng đến trải nghiệm công nghệ của chúng tôi sẽ có được sự thoải mái và tin tưởng tuyệt đối.</li></ul><div id=\"section6\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">VI</span>&nbsp;CẢM NHẬN CỦA KHÁCH HÀNG KHI ĐIỀU TRỊ NÁM TẠI THIÊN KHUÊ</h2><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"></h2><iframe id=\"video\" width=\"100%\" height=\"400\" src=\"https://www.youtube.com/embed/1OuZly5O-lQ?rel=0\" frameborder=\"0\" allowfullscreen=\"\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></iframe><span style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></span><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51); text-align: center;\"><br><em>Khách hàng chia sẻ cảm nhận sau khi điều trị nám tại Thiên Khuê</em></p><div id=\"section7\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">VII</span>&nbsp;BẢNG GIÁ DỊCH VỤ</h2><div class=\"wp-block-columns has-2-columns\" style=\"display: flex; flex-wrap: nowrap; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word; margin-left: 32px;\"><span style=\"color: rgb(204, 153, 0); font-size: 18px; font-weight: 700;\">HÌNH ẢNH KHÁCH HÀNG TRƯỚC VÀ SAU KHI ĐIỀU TRỊ</span><p style=\"line-height: 1.6em;\"></p></div></div><div id=\"section8\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"></div><div class=\"wp-block-columns has-2-columns\" style=\"display: flex; flex-wrap: nowrap; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word;\"><p class=\"has-text-color\" style=\"line-height: 1.6em; color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">Chị Hoa (Quận 7, TP.HCM) chia sẻ:</span></p><p style=\"line-height: 1.6em;\">Thật ra thì đây là lần đầu tiên chị đến trị nám tại Thiên Khuê, trước đây thì biết qua quảng cáo thôi. Trước đây chị đã đi nhiều spa khác rồi nhưng không hiệu quả, nám không dứt điểm gì hết trơn, đã thế còn có dấu hiệu lan rộng nữa. Thế là phải tìm hiểu ngay 1 công nghệ khác, cũng khá là tình cờ thôi, chị có người bạn học đại học đã từng trị nám ở đây, thế là nghe lời nó thử 1 lần đến xem sao, đúng là công nghệ mới có khác luôn em, chị đi đến buổi thứ 2/3 liệu trình thì nám mờ đến 70% rồi, đi hết liệu trình thì chắc còn đẹp hơn nữa. Chắc chắn chị sẽ giới thiệu thêm bạn bè đến đây. Vì làm xong da đẹp mà chả phải nghỉ dưỡng gì cả, cứ thế mà đi làm thôi nên chị rất hài lòng!</p></div><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word; margin-left: 32px;\"><div class=\"wp-block-image\" style=\"max-width: 100%; margin-bottom: 1em; margin-left: 0px; margin-right: 0px;\"><figure class=\"aligncenter is-resized\" style=\"display: table; margin-right: auto; margin-left: auto; width: 407px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/01/3-3.jpg\" alt=\"\" class=\"wp-image-6836\" width=\"375\" height=\"287\" style=\"width: 407px; height: auto; max-width: 100%;\"><figcaption style=\"display: table-caption; margin-top: 0.5em; margin-bottom: 1em; color: rgb(85, 93, 102); font-size: 13px; caption-side: bottom;\">Kêt quả trị liệu sẽ tùy thuộc vào cơ địa của mỗi người</figcaption></figure></div></div></div>', 10, 0, 0, '2019-07-06 01:50:00', '2019-08-03 04:11:33');
INSERT INTO `products` (`idproduct`, `namepro`, `slug`, `short_desc`, `description`, `id_post_type`, `idsize`, `idcolor`, `created_at`, `updated_at`) VALUES
(105, 'Relief laser', 'relief-laser', 'Công nghệ Relief Laser duy trì những ưu điểm của công nghệ cũ và tích hợp những cải tiến mới vượt trội hơn có tác dụng giải quyết “triệt để” những vết nám, mảng nám cứng đầu lâu năm và nám hỏng', '<blockquote style=\"padding-top: 15px; padding-bottom: 5px; padding-left: 40px; font-size: 14px; border-left-width: 7px; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; position: relative; line-height: 1.2; color: rgb(204, 153, 0); box-shadow: rgb(204, 204, 204) 2px 2px 15px; border-right-style: solid; border-right-width: 2px; font-family: &quot;Open Sans&quot;, sans-serif;\"><p style=\"line-height: 1.6em; color: rgb(0, 0, 0);\"><em>Bạn đã từng thử điều trị nám, tàn nhang bằng rất nhiều phương pháp nhưng chỉ mờ đi một ít? Bạn đã trị thành công nhưng nám lại tái phát? Hoặc nám quay trở lại càng đậm màu hơn?</em></p></blockquote><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Không cần lo lắng, công nghệ RELIEF LASER độc quyền tại Thẩm mỹ Thiên Khuê ra đời để giúp bạn giải quyết toàn bộ những vấn đề đó một cách dễ dàng, vượt trội gấp nhiều lần so với trước đây. Với sự thông minh của thấu kính Relief, công nghệ này trở thành sự lựa chọn số 1 trong việc điều trị nám hỏng, nám chân sâu được coi là khó điều trị</p><table border=\"0\" style=\"background-color: rgb(255, 245, 190); color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px; width: 847px;\"><tbody><tr><td style=\"width: 847px;\"><img class=\"alignnone size-full wp-image-2737\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/04/hot.gif\" alt=\"\" width=\"30\" height=\"12\" style=\"width: 24px; height: auto; max-width: 24px;\">&nbsp;<img class=\"alignnone size-full wp-image-2737\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/04/hot.gif\" alt=\"\" width=\"30\" height=\"12\" style=\"width: 24px; height: auto; max-width: 24px;\">&nbsp;<img class=\"alignnone size-full wp-image-2737\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/04/hot.gif\" alt=\"\" width=\"30\" height=\"12\" style=\"width: 24px; height: auto; max-width: 24px;\">&nbsp;&nbsp;<span style=\"font-weight: 700;\"><span style=\"color: rgb(204, 153, 0);\">THÁNG 5 RỰC RỠ – SALE KHỦNG ĐÓN HÈ</span><span &nbsp;<=\"\" span=\"\" style=\"color: rgb(204, 153, 0);\"><img class=\"alignnone size-full wp-image-2737\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/04/hot.gif\" alt=\"\" width=\"30\" height=\"12\" style=\"width: 24px; height: auto; position: relative; max-width: 24px;\"><img class=\"alignnone size-full wp-image-2737\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/04/hot.gif\" alt=\"\" width=\"30\" height=\"12\" style=\"width: 24px; height: auto; position: relative; max-width: 24px;\"><img class=\"alignnone size-full wp-image-2737\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/04/hot.gif\" alt=\"\" width=\"30\" height=\"12\" style=\"width: 24px; height: auto; position: relative; max-width: 24px;\"></span></span>&nbsp;<p style=\"line-height: 1.6em;\"></p><ul><li>TRỊ NÁM CÔNG NGHỆ RELIEF LASER&nbsp;<span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">CHỈ VỚI 350K</span>&nbsp;</span>&nbsp;<span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\"></span></span>&nbsp;</li><li>Thanh toán online giảm thêm&nbsp;<span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">10%</span></span></li><li>Thời hạn ưu đãi:&nbsp;<span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">31/05/2019</span></span></li></ul><p style=\"line-height: 1.6em;\"><img class=\"size-full wp-image-5705 aligncenter\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/04/banner-web-3.jpg\" alt=\"\" width=\"740\" height=\"433\" style=\"width: 847px; height: auto;\"></p><div class=\"quick-reg\"><ul style=\"margin-right: auto; margin-bottom: 0px; margin-left: auto; list-style: none; padding: 0px; text-align: center; max-width: 30%;\"><br></ul></div></td></tr><tr><td><p style=\"line-height: 1.6em;\"></p><p style=\"line-height: 1.6em;\"></p></td></tr></tbody></table><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">ƯU ĐIỂM VƯỢT TRỘI CỦA CÔNG NGHỆ RELIEF LASER</span></span></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\">Công nghệ Relief Laser duy trì những ưu điểm của công nghệ cũ và tích hợp những cải tiến mới vượt trội hơn có tác dụng giải quyết “triệt để” những vết nám, mảng nám cứng đầu lâu năm và nám hỏng do điều trị sai cách ít nhất đến 70%.</p><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Không gây xâm lấn: nhờ vào khả năng định vị thông minh tác động đúng vào các điểm nám trên da mặt, vì thế không gây xâm lấn hoặc tổn thương các vùng lân cận của da.</li><li>Bên cạnh tác dụng trị nám, công nghệ Relief Laser còn giúp da được trẻ hoá, tăng sinh collagen, xoá nhăn, se khít lỗ chân lông và làm da sáng lên trông thấy.</li><li>Kỹ thuật hiện đại an toàn không gây bỏng rát, kích ứng da và không cần phải nghỉ dưỡng sau khi kết thúc điều trị.</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">QUY TRÌNH THỰC HIỆN&nbsp;</span></span></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><img class=\"size-full wp-image-4973 aligncenter\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/relief-laser.jpg\" alt=\"\" width=\"800\" height=\"160\" srcset=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/relief-laser.jpg 800w, https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/relief-laser-740x148.jpg 740w, https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/relief-laser-768x154.jpg 768w\" sizes=\"(max-width: 800px) 100vw, 800px\" style=\"width: 847.5px; height: auto;\"></p><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">CAM KẾT</span></span></p><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Liệu trình điều trị chuẩn Y khoa</li><li>Giảm 20-30% sau lần điều trị đầu tiên.</li><li>Giảm đến 70% sau 1 liệu trình</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">HÌNH ẢNH KHÁCH HÀNG TRỊ LIỆU TẠI THIÊN KHUÊ</span></span></p><div class=\"col-sm-6\" style=\"padding-right: 15px; padding-left: 15px; width: 423.75px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><p style=\"line-height: 1.6em; text-align: justify;\"><span style=\"font-family: arial, helvetica, sans-serif;\"><span style=\"font-weight: 700;\"><span style=\"font-family: &quot;Open Sans&quot;, sans-serif; color: rgb(204, 153, 0);\">Chị Trần Thị Kim Phượng chia sẻ:&nbsp;</span></span></span><span style=\"font-family: arial, helvetica, sans-serif;\">Chị đã điều trị nám tại một số nơi khác, càng làm thì nám càng đậm và lan rộng làm chị mất niềm tin. Chị được một người bạn tặng voucher của hệ thống Thẩm mỹ Quốc tế Thiên Khuê, ban đầu chị không tin, chị chỉ tò mò đến trải nghiệm, ngay lần đầu tiên đến được Chuyên gia / Bác Sỹ tại Thiên Khuê tư vấn làm chị lấy lại niềm tin. Chị quyết định thử sử dụng và điều tuyệt vời là ngay lần trải nghiệm chị đã thấy da chị cải thiện, chị quyết định đi theo liệu trình và sau 12 lần điều trị thì kết quả khiến chị rất bất ngờ.</span></p></div><div class=\"col-sm-6 text-center\" style=\"padding-right: 15px; padding-left: 15px; width: 423.75px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><img class=\"size-full wp-image-4130 aligncenter\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/z1136996915395_550427bb9d6a70ec67f20d3b3038b13c.jpg\" alt=\"\" width=\"500\" height=\"359\" style=\"width: 393.75px; height: auto;\"><p style=\"line-height: 1.6em; font-style: italic;\">Hiệu quả có thể khác nhau tùy theo cơ địa mỗi người</p></div><div class=\"col-sm-6\" style=\"padding-right: 15px; padding-left: 15px; width: 423.75px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><p style=\"line-height: 1.6em; text-align: justify;\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\"><span style=\"font-family: arial, helvetica, sans-serif;\">Chị Huỳnh Thị Hồng Hoa chia sẻ:&nbsp;</span></span></span><span style=\"font-family: arial, helvetica, sans-serif;\">“Sau khi sinh em bé thì chị thấy 2 gò má tự nhiên thâm sạm lại, chị rất hoang mang, đã nghe bạn bè hướng dẫn mua thuốc đông y về bôi, nhưng kết quả thì sau khoảng 3 tháng thì 2 gò mà trở lên thâm sạm như hai đồng tiền. Qua một người bạn giới thiệu thì chị biết đến Thiên Khuê, chị đã quyết định đến và nhờ thăm khám, chị được biết là da bị nhiễm độc. Sau khi nghe Bác sĩ tại Thiên Khuê đưa pháp đồ điều trị, thì sau 6 tháng thì da chị đã cải thiện rõ rệt được hơn 80%. chị chân thành cám ơn Thiên Khuê”</span></p></div><div class=\"col-sm-6 text-center\" style=\"padding-right: 15px; padding-left: 15px; width: 423.75px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><img class=\"size-full wp-image-4129 aligncenter\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/z1136996915394_8eb1d5b4f3bab247a50196d2562ad96b.jpg\" alt=\"\" width=\"500\" height=\"359\" style=\"width: 393.75px; height: auto;\"><p style=\"line-height: 1.6em; font-style: italic;\">Hiệu quả có thể khác nhau tùy theo cơ địa mỗi người</p></div>', 10, 0, 0, '2019-07-06 01:54:02', '2019-08-03 04:01:17'),
(106, 'Công nghệ platanium laser', 'cong-nghe-platanium-laser', 'Công nghệ này mang đến hiệu quả toàn diện giúp giải quyết các mảng nám trên bề mặt da và cả gốc hắc tố sâu bên trong.', '<h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span style=\"font-size: 16px;\">NỖI ÁM ẢNH MANG TÊN NÁM KHIẾN BẠN “LO SỢ” ĐẾN THẾ NÀO?</span></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Không tự tin để mặt mộc, lúc nào cũng phải có 2 3 lớp phấn trên mặt</li><li>Ra đường sợ lắm những khuôn mặt nhòm ngó và lời nói dèm pha</li><li>Buồn tủi và tự ti về diện mạo của mình mỗi lần dự tiệc cùng chồng hay gặp gỡ bạn bè</li><li>Mỗi ngày đều tự hỏi mình Bao giờ thì hết nám hoàn toàn?</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span style=\"font-size: 16px;\">1 LIỆU TRÌNH TRỊ NÁM LASER PLATINUM – SẠCH TẬN GỐC NÁM&nbsp;</span></h2><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51); text-align: justify;\">Công nghệ Laser Platinum được hoạt động dựa trên nguyên lý kép bằng sự kết hợp song song giữa bước sóng kép 1064nm và 532nm tạo ra năng lượng tập trung tác động vào melanin tầng sâu trong tế bào da phát xung ổn định liên tục 10 lần/giây từ đó giúp phá vỡ các hắc sắc tố gây tăng sắc tố, nám tàn nhang &amp; thâm giúp da dần sáng lên. Công nghệ này mang đến hiệu quả toàn diện giúp giải quyết các mảng nám trên bề mặt da và cả gốc hắc tố sâu bên trong.</p><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Đánh bay nám mới hình thành, nám mảng</li><li>Đánh bật nám chân sâu, nám lâu năm, nám sau sinh</li><li>Giải quyết rối loạn sắc tố da, da không đều màu</li><li>Phục hồi làn da mịn màng khỏe mạnh sau khi điều trị nám, không làm mỏng và yếu đi khi sử dụng Laser Platinum</li><li>Phác đồ trị nám toàn diện, khoa học được kiểm soát nghiêm ngặt bởi hội đồng cố vấn chuyên môn là những Y Bác Sỹ có nhiều năm kinh nghiệm tại phòng khám da liễu Thiên Khuê</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span style=\"font-size: 16px;\">VÌ CHÚNG TÔI HIỂU, SỰ TỰ TIN VỀ KHUÔN MẶT KHÔNG NÁM LÀ KHI</span></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Chẳng phải dặm ngàn lớp phấn khi ra đường</li><li>Chẳng phải ghen tị với làn da đẹp của người ta</li><li>Chẳng phải buồn rầu khi đứng trước gương nhìn ngắm gương mặt mình</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span style=\"font-size: 16px;\">LASER PLATINUM – HẾT CHỖ CHO NÁM NGỰ TRỊ</span></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Da sáng hơn 1-2 tone chỉ sau buổi đầu tiên&nbsp;</li><li>Tự tin để mặt mộc không cần dặm phấn&nbsp;</li><li>Trẻ trung trong một diện mạo hoàn toàn mới: Da sáng hồng, chắc khỏe&nbsp;</li><li>Không đau, Không để lại seo, Không mất thời gian nghỉ dưỡng</li><li>Hoàn toàn yên tâm về kết quả sau khi điều trị với công nghệ 100% chuyển giao từ Hàn Quốc&nbsp;</li></ul><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><img class=\"size-full wp-image-4917 aligncenter\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/nam-80.jpg\" alt=\"\" width=\"1200\" height=\"628\" srcset=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/nam-80.jpg 1200w, https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/nam-80-740x387.jpg 740w, https://thammyvienthienkhue.vn/wp-content/uploads/2018/10/nam-80-768x402.jpg 768w\" sizes=\"(max-width: 1200px) 100vw, 1200px\" style=\"width: 847.5px; height: auto;\"></p><div class=\"quick-reg\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><ul style=\"margin-right: auto; margin-bottom: 0px; margin-left: auto; list-style: none; padding: 0px; text-align: center; max-width: 30%;\"><br></ul></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span style=\"font-size: 16px;\">CAM KẾT HIỆU QUẢ</span></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Khả năng tái nám rất thấp</li><li>Hết nám đến 80% chỉ sau 1 liệu trình</li><li>Rút ngắn thời gian điều trị chỉ còn ½ so với các phương pháp thông thường</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span style=\"font-size: 16px;\">ƯU ĐIỂM CÔNG NGHỆ</span></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Phù hợp cho mọi loại da kể cả da kích ứng</li><li>Cải thiện cấu trúc da, giúp da trẻ hóa giảm nhăn, se khít lỗ chân lông</li><li>Phác đồ hỗ trợ điều trị rõ ràng, linh hoạt.</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span style=\"font-size: 16px;\">LƯU Ý SAU TRỊ NÁM CÔNG NGHỆ LASER PLATINUM</span></h2><ul style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><li>Không được sử dụng bất kỳ chất lột tẩy nào trước và sau điều trị</li><li>Đi ngủ trước 23h30, Uống nước 2l/ngày</li><li>Bôi kem chống nắng SPF 30+ ngày tối thiểu 2 lần</li><li>Sử dụng thêm sản phẩm tăng độ ẩm cho da HA, tinh chất làm khỏe và sáng da</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span style=\"font-size: 16px;\">QUY TRÌNH THỰC HIỆN</span></h2><p style=\"font-family: &quot;Open Sans&quot;, sans-serif; line-height: 1.6em; font-size: 14px; color: rgb(51, 51, 51);\"><img class=\"size-full wp-image-5734 aligncenter\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/12/laser-platinum-344.jpg\" alt=\"\" width=\"757\" height=\"179\" srcset=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/12/laser-platinum-344.jpg 757w, https://thammyvienthienkhue.vn/wp-content/uploads/2018/12/laser-platinum-344-740x175.jpg 740w\" sizes=\"(max-width: 757px) 100vw, 757px\" style=\"width: 847.5px; height: auto;\"></p><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span style=\"font-size: 16px;\">CẢM NHẬN CỦA KHÁCH HÀNG SAU KHI TRẢI NGHIỆM LIỆU TRÌNH&nbsp;</span></h2><article id=\"video-container\" class=\"video-desc\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><div class=\"thumbnail-player\"><iframe id=\"player\" frameborder=\"0\" allowfullscreen=\"1\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" title=\"YouTube video player\" width=\"100%\" height=\"678.3\" src=\"https://www.youtube.com/embed/?color=white&amp;rel=0&amp;playlist=NVjAFr3fU8M&amp;enablejsapi=1&amp;origin=https%3A%2F%2Fthammyvienthienkhue.vn&amp;widgetid=1\"></iframe></div></article><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span style=\"font-size: 16px;\">HÌNH ẢNH TRƯỚC VÀ SAU KHI ĐIỀU TRỊ&nbsp;</span></h2><div class=\"col-sm-6 col-xs-12\" style=\"padding-right: 15px; padding-left: 15px; width: 423.75px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><img class=\"alignnone size-full wp-image-5739\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/12/99.jpg\" alt=\"\" width=\"500\" height=\"368\" style=\"width: 393.75px; height: auto;\"></div><div class=\"col-sm-6 col-xs-12\" style=\"padding-right: 15px; padding-left: 15px; width: 423.75px; color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\">Chị Thu Anh (Quận 3, TP.HCM) chia sẻ: “Hiện tôi đang điều trị nám tại Thiên Khuê, thông qua facebook thì tôi biết Thiên Khuê đang có phương pháp điều trị nám rất hiệu quả và tôi đã quyết định đến nhờ bác sĩ tư vấn và điều trị. Đó là phương pháp Laser Platinum”. Đến nay tôi đã đi điều trị được 6 lần, mỗi lần nhìn vào gương tôi thật sự rất hạnh phúc. Chưa bao giờ tôi nghĩ da mặt mình có ngày sẽ sáng đều một màu như thế. Cảm ơn Thiên Khuê.</div><table border=\"0\" style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px; width: 847px;\"><tbody><tr><td style=\"width: 424px; text-align: justify;\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">Chị Nguyễn Thị Hằng (Quận 4, TP.HCM) chia sẻ:</span>&nbsp;<span style=\"color: rgb(0, 0, 0);\">“Sau khi sinh, da chị xuất hiện nhiều vết nám nâu ở 2 bên má khiến chị rất buồn. Chị đã điều trị ở một số nơi khác, càng làm nám không biến mất mà còn đậm màu và lan rộng hơn. Chị được bạn giới thiệu tới Hệ thống thẩm mỹ quốc tế Thiên Khuê, ban đầu chị đến trải nghiệm mang tâm lý chưa tin. Chị nghĩ có bệnh thì vái tứ phương, cứ thử xem sao. Thật không ngờ, chỉ sau 3 lần bắn nám, da chị đã sáng hẳn lên. Theo liệu trình đến buổi thứ 6 thì nám đã mờ hẳn.”</span></span></td><td style=\"width: 423px;\"><img class=\"size-full wp-image-5740 aligncenter\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/12/PLATINUM.jpg\" alt=\"\" width=\"500\" height=\"368\" style=\"width: 423px; height: auto;\"></td></tr></tbody></table><div class=\"quick-reg\" style=\"color: rgb(51, 51, 51); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px;\"><ul style=\"margin-right: auto; margin-bottom: 0px; margin-left: auto; list-style: none; padding: 0px; text-align: center; max-width: 30%;\"><br></ul></div>', 10, 0, 0, '2019-07-06 02:09:17', '2019-08-03 03:57:34'),
(107, 'Công nghệ yellow laser', 'cong-nghe-yellow-laser', 'Yellow Laser–  Công nghệ điều trị sắc tố hàng đầu từ Hoa Kỳ giúp điều trị tàn nhang hiệu quả ngay sau lần đầu tiên. Đồng thời tái tạo làn da sáng khỏe, mịn màng từ sâu bên trong.', '<pre contenteditable=\"true\"><h1 class=\"post-title\" style=\"margin-top: 5px; margin-bottom: 20px; font-size: 20px; font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); text-transform: uppercase; white-space: normal; background-color: rgb(255, 255, 255);\">TRỊ NÁM, TÀN NHANG YELLOW LASER – ĐIỀU TRỊ NHANH &amp; HIỆU QUẢ TỚI 80%</h1><div class=\"post-content\" style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px; white-space: normal; background-color: rgb(255, 255, 255);\"><p style=\"line-height: 1.6em;\"><em>Yellow Laser– &nbsp;Công nghệ điều trị sắc tố hàng đầu từ Hoa Kỳ giúp điều trị tàn nhang hiệu quả ngay sau lần đầu tiên. Đồng thời tái tạo làn da sáng khỏe, mịn màng từ sâu bên trong.</em></p><table border=\"0\" style=\"background-color: rgb(255, 245, 190); width: 847px;\"><tbody><tr><td style=\"width: 847px;\"><img class=\"alignnone size-full wp-image-2737\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/04/hot.gif\" alt=\"\" width=\"30\" height=\"12\" style=\"width: 24px; height: auto; max-width: 24px;\">&nbsp;<img class=\"alignnone size-full wp-image-2737\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/04/hot.gif\" alt=\"\" width=\"30\" height=\"12\" style=\"width: 24px; height: auto; max-width: 24px;\">&nbsp;<img class=\"alignnone size-full wp-image-2737\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/04/hot.gif\" alt=\"\" width=\"30\" height=\"12\" style=\"width: 24px; height: auto; max-width: 24px;\">&nbsp;&nbsp;<span style=\"font-weight: 700;\"><span style=\"color: rgb(204, 153, 0);\">SẠCH NÁM – SÁNG DA, TỰ TIN XUỐNG PHỐ</span><span &nbsp;<=\"\" span=\"\" style=\"color: rgb(204, 153, 0);\"><img class=\"alignnone size-full wp-image-2737\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/04/hot.gif\" alt=\"\" width=\"30\" height=\"12\" style=\"width: 24px; height: auto; position: relative; max-width: 24px;\"><img class=\"alignnone size-full wp-image-2737\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/04/hot.gif\" alt=\"\" width=\"30\" height=\"12\" style=\"width: 24px; height: auto; position: relative; max-width: 24px;\"><img class=\"alignnone size-full wp-image-2737\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2018/04/hot.gif\" alt=\"\" width=\"30\" height=\"12\" style=\"width: 24px; height: auto; position: relative; max-width: 24px;\"></span></span>&nbsp;<p style=\"line-height: 1.6em;\"></p><ul><li>TRỊ NÁM, TÀN NHANG CÔNG NGHỆ YELLOW LASER &nbsp;<span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">CHỈ VỚI 350K (giá gốc 1 TRIỆU)</span>&nbsp;</span>&nbsp;<span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\"></span></span>&nbsp;</li><li>Thanh toán online giảm thêm&nbsp;<span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">10%</span></span></li></ul><p style=\"line-height: 1.6em;\"><img class=\"size-full wp-image-5705 aligncenter\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/07/7b66f7efa113454d1c02.jpg\" alt=\"\" width=\"740\" height=\"433\" style=\"width: 847px; height: auto;\"></p><div class=\"quick-reg\"><ul style=\"margin-right: auto; margin-bottom: 0px; margin-left: auto; list-style: none; padding: 0px; text-align: center; max-width: 30%;\"><br><li style=\"display: inline; text-align: center;\"><ul style=\"margin-right: auto; margin-bottom: 0px; margin-left: auto; list-style: none; padding: 0px; text-align: center; max-width: 30%;\"></ul></li><br></ul></div></td></tr><tr><td><p style=\"line-height: 1.6em;\"></p><p style=\"line-height: 1.6em;\"></p></td></tr></tbody></table><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">I</span>&nbsp;CƠ CHẾ HOẠT ĐỘNG CỦA YELLOW LASER</h2><p style=\"line-height: 1.6em;\">Bước sóng 1064 nm được phát ra từ Yellow Laser&nbsp;rất thông minh, phát theo xung có hiệu suất cao nhưng tính năng lại ổn định.</p><p style=\"line-height: 1.6em;\">Các tia laser này chỉ đi qua bề mặt da và tác động trực tiếp vào những sắc tố sậm màu mà không gây ảnh hưởng đến những vùng xung quanh và mô da lân cận.</p><p style=\"line-height: 1.6em;\">Phần nhiệt lượng rất nhỏ tỏa ra sẽ được làm mát ngay tức khắc nên không gây ra biến chứng, không làm mòn da, tổn thương da,&nbsp;mang tới hiệu quả rõ rệt trong liệu trình điều trị cực ngắn.</p><figure class=\"wp-block-image\" style=\"margin-bottom: 1em; width: 847.5px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center; max-width: 100%;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/06/tri-tan-nhang-1.png\" alt=\"\" class=\"wp-image-11384\" style=\"width: 847.5px; height: auto; max-width: 100%;\"><figcaption style=\"margin-top: 0.5em; margin-bottom: 1em; color: rgb(85, 93, 102); font-size: 13px;\"><em>Cơ chế điều trị của phương pháp trị tàn nhang Yellow Laser gì?</em></figcaption></figure><div class=\"quick-reg\"><ul style=\"margin-right: auto; margin-bottom: 0px; margin-left: auto; list-style: none; padding: 0px; text-align: center; max-width: 30%;\"><li style=\"display: inline; text-align: center;\"><figure style=\"width: 254.25px; height: auto; position: relative; padding: 5px 0px 15px;\"><br></figure></li><br></ul></div><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">II</span>&nbsp;YELLOW LASER MANG LẠI HIỆU QUẢ NHƯ THẾ NÀO?</h2><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">1</span>&nbsp;Loại sạch nám, tàn nhang, hiệu quả lên đến 80%</h3><p style=\"line-height: 1.6em;\">Yellow Laser sử dụng ánh sáng có luồng xung điện cực mạnh để tác động phá vỡ melamin (kể cả vùng hắc sắc tố nằm sâu trong da và len lỏi trong các bó cơ). Đồng thời, ngăn ngừa các melanocytes (tiền tố hình thành melamin sau này) giúp trị khỏi tàn nhang và ngăn ngừa tái phát chỉ sau 1 liệu trình (hiệu quả &gt; 80%).</p><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">2</span>&nbsp;Thời gian điều trị nhanh chóng</h3><p style=\"line-height: 1.6em;\">Bước sóng 1064 nm có khả năng tác động tập trung và tận sâu tới 7nm hạ bì da (nơi chứa nhiều hắc tố melamin) để hấp thụ. Chứng minh kết quả điều trị thực tiễn, Yellow laser mang tới hiệu quả rõ rệt trong liệu trình điều trị cực ngắn.</p><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">3</span>&nbsp;An toàn, không để lại sẹo</h3><p style=\"line-height: 1.6em;\">Do xác định chính xác tình trạng nám da của từng trường hợp khác nhau từ đó đưa ra phác đồ điều trị phù hợp giúp điều trị nám da không chỉ hiệu quả mà còn an toàn trong mọi trường hợp.</p><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">4</span>&nbsp;Làn da được tái tạo khoẻ mạnh &amp; mịn màng</h3><p style=\"line-height: 1.6em;\">Trong quá trình điều trị, tổ chức collagen dưới da được kích thích hồi sinh đồng thời tăng cường tuần hoàn máu, giúp nuôi dưỡng da mặt khỏe mạnh tự nhiên từ sâu bên trong. Đồng thời, khách hàng còn được đắp khăn lạnh giúp da mặt trở nên sáng mịn – hồng hào.</p><h3 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 600; line-height: 1.4em; color: rgb(204, 153, 0); margin-top: 20px; font-size: 16px;\"><span class=\"numbersmall\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 10px; background: url(&quot;../images/icon/b2.png&quot;) 0% 0% / 100% 100% no-repeat; border: none; color: rgb(227, 171, 29); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; line-height: normal; font-family: Arial, sans-serif; font-style: italic !important;\">5</span>&nbsp;Kết quả duy trì ổn định &amp; lâu dài</h3><p style=\"line-height: 1.6em;\">Nhờ khả năng quét sạch hắc tố melamin, Yellow Laser duy trì kết quả điều trị tàn nhang ổn định lâu dài nếu có chế độ chăm sóc da và cơ địa phù hợp. Không chỉ có vậy, công nghệ còn thanh lọc da, đào thải độc tố giúp làn da trở nên sạch – sáng – hồng – mịn chỉ sau thời gian ngắn.</p><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">III</span>&nbsp;ĐỐI TƯỢNG PHÙ HỢP ĐIỀU TRỊ YELLOW LASER</h2><figure class=\"wp-block-image\" style=\"margin-bottom: 1em; width: 847.5px; height: auto; position: relative; padding: 5px 0px 15px; text-align: center; max-width: 100%;\"><img src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/06/tan-nhang.png\" alt=\"\" class=\"wp-image-11385\" srcset=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/06/tan-nhang.png 819w, https://thammyvienthienkhue.vn/wp-content/uploads/2019/06/tan-nhang-768x366.png 768w\" sizes=\"(max-width: 819px) 100vw, 819px\" style=\"width: 847.5px; height: auto; max-width: 100%;\"><figcaption style=\"margin-top: 0.5em; margin-bottom: 1em; color: rgb(85, 93, 102); font-size: 13px;\"><em>Trường hợp nào thì trị nám, tàn nhang Yellow Laser</em></figcaption></figure><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">IV</span>&nbsp;QUY TRÌNH ĐIỀU TRỊ VỚI YELLOW LASER</h2><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Bước 1:&nbsp;Sát khuẩn, vệ sinh da sạch sẽ</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Bước 2:&nbsp;Chiếu ánh sáng Yellow Laser</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Bước 3:&nbsp;Chiếu ánh sáng BioLight</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Bước 4:&nbsp;Đắp khăn lạnh để thu nhỏ lỗ chân lông</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">V</span>&nbsp;KẾT QUẢ SAU KHI ĐIỀU TRỊ VỚI YELLOW LASER</h2><ul class=\"sao\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; list-style: none; padding-left: 0px;\"><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Làn da&nbsp;sạch nám, tàn nhang&nbsp;chỉ sau thời gian ngắn điều trị.</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Không những da sạch tàn nhang mà còn phục hồi độ&nbsp;sáng mịn, đều màu&nbsp;và tươi trẻ hơn.</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Khách hàng sẽ được tặng&nbsp;Phiếu bảo hành&nbsp;sau khi điều trị như lời cam kết duy trì kết quả sạch tàn nhang dài lâu, ngăn ngừa tái phát cho khách hàng.</li><li style=\"position: relative; padding-left: 30px; padding-top: 5px; padding-bottom: 5px;\">Yelow Laser mang đến hiêu quả rõ rệt ngay sau lần đầu tiên giúp bạn&nbsp;tiết kiệm tối đa chi phí và thời gianđiều trị so với các phương pháp khác.</li></ul><h2 style=\"font-family: &quot;Open Sans&quot;, sans-serif; font-weight: 700; color: rgb(204, 153, 0); margin-top: 20px;\"><span class=\"numberCircle\" style=\"border-radius: 50%; width: 25px; height: 25px; padding: 5px 12px; background: url(&quot;../images/icon/b3.png&quot;) 0% 0% / 100% 100% no-repeat; color: rgb(255, 255, 255); text-align: center; font-variant-numeric: normal; font-variant-east-asian: normal; font-weight: normal; font-stretch: normal; font-size: 16px; line-height: normal; font-family: Arial, sans-serif;\">VI</span>&nbsp;VII&nbsp;CẢM NHẬN CỦA KHÁCH HÀNG SAU KHI THỰC HIỆN LIỆU TRÌNH</h2><div class=\"wp-block-columns has-2-columns\" style=\"display: flex; flex-wrap: nowrap;\"><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word;\"><p style=\"line-height: 1.6em;\"><span style=\"color: rgb(204, 153, 0);\"><span style=\"font-weight: 700;\">Chị Ái Linh (Quận Tân Bình) chia sẻ:</span>&nbsp;</span>Phải nói là thực sự ưng ý, hồi đó chị bị nám mảng cũng ko đến mức quá nhiều đâu nhưng rất là đậm luôn, trang điểm khó khăn vì che khuyết điểm bao nhiêu cũng không đủ, mà sau khi đến Thiên Khuê thì chị tự tin hăn, hầu như ra đường chỉ thoa kem chống nắng thôi là đủ đẹp luôn á.&nbsp;</p></div><div class=\"wp-block-column\" style=\"flex-grow: 0; margin-bottom: 1em; flex-basis: calc(50% - 16px); min-width: 0px; word-break: break-word; overflow-wrap: break-word; margin-left: 32px;\"><p style=\"line-height: 1.6em;\"><img class=\"aligncenter\" src=\"https://thammyvienthienkhue.vn/wp-content/uploads/2019/06/1b905b2b628d87d3de9c.jpg\" alt=\"\" style=\"width: 407.75px; height: auto;\"></p></div></div><div class=\"quick-reg\"><ul style=\"margin-right: auto; margin-bottom: 0px; margin-left: auto; list-style: none; padding: 0px; text-align: center; max-width: 30%;\"><li style=\"display: inline; text-align: center;\"><figure style=\"width: 254.25px; height: auto; position: relative; padding: 5px 0px 15px;\"><br></figure></li></ul></div></div></pre>', 10, 0, 0, '2019-07-06 02:44:15', '2019-08-03 03:45:43');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `profile`
--

CREATE TABLE `profile` (
  `idprofile` int(10) UNSIGNED NOT NULL,
  `iduser` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `firstname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `middlename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birthday` datetime DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idcountry` int(10) DEFAULT NULL,
  `idprovince` int(10) DEFAULT NULL,
  `idcitytown` int(10) DEFAULT NULL,
  `iddistrict` int(10) DEFAULT NULL,
  `idward` int(10) DEFAULT NULL,
  `idsex` int(2) DEFAULT NULL,
  `mobile` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `about` text COLLATE utf8mb4_unicode_ci,
  `facebook` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zalo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url_avatar` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `profile`
--

INSERT INTO `profile` (`idprofile`, `iduser`, `firstname`, `middlename`, `lastname`, `birthday`, `address`, `idcountry`, `idprovince`, `idcitytown`, `iddistrict`, `idward`, `idsex`, `mobile`, `about`, `facebook`, `zalo`, `url_avatar`, `created_at`, `updated_at`) VALUES
(1, '2', 'Hậu', 'Tấn', 'Dương', '1980-01-01 00:00:00', 'Số 7, Trần Quang Diệu, P14', 1, 1, 1, 3, 1, 1, '0967655819', 'about', 'facebook', 'zalo', 'uploads/2019/06/27/20190627_1561628641_5d148fe1d0be9.png', '2019-05-05 14:02:41', '2019-06-27 10:13:21'),
(6, '15', 'hatazu', 'juong', 'zu', '1988-02-02 00:00:00', 'ninh thuan', 1, 1, 1, 4, 1, 0, '0125656556', '', '', '', 'uploads/2019/05/11/20190511_1557541962_5cd6344a2c218.png', '2019-05-08 15:13:47', '2019-06-27 04:27:35'),
(7, '16', 'Dung', 'Thanh', 'Nguyễn', '1980-09-25 00:00:00', 'Đồng Nai', 1, 1, 1, 13, 1, 0, '0967655810', '', '', '', 'uploads/2019/05/17/20190517_1558084001_5cde79a1e2f65.png', '2019-05-17 02:36:04', '2019-06-27 04:27:47'),
(8, '24', '', '', '', NULL, '', NULL, NULL, 0, 0, NULL, NULL, '', '', '', '', '', '2019-08-01 09:49:22', '2019-08-01 09:49:22'),
(9, '25', '', '', '', NULL, '', NULL, NULL, 0, 0, NULL, NULL, '', '', '', '', '', '2019-08-01 09:49:58', '2019-08-01 09:49:58'),
(10, '26', '', '', '', NULL, '', NULL, NULL, 0, 0, NULL, NULL, '', '', '', '', '', '2019-08-01 09:50:55', '2019-08-01 09:50:55'),
(11, '27', '', '', '', NULL, '', NULL, NULL, 0, 0, NULL, NULL, '', '', '', '', '', '2019-08-01 09:51:50', '2019-08-01 09:51:50'),
(12, '28', '', '', '', NULL, '', NULL, NULL, 0, 0, NULL, NULL, '', '', '', '', 'uploads/2019/08/01/20190801_1564654544_5d42bbd010d66.png', '2019-08-01 09:56:43', '2019-08-01 10:15:44'),
(13, '29', '', '', '', NULL, '', NULL, NULL, 0, 0, NULL, NULL, '', '', '', '', '', '2019-08-01 10:50:50', '2019-08-01 10:50:50');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `province`
--

CREATE TABLE `province` (
  `idprovince` int(10) UNSIGNED NOT NULL,
  `nameprovince` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idcountry` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `province`
--

INSERT INTO `province` (`idprovince`, `nameprovince`, `idcountry`, `created_at`, `updated_at`) VALUES
(1, 'TP Hồ Chí Minh', 1, '2019-06-27 02:29:26', '2019-06-27 02:29:26');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `roles`
--

CREATE TABLE `roles` (
  `idrole` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `roles`
--

INSERT INTO `roles` (`idrole`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'administrator', 'Quản trị', '2019-04-13 01:29:22', '2019-04-13 01:30:50');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sex`
--

CREATE TABLE `sex` (
  `idsex` int(10) UNSIGNED NOT NULL,
  `namesex` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `sex`
--

INSERT INTO `sex` (`idsex`, `namesex`, `created_at`, `updated_at`) VALUES
(1, 'Nam', '2019-06-27 05:02:32', '2019-06-27 05:03:49'),
(2, 'Nữ', '2019-06-27 05:02:40', '2019-06-27 05:02:40'),
(3, 'Riêng tư', '2019-06-27 05:03:38', '2019-06-27 05:03:38');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `size`
--

CREATE TABLE `size` (
  `idsize` int(10) UNSIGNED NOT NULL,
  `value` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `size`
--

INSERT INTO `size` (`idsize`, `value`, `created_at`, `updated_at`) VALUES
(1, 'M', NULL, '2019-06-18 02:29:29'),
(2, 'L', NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `status_types`
--

CREATE TABLE `status_types` (
  `id_status_type` int(10) UNSIGNED NOT NULL,
  `name_status_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idparent` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `status_types`
--

INSERT INTO `status_types` (`id_status_type`, `name_status_type`, `idparent`, `created_at`, `updated_at`) VALUES
(1, 'request', NULL, '2019-03-02 02:22:20', '2019-03-02 02:22:20'),
(2, 'finish', NULL, '2019-04-17 04:41:57', '2019-04-17 04:41:57'),
(3, 'draft', NULL, '2019-05-30 04:03:34', '2019-05-30 04:03:34'),
(4, 'publish', NULL, '2019-05-30 04:03:50', '2019-05-30 04:03:50');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sv_campaigns`
--

CREATE TABLE `sv_campaigns` (
  `idcampaign` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `begin_at` datetime NOT NULL,
  `end_at` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sv_customers`
--

CREATE TABLE `sv_customers` (
  `idcustomer` int(10) UNSIGNED NOT NULL,
  `firstname` varchar(300) CHARACTER SET utf8mb4 DEFAULT NULL,
  `middlename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birthday` datetime DEFAULT NULL,
  `mobile` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text CHARACTER SET utf8mb4,
  `iddistrict` int(10) DEFAULT NULL,
  `idcitytown` int(10) DEFAULT NULL,
  `job` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `facebook` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sv_posts`
--

CREATE TABLE `sv_posts` (
  `id_svpost` int(10) UNSIGNED NOT NULL,
  `idcategory` int(11) DEFAULT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8mb4_unicode_ci,
  `url` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_post_type` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sv_post_types`
--

CREATE TABLE `sv_post_types` (
  `id_post_type` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sv_receives`
--

CREATE TABLE `sv_receives` (
  `idsv_receive` int(10) UNSIGNED NOT NULL,
  `idcustomer` bigint(20) NOT NULL,
  `idsv_post` bigint(20) NOT NULL,
  `result` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `idcampaign` int(11) NOT NULL,
  `ip_address` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mac_address` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sv_sends`
--

CREATE TABLE `sv_sends` (
  `idsv_send` int(10) UNSIGNED NOT NULL,
  `idcustomer` bigint(20) NOT NULL,
  `idsv_post` bigint(20) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `idcampaign` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(2, 'admin', 'admin@mgkgroup.vn', NULL, '$2y$10$3Ds/XEHqtDG4jZpGUBdIPOQYy/9SgRsXb4pKD2B5eiU5SkeZBYWDG', 'GU2MQNe0lAQ8W7MbYVtKtixvCSlcHZyfcIQCXrS6ZuUADWVGl5c2qIXvlGie', '2019-02-27 03:14:15', '2019-06-27 08:31:50'),
(15, 'cskh1@mgkgroup.vn', 'cskh1@mgkgroup.vn', NULL, '$2y$10$QQCa0HdnBDnIbXmac1q3euNSAhSnCp9.75tzydSfab4Cpa88zEKoi', 'hjPhKivYKcHQEFUanaB6jr5vePYDgjvrFBUGTbKX9KzEFOcIKYcr9iob4dAP', '2019-05-08 15:13:47', '2019-08-01 09:39:29'),
(16, 'letan01dn', 'letan01dn@mgkgroup.vn', NULL, '$2y$10$GPgP6YIMxSp5S0pUj8MDmu97gE0Co4UIWKjNH3eLaYG7KBtdc7wV6', 'eOcQTpyMQvUYbC894ZGvSxivsDCMYr7xF35mqagEGtuommze8DZHJncb5wNQ', '2019-05-17 02:36:04', '2019-05-17 02:36:04'),
(17, 'letan01bd', 'letan01bd@mgkgroup.vn', NULL, '$2y$10$KH39/RhVD6ai0St8ZW0b6O9PGz5C0E1.l2F1lzfJVqNf5nO/dyCz6', NULL, '2019-05-17 02:36:49', '2019-05-17 02:36:49'),
(18, 'digital1', 'digital1@mgkgroup.vn', NULL, '$2y$10$h2zeZyxVFQbky62Kbz.q2OympEwRlfNecRc/cm7TDVwQGE3PmJ6Lu', 'dslUs9Vmvfi3jEF3kJx0kD0FL6gqJNDbvuS8M4yk6OcOGXtZgGVWKEwvLpV6', '2019-05-17 02:39:23', '2019-05-17 02:39:23'),
(23, 'cskh2@mgkgroup.vn', 'cskh2@mgkgroup.vn', NULL, '$2y$10$FymjL7jOLo7VX9L2saQ9JOIg2c.mX67jM0P/XNSNEAQudxbo2E2ny', NULL, '2019-08-01 09:40:25', '2019-08-01 09:40:25'),
(24, 'cskh3@mgkgroup.vn', 'cskh3@mgkgroup.vn', NULL, '$2y$10$WOJe5BFGj5iwFnLcOD4ZpejjnbQmTQai0dCwHCFvjvL3fSI.N1XKm', NULL, '2019-08-01 09:49:21', '2019-08-01 09:49:21'),
(25, 'cskh4@mgkgroup.vn', 'cskh4@mgkgroup.vn', NULL, '$2y$10$W4MKtJvIWLkAvhw5dMcvPeHbmW1BOFUR.t5fiLGJGy2CN97THP2ge', NULL, '2019-08-01 09:49:58', '2019-08-01 09:49:58'),
(27, 'cskh6@mgkgroup.vn', 'cskh6@mgkgroup.vn', NULL, '$2y$10$v/qSfGpRPI/gMyVP8qYMFOEc3yybjeNSgLOzJ6ZZ.2zuqhIl3Nk8m', NULL, '2019-08-01 09:51:49', '2019-08-01 09:51:49'),
(28, 'cskhmgk01@mgkgroup.vn', 'cskhmgk01@mgkgroup.vn', NULL, '$2y$10$WfE64sKZUp21jJhQ8cIOu..3OGkdCm.gNVEP8mmfHoeP9rDeNkQiG', NULL, '2019-08-01 09:56:43', '2019-08-01 10:01:08'),
(29, 'cskh5@mgkgroup.vn', 'cskh5@mgkgroup.vn', NULL, '$2y$10$tiYAKeSW8n41rE67tplEwe6M6plZlS9VvpY5wGKD8YxmesB2TNVae', NULL, '2019-08-01 10:50:50', '2019-08-01 10:50:50');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ward`
--

CREATE TABLE `ward` (
  `idward` int(10) UNSIGNED NOT NULL,
  `nameward` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `iddistrict` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Đang đổ dữ liệu cho bảng `ward`
--

INSERT INTO `ward` (`idward`, `nameward`, `iddistrict`, `created_at`, `updated_at`) VALUES
(1, 'Phường 14', 3, '2019-06-27 02:51:22', '2019-06-27 02:51:22');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `cache`
--
ALTER TABLE `cache`
  ADD UNIQUE KEY `cache_key_unique` (`key`) USING BTREE;

--
-- Chỉ mục cho bảng `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`idcategory`) USING BTREE;

--
-- Chỉ mục cho bảng `category_types`
--
ALTER TABLE `category_types`
  ADD PRIMARY KEY (`idcattype`) USING BTREE;

--
-- Chỉ mục cho bảng `catehasproduct`
--
ALTER TABLE `catehasproduct`
  ADD PRIMARY KEY (`idcateproduct`) USING BTREE;

--
-- Chỉ mục cho bảng `city_town`
--
ALTER TABLE `city_town`
  ADD PRIMARY KEY (`idcitytown`) USING BTREE,
  ADD UNIQUE KEY `city_town_namecitytown_unique` (`namecitytown`) USING BTREE;

--
-- Chỉ mục cho bảng `color`
--
ALTER TABLE `color`
  ADD PRIMARY KEY (`idcolor`) USING BTREE;

--
-- Chỉ mục cho bảng `country`
--
ALTER TABLE `country`
  ADD PRIMARY KEY (`idcountry`) USING BTREE,
  ADD UNIQUE KEY `country_namecountry_unique` (`namecountry`) USING BTREE;

--
-- Chỉ mục cho bảng `cross_product`
--
ALTER TABLE `cross_product`
  ADD PRIMARY KEY (`idcrossproduct`) USING BTREE;

--
-- Chỉ mục cho bảng `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`iddepart`) USING BTREE;

--
-- Chỉ mục cho bảng `depart_employees`
--
ALTER TABLE `depart_employees`
  ADD PRIMARY KEY (`iddepart_employee`) USING BTREE;

--
-- Chỉ mục cho bảng `district`
--
ALTER TABLE `district`
  ADD PRIMARY KEY (`iddistrict`) USING BTREE;

--
-- Chỉ mục cho bảng `exclude_category`
--
ALTER TABLE `exclude_category`
  ADD PRIMARY KEY (`idexcludecate`) USING BTREE,
  ADD UNIQUE KEY `idcategory` (`idcategory`) USING BTREE;

--
-- Chỉ mục cho bảng `expposts`
--
ALTER TABLE `expposts`
  ADD PRIMARY KEY (`idexppost`) USING BTREE;

--
-- Chỉ mục cho bảng `exp_products`
--
ALTER TABLE `exp_products`
  ADD PRIMARY KEY (`idexp`) USING BTREE;

--
-- Chỉ mục cho bảng `files`
--
ALTER TABLE `files`
  ADD PRIMARY KEY (`idfile`) USING BTREE;

--
-- Chỉ mục cho bảng `grants`
--
ALTER TABLE `grants`
  ADD PRIMARY KEY (`idgrant`) USING BTREE;

--
-- Chỉ mục cho bảng `impposts`
--
ALTER TABLE `impposts`
  ADD PRIMARY KEY (`idimppost`) USING BTREE;

--
-- Chỉ mục cho bảng `imp_perms`
--
ALTER TABLE `imp_perms`
  ADD PRIMARY KEY (`idimp_perm`) USING BTREE;

--
-- Chỉ mục cho bảng `imp_products`
--
ALTER TABLE `imp_products`
  ADD PRIMARY KEY (`idimp`) USING BTREE;

--
-- Chỉ mục cho bảng `menus`
--
ALTER TABLE `menus`
  ADD PRIMARY KEY (`idmenu`) USING BTREE,
  ADD UNIQUE KEY `menu_namemenu_unique` (`namemenu`) USING BTREE;

--
-- Chỉ mục cho bảng `menu_has_cate`
--
ALTER TABLE `menu_has_cate`
  ADD PRIMARY KEY (`idmenuhascate`) USING BTREE;

--
-- Chỉ mục cho bảng `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `oauth_access_tokens`
--
ALTER TABLE `oauth_access_tokens`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `oauth_access_tokens_user_id_index` (`user_id`) USING BTREE;

--
-- Chỉ mục cho bảng `oauth_auth_codes`
--
ALTER TABLE `oauth_auth_codes`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `oauth_clients`
--
ALTER TABLE `oauth_clients`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `oauth_clients_user_id_index` (`user_id`) USING BTREE;

--
-- Chỉ mục cho bảng `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `oauth_personal_access_clients_client_id_index` (`client_id`) USING BTREE;

--
-- Chỉ mục cho bảng `oauth_refresh_tokens`
--
ALTER TABLE `oauth_refresh_tokens`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`) USING BTREE;

--
-- Chỉ mục cho bảng `option`
--
ALTER TABLE `option`
  ADD PRIMARY KEY (`option_id`) USING BTREE;

--
-- Chỉ mục cho bảng `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`) USING BTREE;

--
-- Chỉ mục cho bảng `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`idperm`) USING BTREE,
  ADD UNIQUE KEY `permissions_name_unique` (`name`) USING BTREE;

--
-- Chỉ mục cho bảng `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`idpost`) USING BTREE;

--
-- Chỉ mục cho bảng `post_has_files`
--
ALTER TABLE `post_has_files`
  ADD PRIMARY KEY (`idhasfile`) USING BTREE;

--
-- Chỉ mục cho bảng `post_types`
--
ALTER TABLE `post_types`
  ADD PRIMARY KEY (`idposttype`) USING BTREE;

--
-- Chỉ mục cho bảng `producthasfile`
--
ALTER TABLE `producthasfile`
  ADD PRIMARY KEY (`idproducthasfile`) USING BTREE;

--
-- Chỉ mục cho bảng `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`idproduct`) USING BTREE;

--
-- Chỉ mục cho bảng `profile`
--
ALTER TABLE `profile`
  ADD PRIMARY KEY (`idprofile`) USING BTREE;

--
-- Chỉ mục cho bảng `province`
--
ALTER TABLE `province`
  ADD PRIMARY KEY (`idprovince`) USING BTREE,
  ADD UNIQUE KEY `province_nameprovince_unique` (`nameprovince`) USING BTREE;

--
-- Chỉ mục cho bảng `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`idrole`) USING BTREE,
  ADD UNIQUE KEY `roles_name_unique` (`name`) USING BTREE;

--
-- Chỉ mục cho bảng `sex`
--
ALTER TABLE `sex`
  ADD PRIMARY KEY (`idsex`) USING BTREE,
  ADD UNIQUE KEY `sex_namesex_unique` (`namesex`) USING BTREE;

--
-- Chỉ mục cho bảng `size`
--
ALTER TABLE `size`
  ADD PRIMARY KEY (`idsize`) USING BTREE;

--
-- Chỉ mục cho bảng `status_types`
--
ALTER TABLE `status_types`
  ADD PRIMARY KEY (`id_status_type`) USING BTREE;

--
-- Chỉ mục cho bảng `sv_campaigns`
--
ALTER TABLE `sv_campaigns`
  ADD PRIMARY KEY (`idcampaign`) USING BTREE;

--
-- Chỉ mục cho bảng `sv_customers`
--
ALTER TABLE `sv_customers`
  ADD PRIMARY KEY (`idcustomer`) USING BTREE;

--
-- Chỉ mục cho bảng `sv_posts`
--
ALTER TABLE `sv_posts`
  ADD PRIMARY KEY (`id_svpost`) USING BTREE;

--
-- Chỉ mục cho bảng `sv_post_types`
--
ALTER TABLE `sv_post_types`
  ADD PRIMARY KEY (`id_post_type`) USING BTREE;

--
-- Chỉ mục cho bảng `sv_receives`
--
ALTER TABLE `sv_receives`
  ADD PRIMARY KEY (`idsv_receive`) USING BTREE;

--
-- Chỉ mục cho bảng `sv_sends`
--
ALTER TABLE `sv_sends`
  ADD PRIMARY KEY (`idsv_send`) USING BTREE;

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `users_email_unique` (`email`) USING BTREE;

--
-- Chỉ mục cho bảng `ward`
--
ALTER TABLE `ward`
  ADD PRIMARY KEY (`idward`) USING BTREE;

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `categories`
--
ALTER TABLE `categories`
  MODIFY `idcategory` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT cho bảng `category_types`
--
ALTER TABLE `category_types`
  MODIFY `idcattype` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `catehasproduct`
--
ALTER TABLE `catehasproduct`
  MODIFY `idcateproduct` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=259;

--
-- AUTO_INCREMENT cho bảng `city_town`
--
ALTER TABLE `city_town`
  MODIFY `idcitytown` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `color`
--
ALTER TABLE `color`
  MODIFY `idcolor` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `country`
--
ALTER TABLE `country`
  MODIFY `idcountry` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `cross_product`
--
ALTER TABLE `cross_product`
  MODIFY `idcrossproduct` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT cho bảng `departments`
--
ALTER TABLE `departments`
  MODIFY `iddepart` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `depart_employees`
--
ALTER TABLE `depart_employees`
  MODIFY `iddepart_employee` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `district`
--
ALTER TABLE `district`
  MODIFY `iddistrict` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT cho bảng `exclude_category`
--
ALTER TABLE `exclude_category`
  MODIFY `idexcludecate` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `expposts`
--
ALTER TABLE `expposts`
  MODIFY `idexppost` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `exp_products`
--
ALTER TABLE `exp_products`
  MODIFY `idexp` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `files`
--
ALTER TABLE `files`
  MODIFY `idfile` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=486;

--
-- AUTO_INCREMENT cho bảng `grants`
--
ALTER TABLE `grants`
  MODIFY `idgrant` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `impposts`
--
ALTER TABLE `impposts`
  MODIFY `idimppost` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `imp_perms`
--
ALTER TABLE `imp_perms`
  MODIFY `idimp_perm` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `imp_products`
--
ALTER TABLE `imp_products`
  MODIFY `idimp` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT cho bảng `menus`
--
ALTER TABLE `menus`
  MODIFY `idmenu` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `menu_has_cate`
--
ALTER TABLE `menu_has_cate`
  MODIFY `idmenuhascate` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=149;

--
-- AUTO_INCREMENT cho bảng `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=148;

--
-- AUTO_INCREMENT cho bảng `oauth_clients`
--
ALTER TABLE `oauth_clients`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `option`
--
ALTER TABLE `option`
  MODIFY `option_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `permissions`
--
ALTER TABLE `permissions`
  MODIFY `idperm` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `posts`
--
ALTER TABLE `posts`
  MODIFY `idpost` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT cho bảng `post_has_files`
--
ALTER TABLE `post_has_files`
  MODIFY `idhasfile` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `post_types`
--
ALTER TABLE `post_types`
  MODIFY `idposttype` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `producthasfile`
--
ALTER TABLE `producthasfile`
  MODIFY `idproducthasfile` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=163;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `idproduct` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=108;

--
-- AUTO_INCREMENT cho bảng `profile`
--
ALTER TABLE `profile`
  MODIFY `idprofile` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT cho bảng `province`
--
ALTER TABLE `province`
  MODIFY `idprovince` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `roles`
--
ALTER TABLE `roles`
  MODIFY `idrole` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `sex`
--
ALTER TABLE `sex`
  MODIFY `idsex` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `size`
--
ALTER TABLE `size`
  MODIFY `idsize` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `status_types`
--
ALTER TABLE `status_types`
  MODIFY `id_status_type` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `sv_campaigns`
--
ALTER TABLE `sv_campaigns`
  MODIFY `idcampaign` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `sv_customers`
--
ALTER TABLE `sv_customers`
  MODIFY `idcustomer` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `sv_posts`
--
ALTER TABLE `sv_posts`
  MODIFY `id_svpost` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `sv_post_types`
--
ALTER TABLE `sv_post_types`
  MODIFY `id_post_type` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `sv_receives`
--
ALTER TABLE `sv_receives`
  MODIFY `idsv_receive` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `sv_sends`
--
ALTER TABLE `sv_sends`
  MODIFY `idsv_send` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT cho bảng `ward`
--
ALTER TABLE `ward`
  MODIFY `idward` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
