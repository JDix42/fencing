DECLARE @LongName nvarchar(255) = 'Oxfam Open 2017';
DECLARE @ShortName nvarchar(8) = 'OxfmOpen';
DECLARE @Date datetime = '2017-12-09 10:00:00.000';
DECLARE @TotalNumFencers Int = '22';
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
SET FencerCutOff = (
CASE
/*	If there are more than 171 fencers
then the cut-off is beyond the 128 - this
is not allowed */
	WHEN @TotalNumFencers > 171
	THEN '128'
	ELSE
	FLOOR( 0.75 * @TotalNumFencers)
END
)
WHERE CompName = @LongName;