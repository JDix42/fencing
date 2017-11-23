DECLARE @LongName nvarchar(255) = 'Newham Swords Foil Open 2017';
DECLARE @ShortName nvarchar(8) = 'NewHOpen';
DECLARE @Date datetime = '2017-10-07 09:00:00.000';
DECLARE @TotalNumFencers Int = '54';
DECLARE @DomOrInt nvarchar(1) = 'D'

INSERT INTO dbo.Comp (
CompName,
ShortName,
Date,
TotalNumFencers,
DomOrInt
)

VALUES (@LongName,
		@ShortName,
		@Date,
		@TotalNumFencers,
		@DomOrInt);

UPDATE dbo.Comp
SET FencerCutOff = (FLOOR( 0.75 * @TotalNumFencers))
WHERE CompName = @LongName;