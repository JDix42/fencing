DECLARE @LongName nvarchar(255) = 'Tournoi Satellite Fleuret Masculin Amsterdam 2017';
DECLARE @ShortName nvarchar(8) = 'AmstrSat';
DECLARE @Date datetime = '2017-09-23 09:00:00.000';
DECLARE @TotalNumFencers Int = '75';
DECLARE @DomOrInt nvarchar(1) = 'I'

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