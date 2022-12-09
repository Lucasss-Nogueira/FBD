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

------//                                    --------///---------                                    //---------------

Create table gravadora(

	cod_grav	smallint,
	nome	varchar(40),
	ender_fis	varchar(100),
	ender_hp	varchar(100),

	constraint pk_gravadora
		primary key (cod_grav)

)

Create table telefones(

	cod_grav	smallint,
	telefone	varchar(40),

	constraint pk_telefones
		primary key (cod_grav,telefone)

)

Create table album(

	cod_album	smallint,
	tipo_compra	varchar(10),
	descrição	varchar(100),
	pr_compra	dec(11,2),
	pr_venda	dec(11,2),
	dt_compra	date,
	dt_venda	date,
	meio_físico	varchar(10),
	cod_grav	smallint,

	constraint pk_album 
		primary key (cod_album),

	constraint fk_cod_grav_Album
		foreign key (cod_grav)
			references gravadora

)

Create table composição(

	cod_composição	smallint,
	descrição	varchar(40)
	
	constraint pk_composição
		primary key (cod_composição)

)

Create table faixa(

	num_faixa	int,
	descrição	varchar(50),
	tempo_execução	time,
	tipo_gravação	varchar(15),
	cod_album	smallint,
	cod_composição	smallint,

	constraint pk_faixa
		primary key (num_faixa),

	constraint fk_cod_album_Faixa
		foreign key (cod_album)
			references album,
	constraint fk_cod_composição_Faixa
		foreign key (cod_composição)
			references composição

)


Create table playlist(
	
	cod_playlist smallint,
	temp_exec time,
	dt_criado date,
	nome varchar(50),

	constraint pk_playlist 
		primary key (cod_playlist)

)

Create table faixa_playlist(

	cod_playlist	smallint,
	num_faixa	int,
	qt_tocada	smallint,
	dt_ultima_tocada	date,

	constraint pk_faixa_playlist
		primary key (cod_playlist,num_faixa),

	constraint fk_cod_playlist_Faixa_Playlist
		foreign key (cod_playlist)
			references playlist,
	constraint fk_num_faixa_Faixa_Playlist
		foreign key (num_faixa)
			references faixa
	
)


Create table interprete(

	cod_inte	smallint,
	tipo	varchar(20),
	nome	varchar(50),

	constraint pk_interprete
		primary key (cod_inte)

)

Create table faixa_interprete(

	cod_inte	smallint,
	num_faixa	int,
	nome	varchar(50),

	constraint pk_faixa_interprete
		primary key (cod_inte,num_faixa),

	constraint fk_cod_inte_faixa_interprete
		foreign key (cod_inte)
			references interprete,

	constraint fk_num_faixa_faixa_interprete
		foreign key (num_faixa)
			references faixa

)

Create table compositor(

	cod_compositor

)