CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50),
    sobrenome VARCHAR(50),
    cpf VARCHAR(20) NOT NULL,
    endereco VARCHAR(100),
    CONSTRAINT unique_cpf_cliente UNIQUE (cpf)
);

CREATE TABLE produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2),
    classificacao_indicativa VARCHAR(20),
    categoria ENUM('eletronico','vestimenta','brinquedo','alimento','moveis') NOT NULL,
    avaliacao DECIMAL(10, 2) DEFAULT 0,
    dimensoes VARCHAR(50)
);

CREATE TABLE metodo_pagamento (
    id_metodo_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    metodo_pagamento ENUM('credito','debito','boleto','pix'),
    detalhes VARCHAR(100)
);

CREATE TABLE pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_metodo_pagamento INT NOT NULL,
    id_entrega INT NOT NULL,
    estado_pedido ENUM('cancelado','confirmado','em processamento') NOT NULL,
    descricao VARCHAR(100),
    frete DECIMAL(10, 2) DEFAULT 10,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_pedido_metodo_pagamento FOREIGN KEY (id_metodo_pagamento) REFERENCES metodo_pagamento(id_metodo_pagamento)
);


CREATE TABLE estoque (
    id_estoque INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT,
    quantidade INT NOT NULL,
    localizacao VARCHAR(50),
    CONSTRAINT fk_estoque_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

CREATE TABLE fornecedor (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    cnpj VARCHAR(15) NOT NULL,
    razao_social VARCHAR(100) NOT NULL,
    contato VARCHAR(50),
    endereco VARCHAR(100),
    CONSTRAINT unique_cnpj_fornecedor UNIQUE (cnpj)
);

CREATE TABLE vendedor (
    id_vendedor INT AUTO_INCREMENT PRIMARY KEY,
    cnpj VARCHAR(15),
    cpf VARCHAR(15),
    contato VARCHAR(50),
    nome VARCHAR(100),
    CONSTRAINT unique_cnpj_vendedor UNIQUE (cnpj),
    CONSTRAINT unique_cpf_vendedor UNIQUE (cpf)
);

CREATE TABLE entrega (
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    codigo rastreio VARCHAR(20)
)

CREATE TABLE produto_vendedor (
    id_produto INT NOT NULL,
    id_vendedor INT NOT NULL,
    quantidade INT DEFAULT 1,
    CONSTRAINT fk_produto_vendedor_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
    CONSTRAINT fk_produto_vendedor_vendedor FOREIGN KEY (id_vendedor) REFERENCES vendedor(id_vendedor)
);

CREATE TABLE produto_pedido (
    id_produto INT NOT NULL,
    id_pedido INT NOT NULL,
    quantidade INT DEFAULT 1,
    CONSTRAINT fk_produto_pedido_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
    CONSTRAINT fk_produto_pedido_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
);

CREATE TABLE produto_estoque (
    id_produto INT NOT NULL,
    id_estoque INT NOT NULL,
    quantidade INT DEFAULT 1,
    CONSTRAINT fk_produto_estoque_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
    CONSTRAINT fk_produto_estoque_estoque FOREIGN KEY (id_estoque) REFERENCES estoque(id_estoque)
);

ALTER TABLE cliente AUTO_INCREMENT = 1;

CREATE FULLTEXT INDEX index_nome_produto USING HASH ON produto(nome); --Geralmente consulta-se o produto pelo nome

delimiter //
CREATE PROCEDURE IF NOT EXISTS cadastra_produto(
    IN _nome VARCHAR(100),
    IN _preco DECIMAL(10,2),
    IN _classificacao_indicativa VARCHAR(20),
    IN _categoria ENUM('eletronico','vestimenta','brinquedo','alimento','moveis'),
    IN _avaliacao DECIMAL(10, 2),
    IN _dimensoes VARCHAR(50)
    )
    BEGIN
        INSERT INTO produto(nome, preco, classificacao_indicativa, categoria, avaliacaol, dimensoes) VALUES (_nome, _preco, _classificacao_indicativa, _categoria, _avaliacao, _dimensoes);
        SELECT * FROM produto WHERE nome = _nome;
    END//


CREATE VIEW view_produto as SELECT * FROM produto;

delimiter //
CREATE TRIGGER valida_preco BEFORE UPDATE ON produto
       FOR EACH ROW
       BEGIN
           IF NEW.preco < 0 THEN
               SET NEW.preco = 10;
           ELSEIF NEW.preco > 100 THEN
               SET NEW.preco = 100;
           END IF;
       END;//
