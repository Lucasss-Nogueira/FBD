go

select a.cod_album, a.descri, f.num_faixa, f.descri
	from album a inner join faixa f on a.cod_album=f.cod_album

go
--- Utilizadas para povoar o banco de dados
go
insert into gravadora values (1,'Ipanema','Rua do Baralho','www.gravadoramassa')
insert into gravadora values (2,'EMMY','Rua do Barulho','www.gravadoramassaDEMAIS')
insert into gravadora values (3,'RockStudios','Rua do Rock','www.gravadoraDEMAIS')

insert into album values (1,'cartao','um album mt massa',123,432,'11/02/2222','11/02/2223','vinil',1)
insert into album values (2,'cartao','album mt paia',1423,2432,'11/02/2222','11/02/2223','vinil',3)
insert into album values (10,'Dinheiro','Pegadinha',10000.00,9999.00,'10/10/2000','21/12/2005','disco',2)
insert into album values (3,'Dinheiro','Pegadinha2.0',10011.00,9999.00,'10/10/2002','21/12/2005','disco',2)
insert into album values (4,'Dinheiro','Lulala',100000.00,999.00,'10/10/2008','21/12/2012','online',3)
insert into album values (5,'Dinheiro','CanetaAzul',100000.00,999900.00,'10/10/2018','21/12/2020','online',1)

insert into composicao values (1,'Improvisada')
insert into faixa values (1,'HelloMusic','00:02:30','DDD',2,1)

insert into playlist values (1,'00:00:00','10/10/2000','Playlistmassa')
insert into faixa_playlist values (1,1,0,'01/11/2000')

insert into periodo_musical values (1,'Barroco','22:30:00')
insert into compositor values (1,'10/10/1780','10/10/1840','Pedrin Barroquista','Veneza','Itália',1)
insert into faixa values (2,'Música Barroca DDD','00:06:30','DDD',2,1)

insert into faixa values (3,'Música Barroca sem DDD','00:05:30','ADD',1,1)


go
----

select * from faixa_playlist
select * from album
select * from faixa

delete from faixa where cod_album=1

Update album  set pr_compra = 123 where cod_album=1