/*
 /  PENDIENTE:
 /      - Tabla o atributo que indique si el usuario esta o no al dia en sus pagos de peaje
 /
 /  REFERENCIAS:
 /      - http://www.proviasnac.gob.pe/frmOperaciones.aspx?idmenu=865
 /      - http://www.proviasnac.gob.pe/frmOperaciones.aspx?idmenu=867
 */

drop database if exists db_ae1_pf;
create database db_ae1_pf;

use db_ae1_pf;


drop table if exists tb_usuario;
create table tb_usuario
(
    id_usuario      int             not null    primary key auto_increment,
    nombres         varchar(100)    not null,
    apellido_pat    varchar(100)    not null,
    apellido_mat    varchar(100)    not null,
    genero          char(1)         not null,
    email           varchar(200)    not null,
    fecha_registro  datetime        not null
);


drop table if exists tb_vehiculo;
create table tb_vehiculo
(
    id_vehiculo     int         not null    primary key auto_increment,
    id_usuario      int         not null,
    placa           varchar(10) not null,
    categoria       char(1)     not null,   # (L)igero o (P)esado
    ejes            tinyint     null,       # Nro de ejes. Puede ser NULL en caso sea categoria ligera
    fecha_registro  datetime    not null
);
alter table tb_vehiculo
    add constraint foreign key (id_usuario) references tb_usuario(id_usuario);


drop table if exists tb_area_peaje;
create table tb_area_peaje
(
    id_area_peaje   int             not null    primary key auto_increment,
    nombre          varchar(100)    not null,
    fecha_registro  datetime        not null
);


drop table if exists tb_unidad_peaje;
create table tb_unidad_peaje
(
    id_unidad_peaje int             not null    primary key auto_increment,
    id_area_peaje   int             not null,
    nombre          varchar(100)    not null,
    ubicacion       varchar(200)    not null,
    provincia       varchar(100)    not null,
    departamento    varchar(100)    not null,
    precio_ligero   decimal(5,2)    not null,
    precio_x_eje    decimal(5,2)    not null,
    tipo_peaje      tinyint         not null,   # (1) pago en un solo sentido. (2) pago en ambos sentidos
    fecha_registro  datetime        not null
);
alter table tb_unidad_peaje
    add constraint foreign key (id_area_peaje) references tb_area_peaje(id_area_peaje);


drop table if exists tb_registro_peajes;
create table tb_registro_peajes
(
    id_registro_peaje   int             not null    primary key auto_increment,
    id_vehiculo         int             not null,
    id_unidad_peaje     int             not null,
    tipo_trayecto       char(1)         not null,   # (I)da o (V)uelta. Se usa para no cobrar peaje cuando el pago es en un solo sentido
    monto               decimal(5,2)    not null,
    fecha_registro      datetime        not null
);
alter table tb_registro_peajes
    add constraint foreign key (id_vehiculo) references tb_vehiculo(id_vehiculo);
alter table tb_registro_peajes
    add constraint foreign key (id_unidad_peaje) references tb_unidad_peaje(id_unidad_peaje);
