INSERT INTO dbo.Comp (
CompName,
ShortName,
Date,
TotalNumFencers,
)

VALUES ('Birmingham International Fencing',
		'BirmIntl',
		'2017-04-15',
		'117') ;

INSERT INTO dbo.Comp (
FencerCutOff)

VALUES(FLOOR( 0.75 * dbo.Comp.TotalNumFencers));

INSERT INTO dbo.Comp


