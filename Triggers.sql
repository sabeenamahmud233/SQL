USE mydb;

SELECT * FROM dogs;

DROP TABLE IF EXISTS new_Dog;

CREATE TABLE new_Dog
(
row_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
dog_id INT NOT NULL,
update_date TIMESTAMP DEFAULT NOW(),
update_status VARCHAR(8) DEFAULT 'UPDATED'
);




-- TRIGGER AFTER INSERT
DROP TRIGGER IF EXISTS add_dog;

CREATE TRIGGER add_dog
AFTER INSERT
ON dogs
FOR EACH ROW
INSERT INTO new_Dog (dog_id, update_status) VALUE(NEW.id, 'New Dog');

-- TRIGGER AFTER DELETE
DROP TRIGGER IF EXISTS remove_dog;

CREATE TRIGGER remove_dog
AFTER DELETE
ON dogs
FOR EACH ROW
INSERT INTO new_Dog (dog_id, update_status) VALUE(OLD.id, 'Dog Died');

-- TRIGGER AFTER UPDATE
DROP TRIGGER IF EXISTS update_dog;

CREATE TRIGGER update_dog
AFTER UPDATE
ON dogs
FOR EACH ROW
INSERT INTO new_Dog (dog_id, update_status) VALUE(OLD.id, 'Updated');


SHOW TRIGGERS;


-- Examples


SELECT * FROM DOGS ORDER BY id DESC;
SELECT * FROM NEW_DOG ORDER BY row_id DESC;

INSERT INTO DOGS (name, gender, breed) VALUES ('Rocky', 'Male', 'Boxer');
INSERT INTO DOGS (name, gender, breed) VALUES ('Tiger', 'Male', 'Rottweiler');
INSERT INTO DOGS (name, gender, breed) VALUES ('Samy', 'Fenale', 'Labrador');


SELECT * FROM DOGS ORDER BY id DESC;
SELECT * FROM NEW_DOG ORDER BY row_id DESC;


UPDATE dogs
SET breed = 'Beagle'
WHERE id = 510;

UPDATE dogs
SET breed = 'Husky'
WHERE id = 511;

SELECT * FROM DOGS ORDER BY id DESC;
SELECT * FROM NEW_DOG ORDER BY row_id DESC;


DELETE FROM dogs WHERE id = 516;
DELETE FROM dogs WHERE id = 517;
DELETE FROM dogs WHERE id = 518;



SELECT * FROM DOGS ORDER BY id DESC;
SELECT * FROM NEW_DOG ORDER BY row_id DESC;


SHOW TABLES FROM mydb;
SHOW TRIGGERS;



DROP TRIGGER IF EXISTS treatment_dog;

CREATE TRIGGER treatment_dog
BEFORE DELETE
ON dogs
FOR EACH ROW
INSERT INTO new_Dog (dog_id , update_status) 
			VALUE (OLD.id , 
				  (SELECT 
						CASE
								WHEN OLD.id % 2 = 0 THEN 'Treated'
								ELSE 'Dog Died'
							END
					));





