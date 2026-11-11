DROP DATABASE IF EXISTS helpdesk_db;
CREATE DATABASE helpdesk_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE helpdesk_db;

SET NAMES utf8mb4;

-- -----------------------------------------------------
-- Tabela: usuarios
-- -----------------------------------------------------
CREATE TABLE usuarios (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome        VARCHAR(100) NOT NULL,
  email       VARCHAR(150) NOT NULL UNIQUE,
  senha_hash  VARCHAR(255) NOT NULL,
  perfil      ENUM('Solicitante', 'Tecnico') NOT NULL
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabela: categorias
-- -----------------------------------------------------
CREATE TABLE categorias (
  id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome  VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabela: chamados
-- tecnico_id fica NULL até um técnico assumir o chamado
-- -----------------------------------------------------
CREATE TABLE chamados (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  assunto         VARCHAR(150) NOT NULL,
  descricao       TEXT NOT NULL,
  categoria_id    INT UNSIGNED NOT NULL,
  prioridade      ENUM('Baixa', 'Media', 'Alta') NOT NULL,
  solicitante_id  INT UNSIGNED NOT NULL,
  tecnico_id      INT UNSIGNED NULL,
  data_abertura   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status          ENUM('Aberto', 'Em atendimento', 'Finalizado') NOT NULL DEFAULT 'Aberto',
  CONSTRAINT fk_chamados_categoria   FOREIGN KEY (categoria_id)   REFERENCES categorias (id) ON DELETE RESTRICT,
  CONSTRAINT fk_chamados_solicitante FOREIGN KEY (solicitante_id) REFERENCES usuarios (id)   ON DELETE RESTRICT,
  CONSTRAINT fk_chamados_tecnico     FOREIGN KEY (tecnico_id)     REFERENCES usuarios (id)   ON DELETE RESTRICT
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabela: historico_atendimentos
-- Cada atualização do técnico gera uma nova linha (nunca sobrescrever)
-- solucao só é obrigatória ao finalizar (regra validada na API)
-- -----------------------------------------------------
CREATE TABLE historico_atendimentos (
  id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  chamado_id        INT UNSIGNED NOT NULL,
  tecnico_id        INT UNSIGNED NOT NULL,
  data_hora         DATETIME NOT NULL,
  observacao        TEXT NOT NULL,
  solucao           TEXT NULL,
  status_resultante ENUM('Aberto', 'Em atendimento', 'Finalizado') NOT NULL,
  CONSTRAINT fk_historico_chamado FOREIGN KEY (chamado_id) REFERENCES chamados (id) ON DELETE RESTRICT,
  CONSTRAINT fk_historico_tecnico FOREIGN KEY (tecnico_id) REFERENCES usuarios (id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =====================================================
-- POPULAÇÃO
-- Senha de TODOS os usuários de teste: Senha@123
-- (armazenada como hash bcrypt, nunca em texto puro)
-- =====================================================

INSERT INTO usuarios (nome, email, senha_hash, perfil) VALUES
('Ana Souza',    'ana@empresa.com',   '$2b$10$C1OURqnP6GRh2PArDi8v5O5ZVn0deAAhX5l3ZD/OlCGsB8FSWuV/O', 'Solicitante'),
('Bruno Lima',   'bruno@empresa.com', '$2b$10$GUmRgRUQeofz3krgMixwsOCeATWErJlo2JijLB7HSW1Jd0fU9W.HW', 'Solicitante'),
('Carla Mendes', 'carla@empresa.com', '$2b$10$kTs4N0XAc41VXmU40zcHgudkAW8m1N4Niego.Vb9v4T9A3TKg36d2', 'Tecnico'),
('Diego Rocha',  'diego@empresa.com', '$2b$10$txhCNzHganTmkXrEY/ItUeIFn.WnpzolMvtkC/3MANOhgyyIVL4J.', 'Tecnico');

INSERT INTO categorias (nome) VALUES
('Hardware'),
('Software'),
('Rede');

-- Chamados em estados variados para testar todo o fluxo
INSERT INTO chamados (assunto, descricao, categoria_id, prioridade, solicitante_id, tecnico_id, data_abertura, status) VALUES
('Computador não liga',          'O computador da recepção não liga desde ontem. A luz da fonte acende, mas a tela fica preta.', 1, 'Alta',  1, NULL, '2026-11-03 09:15:00', 'Aberto'),
('Sem acesso à internet',        'O Wi-Fi do setor financeiro conecta, mas não carrega nenhuma página.',                          3, 'Media', 2, NULL, '2026-11-04 14:30:00', 'Aberto'),
('Instalar pacote Office',       'Preciso do Word e do Excel instalados no notebook novo.',                                       2, 'Media', 1, 3,    '2026-11-02 10:00:00', 'Em atendimento'),
('Teclado com teclas travando',  'Várias teclas do teclado da minha estação não respondem.',                                      1, 'Baixa', 2, 4,    '2026-10-28 08:45:00', 'Finalizado'),
('Sistema do ERP travando',      'O ERP fecha sozinho ao emitir relatórios.',                                                     2, 'Alta',  2, 4,    '2026-11-05 15:00:00', 'Em atendimento');

INSERT INTO historico_atendimentos (chamado_id, tecnico_id, data_hora, observacao, solucao, status_resultante) VALUES
(3, 3, '2026-11-02 10:30:00', 'Chamado assumido pelo técnico.',                         NULL, 'Em atendimento'),
(4, 4, '2026-10-28 09:00:00', 'Chamado assumido pelo técnico.',                         NULL, 'Em atendimento'),
(4, 4, '2026-10-28 11:20:00', 'Teclado substituído e testado com o usuário.',           'Troca do teclado defeituoso por um novo.', 'Finalizado'),
(5, 4, '2026-11-05 15:10:00', 'Chamado assumido pelo técnico.',                         NULL, 'Em atendimento');
