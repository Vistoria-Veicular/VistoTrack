CREATE TABLE `Pessoas` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Nome` VARCHAR(255) NOT NULL,
    `CPF` VARCHAR(14) NOT NULL,  -- Alterado para VARCHAR, considerando o formato do CPF
    `CEP` VARCHAR(10) NOT NULL,  -- Alterado para VARCHAR para suportar formatos de CEP
    `Logradouro` VARCHAR(255) NOT NULL,
    `numero` INT NOT NULL,
    `complemento` VARCHAR(255) NULL,  -- Permite NULL, caso não haja complemento
    `Naturalidade` VARCHAR(255) NOT NULL,
    `Estado` VARCHAR(100) NOT NULL,
    `Cidade` VARCHAR(255) NOT NULL,
    `EMail` VARCHAR(255) NOT NULL,
    `RG` VARCHAR(20) NOT NULL,  -- Alterado para VARCHAR, considerando o formato do RG
    `mae` VARCHAR(255) NULL,  -- Permite NULL caso não tenha nome da mãe
    `Telefone` VARCHAR(15) NOT NULL,  -- Alterado para VARCHAR(15) para formato de telefone
    `Nascimento` DATE NOT NULL
);

CREATE TABLE `Usuarios` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `EMail` VARCHAR(255) NOT NULL,
    `Senha` VARCHAR(255) NOT NULL,
    `Hash` VARCHAR(255) NOT NULL,
    `Tipo_Usuario` INT NOT NULL,
    `Permissao` INT NOT NULL,
    `Ultimo_Login` DATETIME NOT NULL,
    `Final_Usuario` INT NOT NULL,
    `Id_Pessoa` UNSIGNED INT NOT NULL,
    CONSTRAINT `usuarios_id_pessoa_foreign` FOREIGN KEY (`Id_Pessoa`) REFERENCES `Pessoas`(`id`)
);

CREATE TABLE `Veiculos` (
    `Id_Veiculo` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Marca` VARCHAR(255) NOT NULL,
    `Modelo` VARCHAR(255) NOT NULL,
    `Ano_Fabricacao` INT NOT NULL,
    `placa` VARCHAR(20) NOT NULL,  -- Supondo que a placa tenha um formato específico
    `ultima_verificacao` DATETIME NOT NULL,
    `Status` INT NOT NULL,
    `Id_condutor` UNSIGNED INT NOT NULL,
    CONSTRAINT `veiculos_id_condutor_foreign` FOREIGN KEY (`Id_condutor`) REFERENCES `Pessoas`(`id`)
);

CREATE TABLE `Verificacao` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Id_Patio` UNSIGNED INT NOT NULL,
    `Id_Veiculo` UNSIGNED INT NOT NULL,
    `Id_Inspetor` UNSIGNED INT NOT NULL,
    `Id_Condutor` UNSIGNED INT NOT NULL,
    `Arquivo_relatorio` VARCHAR(255) NOT NULL,
    `Status` INT NOT NULL,
    `Resultado` INT NOT NULL,
    CONSTRAINT `verificacao_id_veiculo_foreign` FOREIGN KEY (`Id_Veiculo`) REFERENCES `Veiculos`(`Id_Veiculo`),
    CONSTRAINT `verificacao_id_inspetor_foreign` FOREIGN KEY (`Id_Inspetor`) REFERENCES `Pessoas`(`id`),
    CONSTRAINT `verificacao_id_condutor_foreign` FOREIGN KEY (`Id_Condutor`) REFERENCES `Pessoas`(`id`),
    CONSTRAINT `verificacao_id_patio_foreign` FOREIGN KEY (`Id_Patio`) REFERENCES `Patio`(`id`)
);

CREATE TABLE `Patio` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Pais` VARCHAR(255) NOT NULL,
    `Estado` VARCHAR(255) NOT NULL,
    `Cidade` VARCHAR(255) NOT NULL,
    `CEP` VARCHAR(10) NOT NULL,  -- Alterado para VARCHAR para formatos de CEP
    `Logradouro` VARCHAR(255) NOT NULL,
    `Numero` INT NOT NULL,
    `Complemento` VARCHAR(255) NULL,  -- Permite NULL para o complemento
    `Id_Responsavel` UNSIGNED INT NOT NULL,
    `Arquivo_FTP` VARCHAR(255) NOT NULL,
    `Arquivo_Server` VARCHAR(255) NOT NULL,
    CONSTRAINT `patio_id_responsavel_foreign` FOREIGN KEY (`Id_Responsavel`) REFERENCES `Pessoas`(`id`)
);

CREATE TABLE `Calendario` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Id_Usuario` INT NOT NULL,
    `Id_Patio` INT NOT NULL,
    `Tipo_Agendamento` INT NOT NULL,
    `Id_Veiculo` UNSIGNED INT NOT NULL,
    `Data` DATE NOT NULL,
    `Hora` TIME NOT NULL,
    `Status` INT NOT NULL,
    CONSTRAINT `calendario_id_veiculo_foreign` FOREIGN KEY (`Id_Veiculo`) REFERENCES `Veiculos`(`Id_Veiculo`),
    CONSTRAINT `calendario_id_usuario_foreign` FOREIGN KEY (`Id_Usuario`) REFERENCES `Pessoas`(`id`),
    CONSTRAINT `calendario_id_patio_foreign` FOREIGN KEY (`Id_Patio`) REFERENCES `Patio`(`id`)
);

-- Índices adicionais para campos que serão frequentemente consultados
CREATE INDEX idx_cpf ON Pessoas(CPF);
CREATE INDEX idx_rg ON Pessoas(RG);
CREATE INDEX idx_email ON Pessoas(EMail);
CREATE INDEX idx_placa ON Veiculos(placa);
