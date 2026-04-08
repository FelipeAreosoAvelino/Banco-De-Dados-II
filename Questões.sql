-- SCRIPT DE PROCEDIMENTOS ARMAZENADOS - LOCADORA

-- 1) CRUD DE CLIENTES --

-- Inclui um novo cliente na tabela CLIENTES
CREATE PROCEDURE Inclui_Cliente
	@RG VARCHAR(9),
    @NOME VARCHAR(50), 
    @ENDERECO VARCHAR(50), 
    @BAIRRO VARCHAR(30), 
    @CIDADE VARCHAR(30), 
    @ESTADO CHAR(2),
    @TELEFONE VARCHAR(15),
    @EMAIL VARCHAR(30), 
    @DATANASCIMENTO DATETIME, 
    @Sexo CHAR(1)
AS
BEGIN 
    INSERT INTO CLIENTES ([RG],[NOME], [ENDERECO], [BAIRRO], [CIDADE], [ESTADO], [TELEFONE], [EMAIL], [DATANASCIMENTO], [Sexo]) 
    VALUES (@RG,@NOME, @ENDERECO, @BAIRRO, @CIDADE, @ESTADO, @TELEFONE, @EMAIL, @DATANASCIMENTO, @Sexo)
END
GO

EXEC Inclui_Cliente
    @DATANASCIMENTO = '19870415', 
    @NOME = 'Jeferson Almida', 
    @ENDERECO = 'Rua das amélias', 
    @BAIRRO = 'Jardim simus', 
    @SEXO = 'M',
    @ESTADO = 'SP',
    @EMAIL = 'Jefersonalmeida@email.com', 
    @CIDADE = 'Sorocaba', 
    @TELEFONE = '(15)99999-9999',
    @RG = '123456789';


SELECT * FROM CLIENTES

GO

-- Lista todos os clientes cadastrados
CREATE PROCEDURE Mostra_Clientes
AS
BEGIN 
    SELECT * FROM CLIENTES
END
GO

-- Busca um cliente específico por seu código
CREATE PROCEDURE Seleciona_ID_Cliente
    @ID NUMERIC(18,0)
AS
BEGIN 
    SELECT * FROM CLIENTES WHERE COD_CLIENTE = @ID
END
GO

EXEC Seleciona_ID_Cliente 12

GO

-- Altera os dados de um cliente existente
CREATE PROCEDURE Alterar_Cliente
    @COD_CLIENTE NUMERIC(18,0),
    @RG VARCHAR(9),
    @NOME VARCHAR(50), 
    @ENDERECO VARCHAR(40), 
    @BAIRRO VARCHAR(30), 
    @CIDADE VARCHAR(30), 
    @ESTADO CHAR(2),
    @TELEFONE VARCHAR(15),
    @EMAIL VARCHAR(30), 
    @DATANASCIMENTO DATETIME, 
    @Sexo CHAR(1)
AS
BEGIN 
    UPDATE CLIENTES
    SET
        RG = @RG,
        NOME = @NOME,
        BAIRRO = @BAIRRO,
        ENDERECO = @ENDERECO,
        ESTADO = @ESTADO,
        TELEFONE = @TELEFONE,
        CIDADE = @CIDADE,
        Sexo = @Sexo,
        EMAIL = @EMAIL,
        DATANASCIMENTO = @DATANASCIMENTO
    WHERE COD_CLIENTE = @COD_CLIENTE
END
GO

SELECT * FROM CLIENTES

EXEC Alterar_Cliente
    @COD_CLIENTE = 11,
    @DATANASCIMENTO = '19870415', 
    @NOME = 'Jeferson Almeida', 
    @ENDERECO = 'Rua dos Crisantemos', 
    @BAIRRO = 'Jardim simus', 
    @SEXO = 'M',
    @ESTADO = 'SP',
    @EMAIL = 'Jefersonalmeida@email.com', 
    @CIDADE = 'Sorocaba', 
    @TELEFONE = '(15)95178-3193',
    @RG = '123456789';

-- Remove um cliente e suas locações associadas (em cascata)
CREATE PROCEDURE Deletar_clientes
    @ID NUMERIC(18,0)
AS
BEGIN
    DELETE FROM LOCACOES WHERE COD_CLIENTE = @ID
    DELETE FROM CLIENTES WHERE COD_CLIENTE = @ID
END
GO

EXEC Deletar_clientes 11
    
go

-- -----------------------------------------------------
-- 2) ANIVERSARIANTES DO MÊS
-- -----------------------------------------------------
-- Retorna nome e dia do nascimento dos clientes que fazem aniversário no mês informado
CREATE PROCEDURE Aniversariantes_Mes
    @mes NUMERIC(2,0)
AS
BEGIN 
    SELECT NOME, DAY(DATANASCIMENTO) AS Dia 
    FROM CLIENTES 
    WHERE MONTH(DATANASCIMENTO) = @mes
END
GO

EXEC Aniversariantes_Mes 1
SELECT * FROM CLIENTES
GO
-- -----------------------------------------------------
-- 3) RESUMO DE ANIVERSARIANTES POR MÊS
-- -----------------------------------------------------
-- Mostra a contagem de aniversariantes para cada mês do ano (exibe 0 quando não houver)
CREATE PROCEDURE Resumos_Aniversariantes 
AS
BEGIN
    SELECT 
        M.mes AS Mês,
        COUNT(c.DATANASCIMENTO) AS Quantidade
    FROM (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)) AS M(mes)
    LEFT JOIN CLIENTES AS c ON MONTH(c.DATANASCIMENTO) = M.mes
    GROUP BY M.mes
    ORDER BY M.mes ASC
END
GO

EXEC Resumos_Aniversariantes
SELECT * FROM CLIENTES 
go
-- -----------------------------------------------------
-- 4) CLIENTES POR CIDADE COM IDADE LIMITE
-- -----------------------------------------------------
-- Lista clientes de uma cidade específica com idade menor ou igual ao valor informado
CREATE PROCEDURE ClienteCidadeIdade
    @cidade VARCHAR(30),
    @idade NUMERIC(3,0)
AS
BEGIN
    SELECT 
        c.NOME AS [Nome do Cliente],
        c.DATANASCIMENTO AS [Data Nascimento],
        (
            DATEDIFF(YEAR, c.DATANASCIMENTO, GETDATE()) - 
            CASE 
                WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.DATANASCIMENTO, GETDATE()), c.DATANASCIMENTO) > GETDATE()
                THEN 1 ELSE 0 
            END
        ) AS Idade
    FROM CLIENTES AS c  
    WHERE c.CIDADE = @cidade 
    AND (
            DATEDIFF(YEAR, c.DATANASCIMENTO, GETDATE()) - 
            CASE 
                WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.DATANASCIMENTO, GETDATE()), c.DATANASCIMENTO) > GETDATE()
                THEN 1 ELSE 0 
            END
        ) <= @idade
END
GO

EXEC ClienteCidadeIdade Sorocaba, 33
select * from clientes
GO

/*5)*/
Alter table filme
add status varchar(10) not null default 'disponível'

alter table locacoes 
add Data_Devolucao datetime null;
select* from LOCACOES;
go

create procedure IncluirLocacao
	@id_cliente numeric(18,0),
	@id_filme numeric(18,0)
as 
begin 
insert into LOCACOES (COD_CLIENTE,COD_FILME,DATA_LOCACAO,DATA_EXPIRACAO) values (@id_cliente,@id_filme,GETDATE(),DATEADD(DAY,5,GETDATE()));
update FILME set status  = 'alugado' where COD_FILME = @id_filme;
end

exec IncluirLocacao 8, 8;
go

/*Questão 6) */
create procedure Devolver_Filme
@id_locacao numeric(18,0)
as begin
update LOCACOES set Data_Devolucao = GETDATE() where COD_LOCACAO = @id_locacao;
update filme set status = 'disponivel'  
    from filme as f 
    inner join LOCACOES  l on l.COD_FILME = f.COD_FILME 
    where l.COD_LOCACAO = @id_locacao;
end
exec Devolver_Filme 128;
DELETE FROM locacoes WHERE COD_LOCACAO >= 30;
select* from LOCACOES;