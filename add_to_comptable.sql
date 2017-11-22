DECLARE @LongName nvarchar(255) = 'Birmingham International Fencing';
DECLARE @ShortName nvarchar(8) = 'BirmIntl';
DECLARE @Date datetime = '2017-04-15 00:00:00.000';
DECLARE @TotalNumFencers Int = '117';
DECLARE @DomOrInt nvarchar(1) = 'D'

INSERT INTO dbo.Comp (
CompName,
ShortName,
Date,
TotalNumFencers,
DomOrInt
)

VALUES (@LongName,
		@ShortName
		@Date,
		@TotalNumFencers,
		@DomOrInt);

UPDATE dbo.Comp
SET FencerCutOff = (FLOOR( 0.75 * @TotalNumFencers))
WHERE CompName = @LongName;
