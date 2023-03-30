CREATE PROC NAME1 (@name int)
as
	begin

	end
go


exec NAME1 1

CREATE FUNCTION NAME2 (@name int)
returns @t table(name1 int, name2 varchar(20))
as
	begin
		insert @t
			select 
			from

		return
	end
go

select *from NAME2(1)

CREATE FUNCTION NAME2 (@name int)
returns int
as
	begin
		return 
		select ...
	end
go

DECLARE @A INT, @B VARCHAR(10)
SET @A
PRINT N''

CREATE FUNCTION NAME2 (@name int)
returns TABLE
as
		RETURN
		select 
		from
go

SELECT A , B = 
(CASE
	WHEN [SubTotal]<1000 
	THEN 0
	WHEN 1000<=[SubTotal] AND [SubTotal]<5000
	THEN 0.05*subtotal
END)
