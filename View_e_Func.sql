drop view ver_playlist
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

go
-----
--8c
--Listar nome do compositor com maior número de faixas nas playlists existentes
select cp.nome from compositor cp left outer join faixa_compositor fc left outer join faixa f left outer join faixa_playlist fp left outer join playlist p 
				on p.cod_playlist = fp.cod_playlist
				on fp.num_faixa = f.num_faixa
				on f.num_faixa = fc.num_faixa 
				on fc.cod_compositor =  cp.cod_compositor 
				
				 

group by cp.cod_compositor, cp.nome
having count(distinct fc.num_faixa) >= all (select count(distinct f.num_faixa) from faixa f, faixa_playlist fp, playlist p 
where f.num_faixa = fp.num_faixa and fp.cod_playlist = p.cod_playlist group by f.num_faixa)
go


go
--8d
--(d) Listar playlists, cujas faixas (todas) têm tipo de composição “Concerto” e período “Barroco”.

--Select dos nomes das playlists
select p.cod_playlist,p.nome from playlist p inner join faixa_playlist fp inner join  faixa f 
								on fp.num_faixa = f.num_faixa
								on p.cod_playlist = fp.cod_playlist 
								
group by p.cod_playlist,p.nome
-- qtde total de faixas nessa playlist igual a qtde total de faixas nessa playlist que estao nesse periodo musical e nessa composicao, logo assim somente as playlist com todas as faixas nesse pm e cmp serao aceitas
having count(distinct f.num_faixa) = (select count( distinct f.num_faixa) 
											  from faixa f, faixa_compositor fc, compositor cp, periodo_Musical pm , composicao cmp, playlist p, faixa_playlist fp
											  where	  f.cod_comp = cmp.cod_comp and
													  f.num_faixa = fc.num_faixa and
													  fc.cod_compositor = cp.cod_compositor and 
													  cp.cod_pm = pm.cod_pm and 
													  f.num_faixa = fp.num_faixa and 
													  fp.cod_playlist = p.cod_playlist and
													  pm.descri like 'Barroco' and 
													  cmp.descri like 'Concerto'
											)
go