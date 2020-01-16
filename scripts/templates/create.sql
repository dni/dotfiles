create database %name% default character set utf8 default collate utf8_general_ci;
create user %name% identified by "%pw%";
grant all privileges on %name% . * to %name%;
