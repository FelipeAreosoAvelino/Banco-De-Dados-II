/*Create*/

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

EXEC Inclui_Cliente '123456789', 'João Silva', 'Rua das Flores, 123', 'Centro', 'São Paulo', 'SP', '11999999999', 'joao@email.com', '1990-01-01', 'M';

CREATE PROCEDURE Inclui_Categoria
	@NOME_CATEGORIA VARCHAR(20)
AS
BEGIN 
    INSERT INTO CATEGORIA([NOME_CATEGORIA]) 
    VALUES (@NOME_CATEGORIA)
END

EXEC Inclui_Categoria 'Sci-fi';
select * from CATEGORIA;

/* READ*/
CREATE PROCEDURE Mostra_Clientes
AS
BEGIN 
    select * from CLIENTES;
END

exec Mostra_Clientes;

CREATE PROCEDURE Mostra_Cliente_Por_ID
	@ID numeric(18,0)
AS
BEGIN 
    select * from CLIENTES where COD_CLIENTE = @ID
END
exec Mostra_Cliente_Por_ID 5;

CREATE PROCEDURE Update_Dados_Cliente
	@COD_CLIENTE numeric(18,0),
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
    UPDATE CLIENTES
    SET
        RG = @RG,
        NOME = @NOME,
        ENDERECO = @ENDERECO,
        BAIRRO = @BAIRRO,
        CIDADE = @CIDADE,
        ESTADO = @ESTADO,
        TELEFONE = @TELEFONE,
        EMAIL = @EMAIL,
        DATANASCIMENTO = @DATANASCIMENTO,
        Sexo = @Sexo
    WHERE COD_CLIENTE = @COD_CLIENTE
END

EXEC Update_Dados_Cliente 12, '123456789', 'João Silva', 'Rua das Flores, 123', 'Centro', 'São Paulo', 'SP', '11999999999', 'joaosilva@email.com', '1990-01-01', 'M';

CREATE PROCEDURE Deleta_cliente
	@ID numeric(18,0)
AS
BEGIN
	delete from LOCACOES  where COD_CLIENTE = @ID
    delete from CLIENTES where COD_CLIENTE = @ID

END