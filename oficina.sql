CREATE TABLE peca(
    id_peca INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(20) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    numero_serie INT NOT NULL,
    preco DECIMAL(10,2) NOT NULL
)

CREATE TABLE funcionario(
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL,
    especialidade VARCHAR(20),
    CONSTRAINT unique_cpf_funcionario UNIQUE (cpf)
)

CREATE TABLE servico(
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(300),
    preco DECIMAL(10,2) NOT NULL
)

CREATE TABLE cliente(
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL,
    contato VARCHAR(11) NOT NULL,
    CONSTRAINT unique_cpf_cliente UNIQUE (cpf)
);

CREATE TABLE veiculo(
    id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(8) NOT NULL,
    tipo_veiculo ENUM('moto','caminhão','carro','ônibus') NOT NULL,
    modelo_veiculo VARCHAR(20) NOT NULL,
    CONSTRAINT unique_placa_veiculo UNIQUE (placa)
);

CREATE TABLE equipe(
    id_equipe INT AUTO_INCREMENT PRIMARY KEY,
    id_funcionario INT NOT NULL,
    CONSTRAINT fk_equipe_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)

);

CREATE TABLE avaliacao(
    id_avaliacao INT AUTO_INCREMENT PRIMARY KEY,
    id_veiculo INT NOT NULL,
    id_cliente INT NOT NULL,
    id_equipe INT NOT NULL,
    valor_estimado DECIMAL(10,2) NOT NULL,
    status_avaliacao VARCHAR(20),
    CONSTRAINT fk_avaliacao_veiculo FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),
    CONSTRAINT fk_avaliacao_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_avaliacao_equipe FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe)
);

CREATE TABLE ordem_servico(
    id_ordem_servico INT AUTO_INCREMENT PRIMARY KEY,
    id_avaliacao INT NOT NULL,
    tipo_servico VARCHAR(20),
    data_emissao DATETIME,
    data_conclusao DATETIME,
    mao_de_obra DECIMAL(10,2) NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_ordem_servico_avaliacao FOREIGN KEY (id_avaliacao) REFERENCES avaliacao(id_avaliacao)
);

CREATE TABLE servico_ordem_servico (
    id_servico INT NOT NULL,
    id_ordem_servico INT NOT NULL,
    quantidade INT DEFAULT 1,
    valor_total DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_ordem_servico_servico FOREIGN KEY (id_servico) REFERENCES servico(id_servico),
    CONSTRAINT fk_ordem_servico_ordem_servico FOREIGN KEY (id_ordem_servico) REFERENCES ordem_servico(id_ordem_servico)
);

CREATE TABLE ordem_servico_pecas(
    id_peca INT NOT NULL,
    id_ordem_servico INT NOT NULL,
    quantidade INT NOT NULL,
    CONSTRAINT fk_ordem_servico_peca_peca FOREIGN KEY (id_peca) REFERENCES peca(id_peca),
    CONSTRAINT fk_ordem_servico_peca_ordem_servico FOREIGN KEY (id_ordem_servico) REFERENCES ordem_servico(id_ordem_servico)
);