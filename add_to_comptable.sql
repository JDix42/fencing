DECLARE @LongName nvarchar(255) = 'Derry Open 2017';
DECLARE @ShortName nvarchar(8) = 'DrryOpen';
DECLARE @Date datetime = '2017-11-18 08:45:00.000';
DECLARE @TotalNumFencers Int = '14';
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