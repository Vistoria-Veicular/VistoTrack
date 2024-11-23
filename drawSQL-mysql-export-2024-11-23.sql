CREATE TABLE `Pessoas`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Nome` TEXT NULL,
    `CPF` BIGINT NULL,
    `CEP` BIGINT NULL,
    `Logradouro` VARCHAR(255) NULL,
    `numero` BIGINT NULL,
    `complemento` VARCHAR(255) NULL,
    `Naturalidade` TEXT NULL,
    `Estado` TEXT NULL,
    `Cidade` TEXT NULL,
    `EMail` VARCHAR(255) NULL,
    `RG` BIGINT NULL,
    `mae` TEXT NOT NULL,
    `Telefone` VARCHAR(255) NULL,
    `Nascimento` DATE NULL
);
CREATE TABLE `Usuarios`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `EMail` VARCHAR(255) NULL,
    `Senha` VARCHAR(255) NULL,
    `Hash` VARCHAR(255) NULL,
    `Tipo_Usuario` BIGINT NULL,
    `Permissao` BIGINT NULL,
    `Ultimo_Login` DATETIME NULL,
    `Final_Usuario` INT NULL,
    `Id_Pessoa` INT NULL
);
CREATE TABLE `Veiculos`(
    `Id_Veiculo` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Marca` TEXT NULL,
    `Modelo` TEXT NULL,
    `Ano_Fabricacao` INT NULL,
    `placa` VARCHAR(255) NULL,
    `ultima_verificacao` DATETIME NULL,
    `Status` INT NULL,
    `Id_condutor` INT NULL
);
CREATE TABLE `Verificacao`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Id_Patio` BIGINT NULL,
    `Id_Veiculo` BIGINT NULL,
    `Id_Inspetor` BIGINT NULL,
    `Id_Condutor` BIGINT NULL,
    `Arquivo_relatorio` VARCHAR(255) NULL,
    `Status` INT NULL,
    `Resultado` INT NULL
);
CREATE TABLE `Patio`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Pais` TEXT NULL,
    `Estado` TEXT NULL,
    `Cidade` TEXT NULL,
    `CEP` INT NULL,
    `Logradouro` VARCHAR(255) NULL,
    `Numero` INT NULL,
    `Complemento` VARCHAR(255) NULL,
    `Id_Responsavel` INT NULL,
    `Arquivo_FTP` VARCHAR(255) NULL,
    `Arquivo_Server` VARCHAR(255) NULL
);
CREATE TABLE `Calendario`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Id_Usuario` INT NULL,
    `Id_Patio` INT NULL,
    `Tipo_Agendamento` INT NULL,
    `Id_Veiculo` INT NULL,
    `Data` DATE NULL,
    `Hora` TIME NULL,
    `Status` INT NULL
);
ALTER TABLE
    `Calendario` ADD CONSTRAINT `calendario_id_veiculo_foreign` FOREIGN KEY(`Id_Veiculo`) REFERENCES `Veiculos`(`Id_Veiculo`);
ALTER TABLE
    `Verificacao` ADD CONSTRAINT `verificacao_id_veiculo_foreign` FOREIGN KEY(`Id_Veiculo`) REFERENCES `Veiculos`(`Id_Veiculo`);
ALTER TABLE
    `Patio` ADD CONSTRAINT `patio_id_responsavel_foreign` FOREIGN KEY(`Id_Responsavel`) REFERENCES `Pessoas`(`id`);
ALTER TABLE
    `Usuarios` ADD CONSTRAINT `usuarios_id_pessoa_foreign` FOREIGN KEY(`Id_Pessoa`) REFERENCES `Pessoas`(`id`);
ALTER TABLE
    `Verificacao` ADD CONSTRAINT `verificacao_id_inspetor_foreign` FOREIGN KEY(`Id_Inspetor`) REFERENCES `Pessoas`(`id`);
ALTER TABLE
    `Verificacao` ADD CONSTRAINT `verificacao_id_condutor_foreign` FOREIGN KEY(`Id_Condutor`) REFERENCES `Pessoas`(`id`);
ALTER TABLE
    `Calendario` ADD CONSTRAINT `calendario_id_usuario_foreign` FOREIGN KEY(`Id_Usuario`) REFERENCES `Pessoas`(`id`);
ALTER TABLE
    `Verificacao` ADD CONSTRAINT `verificacao_id_patio_foreign` FOREIGN KEY(`Id_Patio`) REFERENCES `Patio`(`id`);
ALTER TABLE
    `Veiculos` ADD CONSTRAINT `veiculos_id_condutor_foreign` FOREIGN KEY(`Id_condutor`) REFERENCES `Pessoas`(`id`);
ALTER TABLE
    `Calendario` ADD CONSTRAINT `calendario_id_patio_foreign` FOREIGN KEY(`Id_Patio`) REFERENCES `Patio`(`id`);