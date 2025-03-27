-- FEITO EM Postgres >10.0
-- OBS: ARQUIVO CSV (Relatorio_cadop) IMPORTADO DENTRO DA TABELA OPERADORAS PELO PGADMIN4.
-- CONFIGURAÇÕES DA IMPORTAÇÃO -> Format = CSV, Encoding = UTF8, HEADER ✅, Delimiter: ";".

-- Tabela Principal NO PGADMIN 4
CREATE TABLE operadoras (
    registro_ans VARCHAR(10) UNIQUE PRIMARY KEY,
    cnpj VARCHAR(14) NOT NULL,
    razao_social VARCHAR(255) NOT NULL,
    nome_fantasia VARCHAR(255),
    modalidade VARCHAR(100) NOT NULL,
    logradouro VARCHAR(255) NOT NULL,
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    uf CHAR(2) NOT NULL,
    cep VARCHAR(10) NOT NULL,
    ddd VARCHAR(2),
    telefone VARCHAR(20),
    fax VARCHAR(20),
    endereco_eletronico VARCHAR(255),
    representante VARCHAR(255) NOT NULL,
    cargo_representante VARCHAR(100) NOT NULL,
    regiao_comercializacao VARCHAR(10),
    data_registro_ans DATE NOT NULL,
    UNIQUE (cnpj)
);


--  Tabela de Modalidades NO PGADMIN 4
CREATE TABLE modalidades (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    UNIQUE (nome)
);

INSERT INTO modalidades (nome) VALUES 
('Administradora de Benefícios'),
('Odontologia de Grupo'),
('Medicina de Grupo'),
('Autogestão'),
('Seguradora Especializada em Saúde'),
('Filantropia'),
('Cooperativa Médica'),
('Cooperativa odontológica');


-- Tabela de Regiões de Comercialização NO PGADMIN 4
CREATE TABLE regioes_comercializacao (
    codigo VARCHAR(10) PRIMARY KEY,
    descricao VARCHAR(255) NOT NULL
);

INSERT INTO regioes_comercializacao (codigo, descricao) VALUES 
('1', 'Região 1'),
('2', 'Região 2'),
('3', 'Região 3'),
('4', 'Região 4'),
('5', 'Região 5'),
('6', 'Região 6');


-- MELHORANDO A OTIMIZAÇÃO PARA BUSCAS FREQUENTES NO PGADMIN 4
CREATE INDEX idx_operadoras_razao_social ON operadoras(razao_social);
CREATE INDEX idx_operadoras_nome_fantasia ON operadoras(nome_fantasia);
CREATE INDEX idx_operadoras_modalidade ON operadoras(modalidade);
CREATE INDEX idx_operadoras_uf ON operadoras(uf);
CREATE INDEX idx_operadoras_data_registro ON operadoras(data_registro_ans);


-- TABELA DE RELACIONAMENTO NO PGADMIN 4
CREATE TABLE operadoras_modalidades (
    operadora_registro_ans VARCHAR(10) REFERENCES operadoras(registro_ans),
    modalidade_id INTEGER REFERENCES modalidades(id),
    PRIMARY KEY (operadora_registro_ans, modalidade_id)
);