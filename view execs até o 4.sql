-- exec 1 (view q mostra filmes disponiveis)
create view vw_filmes_disponiveis AS
select *
from FILME
where Status = 'disponível';
select * from vw_filmes_disponiveis;
go
-- exec 2 (mostrar filmes mais alugados)
create view vw_filmes_mais_alugados as
select COD_FILME, count(cod_filme) as quantidade_alugueis
from LOCACOES
group by COD_FILME;
go
select * from vw_filmes_mais_alugados order by quantidade_alugueis desc;
go
--exec 3 ()
create function dbo.fnAcrescimo (
	@ValorOriginal decimal(10,2),
	@PorcentagemAumento decimal(5,2)
)
returns decimal (10,2)
as
begin
	declare @ValorFinal decimal(10,2);
	set @ValorFinal = @ValorOriginal + (@ValorOriginal * (@PorcentagemAumento / 100));
	return @ValorFinal;
end;
go
select dbo.fnAcrescimo(100,10) as Preço_com_aumento;
go

--Exec 4(func 2 numeros int maior entre eles)
create function dbo.fnMaior_Numero(
	@Num1 decimal(10,2),
	@Num2 decimal(10,2)
)
returns decimal (10,2)
as
begin
	declare @maior_numero decimal(10,2)
	set @maior_numero = case
							when @Num1 > @Num2 then @Num1
							else @Num2
							end;
	return @maior_numero
end;
go

	select dbo.fnMaior_Numero(10,2) as maior_numero