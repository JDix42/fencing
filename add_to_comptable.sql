DECLARE @LongName nvarchar(255) = 'Birmingham International Fencing';
DECLARE @ShortName nvarchar(8) = 'BirmIntl';
DECLARE @Date datetime = '2017-04-15 00:00:00.000';
DECLARE @TotalNumFencers Int = '117';

INSERT INTO dbo.Comp (
CompName,
ShortName,
Date,
TotalNumFencers
)

VALUES (@LongName,
		@ShortName
		@Date,
		@TotalNumFencers);

UPDATE dbo.Comp
SET FencerCutOff = (FLOOR( 0.75 * @TotalNumFencers))
WHERE CompName = @LongName;