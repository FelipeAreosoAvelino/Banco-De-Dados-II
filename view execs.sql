-- exec 1 (view q mostra filmes disponiveis)
create view vw_filmes_disponiveis AS
select *
from FILME
where Status = 'disponível';
go

-- exec 2 ()
select * from FILME;
select * from LOCACOES;
create view vw_filmes_mais_alugados as
select *
from LOCACOES
where 