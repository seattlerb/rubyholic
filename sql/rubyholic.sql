
DROP TABLE urls CASCADE;
DROP TABLE groups CASCADE;
DROP TABLE locations CASCADE;
DROP TABLE contacts CASCADE;
DROP TABLE events CASCADE;
DROP TABLE subjects CASCADE;
DROP SEQUENCE urls_id_seq;
DROP SEQUENCE groups_id_seq;
DROP SEQUENCE locations_id_seq;
DROP SEQUENCE contacts_id_seq;
DROP SEQUENCE events_id_seq;
DROP SEQUENCE subjects_id_seq;

CREATE SEQUENCE urls_id_seq;
CREATE SEQUENCE groups_id_seq;
CREATE SEQUENCE locations_id_seq;
CREATE SEQUENCE contacts_id_seq;
CREATE SEQUENCE events_id_seq;
CREATE SEQUENCE subjects_id_seq;

CREATE TABLE groups (
    id integer NOT NULL PRIMARY KEY DEFAULT nextval('groups_id_seq'::text),
    name varchar(100),
    city varchar(100)
);

CREATE TABLE urls (
    id integer NOT NULL PRIMARY KEY DEFAULT nextval('urls_id_seq'::text),
    label varchar(10),
    url varchar(255),
    group_id INTEGER NOT NULL references "groups" ("id")
);

CREATE TABLE locations (
    id integer NOT NULL PRIMARY KEY DEFAULT nextval('locations_id_seq'::text),
    name varchar(255),
    group_id INTEGER NOT NULL references "groups" ("id")
);

CREATE TABLE contacts (
    id integer NOT NULL PRIMARY KEY DEFAULT nextval('contacts_id_seq'::text),
    name varchar(50),
    email varchar(50),
    group_id INTEGER NOT NULL references "groups" ("id")
);

CREATE TABLE events (
    id integer NOT NULL PRIMARY KEY DEFAULT nextval('events_id_seq'::text),
    start timestamp,
    summary varchar(255),
    location_id INTEGER NOT NULL references "locations" ("id"),
    group_id INTEGER NOT NULL references "groups" ("id")
);

CREATE TABLE subjects (
    id integer NOT NULL PRIMARY KEY DEFAULT nextval('subjects_id_seq'::text),
    description varchar(255),
    event_id INTEGER NOT NULL references "events" ("id")
);

