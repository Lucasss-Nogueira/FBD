--drop database SpotPer

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
use SpotPer

go

Create table gravadora(

	cod_grav	smallint,
	nome	varchar(40),
	ender_fis	varchar(100),
	ender_hp	varchar(100),

	constraint pk_gravadora
		primary key (cod_grav)

) on SpotPer_fg01

Create table telefones(

	cod_grav	smallint,
	telefone	varchar(40),

	constraint pk_telefones
		primary key (cod_grav,telefone),

	constraint fk_cod_grav_telefones
		foreign key (cod_grav)
			references gravadora

) on SpotPer_fg01

Create table album(

	cod_album	smallint,
	tipo_compra	varchar(10),
	descri	varchar(100),
	pr_compra	dec(11,2),
	pr_venda	dec(11,2),
	dt_compra	date,
	dt_venda	date,
	meio_fisico	varchar(10),
	cod_grav	smallint,

	constraint pk_album 
		primary key (cod_album),

	constraint fk_cod_grav_Album
		foreign key (cod_grav)
			references gravadora

) on SpotPer_fg01

Create table composicao(

	cod_comp	smallint,
	descri	varchar(40)
	
	constraint pk_composicao
		primary key (cod_comp)

) on SpotPer_fg01

Create table faixa(

	num_faixa	int,
	descri	varchar(50),
	tempo_exec	time,
	tipo_grav	varchar(15),
	cod_album	smallint,
	cod_comp	smallint,

	constraint pk_faixa
		primary key nonclustered (num_faixa),

	constraint fk_cod_album_Faixa
		foreign key (cod_album)
			references album,

	constraint fk_cod_comp_Faixa
		foreign key (cod_comp)
			references composicao

) on SpotPer_fg02

--É preciso dropar o índice primário que é criado automáticamente  

Create Clustered Index Faixa_IDX_Cod_Album
	on faixa (cod_album)
	with (fillfactor=100, pad_index=on)

Create NonClustered Index Faixa_IDX_Cod_Comp
	on faixa (cod_comp)
	with (fillfactor=100, pad_index=on)


Create table playlist(
	
	cod_playlist smallint,
	temp_exec time,
	dt_criado date,
	nome varchar(50),

	constraint pk_playlist 
		primary key (cod_playlist)

) on SpotPer_fg02

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
	
) on SpotPer_fg02


Create table interprete(

	cod_inte	smallint,
	tipo	varchar(20),
	nome	varchar(50),

	constraint pk_interprete
		primary key (cod_inte)

) on SpotPer_fg01

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

) on SpotPer_fg01

Create table periodo_musical(

	cod_pm	smallint,
	descri	varchar(100),
	temp_ativo	time

	constraint pk_periodo_musical
		primary key (cod_pm)

) on SpotPer_fg01

Create table compositor(

	cod_compositor	smallint,
	dt_nasc	date,
	dt_morte	date,
	nome	varchar(50),
	cid_nasc	varchar(100),
	pais_nasc	varchar(100),
	cod_pm	smallint,

	constraint pk_compositor
		primary key (cod_compositor),

	constraint fk_cod_pm_Compositor
		foreign key (cod_pm)
			references periodo_musical

) on SpotPer_fg01

Create table faixa_compositor(

	cod_compositor	smallint,
	num_faixa	int,

	constraint pk_faixa_compositor
		primary key (cod_compositor,num_faixa),

	constraint fk_cod_compositor_faixa_compositor
		foreign key (cod_compositor)
			references compositor,

	constraint pk_num_faixa_faixa_compositor
		foreign key (num_faixa)
			references faixa

) on SpotPer_fg01

go