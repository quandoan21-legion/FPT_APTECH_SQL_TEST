DROP DATABASE XgameBattle;
-- 1.
CREATE DATABASE XgameBattle;

USE XgameBattle;

CREATE TABLE PlayerTable (
    PlayerId CHAR(38) NOT NULL,
    PlayerName nvarchar(120)  NOT NULL,
    PlayerNational nvarchar(50),
    PRIMARY KEY (PlayerId)
);


CREATE TABLE ItemTable (
    ItemId CHAR(38) NOT NULL,
    ItemName nvarchar(120)  NOT NULL,
    ItemTypeId int(4) NOT NULL,
    Price decimal(21,6) NOT NULL,
    PRIMARY KEY (ItemId)
);

CREATE TABLE PlayerItem (
    ItemId CHAR(38) NOT NULL,
    PlayerId CHAR(38) NOT NULL,
    FOREIGN KEY (ItemId) REFERENCES ItemTable(ItemId),
    FOREIGN KEY (PlayerId) REFERENCES PlayerTable(PlayerId)
);


CREATE TABLE ItemTypeTable (
    ItemTypeId tinyint NOT NULL,
    ItemTypeName NVARCHAR(50) NOT NULL,
    PRIMARY KEY (ItemTypeId)
);

-- 2.
INSERT INTO PlayerTable (PlayerId , PlayerName, PlayerNational) VALUES ('C16E515-83AF-4D37-8A21-58AFD900E3F6' , 'Player 1', 'Viet Nam');
INSERT INTO PlayerTable (PlayerId , PlayerName, PlayerNational) VALUES ('D401EA60-7A83-4C7E-BF6E-707CF1F3E57E' , 'Player 2', 'US');

INSERT INTO ItemTable (ItemId , ItemName , ItemTypeId , Price) VALUES ('72B83972-051D-4B96-B229-05DE585DF1EE', 'Gun' , 1, 5);
INSERT INTO ItemTable (ItemId , ItemName , ItemTypeId , Price) VALUES ('83B931C2-AC84-4080-9852-5734C4E05082', 'Bullet' , 1, 10);
INSERT INTO ItemTable (ItemId , ItemName , ItemTypeId , Price) VALUES ('97E25C9F-FA12-4D9A-AB32-D62EBC2107BF', 'Shield' , 2, 20);

INSERT INTO PlayerItem (ItemId , PlayerId) VALUES ('72B83972-051D-4B96-B229-05DE585DF1EE','C16E515-83AF-4D37-8A21-58AFD900E3F6');
INSERT INTO PlayerItem (ItemId , PlayerId) VALUES ('72B83972-051D-4B96-B229-05DE585DF1EE','C16E515-83AF-4D37-8A21-58AFD900E3F6');
INSERT INTO PlayerItem (ItemId , PlayerId) VALUES ('83B931C2-AC84-4080-9852-5734C4E05082','C16E515-83AF-4D37-8A21-58AFD900E3F6');
INSERT INTO PlayerItem (ItemId , PlayerId) VALUES ('83B931C2-AC84-4080-9852-5734C4E05082','D401EA60-7A83-4C7E-BF6E-707CF1F3E57E');
INSERT INTO PlayerItem (ItemId , PlayerId) VALUES ('97E25C9F-FA12-4D9A-AB32-D62EBC2107BF','D401EA60-7A83-4C7E-BF6E-707CF1F3E57E');
INSERT INTO PlayerItem (ItemId , PlayerId) VALUES ('97E25C9F-FA12-4D9A-AB32-D62EBC2107BF','D401EA60-7A83-4C7E-BF6E-707CF1F3E57E');

INSERT INTO ItemTypeTable (ItemTypeId, ItemTypeName) VALUES (1, 'Attack');
INSERT INTO ItemTypeTable (ItemTypeId, ItemTypeName) VALUES (2, 'Defense');


-- 3.
DELIMITER //
CREATE PROCEDURE GetPLayerInventoryValue(
	IN p_PlayerName nvarchar(120)
)
BEGIN
	SELECT 
		SUM(total_value) AS InventoryValue
	FROM (
		SELECT 
			SUM(it.Price) * COUNT(it.ItemId) AS total_value
		FROM 
			PlayerItem pi
		JOIN 
			ItemTable it ON pi.ItemId = it.ItemId
		WHERE 
			pi.PlayerId = (SELECT PlayerId FROM PlayerTable WHERE PlayerName = p_PlayerName)
		GROUP BY 
			it.ItemId, it.Price
	) AS SubQuery;
END //
DELIMITER ;

CALL GetPLayerInventoryValue('Player 1');

-- 4.
DELIMITER //
CREATE PROCEDURE GetPLayerInventoryValue(
	IN p_PlayerName nvarchar(120)
)
BEGIN
	SELECT 
		p_PlayerName as Player_Name,
		it.ItemName as Item_Name,
		itt.ItemTypeName as Item_Type,
		it.Price as Price
	FROM PlayerItem pi
	JOIN ItemTable it
	ON pi.ItemId = it.ItemId
	JOIN ItemTypeTable itt
	ON itt.ItemTypeId = it.ItemTypeId
	WHERE PlayerId = 
		(SELECT PlayerId 
		FROM PlayerTable 
		WHERE PlayerName = p_PlayerName);
END //
DELIMITER ;

CALL GetPLayerInventoryValue('Player 2');
