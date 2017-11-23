DECLARE @LongName nvarchar(255) = 'Hampshire Open';
DECLARE @ShortName nvarchar(8) = 'HampOpen';
DECLARE @Date datetime = '2017-05-14 09:00:00.000';
DECLARE @TotalNumFencers Int = '40';
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