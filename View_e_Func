--CODIGOS SEM TESTES



create view ver_playlist(nome_playlist, qtde_album)
with
  schemabinding
as
select p.nome, count(distinct alb.cod_alb) from Playlist p inner join Faixa_Playlist fp inner join  Faixa f inner join album alb
on p.cod_playlist = fp.cod_playlist on fp.num_faixa = f.num_faixa on f.cod_alb = alb.cod_alb
group by p.nome, alb.cod_alb


create unique clustered index I_VP on ver_playlist(playlist)




-- albuns com obras desse compositor
create function obras_comp (@nome_cp varchar(40))
returns @tab_result(@nome_alb varchar(40))
as
begin
insert into @tab_result
select alb.nome from Album alb inner join Faixa f inner join Faixa_Compositor fc inner join Compositor cp on alb.cod_alb = f.cod_alb on f.num_faixa = fc.num_faixa on fc.cod_compositor =  cp.cod_compositor
where cp.nome = @nome_cp
return
end
