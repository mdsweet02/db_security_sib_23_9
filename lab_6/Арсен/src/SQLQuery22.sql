CREATE FUNCTION fn_‘инансовыйќтчетѕо варталам (@√од INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
         вартал,
        SUM(—уммаѕлатежа) AS ќбща€—уммаѕлатежей,
        COUNT(*) AS  оличествоѕлатежей,
        AVG(—уммаѕлатежа) AS —реднийѕлатеж
    FROM ѕлановыеѕлатежи
    WHERE √од = @√од
    GROUP BY  вартал
);
GO