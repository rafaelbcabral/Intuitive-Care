-- FEITO EM Postgres >10.0

-- CRIAÇÃO DA TABELA PRINCIPAL NO PGADMIN 4
CREATE TABLE demonstracoes_contabeis (
    id SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    registro_ans VARCHAR(10) NOT NULL,
    codigo_conta VARCHAR(20) NOT NULL,    
    descricao_conta TEXT NOT NULL,          
    saldo_inicial NUMERIC(15, 2) NOT NULL,  
    saldo_final NUMERIC(15, 2) NOT NULL  
);

-- ÍNDICES PARA OTIMIZAÇÃO DE CONSULTASs NO PGADMIN 4
CREATE INDEX idx_demcontab_data ON demonstracoes_contabeis(data);
CREATE INDEX idx_demcontab_registro_ans ON demonstracoes_contabeis(registro_ans);

-- COMANDO PARA EXECUTAR NO PSQL, APÓS ENTRAR NO \c "Seu data-base que criou"
-- CRIaCAO DA TABELA TEMPORARIA NO PSQL POR CONTA DOS ARQUIVOS QUE ESTAO COM VIRGULA EM VALORES
CREATE TEMP TABLE temp_contabeis(
    data date,
    registro_ans text,
    codigo_conta text,
    descricao_conta text,
    saldo_inicial text,
    saldo_final text
);

-- CONTINUAÇÃO PARA EXECUTAR NO PSQL, APÓS A CRIACAO DA TABELA TEMPORÁRIA
-- IMPORTS DOS ARQUIVOS(USE DE ACORDO COM AONDE ESTÁ NO SEU COMPUTADOR):
\copy temp_contabeis FROM 'C:\Users\rafae\Downloads\TESTE DE NIVELAMENTO\TESTE DE BANCO DE DADOS\dados\1T2023.csv' WITH (FORMAT csv, DELIMITER ';', HEADER, ENCODING 'UTF8');
\copy temp_contabeis FROM 'C:\Users\rafae\Downloads\TESTE DE NIVELAMENTO\TESTE DE BANCO DE DADOS\dados\2T2023.csv' WITH (FORMAT csv, DELIMITER ';', HEADER, ENCODING 'UTF8');
\copy temp_contabeis FROM 'C:\Users\rafae\Downloads\TESTE DE NIVELAMENTO\TESTE DE BANCO DE DADOS\dados\3T2023.csv' WITH (FORMAT csv, DELIMITER ';', HEADER, ENCODING 'UTF8');
\copy temp_contabeis FROM 'C:\Users\rafae\Downloads\TESTE DE NIVELAMENTO\TESTE DE BANCO DE DADOS\dados\4T2023.csv' WITH (FORMAT csv, DELIMITER ';', HEADER, ENCODING 'UTF8');
\copy temp_contabeis FROM 'C:\Users\rafae\Downloads\TESTE DE NIVELAMENTO\TESTE DE BANCO DE DADOS\dados\1T2024.csv' WITH (FORMAT csv, DELIMITER ';', HEADER, ENCODING 'UTF8');
\copy temp_contabeis FROM 'C:\Users\rafae\Downloads\TESTE DE NIVELAMENTO\TESTE DE BANCO DE DADOS\dados\2T2024.csv' WITH (FORMAT csv, DELIMITER ';', HEADER, ENCODING 'UTF8');
\copy temp_contabeis FROM 'C:\Users\rafae\Downloads\TESTE DE NIVELAMENTO\TESTE DE BANCO DE DADOS\dados\3T2024.csv' WITH (FORMAT csv, DELIMITER ';', HEADER, ENCODING 'UTF8');
\copy temp_contabeis FROM 'C:\Users\rafae\Downloads\TESTE DE NIVELAMENTO\TESTE DE BANCO DE DADOS\dados\4T2024.csv' WITH (FORMAT csv, DELIMITER ';', HEADER, ENCODING 'UTF8');

-- CONTINUAÇÃO PARA EXECUTAR NO PSQL, APÓS OS IMPORTS
-- Converção para a tabela final
INSERT INTO demonstracoes_contabeis (
    data,              
    registro_ans,
    codigo_conta,
    descricao_conta,
    saldo_inicial,
    saldo_final
)
SELECT 
    data,
    registro_ans,
    codigo_conta,
    descricao_conta,
    REPLACE(saldo_inicial, ',', '.')::numeric,
    REPLACE(saldo_final, ',', '.')::numeric
FROM temp_contabeis;

-- CONTINUAÇÃO PARA EXECUTAR NO PSQL, APÓS A CONVERSÃO
-- Limpar tabela temporária
DROP TABLE temp_contabeis;
