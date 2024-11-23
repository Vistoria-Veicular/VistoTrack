CREATE TABLE `Pessoas`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Nome` TEXT NOT NULL,
    `CPF` INT NOT NULL,
    `CEP` INT NOT NULL,
    `Logradouro` VARCHAR(255) NOT NULL,
    `numero` INT NOT NULL,
    `complemento` VARCHAR(255) NOT NULL,
    `Naturalidade` TEXT NOT NULL,
    `Estado` TEXT NOT NULL,
    `Cidade` TEXT NOT NULL,
    `EMail` VARCHAR(255) NOT NULL,
    `RG` INT NOT NULL,
    `mae` TEXT NULL,
    `Telefone` VARCHAR(255) NOT NULL,
    `Nascimento` DATE NOT NULL
);
CREATE TABLE `Usuarios`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `EMail` VARCHAR(255) NOT NULL,
    `Senha` VARCHAR(255) NOT NULL,
    `Hash` VARCHAR(255) NOT NULL,
    `Tipo_Usuario` INT NOT NULL,
    `Permissao` INT NOT NULL,
    `Ultimo_Login` DATETIME NOT NULL,
    `Final_Usuario` INT NOT NULL,
    `Id_Pessoa` INT NOT NULL
);
CREATE TABLE `Veiculos`(
    `Id_Veiculo` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Marca` TEXT NOT NULL,
    `Modelo` TEXT NOT NULL,
    `Ano_Fabricacao` INT NOT NULL,
    `placa` VARCHAR(255) NOT NULL,
    `ultima_verificacao` DATETIME NOT NULL,
    `Status` INT NOT NULL,
    `Id_condutor` INT NOT NULL
);
CREATE TABLE `Verificacao`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Id_Patio` INT NOT NULL,
    `Id_Veiculo` INT NOT NULL,
    `Id_Inspetor` INT NOT NULL,
    `Id_Condutor` INT NOT NULL,
    `Arquivo_relatorio` VARCHAR(255) NOT NULL,
    `Status` INT NOT NULL,
    `Resultado` INT NOT NULL
);
CREATE TABLE `Patio`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Pais` TEXT NOT NULL,
    `Estado` TEXT NOT NULL,
    `Cidade` TEXT NOT NULL,
    `CEP` INT NOT NULL,
    `Logradouro` VARCHAR(255) NOT NULL,
    `Numero` INT NOT NULL,
    `Complemento` VARCHAR(255) NOT NULL,
    `Id_Responsavel` INT NOT NULL,
    `Arquivo_FTP` VARCHAR(255) NOT NULL,
    `Arquivo_Server` VARCHAR(255) NOT NULL
);
CREATE TABLE `Calendario`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Id_Usuario` INT NOT NULL,
    `Id_Patio` INT NOT NULL,
    `Tipo_Agendamento` INT NOT NULL,
    `Id_Veiculo` INT NOT NULL,
    `Data` DATE NOT NULL,
    `Hora` TIME NOT NULL,
    `Status` INT NOT NULL
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