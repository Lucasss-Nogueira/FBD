create database SpotPer
on
	PRIMARY 
	(
		NAME = 'SpotPer',
		FILENAME = 'C:\FBD\SpotPer.mdf',
		SIZE = 5120KB,
		FILEGROWTH = 1024KB
	),

	FILEGROUP SpotPer_fg01
	(
		NAME = 'SpotPer_001',
		FILENAME = 'C:\FBD\SpotPer_001.ndf',
		SIZE = 1024KB,
		FILEGROWTH = 30%
	), 
	(
		NAME ='SpotPer_002',
		FILENAME = 'C:\FBD\SpotPer_002.ndf',
		SIZE = 1024KB,
		MAXSIZE = 3072KB,
		FILEGROWTH = 15%
	),

	FILEGROUP SpotPer_fg02
	(
		NAME = 'SpotPer_003',
		FILENAME = 'C:\FBD\SpotPer_003.ndf',
		SIZE = 2048KB,
		MAXSIZE = 5120KB,
		FILEGROWTH = 1024KB
	)

	LOG ON 
	(
		NAME = 'SpotPer_log',
		FILENAME = 'C:\FBD\SpotPer.ldf',
		SIZE = 1024KB,
		FILEGROWTH = 10%
	)

