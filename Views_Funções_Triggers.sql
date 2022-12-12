
---- Triggers ----
--3.a)
go
CREATE TRIGGER album_barrocoDDD_trigger
       ON album
       FOR INSERT, UPDATE
       AS
  
		if (select i.cod_album from inserted i)
		 in
		( SELECT i.cod_album 
			FROM inserted i inner join faixa f inner join faixa_compositor fc inner join compositor cp inner join periodo_musical pm 
				on pm.cod_pm=cp.cod_pm on cp.cod_compositor=fc.cod_compositor on fc.num_faixa=f.num_faixa on f.cod_album=i.cod_album
					where pm.descri like 'Barroco' and f.tipo_grav not like 'DDD')
			BEGIN
				   RAISERROR ('Álbum com faixas do período Barroco com gravações que não são do tipo DDD', 10, 6)
				   ROLLBACK TRANSACTION
			END
go
--3.b)
go
CREATE TRIGGER album_64_trigger
       ON faixa
       FOR INSERT, UPDATE
       AS
		declare @qtde int
		declare @cod_album smallint

		select @cod_album=cod_album from inserted

		SELECT  @qtde=count(distinct num_faixa)
			FROM faixa f, album a
				where a.cod_album= @cod_album

		if @qtde>64
			BEGIN
				RAISERROR ('Álbum ficaria com mais de 64 faixas', 10, 6)
				ROLLBACK TRANSACTION
			END
go
--3.c) Foi feito na própria criação da tabela faixa adicionando on delete cascade na foreign key fk_cod_album_Faixa
CREATE TRIGGER album_pr_compra_trigger
       ON album
       FOR INSERT, UPDATE
       AS
		declare @pr_inserted dec(11,2)
		declare @media dec(11,2)

		select @pr_inserted=pr_compra from inserted

		select @media=avg(pr_compra)
			from album a1 inner join faixa f1 
				on a1.cod_album=f1.cod_album
					group by a1.cod_album
						having count(distinct num_faixa)= (
															select count(distinct num_faixa)
																from album a inner join faixa f 
																	on a.cod_album=f.cod_album
																		where f.tipo_grav like 'DDD' and a.cod_album=a1.cod_album)
	
		if @pr_inserted > 3*@media
			BEGIN
				RAISERROR ('Álbum ficaria com mais de 64 faixas', 10, 6)
				ROLLBACK TRANSACTION
			END
go

--------
--5)
---------------- View --
--drop view ver_playlist
go
create  view ver_playlist(nome_playlist, qtde_album)
with
  schemabinding
as
select p.nome, count_big(distinct alb.cod_album) from dbo.Playlist p inner join dbo.Faixa_Playlist fp inner join  dbo.Faixa f inner join dbo.album alb
on f.cod_album = alb.cod_album on fp.num_faixa = f.num_faixa on p.cod_playlist = fp.cod_playlist
group by p.nome
go

go
create unique clustered index I_VP on ver_playlist(nome_playlist)
go

-------------
--6)
-------Função-------
go
-- albuns com obras desse compositor
create function obras_comp (@nome_cp varchar(40))
returns @tab_result table(nome_alb varchar(40))
as
begin
insert into @tab_result
select distinct alb.descri from album alb inner join faixa f inner join faixa_compositor fc inner join compositor cp 
							on fc.cod_compositor =  cp.cod_compositor  on f.num_faixa = fc.num_faixa  on alb.cod_album = f.cod_album
where cp.nome = @nome_cp
return
end

go
---------------

-----Consultas-----
go
-----
--8a
--Listar os álbum com preço de compra maior que a média de preços de compra de todos os álbuns
select a.cod_album,a.descri 
	from album a
		where a.pr_compra > (select avg(pr_compra) from album) 
------------------------------------------------------
--8b
--Listar nome da gravadora com maior número de playlists que possuem pelo menos uma faixa composta pelo compositor Dvorack.
go
select g.nome 
	from gravadora g left outer join album a left outer join faixa f left outer join  faixa_playlist fp inner join playlist p
		on p.cod_playlist = fp.cod_playlist on fp.num_faixa=f.num_faixa on a.cod_album=f.cod_album  on  g.cod_grav=a.cod_grav 
			where exists (
							select *
								from faixa f2, faixa_compositor fc, compositor cp 
									where f2.num_faixa = fc.num_faixa and fc.cod_compositor = cp.cod_compositor and cp.nome like 'Dvorack' and f2.num_faixa = f.num_faixa)
				group by g.cod_grav,g.nome
					having count(distinct p.cod_playlist) >= all (
																	select count(distinct p.cod_playlist)
																		from gravadora g left outer join album a left outer join faixa f left outer join  faixa_playlist fp inner join playlist p
																			on p.cod_playlist = fp.cod_playlist on fp.num_faixa=f.num_faixa on a.cod_album=f.cod_album  on  g.cod_grav=a.cod_grav 
																				where exists (
																								select *
																									from faixa f2, faixa_compositor fc, compositor cp 
																										where f2.num_faixa = fc.num_faixa and fc.cod_compositor = cp.cod_compositor and cp.nome like 'Dvorack' and f2.num_faixa = f.num_faixa)
																					group by g.cod_grav)

go

-------------------------------------------------------
--8c
--Listar nome do compositor com maior número de faixas nas playlists existentes
go
select cp.nome from compositor cp left outer join faixa_compositor fc left outer join faixa f left outer join faixa_playlist fp left outer join playlist p 
				on p.cod_playlist = fp.cod_playlist
				on fp.num_faixa = f.num_faixa
				on f.num_faixa = fc.num_faixa 
				on fc.cod_compositor =  cp.cod_compositor 
				
				 

group by cp.cod_compositor, cp.nome
having count(distinct fc.num_faixa) >= all (select count(distinct f.num_faixa) from compositor cp left outer join faixa_compositor fc left outer join faixa f left outer join faixa_playlist fp left outer join playlist p 
												on p.cod_playlist = fp.cod_playlist
												on fp.num_faixa = f.num_faixa
												on f.num_faixa = fc.num_faixa 
												on fc.cod_compositor =  cp.cod_compositor
												group by cp.cod_compositor)
go


go
--8d
select p.cod_playlist,p.nome from playlist p inner join faixa_playlist fp inner join  faixa f 
								on fp.num_faixa = f.num_faixa
								on p.cod_playlist = fp.cod_playlist 
								
group by p.cod_playlist,p.nome
-- qtde total de faixas nessa playlist igual a qtde total de faixas nessa playlist que estao nesse periodo musical e nessa composicao, logo assim somente as playlist com todas as faixas nesse pm e cmp serao aceitas
having count(distinct f.num_faixa) = (select count( distinct f.num_faixa) 
											  from faixa f, faixa_compositor fc, compositor cp, periodo_Musical pm , composicao cmp, playlist p2, faixa_playlist fp
											  where	  f.cod_comp = cmp.cod_comp and
													  f.num_faixa = fc.num_faixa and
													  fc.cod_compositor = cp.cod_compositor and 
													  cp.cod_pm = pm.cod_pm and 
													  f.num_faixa = fp.num_faixa and 
													  fp.cod_playlist = p2.cod_playlist and
													  pm.descri like 'Barroco' and 
													  cmp.descri like 'Concerto'
													  and p.cod_playlist = p2.cod_playlist
											)
go

--------------