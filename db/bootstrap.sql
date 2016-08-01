--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;


--
-- Clean Schema before import
--

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: rand(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rand() RETURNS double precision
    LANGUAGE sql
    AS $$SELECT random();$$;


--
-- Name: substring_index(text, text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION substring_index(text, text, integer) RETURNS text
    LANGUAGE sql
    AS $_$SELECT array_to_string((string_to_array($1, $2)) [1:$3], $2);$_$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: batch; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE batch (
    bid bigint NOT NULL,
    token character varying(64) NOT NULL,
    "timestamp" integer NOT NULL,
    batch bytea,
    CONSTRAINT batch_bid_check CHECK ((bid >= 0))
);


--
-- Name: TABLE batch; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE batch IS 'Stores details about batches (processes that run in multiple HTTP requests).';


--
-- Name: COLUMN batch.bid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN batch.bid IS 'Primary Key: Unique batch ID.';


--
-- Name: COLUMN batch.token; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN batch.token IS 'A string token generated against the current user''s session id and the batch id, used to ensure that only the user who submitted the batch can effectively access it.';


--
-- Name: COLUMN batch."timestamp"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN batch."timestamp" IS 'A Unix timestamp indicating when this batch was submitted for processing. Stale batches are purged at cron time.';


--
-- Name: COLUMN batch.batch; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN batch.batch IS 'A serialized array containing the processing data for the batch.';


--
-- Name: cache_bootstrap; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cache_bootstrap (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire integer DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


--
-- Name: TABLE cache_bootstrap; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE cache_bootstrap IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_bootstrap.cid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_bootstrap.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_bootstrap.data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_bootstrap.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_bootstrap.expire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_bootstrap.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_bootstrap.created; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_bootstrap.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_bootstrap.serialized; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_bootstrap.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_bootstrap.tags; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_bootstrap.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_bootstrap.checksum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_bootstrap.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cache_config (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire integer DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


--
-- Name: TABLE cache_config; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE cache_config IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_config.cid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_config.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_config.data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_config.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_config.expire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_config.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_config.created; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_config.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_config.serialized; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_config.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_config.tags; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_config.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_config.checksum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_config.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_container; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cache_container (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire integer DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


--
-- Name: TABLE cache_container; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE cache_container IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_container.cid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_container.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_container.data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_container.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_container.expire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_container.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_container.created; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_container.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_container.serialized; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_container.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_container.tags; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_container.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_container.checksum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_container.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cache_data (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire integer DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


--
-- Name: TABLE cache_data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE cache_data IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_data.cid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_data.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_data.data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_data.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_data.expire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_data.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_data.created; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_data.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_data.serialized; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_data.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_data.tags; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_data.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_data.checksum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_data.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_default; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cache_default (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire integer DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


--
-- Name: TABLE cache_default; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE cache_default IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_default.cid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_default.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_default.data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_default.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_default.expire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_default.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_default.created; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_default.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_default.serialized; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_default.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_default.tags; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_default.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_default.checksum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_default.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_discovery; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cache_discovery (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire integer DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


--
-- Name: TABLE cache_discovery; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE cache_discovery IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_discovery.cid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_discovery.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_discovery.data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_discovery.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_discovery.expire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_discovery.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_discovery.created; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_discovery.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_discovery.serialized; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_discovery.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_discovery.tags; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_discovery.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_discovery.checksum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_discovery.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_dynamic_page_cache; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cache_dynamic_page_cache (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire integer DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


--
-- Name: TABLE cache_dynamic_page_cache; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE cache_dynamic_page_cache IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_dynamic_page_cache.cid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_dynamic_page_cache.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_dynamic_page_cache.data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_dynamic_page_cache.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_dynamic_page_cache.expire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_dynamic_page_cache.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_dynamic_page_cache.created; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_dynamic_page_cache.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_dynamic_page_cache.serialized; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_dynamic_page_cache.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_dynamic_page_cache.tags; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_dynamic_page_cache.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_dynamic_page_cache.checksum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_dynamic_page_cache.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_entity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cache_entity (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire integer DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


--
-- Name: TABLE cache_entity; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE cache_entity IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_entity.cid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_entity.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_entity.data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_entity.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_entity.expire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_entity.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_entity.created; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_entity.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_entity.serialized; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_entity.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_entity.tags; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_entity.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_entity.checksum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_entity.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_menu; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cache_menu (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire integer DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


--
-- Name: TABLE cache_menu; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE cache_menu IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_menu.cid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_menu.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_menu.data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_menu.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_menu.expire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_menu.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_menu.created; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_menu.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_menu.serialized; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_menu.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_menu.tags; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_menu.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_menu.checksum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_menu.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_render; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cache_render (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire integer DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


--
-- Name: TABLE cache_render; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE cache_render IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_render.cid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_render.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_render.data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_render.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_render.expire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_render.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_render.created; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_render.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_render.serialized; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_render.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_render.tags; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_render.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_render.checksum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cache_render.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cachetags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cachetags (
    tag character varying(255) DEFAULT ''::character varying NOT NULL,
    invalidations integer DEFAULT 0 NOT NULL
);


--
-- Name: TABLE cachetags; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE cachetags IS 'Cache table for tracking cache tag invalidations.';


--
-- Name: COLUMN cachetags.tag; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cachetags.tag IS 'Namespace-prefixed tag string.';


--
-- Name: COLUMN cachetags.invalidations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cachetags.invalidations IS 'Number incremented when the tag is invalidated.';


--
-- Name: config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE config (
    collection character varying(255) DEFAULT ''::character varying NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea
);


--
-- Name: TABLE config; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE config IS 'The base table for configuration data.';


--
-- Name: COLUMN config.collection; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN config.collection IS 'Primary Key: Config object collection.';


--
-- Name: COLUMN config.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN config.name IS 'Primary Key: Config object name.';


--
-- Name: COLUMN config.data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN config.data IS 'A serialized configuration object data.';


--
-- Name: file_managed; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE file_managed (
    fid integer NOT NULL,
    uuid character varying(128) NOT NULL,
    langcode character varying(12) NOT NULL,
    uid bigint,
    filename character varying(255),
    uri character varying(255) NOT NULL,
    filemime character varying(255),
    filesize bigint,
    status smallint NOT NULL,
    created integer,
    changed integer NOT NULL,
    CONSTRAINT file_managed_fid_check CHECK ((fid >= 0)),
    CONSTRAINT file_managed_filesize_check CHECK ((filesize >= 0)),
    CONSTRAINT file_managed_uid_check CHECK ((uid >= 0))
);


--
-- Name: TABLE file_managed; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE file_managed IS 'The base table for file entities.';


--
-- Name: COLUMN file_managed.uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN file_managed.uid IS 'The ID of the target entity.';


--
-- Name: file_managed_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE file_managed_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: file_managed_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE file_managed_fid_seq OWNED BY file_managed.fid;


--
-- Name: file_usage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE file_usage (
    fid bigint NOT NULL,
    module character varying(50) DEFAULT ''::character varying NOT NULL,
    type character varying(64) DEFAULT ''::character varying NOT NULL,
    id character varying(64) DEFAULT 0 NOT NULL,
    count bigint DEFAULT 0 NOT NULL,
    CONSTRAINT file_usage_count_check CHECK ((count >= 0)),
    CONSTRAINT file_usage_fid_check CHECK ((fid >= 0))
);


--
-- Name: TABLE file_usage; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE file_usage IS 'Track where a file is used.';


--
-- Name: COLUMN file_usage.fid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN file_usage.fid IS 'File ID.';


--
-- Name: COLUMN file_usage.module; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN file_usage.module IS 'The name of the module that is using the file.';


--
-- Name: COLUMN file_usage.type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN file_usage.type IS 'The name of the object type in which the file is used.';


--
-- Name: COLUMN file_usage.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN file_usage.id IS 'The primary key of the object using the file.';


--
-- Name: COLUMN file_usage.count; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN file_usage.count IS 'The number of times this file is used by this object.';


--
-- Name: key_value; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE key_value (
    collection character varying(128) DEFAULT ''::character varying NOT NULL,
    name character varying(128) DEFAULT ''::character varying NOT NULL,
    value bytea NOT NULL
);


--
-- Name: TABLE key_value; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE key_value IS 'Generic key-value storage table. See the state system for an example.';


--
-- Name: COLUMN key_value.collection; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN key_value.collection IS 'A named collection of key and value pairs.';


--
-- Name: COLUMN key_value.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN key_value.name IS 'The key of the key-value pair. As KEY is a SQL reserved keyword, name was chosen instead.';


--
-- Name: COLUMN key_value.value; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN key_value.value IS 'The value.';


--
-- Name: key_value_expire; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE key_value_expire (
    collection character varying(128) DEFAULT ''::character varying NOT NULL,
    name character varying(128) DEFAULT ''::character varying NOT NULL,
    value bytea NOT NULL,
    expire integer DEFAULT 2147483647 NOT NULL
);


--
-- Name: TABLE key_value_expire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE key_value_expire IS 'Generic key/value storage table with an expiration.';


--
-- Name: COLUMN key_value_expire.collection; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN key_value_expire.collection IS 'A named collection of key and value pairs.';


--
-- Name: COLUMN key_value_expire.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN key_value_expire.name IS 'The key of the key/value pair.';


--
-- Name: COLUMN key_value_expire.value; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN key_value_expire.value IS 'The value of the key/value pair.';


--
-- Name: COLUMN key_value_expire.expire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN key_value_expire.expire IS 'The time since Unix epoch in seconds when this item expires. Defaults to the maximum possible time.';


--
-- Name: menu_tree; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE menu_tree (
    menu_name character varying(32) DEFAULT ''::character varying NOT NULL,
    mlid integer NOT NULL,
    id character varying(255) NOT NULL,
    parent character varying(255) DEFAULT ''::character varying NOT NULL,
    route_name character varying(255),
    route_param_key character varying(255),
    route_parameters bytea,
    url character varying(255) DEFAULT ''::character varying NOT NULL,
    title bytea,
    description bytea,
    class text,
    options bytea,
    provider character varying(50) DEFAULT 'system'::character varying NOT NULL,
    enabled smallint DEFAULT 1 NOT NULL,
    discovered smallint DEFAULT 0 NOT NULL,
    expanded smallint DEFAULT 0 NOT NULL,
    weight integer DEFAULT 0 NOT NULL,
    metadata bytea,
    has_children smallint DEFAULT 0 NOT NULL,
    depth smallint DEFAULT 0 NOT NULL,
    p1 bigint DEFAULT 0 NOT NULL,
    p2 bigint DEFAULT 0 NOT NULL,
    p3 bigint DEFAULT 0 NOT NULL,
    p4 bigint DEFAULT 0 NOT NULL,
    p5 bigint DEFAULT 0 NOT NULL,
    p6 bigint DEFAULT 0 NOT NULL,
    p7 bigint DEFAULT 0 NOT NULL,
    p8 bigint DEFAULT 0 NOT NULL,
    p9 bigint DEFAULT 0 NOT NULL,
    form_class character varying(255),
    CONSTRAINT menu_tree_mlid_check CHECK ((mlid >= 0)),
    CONSTRAINT menu_tree_p1_check CHECK ((p1 >= 0)),
    CONSTRAINT menu_tree_p2_check CHECK ((p2 >= 0)),
    CONSTRAINT menu_tree_p3_check CHECK ((p3 >= 0)),
    CONSTRAINT menu_tree_p4_check CHECK ((p4 >= 0)),
    CONSTRAINT menu_tree_p5_check CHECK ((p5 >= 0)),
    CONSTRAINT menu_tree_p6_check CHECK ((p6 >= 0)),
    CONSTRAINT menu_tree_p7_check CHECK ((p7 >= 0)),
    CONSTRAINT menu_tree_p8_check CHECK ((p8 >= 0)),
    CONSTRAINT menu_tree_p9_check CHECK ((p9 >= 0))
);


--
-- Name: TABLE menu_tree; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE menu_tree IS 'Contains the menu tree hierarchy.';


--
-- Name: COLUMN menu_tree.menu_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.menu_name IS 'The menu name. All links with the same menu name (such as ''tools'') are part of the same menu.';


--
-- Name: COLUMN menu_tree.mlid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.mlid IS 'The menu link ID (mlid) is the integer primary key.';


--
-- Name: COLUMN menu_tree.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.id IS 'Unique machine name: the plugin ID.';


--
-- Name: COLUMN menu_tree.parent; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.parent IS 'The plugin ID for the parent of this link.';


--
-- Name: COLUMN menu_tree.route_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.route_name IS 'The machine name of a defined Symfony Route this menu item represents.';


--
-- Name: COLUMN menu_tree.route_param_key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.route_param_key IS 'An encoded string of route parameters for loading by route.';


--
-- Name: COLUMN menu_tree.route_parameters; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.route_parameters IS 'Serialized array of route parameters of this menu link.';


--
-- Name: COLUMN menu_tree.url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.url IS 'The external path this link points to (when not using a route).';


--
-- Name: COLUMN menu_tree.title; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.title IS 'The serialized title for the link. May be a TranslatableMarkup.';


--
-- Name: COLUMN menu_tree.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.description IS 'The serialized description of this link - used for admin pages and title attribute. May be a TranslatableMarkup.';


--
-- Name: COLUMN menu_tree.class; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.class IS 'The class for this link plugin.';


--
-- Name: COLUMN menu_tree.options; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.options IS 'A serialized array of URL options, such as a query string or HTML attributes.';


--
-- Name: COLUMN menu_tree.provider; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.provider IS 'The name of the module that generated this link.';


--
-- Name: COLUMN menu_tree.enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.enabled IS 'A flag for whether the link should be rendered in menus. (0 = a disabled menu item that may be shown on admin screens, 1 = a normal, visible link)';


--
-- Name: COLUMN menu_tree.discovered; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.discovered IS 'A flag for whether the link was discovered, so can be purged on rebuild';


--
-- Name: COLUMN menu_tree.expanded; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.expanded IS 'Flag for whether this link should be rendered as expanded in menus - expanded links always have their child links displayed, instead of only when the link is in the active trail (1 = expanded, 0 = not expanded)';


--
-- Name: COLUMN menu_tree.weight; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.weight IS 'Link weight among links in the same menu at the same depth.';


--
-- Name: COLUMN menu_tree.metadata; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.metadata IS 'A serialized array of data that may be used by the plugin instance.';


--
-- Name: COLUMN menu_tree.has_children; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.has_children IS 'Flag indicating whether any enabled links have this link as a parent (1 = enabled children exist, 0 = no enabled children).';


--
-- Name: COLUMN menu_tree.depth; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.depth IS 'The depth relative to the top level. A link with empty parent will have depth == 1.';


--
-- Name: COLUMN menu_tree.p1; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.p1 IS 'The first mlid in the materialized path. If N = depth, then pN must equal the mlid. If depth > 1 then p(N-1) must equal the parent link mlid. All pX where X > depth must equal zero. The columns p1 .. p9 are also called the parents.';


--
-- Name: COLUMN menu_tree.p2; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.p2 IS 'The second mlid in the materialized path. See p1.';


--
-- Name: COLUMN menu_tree.p3; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.p3 IS 'The third mlid in the materialized path. See p1.';


--
-- Name: COLUMN menu_tree.p4; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.p4 IS 'The fourth mlid in the materialized path. See p1.';


--
-- Name: COLUMN menu_tree.p5; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.p5 IS 'The fifth mlid in the materialized path. See p1.';


--
-- Name: COLUMN menu_tree.p6; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.p6 IS 'The sixth mlid in the materialized path. See p1.';


--
-- Name: COLUMN menu_tree.p7; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.p7 IS 'The seventh mlid in the materialized path. See p1.';


--
-- Name: COLUMN menu_tree.p8; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.p8 IS 'The eighth mlid in the materialized path. See p1.';


--
-- Name: COLUMN menu_tree.p9; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.p9 IS 'The ninth mlid in the materialized path. See p1.';


--
-- Name: COLUMN menu_tree.form_class; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN menu_tree.form_class IS 'meh';


--
-- Name: menu_tree_mlid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE menu_tree_mlid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: menu_tree_mlid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE menu_tree_mlid_seq OWNED BY menu_tree.mlid;


--
-- Name: node; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE node (
    nid integer NOT NULL,
    vid bigint,
    type character varying(32) NOT NULL,
    uuid character varying(128) NOT NULL,
    langcode character varying(12) NOT NULL,
    CONSTRAINT node_nid_check CHECK ((nid >= 0)),
    CONSTRAINT node_vid_check CHECK ((vid >= 0))
);


--
-- Name: TABLE node; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE node IS 'The base table for node entities.';


--
-- Name: COLUMN node.type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node.type IS 'The ID of the target entity.';


--
-- Name: node__body; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE node__body (
    bundle character varying(128) DEFAULT ''::character varying NOT NULL,
    deleted smallint DEFAULT 0 NOT NULL,
    entity_id bigint NOT NULL,
    revision_id bigint NOT NULL,
    langcode character varying(32) DEFAULT ''::character varying NOT NULL,
    delta bigint NOT NULL,
    body_value text NOT NULL,
    body_summary text,
    body_format character varying(255),
    CONSTRAINT node__body_delta_check CHECK ((delta >= 0)),
    CONSTRAINT node__body_entity_id_check CHECK ((entity_id >= 0)),
    CONSTRAINT node__body_revision_id_check CHECK ((revision_id >= 0))
);


--
-- Name: TABLE node__body; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE node__body IS 'Data storage for node field body.';


--
-- Name: COLUMN node__body.bundle; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node__body.bundle IS 'The field instance bundle to which this row belongs, used when deleting a field instance';


--
-- Name: COLUMN node__body.deleted; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node__body.deleted IS 'A boolean indicating whether this data item has been deleted';


--
-- Name: COLUMN node__body.entity_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node__body.entity_id IS 'The entity id this data is attached to';


--
-- Name: COLUMN node__body.revision_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node__body.revision_id IS 'The entity revision id this data is attached to';


--
-- Name: COLUMN node__body.langcode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node__body.langcode IS 'The language code for this data item.';


--
-- Name: COLUMN node__body.delta; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node__body.delta IS 'The sequence number for this data item, used for multi-value fields';


--
-- Name: node_access; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE node_access (
    nid bigint DEFAULT 0 NOT NULL,
    langcode character varying(12) DEFAULT ''::character varying NOT NULL,
    fallback bigint DEFAULT 1 NOT NULL,
    gid bigint DEFAULT 0 NOT NULL,
    realm character varying(255) DEFAULT ''::character varying NOT NULL,
    grant_view integer DEFAULT 0 NOT NULL,
    grant_update integer DEFAULT 0 NOT NULL,
    grant_delete integer DEFAULT 0 NOT NULL,
    CONSTRAINT node_access_fallback_check CHECK ((fallback >= 0)),
    CONSTRAINT node_access_gid_check CHECK ((gid >= 0)),
    CONSTRAINT node_access_grant_delete_check CHECK ((grant_delete >= 0)),
    CONSTRAINT node_access_grant_update_check CHECK ((grant_update >= 0)),
    CONSTRAINT node_access_grant_view_check CHECK ((grant_view >= 0)),
    CONSTRAINT node_access_nid_check CHECK ((nid >= 0))
);


--
-- Name: TABLE node_access; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE node_access IS 'Identifies which realm/grant pairs a user must possess in order to view, update, or delete specific nodes.';


--
-- Name: COLUMN node_access.nid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_access.nid IS 'The node.nid this record affects.';


--
-- Name: COLUMN node_access.langcode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_access.langcode IS 'The language.langcode of this node.';


--
-- Name: COLUMN node_access.fallback; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_access.fallback IS 'Boolean indicating whether this record should be used as a fallback if a language condition is not provided.';


--
-- Name: COLUMN node_access.gid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_access.gid IS 'The grant ID a user must possess in the specified realm to gain this row''s privileges on the node.';


--
-- Name: COLUMN node_access.realm; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_access.realm IS 'The realm in which the user must possess the grant ID. Each node access node can define one or more realms.';


--
-- Name: COLUMN node_access.grant_view; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_access.grant_view IS 'Boolean indicating whether a user with the realm/grant pair can view this node.';


--
-- Name: COLUMN node_access.grant_update; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_access.grant_update IS 'Boolean indicating whether a user with the realm/grant pair can edit this node.';


--
-- Name: COLUMN node_access.grant_delete; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_access.grant_delete IS 'Boolean indicating whether a user with the realm/grant pair can delete this node.';


--
-- Name: node_field_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE node_field_data (
    nid bigint NOT NULL,
    vid bigint NOT NULL,
    type character varying(32) NOT NULL,
    langcode character varying(12) NOT NULL,
    title character varying(255) NOT NULL,
    uid bigint NOT NULL,
    status smallint NOT NULL,
    created integer NOT NULL,
    changed integer NOT NULL,
    promote smallint NOT NULL,
    sticky smallint NOT NULL,
    revision_translation_affected smallint,
    default_langcode smallint NOT NULL,
    CONSTRAINT node_field_data_nid_check CHECK ((nid >= 0)),
    CONSTRAINT node_field_data_uid_check CHECK ((uid >= 0)),
    CONSTRAINT node_field_data_vid_check CHECK ((vid >= 0))
);


--
-- Name: TABLE node_field_data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE node_field_data IS 'The data table for node entities.';


--
-- Name: COLUMN node_field_data.type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_field_data.type IS 'The ID of the target entity.';


--
-- Name: COLUMN node_field_data.uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_field_data.uid IS 'The ID of the target entity.';


--
-- Name: node_field_revision; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE node_field_revision (
    nid bigint NOT NULL,
    vid bigint NOT NULL,
    langcode character varying(12) NOT NULL,
    title character varying(255),
    uid bigint NOT NULL,
    status smallint NOT NULL,
    created integer,
    changed integer,
    promote smallint,
    sticky smallint,
    revision_translation_affected smallint,
    default_langcode smallint NOT NULL,
    CONSTRAINT node_field_revision_nid_check CHECK ((nid >= 0)),
    CONSTRAINT node_field_revision_uid_check CHECK ((uid >= 0)),
    CONSTRAINT node_field_revision_vid_check CHECK ((vid >= 0))
);


--
-- Name: TABLE node_field_revision; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE node_field_revision IS 'The revision data table for node entities.';


--
-- Name: COLUMN node_field_revision.uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_field_revision.uid IS 'The ID of the target entity.';


--
-- Name: node_nid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE node_nid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: node_nid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE node_nid_seq OWNED BY node.nid;


--
-- Name: node_revision; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE node_revision (
    nid bigint NOT NULL,
    vid integer NOT NULL,
    langcode character varying(12) NOT NULL,
    revision_timestamp integer,
    revision_uid bigint,
    revision_log text,
    CONSTRAINT node_revision_nid_check CHECK ((nid >= 0)),
    CONSTRAINT node_revision_revision_uid_check CHECK ((revision_uid >= 0)),
    CONSTRAINT node_revision_vid_check CHECK ((vid >= 0))
);


--
-- Name: TABLE node_revision; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE node_revision IS 'The revision table for node entities.';


--
-- Name: COLUMN node_revision.revision_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_revision.revision_uid IS 'The ID of the target entity.';


--
-- Name: node_revision__body; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE node_revision__body (
    bundle character varying(128) DEFAULT ''::character varying NOT NULL,
    deleted smallint DEFAULT 0 NOT NULL,
    entity_id bigint NOT NULL,
    revision_id bigint NOT NULL,
    langcode character varying(32) DEFAULT ''::character varying NOT NULL,
    delta bigint NOT NULL,
    body_value text NOT NULL,
    body_summary text,
    body_format character varying(255),
    CONSTRAINT node_revision__body_delta_check CHECK ((delta >= 0)),
    CONSTRAINT node_revision__body_entity_id_check CHECK ((entity_id >= 0)),
    CONSTRAINT node_revision__body_revision_id_check CHECK ((revision_id >= 0))
);


--
-- Name: TABLE node_revision__body; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE node_revision__body IS 'Revision archive storage for node field body.';


--
-- Name: COLUMN node_revision__body.bundle; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_revision__body.bundle IS 'The field instance bundle to which this row belongs, used when deleting a field instance';


--
-- Name: COLUMN node_revision__body.deleted; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_revision__body.deleted IS 'A boolean indicating whether this data item has been deleted';


--
-- Name: COLUMN node_revision__body.entity_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_revision__body.entity_id IS 'The entity id this data is attached to';


--
-- Name: COLUMN node_revision__body.revision_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_revision__body.revision_id IS 'The entity revision id this data is attached to';


--
-- Name: COLUMN node_revision__body.langcode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_revision__body.langcode IS 'The language code for this data item.';


--
-- Name: COLUMN node_revision__body.delta; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN node_revision__body.delta IS 'The sequence number for this data item, used for multi-value fields';


--
-- Name: node_revision_vid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE node_revision_vid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: node_revision_vid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE node_revision_vid_seq OWNED BY node_revision.vid;


--
-- Name: queue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE queue (
    item_id integer NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire integer DEFAULT 0 NOT NULL,
    created integer DEFAULT 0 NOT NULL,
    CONSTRAINT queue_item_id_check CHECK ((item_id >= 0))
);


--
-- Name: TABLE queue; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE queue IS 'Stores items in queues.';


--
-- Name: COLUMN queue.item_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN queue.item_id IS 'Primary Key: Unique item ID.';


--
-- Name: COLUMN queue.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN queue.name IS 'The queue name.';


--
-- Name: COLUMN queue.data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN queue.data IS 'The arbitrary data for the item.';


--
-- Name: COLUMN queue.expire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN queue.expire IS 'Timestamp when the claim lease expires on the item.';


--
-- Name: COLUMN queue.created; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN queue.created IS 'Timestamp when the item was created.';


--
-- Name: queue_item_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE queue_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: queue_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE queue_item_id_seq OWNED BY queue.item_id;


--
-- Name: router; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE router (
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    path character varying(255) DEFAULT ''::character varying NOT NULL,
    pattern_outline character varying(255) DEFAULT ''::character varying NOT NULL,
    fit integer DEFAULT 0 NOT NULL,
    route bytea,
    number_parts smallint DEFAULT 0 NOT NULL
);


--
-- Name: TABLE router; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE router IS 'Maps paths to various callbacks (access, page and title)';


--
-- Name: COLUMN router.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN router.name IS 'Primary Key: Machine name of this route';


--
-- Name: COLUMN router.path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN router.path IS 'The path for this URI';


--
-- Name: COLUMN router.pattern_outline; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN router.pattern_outline IS 'The pattern';


--
-- Name: COLUMN router.fit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN router.fit IS 'A numeric representation of how specific the path is.';


--
-- Name: COLUMN router.route; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN router.route IS 'A serialized Route object';


--
-- Name: COLUMN router.number_parts; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN router.number_parts IS 'Number of parts in this router path.';


--
-- Name: semaphore; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE semaphore (
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    value character varying(255) DEFAULT ''::character varying NOT NULL,
    expire double precision NOT NULL
);


--
-- Name: TABLE semaphore; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE semaphore IS 'Table for holding semaphores, locks, flags, etc. that cannot be stored as state since they must not be cached.';


--
-- Name: COLUMN semaphore.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN semaphore.name IS 'Primary Key: Unique name.';


--
-- Name: COLUMN semaphore.value; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN semaphore.value IS 'A value for the semaphore.';


--
-- Name: COLUMN semaphore.expire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN semaphore.expire IS 'A Unix timestamp with microseconds indicating when the semaphore should expire.';


--
-- Name: sequences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sequences (
    value integer NOT NULL,
    CONSTRAINT sequences_value_check CHECK ((value >= 0))
);


--
-- Name: TABLE sequences; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE sequences IS 'Stores IDs.';


--
-- Name: COLUMN sequences.value; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN sequences.value IS 'The value of the sequence.';


--
-- Name: sequences_value_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sequences_value_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sequences_value_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sequences_value_seq OWNED BY sequences.value;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sessions (
    uid bigint NOT NULL,
    sid character varying(128) NOT NULL,
    hostname character varying(128) DEFAULT ''::character varying NOT NULL,
    "timestamp" integer DEFAULT 0 NOT NULL,
    session bytea,
    CONSTRAINT sessions_uid_check CHECK ((uid >= 0))
);


--
-- Name: TABLE sessions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE sessions IS 'Drupal''s session handlers read and write into the sessions table. Each record represents a user session, either anonymous or authenticated.';


--
-- Name: COLUMN sessions.uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN sessions.uid IS 'The users.uid corresponding to a session, or 0 for anonymous user.';


--
-- Name: COLUMN sessions.sid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN sessions.sid IS 'A session ID (hashed). The value is generated by Drupal''s session handlers.';


--
-- Name: COLUMN sessions.hostname; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN sessions.hostname IS 'The IP address that last used this session ID (sid).';


--
-- Name: COLUMN sessions."timestamp"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN sessions."timestamp" IS 'The Unix timestamp when this session last requested a page. Old records are purged by PHP automatically.';


--
-- Name: COLUMN sessions.session; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN sessions.session IS 'The serialized contents of $_SESSION, an array of name/value pairs that persists across page requests by this session ID. Drupal loads $_SESSION from here at the start of each request and saves it at the end.';


--
-- Name: url_alias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE url_alias (
    pid integer NOT NULL,
    source character varying(255) DEFAULT ''::character varying NOT NULL,
    alias character varying(255) DEFAULT ''::character varying NOT NULL,
    langcode character varying(12) DEFAULT ''::character varying NOT NULL,
    CONSTRAINT url_alias_pid_check CHECK ((pid >= 0))
);


--
-- Name: TABLE url_alias; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE url_alias IS 'A list of URL aliases for Drupal paths. a user may visit either the source or destination path.';


--
-- Name: COLUMN url_alias.pid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN url_alias.pid IS 'A unique path alias identifier.';


--
-- Name: COLUMN url_alias.source; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN url_alias.source IS 'The Drupal path this alias is for. e.g. node/12.';


--
-- Name: COLUMN url_alias.alias; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN url_alias.alias IS 'The alias for this path. e.g. title-of-the-story.';


--
-- Name: COLUMN url_alias.langcode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN url_alias.langcode IS 'The language code this alias is for. if ''und'', the alias will be used for unknown languages. Each Drupal path can have an alias for each supported language.';


--
-- Name: url_alias_pid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE url_alias_pid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: url_alias_pid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE url_alias_pid_seq OWNED BY url_alias.pid;


--
-- Name: user__roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user__roles (
    bundle character varying(128) DEFAULT ''::character varying NOT NULL,
    deleted smallint DEFAULT 0 NOT NULL,
    entity_id bigint NOT NULL,
    revision_id bigint NOT NULL,
    langcode character varying(32) DEFAULT ''::character varying NOT NULL,
    delta bigint NOT NULL,
    roles_target_id character varying(255) NOT NULL,
    CONSTRAINT user__roles_delta_check CHECK ((delta >= 0)),
    CONSTRAINT user__roles_entity_id_check CHECK ((entity_id >= 0)),
    CONSTRAINT user__roles_revision_id_check CHECK ((revision_id >= 0))
);


--
-- Name: TABLE user__roles; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE user__roles IS 'Data storage for user field roles.';


--
-- Name: COLUMN user__roles.bundle; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN user__roles.bundle IS 'The field instance bundle to which this row belongs, used when deleting a field instance';


--
-- Name: COLUMN user__roles.deleted; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN user__roles.deleted IS 'A boolean indicating whether this data item has been deleted';


--
-- Name: COLUMN user__roles.entity_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN user__roles.entity_id IS 'The entity id this data is attached to';


--
-- Name: COLUMN user__roles.revision_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN user__roles.revision_id IS 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id';


--
-- Name: COLUMN user__roles.langcode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN user__roles.langcode IS 'The language code for this data item.';


--
-- Name: COLUMN user__roles.delta; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN user__roles.delta IS 'The sequence number for this data item, used for multi-value fields';


--
-- Name: COLUMN user__roles.roles_target_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN user__roles.roles_target_id IS 'The ID of the target entity.';


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    uid bigint NOT NULL,
    uuid character varying(128) NOT NULL,
    langcode character varying(12) NOT NULL,
    CONSTRAINT users_uid_check CHECK ((uid >= 0))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE users IS 'The base table for user entities.';


--
-- Name: users_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users_data (
    uid bigint DEFAULT 0 NOT NULL,
    module character varying(50) DEFAULT ''::character varying NOT NULL,
    name character varying(128) DEFAULT ''::character varying NOT NULL,
    value bytea,
    serialized integer DEFAULT 0,
    CONSTRAINT users_data_serialized_check CHECK ((serialized >= 0)),
    CONSTRAINT users_data_uid_check CHECK ((uid >= 0))
);


--
-- Name: TABLE users_data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE users_data IS 'Stores module data as key/value pairs per user.';


--
-- Name: COLUMN users_data.uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN users_data.uid IS 'Primary key: users.uid for user.';


--
-- Name: COLUMN users_data.module; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN users_data.module IS 'The name of the module declaring the variable.';


--
-- Name: COLUMN users_data.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN users_data.name IS 'The identifier of the data.';


--
-- Name: COLUMN users_data.value; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN users_data.value IS 'The value.';


--
-- Name: COLUMN users_data.serialized; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN users_data.serialized IS 'Whether value is serialized.';


--
-- Name: users_field_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users_field_data (
    uid bigint NOT NULL,
    langcode character varying(12) NOT NULL,
    preferred_langcode character varying(12),
    preferred_admin_langcode character varying(12),
    name character varying(60) NOT NULL,
    pass character varying(255),
    mail character varying(254),
    timezone character varying(32),
    status smallint,
    created integer NOT NULL,
    changed integer,
    access integer NOT NULL,
    login integer,
    init character varying(254),
    default_langcode smallint NOT NULL,
    CONSTRAINT users_field_data_uid_check CHECK ((uid >= 0))
);


--
-- Name: TABLE users_field_data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE users_field_data IS 'The data table for user entities.';


--
-- Name: watchdog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE watchdog (
    wid integer NOT NULL,
    uid bigint DEFAULT 0 NOT NULL,
    type character varying(64) DEFAULT ''::character varying NOT NULL,
    message text NOT NULL,
    variables bytea NOT NULL,
    severity integer DEFAULT 0 NOT NULL,
    link text,
    location text NOT NULL,
    referer text,
    hostname character varying(128) DEFAULT ''::character varying NOT NULL,
    "timestamp" integer DEFAULT 0 NOT NULL,
    CONSTRAINT watchdog_severity_check CHECK ((severity >= 0)),
    CONSTRAINT watchdog_uid_check CHECK ((uid >= 0))
);


--
-- Name: TABLE watchdog; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE watchdog IS 'Table that contains logs of all system events.';


--
-- Name: COLUMN watchdog.wid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN watchdog.wid IS 'Primary Key: Unique watchdog event ID.';


--
-- Name: COLUMN watchdog.uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN watchdog.uid IS 'The users.uid of the user who triggered the event.';


--
-- Name: COLUMN watchdog.type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN watchdog.type IS 'Type of log message, for example "user" or "page not found."';


--
-- Name: COLUMN watchdog.message; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN watchdog.message IS 'Text of log message to be passed into the t() function.';


--
-- Name: COLUMN watchdog.variables; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN watchdog.variables IS 'Serialized array of variables that match the message string and that is passed into the t() function.';


--
-- Name: COLUMN watchdog.severity; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN watchdog.severity IS 'The severity level of the event. ranges from 0 (Emergency) to 7 (Debug)';


--
-- Name: COLUMN watchdog.link; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN watchdog.link IS 'Link to view the result of the event.';


--
-- Name: COLUMN watchdog.location; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN watchdog.location IS 'URL of the origin of the event.';


--
-- Name: COLUMN watchdog.referer; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN watchdog.referer IS 'URL of referring page.';


--
-- Name: COLUMN watchdog.hostname; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN watchdog.hostname IS 'Hostname of the user who triggered the event.';


--
-- Name: COLUMN watchdog."timestamp"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN watchdog."timestamp" IS 'Unix timestamp of when event occurred.';


--
-- Name: watchdog_wid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE watchdog_wid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: watchdog_wid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE watchdog_wid_seq OWNED BY watchdog.wid;


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY file_managed ALTER COLUMN fid SET DEFAULT nextval('file_managed_fid_seq'::regclass);


--
-- Name: mlid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY menu_tree ALTER COLUMN mlid SET DEFAULT nextval('menu_tree_mlid_seq'::regclass);


--
-- Name: nid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY node ALTER COLUMN nid SET DEFAULT nextval('node_nid_seq'::regclass);


--
-- Name: vid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY node_revision ALTER COLUMN vid SET DEFAULT nextval('node_revision_vid_seq'::regclass);


--
-- Name: item_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY queue ALTER COLUMN item_id SET DEFAULT nextval('queue_item_id_seq'::regclass);


--
-- Name: value; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sequences ALTER COLUMN value SET DEFAULT nextval('sequences_value_seq'::regclass);


--
-- Name: pid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY url_alias ALTER COLUMN pid SET DEFAULT nextval('url_alias_pid_seq'::regclass);


--
-- Name: wid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY watchdog ALTER COLUMN wid SET DEFAULT nextval('watchdog_wid_seq'::regclass);


--
-- Data for Name: batch; Type: TABLE DATA; Schema: public; Owner: -
--

COPY batch (bid, token, "timestamp", batch) FROM stdin;
\.


--
-- Data for Name: cache_bootstrap; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cache_bootstrap (cid, data, expire, created, serialized, tags, checksum) FROM stdin;
\.


--
-- Data for Name: cache_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cache_config (cid, data, expire, created, serialized, tags, checksum) FROM stdin;
\.


--
-- Data for Name: cache_container; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cache_container (cid, data, expire, created, serialized, tags, checksum) FROM stdin;
\.


--
-- Data for Name: cache_data; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cache_data (cid, data, expire, created, serialized, tags, checksum) FROM stdin;
\.


--
-- Data for Name: cache_default; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cache_default (cid, data, expire, created, serialized, tags, checksum) FROM stdin;
\.


--
-- Data for Name: cache_discovery; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cache_discovery (cid, data, expire, created, serialized, tags, checksum) FROM stdin;
\.


--
-- Data for Name: cache_dynamic_page_cache; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cache_dynamic_page_cache (cid, data, expire, created, serialized, tags, checksum) FROM stdin;
\.


--
-- Data for Name: cache_entity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cache_entity (cid, data, expire, created, serialized, tags, checksum) FROM stdin;
\.


--
-- Data for Name: cache_menu; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cache_menu (cid, data, expire, created, serialized, tags, checksum) FROM stdin;
\.


--
-- Data for Name: cache_render; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cache_render (cid, data, expire, created, serialized, tags, checksum) FROM stdin;
\.


--
-- Data for Name: cachetags; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cachetags (tag, invalidations) FROM stdin;
\.


--
-- Data for Name: config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY config (collection, name, data) FROM stdin;
	core.menu.static_menu_link_overrides	a:2:{s:11:"definitions";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"jdY7AU0tU-QsjmiOw3W8vwpYMb-By--_MSFgbqKUTYM";}}
	system.date	a:4:{s:7:"country";a:1:{s:7:"default";s:2:"US";}s:9:"first_day";i:0;s:8:"timezone";a:2:{s:7:"default";s:16:"America/New_York";s:4:"user";a:3:{s:12:"configurable";b:1;s:4:"warn";b:0;s:7:"default";i:0;}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"V9UurX2GPT05NWKG9f2GWQqFG2TRG8vczidwjpy7Woo";}}
	core.date_format.fallback	a:9:{s:4:"uuid";s:36:"ca4937a2-9570-44fc-bdd4-f8d325dc482a";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"7klS5IWXrwzVaPpYZFAs6wcx8U2FF1X73OfrtTsvuvE";}s:2:"id";s:8:"fallback";s:5:"label";s:20:"Fallback date format";s:6:"locked";b:1;s:7:"pattern";s:14:"D, m/d/Y - H:i";}
	core.date_format.html_date	a:9:{s:4:"uuid";s:36:"6fcc87cb-7ff0-49c5-bafe-e55df65d4395";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"EOQltUQPmgc6UQ2rcJ4Xi_leCEJj5ui0TR-12duS-Tk";}s:2:"id";s:9:"html_date";s:5:"label";s:9:"HTML Date";s:6:"locked";b:1;s:7:"pattern";s:5:"Y-m-d";}
	core.date_format.html_datetime	a:9:{s:4:"uuid";s:36:"0e61d569-32ab-4ee8-a2e6-0da2d5a4ebb2";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"jxfClwZIRXIdcvMrE--WkcZxDGUVoOIE3Sm2NRZlFuE";}s:2:"id";s:13:"html_datetime";s:5:"label";s:13:"HTML Datetime";s:6:"locked";b:1;s:7:"pattern";s:13:"Y-m-d\\\\TH:i:sO";}
	core.date_format.html_month	a:9:{s:4:"uuid";s:36:"4c63cb33-49ea-4fad-86e0-692bf302f2eb";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"Z7KuCUwM_WdTNvLcoltuX3_8d-s-8FZkTN6KgNwF0eM";}s:2:"id";s:10:"html_month";s:5:"label";s:10:"HTML Month";s:6:"locked";b:1;s:7:"pattern";s:3:"Y-m";}
	core.date_format.html_time	a:9:{s:4:"uuid";s:36:"5a6d4205-6f2c-47ed-9750-c67af7f6c252";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"M7yqicYkU36hRy5p9drAaGBBihhUD1OyujFrAaQ93ZE";}s:2:"id";s:9:"html_time";s:5:"label";s:9:"HTML Time";s:6:"locked";b:1;s:7:"pattern";s:5:"H:i:s";}
	core.date_format.html_week	a:9:{s:4:"uuid";s:36:"07184cc4-085c-4d68-8764-cba86a6d865f";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"wKD4WsoV_wFgv2vgI4mcAAFSIzrye17ykzdwrnApkfY";}s:2:"id";s:9:"html_week";s:5:"label";s:9:"HTML Week";s:6:"locked";b:1;s:7:"pattern";s:5:"Y-\\\\WW";}
	core.date_format.html_year	a:9:{s:4:"uuid";s:36:"d669e4e2-935e-488d-8a41-0d58a1afddc4";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"OjekiQuX9RbVQ2_8jOHBL94RgYLePqX7wpfNGgcQzrk";}s:2:"id";s:9:"html_year";s:5:"label";s:9:"HTML Year";s:6:"locked";b:1;s:7:"pattern";s:1:"Y";}
	core.date_format.html_yearless_date	a:9:{s:4:"uuid";s:36:"8542c5c7-656b-4932-b6ea-353556d25cc0";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"5VpawMrKPEPCkoO4YpPa0TDFO2dgiIHfTziJtwlmUxc";}s:2:"id";s:18:"html_yearless_date";s:5:"label";s:18:"HTML Yearless date";s:6:"locked";b:1;s:7:"pattern";s:3:"m-d";}
	core.date_format.long	a:9:{s:4:"uuid";s:36:"1812fd1d-04ce-41d8-ac97-5dd61a6fe6ce";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"og8sWXhBuHbLMw3CoiBEZjgqSyhFBFmcbUW_wLcfNbo";}s:2:"id";s:4:"long";s:5:"label";s:17:"Default long date";s:6:"locked";b:0;s:7:"pattern";s:15:"l, F j, Y - H:i";}
	core.date_format.medium	a:9:{s:4:"uuid";s:36:"15d11cb8-2816-4f71-97a5-68fce03d019f";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"nzL5d024NjXIX_8TlT6uFAu973lmfkmHklJC-2i9rAE";}s:2:"id";s:6:"medium";s:5:"label";s:19:"Default medium date";s:6:"locked";b:0;s:7:"pattern";s:14:"D, m/d/Y - H:i";}
	core.date_format.short	a:9:{s:4:"uuid";s:36:"dfcbbb90-3d30-4ae5-befc-a057626f9538";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"AlzeyytA8InBgxIG9H2UDJYs3CG98Zj6yRsDKmlbZwA";}s:2:"id";s:5:"short";s:5:"label";s:18:"Default short date";s:6:"locked";b:0;s:7:"pattern";s:11:"m/d/Y - H:i";}
	system.authorize	a:2:{s:20:"filetransfer_default";N;s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"z63ds8M4zPrylEgFRkRcOlfcsXWwfITzjD4cj1kRdfg";}}
	system.cron	a:2:{s:9:"threshold";a:2:{s:20:"requirements_warning";i:172800;s:18:"requirements_error";i:1209600;}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"05U0n1_8zHYzxEFSWjyHCWuJyhdez2a6Z_aTIXin04E";}}
	system.diff	a:2:{s:7:"context";a:2:{s:13:"lines_leading";i:2;s:14:"lines_trailing";i:2;}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"1WanmaEhxW_vM8_5Ktsdntj8MaO9UBHXg0lN603PsWM";}}
	system.image	a:2:{s:7:"toolkit";s:2:"gd";s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"durWHaKeBaq4d9Wpi4RqwADj1OufDepcnJuhVLmKN24";}}
	system.image.gd	a:2:{s:12:"jpeg_quality";i:75;s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"eNXaHfkJJUThHeF0nvkoXyPLRrKYGxgHRjORvT4F5rQ";}}
	system.logging	a:2:{s:11:"error_level";s:4:"hide";s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"u3-njszl92FaxjrCMiq0yDcjAfcdx72w1zT1O9dx6aA";}}
	system.mail	a:2:{s:9:"interface";a:1:{s:7:"default";s:8:"php_mail";}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"rYgt7uhPafP2ngaN_ZUPFuyI4KdE0zU868zLNSlzKoE";}}
	system.maintenance	a:3:{s:7:"message";s:93:"@site is currently under maintenance. We should be back shortly. Thank you for your patience.";s:8:"langcode";s:2:"en";s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"Z5MXifrF77GEAgx0GQ6iWT8wStjFuY8BD9OruofWTJ8";}}
	system.menu.account	a:9:{s:4:"uuid";s:36:"469eaacc-e1d4-4472-ac7a-e413052857b8";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"M_Bh81osDyUQ4wV0GgU_NdBNqkzM87sLxjaCdFj9mnw";}s:2:"id";s:7:"account";s:5:"label";s:17:"User account menu";s:11:"description";s:40:"Links related to the active user account";s:6:"locked";b:1;}
	system.menu.admin	a:9:{s:4:"uuid";s:36:"2968d94a-d85a-4926-8e2c-0235e258eb5e";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"sapEi2YDGoI9yQIT_WgIV2vUdQ6DScH0V3fAyTadAL0";}s:2:"id";s:5:"admin";s:5:"label";s:14:"Administration";s:11:"description";s:25:"Administrative task links";s:6:"locked";b:1;}
	system.menu.footer	a:9:{s:4:"uuid";s:36:"bcd03cb8-6819-48d7-9698-d27fae1af931";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"7yrlW5z9zdg2eBucB2GPqXKSMQfH9lSRSO4DbWF7AFc";}s:2:"id";s:6:"footer";s:5:"label";s:6:"Footer";s:11:"description";s:22:"Site information links";s:6:"locked";b:1;}
	system.menu.main	a:9:{s:4:"uuid";s:36:"d63dd624-898a-4f9c-b0cc-e47e3f8ff39f";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"Q2Ra3jfoIVk0f3SjxJX61byRQFVBAbpzYDQOiY-kno8";}s:2:"id";s:4:"main";s:5:"label";s:15:"Main navigation";s:11:"description";s:18:"Site section links";s:6:"locked";b:1;}
	system.menu.tools	a:9:{s:4:"uuid";s:36:"008565e5-83e0-422c-a3aa-fb6a37013508";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"BCM-vV1zzRaLHN18dqAR_CuGOj8AFJvTx7BKl_8Gcxc";}s:2:"id";s:5:"tools";s:5:"label";s:5:"Tools";s:11:"description";s:39:"User tool links, often added by modules";s:6:"locked";b:1;}
	system.performance	a:6:{s:5:"cache";a:1:{s:4:"page";a:1:{s:7:"max_age";i:0;}}s:3:"css";a:2:{s:10:"preprocess";b:1;s:4:"gzip";b:1;}s:8:"fast_404";a:4:{s:7:"enabled";b:1;s:5:"paths";s:69:"/\\\\.(?:txt|png|gif|jpe?g|css|js|ico|swf|flv|cgi|bat|pl|dll|exe|asp)$/i";s:13:"exclude_paths";s:27:"/\\\\/(?:styles|imagecache)\\\\//";s:4:"html";s:162:"<!DOCTYPE html><html><head><title>404 Not Found</title></head><body><h1>Not Found</h1><p>The requested URL "@path" was not found on this server.</p></body></html>";}s:2:"js";a:2:{s:10:"preprocess";b:1;s:4:"gzip";b:1;}s:20:"stale_file_threshold";i:2592000;s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"b2cssrj-lOmATIbdehfCqfCFgVR0qCdxxWhwqa2KBVQ";}}
	system.rss	a:4:{s:7:"channel";a:1:{s:11:"description";s:0:"";}s:5:"items";a:2:{s:5:"limit";i:10;s:9:"view_mode";s:3:"rss";}s:8:"langcode";s:2:"en";s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"TlH7NNk46phfxu1mSUfwg1C0YqaGsUCeD4l9JQnQlDU";}}
	system.theme	a:3:{s:5:"admin";s:0:"";s:7:"default";s:5:"stark";s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"6lQ55NXM9ysybMQ6NzJj4dtiQ1dAkOYxdDompa-r_kk";}}
	system.theme.global	a:4:{s:7:"favicon";a:4:{s:8:"mimetype";s:24:"image/vnd.microsoft.icon";s:4:"path";s:0:"";s:3:"url";s:0:"";s:11:"use_default";b:1;}s:8:"features";a:4:{s:20:"comment_user_picture";b:1;s:25:"comment_user_verification";b:1;s:7:"favicon";b:1;s:17:"node_user_picture";b:0;}s:4:"logo";a:3:{s:4:"path";s:0:"";s:3:"url";s:0:"";s:11:"use_default";b:1;}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"9rAU4Pku7eMBQxauQqAgjzlcicFZ2As6zEa6zvTlCB8";}}
	system.file	a:5:{s:22:"allow_insecure_uploads";b:0;s:14:"default_scheme";s:6:"public";s:4:"path";a:1:{s:9:"temporary";s:4:"/tmp";}s:21:"temporary_maximum_age";i:21600;s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"t48gCU9DzYfjb3bAOIqHLzhL0ChBlXh6_5B5Pyo9t8g";}}
	core.entity_form_mode.user.register	a:9:{s:4:"uuid";s:36:"c20e65c8-0758-4da0-8f08-0fd1ec6550ca";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"user";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"flXhTcp55yLcyy7ZLOhPGKGZobZQJdkAFVWV3LseiuI";}s:2:"id";s:13:"user.register";s:5:"label";s:8:"Register";s:16:"targetEntityType";s:4:"user";s:5:"cache";b:1;}
	core.entity_view_mode.user.compact	a:9:{s:4:"uuid";s:36:"1738e8cf-44eb-4a5e-97b4-b502bec4ad0a";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"user";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"71CSAr_LNPcgu6D6jI4INl1KATkahmeyUFBETAWya8g";}s:2:"id";s:12:"user.compact";s:5:"label";s:7:"Compact";s:16:"targetEntityType";s:4:"user";s:5:"cache";b:1;}
	core.entity_view_mode.user.full	a:9:{s:4:"uuid";s:36:"ab4a4582-1641-45b3-95af-4840e3fa0bb5";s:8:"langcode";s:2:"en";s:6:"status";b:0;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"user";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"mQIF_foYjmnVSr9MpcD4CTaJE_FpO1AyDd_DskztGhM";}s:2:"id";s:9:"user.full";s:5:"label";s:12:"User account";s:16:"targetEntityType";s:4:"user";s:5:"cache";b:1;}
	system.action.user_block_user_action	a:10:{s:4:"uuid";s:36:"aa5e4e36-35cd-47e2-a44b-86ba53104e69";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"user";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"DyypzTfThX10FFQw-399qPfEbLLyrhXgQrKPVsmAoJ4";}s:2:"id";s:22:"user_block_user_action";s:5:"label";s:26:"Block the selected user(s)";s:4:"type";s:4:"user";s:6:"plugin";s:22:"user_block_user_action";s:13:"configuration";a:0:{}}
	system.action.user_cancel_user_action	a:10:{s:4:"uuid";s:36:"83c3b783-4235-4786-b7e7-de51861126dc";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"user";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"nvrL9bFilzBvm2bjO9rQnFDpBA7dBBUjShSSt6NS-DU";}s:2:"id";s:23:"user_cancel_user_action";s:5:"label";s:35:"Cancel the selected user account(s)";s:4:"type";s:4:"user";s:6:"plugin";s:23:"user_cancel_user_action";s:13:"configuration";a:0:{}}
	system.action.user_unblock_user_action	a:10:{s:4:"uuid";s:36:"cdf8f740-43b5-4658-aa94-57556305490b";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"user";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"SPsUXsR3Rc8d1y3gewzaAKWa1ncea_ywXX3f7LTn7k0";}s:2:"id";s:24:"user_unblock_user_action";s:5:"label";s:28:"Unblock the selected user(s)";s:4:"type";s:4:"user";s:6:"plugin";s:24:"user_unblock_user_action";s:13:"configuration";a:0:{}}
	user.flood	a:6:{s:8:"uid_only";b:0;s:8:"ip_limit";i:50;s:9:"ip_window";i:3600;s:10:"user_limit";i:5;s:11:"user_window";i:21600;s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"UYfMzeP1S8jKm9PSvxf7nQNe8DsNS-3bc2WSNNXBQWs";}}
	system.site	a:10:{s:4:"uuid";s:36:"855f1ea5-713b-4bf5-aefe-f1bb012ace60";s:4:"name";s:15:"Project Planner";s:4:"mail";s:19:"adrian.webb@gsa.gov";s:6:"slogan";s:0:"";s:4:"page";a:3:{i:403;s:0:"";i:404;s:0:"";s:5:"front";s:11:"/user/login";}s:18:"admin_compact_mode";b:0;s:17:"weight_select_max";i:100;s:8:"langcode";s:2:"en";s:16:"default_langcode";s:2:"en";s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"yXadRE77Va-G6dxhd2kPYapAvbnSvTF6hO4oXiOEynI";}}
	user.mail	a:11:{s:14:"cancel_confirm";a:2:{s:4:"body";s:377:"[user:display-name],\\012\\012A request to cancel your account has been made at [site:name].\\012\\012You may now cancel your account on [site:url-brief] by clicking this link or copying and pasting it into your browser:\\012\\012[user:cancel-url]\\012\\012NOTE: The cancellation of your account is not reversible.\\012\\012This link expires in one day and nothing will happen if it is not used.\\012\\012--  [site:name] team";s:7:"subject";s:67:"Account cancellation request for [user:display-name] at [site:name]";}s:14:"password_reset";a:2:{s:4:"body";s:407:"[user:display-name],\\012\\012A request to reset the password for your account has been made at [site:name].\\012\\012You may now log in by clicking this link or copying and pasting it into your browser:\\012\\012[user:one-time-login-url]\\012\\012This link can only be used once to log in and will lead you to a page where you can set your password. It expires after one day and nothing will happen if it's not used.\\012\\012--  [site:name] team";s:7:"subject";s:68:"Replacement login information for [user:display-name] at [site:name]";}s:22:"register_admin_created";a:2:{s:4:"body";s:473:"[user:display-name],\\012\\012A site administrator at [site:name] has created an account for you. You may now log in by clicking this link or copying and pasting it into your browser:\\012\\012[user:one-time-login-url]\\012\\012This link can only be used once to log in and will lead you to a page where you can set your password.\\012\\012After setting your password, you will be able to log in at [site:login-url] in the future using:\\012\\012username: [user:name]\\012password: Your password\\012\\012--  [site:name] team";s:7:"subject";s:58:"An administrator created an account for you at [site:name]";}s:29:"register_no_approval_required";a:2:{s:4:"body";s:447:"[user:display-name],\\012\\012Thank you for registering at [site:name]. You may now log in by clicking this link or copying and pasting it into your browser:\\012\\012[user:one-time-login-url]\\012\\012This link can only be used once to log in and will lead you to a page where you can set your password.\\012\\012After setting your password, you will be able to log in at [site:login-url] in the future using:\\012\\012username: [user:name]\\012password: Your password\\012\\012--  [site:name] team";s:7:"subject";s:54:"Account details for [user:display-name] at [site:name]";}s:25:"register_pending_approval";a:2:{s:4:"body";s:289:"[user:display-name],\\012\\012Thank you for registering at [site:name]. Your application for an account is currently pending approval. Once it has been approved, you will receive another email containing information about how to log in, set your password, and other details.\\012\\012\\012--  [site:name] team";s:7:"subject";s:79:"Account details for [user:display-name] at [site:name] (pending admin approval)";}s:31:"register_pending_approval_admin";a:2:{s:4:"body";s:64:"[user:display-name] has applied for an account.\\012\\012[user:edit-url]";s:7:"subject";s:79:"Account details for [user:display-name] at [site:name] (pending admin approval)";}s:16:"status_activated";a:2:{s:4:"body";s:462:"[user:display-name],\\012\\012Your account at [site:name] has been activated.\\012\\012You may now log in by clicking this link or copying and pasting it into your browser:\\012\\012[user:one-time-login-url]\\012\\012This link can only be used once to log in and will lead you to a page where you can set your password.\\012\\012After setting your password, you will be able to log in at [site:login-url] in the future using:\\012\\012username: [user:account-name]\\012password: Your password\\012\\012--  [site:name] team";s:7:"subject";s:65:"Account details for [user:display-name] at [site:name] (approved)";}s:14:"status_blocked";a:2:{s:4:"body";s:89:"[user:display-name],\\012\\012Your account on [site:name] has been blocked.\\012\\012--  [site:name] team";s:7:"subject";s:64:"Account details for [user:display-name] at [site:name] (blocked)";}s:15:"status_canceled";a:2:{s:4:"body";s:90:"[user:display-name],\\012\\012Your account on [site:name] has been canceled.\\012\\012--  [site:name] team";s:7:"subject";s:65:"Account details for [user:display-name] at [site:name] (canceled)";}s:8:"langcode";s:2:"en";s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"m4J3ROov32OEquRYGLbx3SpdDGuqx9l_zJtNvihqdCg";}}
	field.settings	a:2:{s:16:"purge_batch_size";i:50;s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"nJk0TAQBzlNo52ehiHI7bIEPLGi0BYqZvPdEn7Chfu0";}}
	filter.format.plain_text	a:9:{s:4:"uuid";s:36:"1f34c846-0c64-41db-9704-2a68568b8b97";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"NIKBt6kw_uPhNI0qtR2DnRf7mSOgAQdx7Q94SKMjXbQ";}s:4:"name";s:10:"Plain text";s:6:"format";s:10:"plain_text";s:6:"weight";i:10;s:7:"filters";a:3:{s:18:"filter_html_escape";a:5:{s:2:"id";s:18:"filter_html_escape";s:8:"provider";s:6:"filter";s:6:"status";b:1;s:6:"weight";i:-10;s:8:"settings";a:0:{}}s:10:"filter_url";a:5:{s:2:"id";s:10:"filter_url";s:8:"provider";s:6:"filter";s:6:"status";b:1;s:6:"weight";i:0;s:8:"settings";a:1:{s:17:"filter_url_length";i:72;}}s:12:"filter_autop";a:5:{s:2:"id";s:12:"filter_autop";s:8:"provider";s:6:"filter";s:6:"status";b:1;s:6:"weight";i:0;s:8:"settings";a:0:{}}}}
	filter.settings	a:3:{s:15:"fallback_format";s:10:"plain_text";s:27:"always_show_fallback_choice";b:0;s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"FiPjM3WdB__ruFA7B6TLwni_UcZbmek5G4b2dxQItxA";}}
	text.settings	a:2:{s:22:"default_summary_length";i:600;s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"Bkewb77RBOK3_aXMPsp8p87gbc03NvmC5gBLzPl7hVA";}}
	core.entity_view_mode.node.full	a:9:{s:4:"uuid";s:36:"79db923d-61cb-466a-aadd-1f0dd900f49f";s:8:"langcode";s:2:"en";s:6:"status";b:0;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"node";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"ElrtInxGjZd7GaapJ5O9n-ugi2hG2IxFivtgn0tHOsk";}s:2:"id";s:9:"node.full";s:5:"label";s:12:"Full content";s:16:"targetEntityType";s:4:"node";s:5:"cache";b:1;}
	core.entity_view_mode.node.rss	a:9:{s:4:"uuid";s:36:"30dd5937-104b-4038-9243-ca3284e1a756";s:8:"langcode";s:2:"en";s:6:"status";b:0;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"node";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"vlYzr-rp2f9NMp-Qlr4sFjlqRq-90mco5-afLNGwCrU";}s:2:"id";s:8:"node.rss";s:5:"label";s:3:"RSS";s:16:"targetEntityType";s:4:"node";s:5:"cache";b:1;}
	core.entity_view_mode.node.search_index	a:9:{s:4:"uuid";s:36:"33d74b88-d495-40a5-845f-e213a579dd8d";s:8:"langcode";s:2:"en";s:6:"status";b:0;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"node";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"fVFfJv_GzBRE-wpRHbfD5a3VjnhbEOXG6lvRd3uaccY";}s:2:"id";s:17:"node.search_index";s:5:"label";s:12:"Search index";s:16:"targetEntityType";s:4:"node";s:5:"cache";b:1;}
	core.entity_view_mode.node.search_result	a:9:{s:4:"uuid";s:36:"650a4e5a-4539-472b-9223-b590b03615ca";s:8:"langcode";s:2:"en";s:6:"status";b:0;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"node";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"6GCOQ-jP2RbdbHA5YWQ6bT8CfGbqrBYKOSC_XY4E3ZM";}s:2:"id";s:18:"node.search_result";s:5:"label";s:32:"Search result highlighting input";s:16:"targetEntityType";s:4:"node";s:5:"cache";b:1;}
	core.entity_view_mode.node.teaser	a:9:{s:4:"uuid";s:36:"221682e7-4df7-4f58-a35e-bce1b22e780c";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"node";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"Mz9qWr1kUYK0mjRAGDsr5XS6PvtZ24en_7ndt-pyWe4";}s:2:"id";s:11:"node.teaser";s:5:"label";s:6:"Teaser";s:16:"targetEntityType";s:4:"node";s:5:"cache";b:1;}
	field.storage.node.body	a:17:{s:4:"uuid";s:36:"be65f75d-5fa0-4343-aa5f-0f1e689b2782";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:6:"module";a:2:{i:0;s:4:"node";i:1;s:4:"text";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"EBUo7qOWqaiZaQ_RC9sLY5IoDKphS34v77VIHSACmVY";}s:2:"id";s:9:"node.body";s:10:"field_name";s:4:"body";s:11:"entity_type";s:4:"node";s:4:"type";s:17:"text_with_summary";s:8:"settings";a:0:{}s:6:"module";s:4:"text";s:6:"locked";b:0;s:11:"cardinality";i:1;s:12:"translatable";b:1;s:7:"indexes";a:0:{}s:22:"persist_with_no_fields";b:1;s:14:"custom_storage";b:0;}
	node.settings	a:2:{s:15:"use_admin_theme";b:0;s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"2OMXCScXUOLSYID9-phjO4q36nnnaMWNUlDxEqZzG1U";}}
	system.action.node_delete_action	a:10:{s:4:"uuid";s:36:"6edf514f-e89c-4371-b3c5-2e192f1d201b";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"node";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"Zx0jD1Klh5tZaGJy8uOeR_2MCu9FDM4xg7TaUJUEbkI";}s:2:"id";s:18:"node_delete_action";s:5:"label";s:14:"Delete content";s:4:"type";s:4:"node";s:6:"plugin";s:18:"node_delete_action";s:13:"configuration";a:0:{}}
	user.role.anonymous	a:10:{s:4:"uuid";s:36:"a8b07ef0-4489-45c0-82d9-f4061afeeaf4";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"j5zLMOdJBqC0bMvSdth5UebkprJB8g_2FXHqhfpJzow";}s:2:"id";s:9:"anonymous";s:5:"label";s:14:"Anonymous user";s:6:"weight";i:0;s:8:"is_admin";b:0;s:11:"permissions";a:1:{i:0;s:14:"access content";}}
	user.settings	a:9:{s:9:"anonymous";s:9:"Anonymous";s:11:"verify_mail";b:1;s:6:"notify";a:8:{s:14:"cancel_confirm";b:1;s:14:"password_reset";b:1;s:16:"status_activated";b:1;s:14:"status_blocked";b:0;s:15:"status_canceled";b:0;s:22:"register_admin_created";b:1;s:29:"register_no_approval_required";b:1;s:25:"register_pending_approval";b:1;}s:8:"register";s:23:"visitors_admin_approval";s:13:"cancel_method";s:17:"user_cancel_block";s:22:"password_reset_timeout";i:86400;s:17:"password_strength";b:1;s:8:"langcode";s:2:"en";s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"r4kwhOM0IWXVMUZDz744Yc16EOh37ZhYbA8kGOhSmLk";}}
	system.action.node_make_sticky_action	a:10:{s:4:"uuid";s:36:"a1a19d64-7a11-4cb6-91fd-65722a2bc14e";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"node";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"sOb26JSy3fGpWkvR0WYN6_hMqj_6d1rvbvrkzp1yya0";}s:2:"id";s:23:"node_make_sticky_action";s:5:"label";s:19:"Make content sticky";s:4:"type";s:4:"node";s:6:"plugin";s:23:"node_make_sticky_action";s:13:"configuration";a:0:{}}
	system.action.node_make_unsticky_action	a:10:{s:4:"uuid";s:36:"3bf212b6-7e24-4d0a-ac01-c4ab31074c1c";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"node";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"lDM9mvIGAu8Sw8rt-uCO4Sr7yX5VPrDPxYcawkbKd6k";}s:2:"id";s:25:"node_make_unsticky_action";s:5:"label";s:21:"Make content unsticky";s:4:"type";s:4:"node";s:6:"plugin";s:25:"node_make_unsticky_action";s:13:"configuration";a:0:{}}
	system.action.node_promote_action	a:10:{s:4:"uuid";s:36:"4526b41e-b086-46d6-812f-3e411bf52684";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"node";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"N0RDBTqiK4dKoN4p4oW2j0SGWycdHyALUe9M-Ofp89U";}s:2:"id";s:19:"node_promote_action";s:5:"label";s:29:"Promote content to front page";s:4:"type";s:4:"node";s:6:"plugin";s:19:"node_promote_action";s:13:"configuration";a:0:{}}
	system.action.node_publish_action	a:10:{s:4:"uuid";s:36:"0667e9ca-dda6-4e4e-85ad-115b3a3b130e";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"node";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"lsQkbo4njZ-Q_oGKCPGXGWFjWF1I7QpgA6m-t9rcRoA";}s:2:"id";s:19:"node_publish_action";s:5:"label";s:15:"Publish content";s:4:"type";s:4:"node";s:6:"plugin";s:19:"node_publish_action";s:13:"configuration";a:0:{}}
	system.action.node_save_action	a:10:{s:4:"uuid";s:36:"4778db72-9b23-4b12-a668-ea304c1b6f9c";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"node";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"U9HspszLxcw6pZmRacFa6yDbbheyMN-We4fPbrWWHGg";}s:2:"id";s:16:"node_save_action";s:5:"label";s:12:"Save content";s:4:"type";s:4:"node";s:6:"plugin";s:16:"node_save_action";s:13:"configuration";a:0:{}}
	system.action.node_unpromote_action	a:10:{s:4:"uuid";s:36:"52c908e0-2f11-4874-8423-179f46c7e3a5";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"node";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"JBptjnfuOMtsdKygklXxoOgeOCTMtQxlkymjnnj-cC0";}s:2:"id";s:21:"node_unpromote_action";s:5:"label";s:30:"Remove content from front page";s:4:"type";s:4:"node";s:6:"plugin";s:21:"node_unpromote_action";s:13:"configuration";a:0:{}}
	system.action.node_unpublish_action	a:10:{s:4:"uuid";s:36:"36bdf044-727d-48f0-8e4c-961dc97dad3c";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:6:"module";a:1:{i:0;s:4:"node";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"gGQXiSspwGl0lyOS6w_HCPpvGAPDciqDNLFwWOydVtI";}s:2:"id";s:21:"node_unpublish_action";s:5:"label";s:17:"Unpublish content";s:4:"type";s:4:"node";s:6:"plugin";s:21:"node_unpublish_action";s:13:"configuration";a:0:{}}
	user.role.authenticated	a:10:{s:4:"uuid";s:36:"ff471ab3-0009-42db-a44e-469038ee0d15";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:0:{}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"dJ0L2DNSj5q6XVZAGsuVDpJTh5UeYkIPwKrUOOpr8YI";}s:2:"id";s:13:"authenticated";s:5:"label";s:18:"Authenticated user";s:6:"weight";i:1;s:8:"is_admin";b:0;s:11:"permissions";a:1:{i:0;s:14:"access content";}}
	dblog.settings	a:2:{s:9:"row_limit";i:1000;s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"e883aGsrt1wFrsydlYU584PZONCSfRy0DtkZ9KzHb58";}}
	block.block.stark_admin	a:13:{s:4:"uuid";s:36:"fa69d33a-df76-4e48-93d6-06574d7d5b75";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:3:{s:6:"config";a:1:{i:0;s:17:"system.menu.admin";}s:6:"module";a:1:{i:0;s:6:"system";}s:5:"theme";a:1:{i:0;s:5:"stark";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"DWAB7HaAfAJerAmyT8B2K-6qxicu9n0PcKVpDr--N4c";}s:2:"id";s:11:"stark_admin";s:5:"theme";s:5:"stark";s:6:"region";s:13:"sidebar_first";s:6:"weight";i:1;s:8:"provider";N;s:6:"plugin";s:23:"system_menu_block:admin";s:8:"settings";a:6:{s:2:"id";s:23:"system_menu_block:admin";s:5:"label";s:14:"Administration";s:8:"provider";s:6:"system";s:13:"label_display";s:7:"visible";s:5:"level";i:1;s:5:"depth";i:0;}s:10:"visibility";a:0:{}}
	block.block.stark_branding	a:13:{s:4:"uuid";s:36:"f3bfa429-a2a4-4bb2-9e53-02619428526d";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:2:{s:6:"module";a:1:{i:0;s:6:"system";}s:5:"theme";a:1:{i:0;s:5:"stark";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"fRKXNB91UxDvEMkzCR8ZBsawfC6Fqbme2gtobei3gu4";}s:2:"id";s:14:"stark_branding";s:5:"theme";s:5:"stark";s:6:"region";s:6:"header";s:6:"weight";i:0;s:8:"provider";N;s:6:"plugin";s:21:"system_branding_block";s:8:"settings";a:7:{s:2:"id";s:21:"system_branding_block";s:5:"label";s:13:"Site branding";s:8:"provider";s:6:"system";s:13:"label_display";s:1:"0";s:13:"use_site_logo";b:1;s:13:"use_site_name";b:1;s:15:"use_site_slogan";b:1;}s:10:"visibility";a:0:{}}
	block.block.stark_local_actions	a:13:{s:4:"uuid";s:36:"99d07e15-91a7-4b58-9fbf-c67899985951";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:5:"theme";a:1:{i:0;s:5:"stark";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"PffmQ-ABSz5tFjWmVsR7NesunDnEivvopnJnBjl8KNE";}s:2:"id";s:19:"stark_local_actions";s:5:"theme";s:5:"stark";s:6:"region";s:7:"content";s:6:"weight";i:-10;s:8:"provider";N;s:6:"plugin";s:19:"local_actions_block";s:8:"settings";a:4:{s:2:"id";s:19:"local_actions_block";s:5:"label";s:21:"Primary admin actions";s:8:"provider";s:4:"core";s:13:"label_display";s:1:"0";}s:10:"visibility";a:0:{}}
	block.block.stark_local_tasks	a:13:{s:4:"uuid";s:36:"de79c9f1-cf2d-449c-8381-14642e01a6b4";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:5:"theme";a:1:{i:0;s:5:"stark";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"c-06bbElRY5sKmglk74ppgTW93Et4-EJFyNiUZMb8JY";}s:2:"id";s:17:"stark_local_tasks";s:5:"theme";s:5:"stark";s:6:"region";s:7:"content";s:6:"weight";i:-20;s:8:"provider";N;s:6:"plugin";s:17:"local_tasks_block";s:8:"settings";a:6:{s:2:"id";s:17:"local_tasks_block";s:5:"label";s:4:"Tabs";s:8:"provider";s:4:"core";s:13:"label_display";s:1:"0";s:7:"primary";b:1;s:9:"secondary";b:1;}s:10:"visibility";a:0:{}}
	block.block.stark_login	a:13:{s:4:"uuid";s:36:"2d2669eb-561b-4ed3-a5d7-0da811be0e15";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:2:{s:6:"module";a:1:{i:0;s:4:"user";}s:5:"theme";a:1:{i:0;s:5:"stark";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"4QlSnWBcxxKMIFRM8sbu_MjSkcp3NjGgnVrc-lynQHI";}s:2:"id";s:11:"stark_login";s:5:"theme";s:5:"stark";s:6:"region";s:13:"sidebar_first";s:6:"weight";i:0;s:8:"provider";N;s:6:"plugin";s:16:"user_login_block";s:8:"settings";a:4:{s:2:"id";s:16:"user_login_block";s:5:"label";s:10:"User login";s:8:"provider";s:4:"user";s:13:"label_display";s:7:"visible";}s:10:"visibility";a:0:{}}
	block.block.stark_messages	a:13:{s:4:"uuid";s:36:"5094077e-aceb-418a-88aa-6647649fa046";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:2:{s:6:"module";a:1:{i:0;s:6:"system";}s:5:"theme";a:1:{i:0;s:5:"stark";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"5MNdk3fpMKx_xxBTcz2T11DL4XEU1H5SgHl8BsYdFsA";}s:2:"id";s:14:"stark_messages";s:5:"theme";s:5:"stark";s:6:"region";s:11:"highlighted";s:6:"weight";i:0;s:8:"provider";N;s:6:"plugin";s:21:"system_messages_block";s:8:"settings";a:4:{s:2:"id";s:21:"system_messages_block";s:5:"label";s:15:"Status messages";s:8:"provider";s:6:"system";s:13:"label_display";s:1:"0";}s:10:"visibility";a:0:{}}
	block.block.stark_page_title	a:13:{s:4:"uuid";s:36:"19652566-787b-4810-8c62-f0310a2056e2";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:1:{s:5:"theme";a:1:{i:0;s:5:"stark";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"8yptDf6WrXxeyevUz4nP5vfr7BtxQqCBMninhV2IJ1g";}s:2:"id";s:16:"stark_page_title";s:5:"theme";s:5:"stark";s:6:"region";s:7:"content";s:6:"weight";i:-30;s:8:"provider";N;s:6:"plugin";s:16:"page_title_block";s:8:"settings";a:4:{s:2:"id";s:16:"page_title_block";s:5:"label";s:10:"Page title";s:8:"provider";s:4:"core";s:13:"label_display";s:1:"0";}s:10:"visibility";a:0:{}}
	block.block.stark_tools	a:13:{s:4:"uuid";s:36:"7eead4c7-6df4-4f33-ae2b-485e5a657765";s:8:"langcode";s:2:"en";s:6:"status";b:1;s:12:"dependencies";a:3:{s:6:"config";a:1:{i:0;s:17:"system.menu.tools";}s:6:"module";a:1:{i:0;s:6:"system";}s:5:"theme";a:1:{i:0;s:5:"stark";}}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"xCOijLdB1-UgXxQ9a0D1_pd8vxNEhfMnxXZc8jYhHjs";}s:2:"id";s:11:"stark_tools";s:5:"theme";s:5:"stark";s:6:"region";s:13:"sidebar_first";s:6:"weight";i:0;s:8:"provider";N;s:6:"plugin";s:23:"system_menu_block:tools";s:8:"settings";a:6:{s:2:"id";s:23:"system_menu_block:tools";s:5:"label";s:5:"Tools";s:8:"provider";s:6:"system";s:13:"label_display";s:7:"visible";s:5:"level";i:1;s:5:"depth";i:0;}s:10:"visibility";a:0:{}}
	file.settings	a:3:{s:11:"description";a:2:{s:4:"type";s:9:"textfield";s:6:"length";i:128;}s:4:"icon";a:1:{s:9:"directory";s:23:"core/modules/file/icons";}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"8LI-1XgwLt9hYRns_7c81S632d6JhdqXKs4vDheaG6E";}}
	update.settings	a:4:{s:5:"check";a:2:{s:19:"disabled_extensions";b:0;s:13:"interval_days";i:1;}s:5:"fetch";a:3:{s:3:"url";s:0:"";s:12:"max_attempts";i:2;s:7:"timeout";i:30;}s:12:"notification";a:2:{s:6:"emails";a:1:{i:0;s:19:"adrian.webb@gsa.gov";}s:9:"threshold";s:3:"all";}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"2QzULf0zovJQx3J06Y9rufzzfi-CY2CTTlEfJJh2Qyw";}}
	core.extension	a:3:{s:6:"module";a:13:{s:5:"block";i:0;s:5:"dblog";i:0;s:18:"dynamic_page_cache";i:0;s:5:"field";i:0;s:4:"file";i:0;s:6:"filter";i:0;s:4:"node";i:0;s:10:"page_cache";i:0;s:6:"system";i:0;s:4:"text";i:0;s:6:"update";i:0;s:4:"user";i:0;s:7:"minimal";i:1000;}s:5:"theme";a:1:{s:5:"stark";i:0;}s:5:"_core";a:1:{s:19:"default_config_hash";s:43:"m2GVq11UAOVuNgj8x0t5fMOPujpvQQ_zxLoaly1BMEU";}}
\.


--
-- Data for Name: file_managed; Type: TABLE DATA; Schema: public; Owner: -
--

COPY file_managed (fid, uuid, langcode, uid, filename, uri, filemime, filesize, status, created, changed) FROM stdin;
\.


--
-- Name: file_managed_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('file_managed_fid_seq', 1, false);


--
-- Data for Name: file_usage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY file_usage (fid, module, type, id, count) FROM stdin;
\.


--
-- Data for Name: key_value; Type: TABLE DATA; Schema: public; Owner: -
--

COPY key_value (collection, name, value) FROM stdin;
entity.definitions.installed	action.entity_type	O:42:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityType":39:{s:16:"\\000*\\000config_prefix";N;s:15:"\\000*\\000static_cache";b:0;s:14:"\\000*\\000lookup_keys";a:1:{i:0;s:4:"uuid";}s:16:"\\000*\\000config_export";a:5:{i:0;s:2:"id";i:1;s:5:"label";i:2;s:4:"type";i:3;s:6:"plugin";i:4;s:13:"configuration";}s:21:"\\000*\\000mergedConfigExport";a:0:{}s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:7:{s:2:"id";s:2:"id";s:5:"label";s:5:"label";s:8:"revision";s:0:"";s:6:"bundle";s:0:"";s:8:"langcode";s:8:"langcode";s:16:"default_langcode";s:16:"default_langcode";s:4:"uuid";s:4:"uuid";}s:5:"\\000*\\000id";s:6:"action";s:11:"\\000*\\000provider";s:6:"system";s:8:"\\000*\\000class";s:27:"Drupal\\\\system\\\\Entity\\\\Action";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:2:{s:6:"access";s:45:"Drupal\\\\Core\\\\Entity\\\\EntityAccessControlHandler";s:7:"storage";s:45:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityStorage";}s:19:"\\000*\\000admin_permission";s:18:"administer actions";s:25:"\\000*\\000permission_granularity";s:11:"entity_type";s:8:"\\000*\\000links";a:0:{}s:17:"\\000*\\000label_callback";N;s:21:"\\000*\\000bundle_entity_type";N;s:12:"\\000*\\000bundle_of";N;s:15:"\\000*\\000bundle_label";N;s:13:"\\000*\\000base_table";N;s:22:"\\000*\\000revision_data_table";N;s:17:"\\000*\\000revision_table";N;s:13:"\\000*\\000data_table";N;s:15:"\\000*\\000translatable";b:0;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:6:"Action";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";s:0:"";s:15:"\\000*\\000label_plural";s:0:"";s:14:"\\000*\\000label_count";a:0:{}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:13:"configuration";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Configuration";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";N;s:26:"\\000*\\000common_reference_target";b:0;s:22:"\\000*\\000list_cache_contexts";a:0:{}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:18:"config:action_list";}s:14:"\\000*\\000constraints";a:0:{}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
entity.definitions.installed	menu.entity_type	O:42:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityType":39:{s:16:"\\000*\\000config_prefix";N;s:15:"\\000*\\000static_cache";b:0;s:14:"\\000*\\000lookup_keys";a:1:{i:0;s:4:"uuid";}s:16:"\\000*\\000config_export";a:4:{i:0;s:2:"id";i:1;s:5:"label";i:2;s:11:"description";i:3;s:6:"locked";}s:21:"\\000*\\000mergedConfigExport";a:0:{}s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:7:{s:2:"id";s:2:"id";s:5:"label";s:5:"label";s:8:"revision";s:0:"";s:6:"bundle";s:0:"";s:8:"langcode";s:8:"langcode";s:16:"default_langcode";s:16:"default_langcode";s:4:"uuid";s:4:"uuid";}s:5:"\\000*\\000id";s:4:"menu";s:11:"\\000*\\000provider";s:6:"system";s:8:"\\000*\\000class";s:25:"Drupal\\\\system\\\\Entity\\\\Menu";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:2:{s:6:"access";s:38:"Drupal\\\\system\\\\MenuAccessControlHandler";s:7:"storage";s:45:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityStorage";}s:19:"\\000*\\000admin_permission";s:15:"administer menu";s:25:"\\000*\\000permission_granularity";s:11:"entity_type";s:8:"\\000*\\000links";a:0:{}s:17:"\\000*\\000label_callback";N;s:21:"\\000*\\000bundle_entity_type";N;s:12:"\\000*\\000bundle_of";N;s:15:"\\000*\\000bundle_label";N;s:13:"\\000*\\000base_table";N;s:22:"\\000*\\000revision_data_table";N;s:17:"\\000*\\000revision_table";N;s:13:"\\000*\\000data_table";N;s:15:"\\000*\\000translatable";b:0;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:4:"Menu";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";s:0:"";s:15:"\\000*\\000label_plural";s:0:"";s:14:"\\000*\\000label_count";a:0:{}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:13:"configuration";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Configuration";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";N;s:26:"\\000*\\000common_reference_target";b:0;s:22:"\\000*\\000list_cache_contexts";a:0:{}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:16:"config:menu_list";}s:14:"\\000*\\000constraints";a:0:{}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
config.entity.key_store.date_format	uuid:ca4937a2-9570-44fc-bdd4-f8d325dc482a	a:1:{i:0;s:25:"core.date_format.fallback";}
config.entity.key_store.date_format	uuid:6fcc87cb-7ff0-49c5-bafe-e55df65d4395	a:1:{i:0;s:26:"core.date_format.html_date";}
config.entity.key_store.date_format	uuid:0e61d569-32ab-4ee8-a2e6-0da2d5a4ebb2	a:1:{i:0;s:30:"core.date_format.html_datetime";}
config.entity.key_store.date_format	uuid:4c63cb33-49ea-4fad-86e0-692bf302f2eb	a:1:{i:0;s:27:"core.date_format.html_month";}
config.entity.key_store.date_format	uuid:5a6d4205-6f2c-47ed-9750-c67af7f6c252	a:1:{i:0;s:26:"core.date_format.html_time";}
config.entity.key_store.date_format	uuid:07184cc4-085c-4d68-8764-cba86a6d865f	a:1:{i:0;s:26:"core.date_format.html_week";}
config.entity.key_store.date_format	uuid:d669e4e2-935e-488d-8a41-0d58a1afddc4	a:1:{i:0;s:26:"core.date_format.html_year";}
config.entity.key_store.date_format	uuid:8542c5c7-656b-4932-b6ea-353556d25cc0	a:1:{i:0;s:35:"core.date_format.html_yearless_date";}
config.entity.key_store.date_format	uuid:1812fd1d-04ce-41d8-ac97-5dd61a6fe6ce	a:1:{i:0;s:21:"core.date_format.long";}
config.entity.key_store.date_format	uuid:15d11cb8-2816-4f71-97a5-68fce03d019f	a:1:{i:0;s:23:"core.date_format.medium";}
config.entity.key_store.date_format	uuid:dfcbbb90-3d30-4ae5-befc-a057626f9538	a:1:{i:0;s:22:"core.date_format.short";}
config.entity.key_store.menu	uuid:469eaacc-e1d4-4472-ac7a-e413052857b8	a:1:{i:0;s:19:"system.menu.account";}
config.entity.key_store.menu	uuid:2968d94a-d85a-4926-8e2c-0235e258eb5e	a:1:{i:0;s:17:"system.menu.admin";}
config.entity.key_store.menu	uuid:bcd03cb8-6819-48d7-9698-d27fae1af931	a:1:{i:0;s:18:"system.menu.footer";}
config.entity.key_store.menu	uuid:d63dd624-898a-4f9c-b0cc-e47e3f8ff39f	a:1:{i:0;s:16:"system.menu.main";}
config.entity.key_store.menu	uuid:008565e5-83e0-422c-a3aa-fb6a37013508	a:1:{i:0;s:17:"system.menu.tools";}
system.schema	system	s:4:"8014";
post_update	existing_updates	a:5:{i:0;s:64:"system_post_update_recalculate_configuration_entity_dependencies";i:1;s:43:"field_post_update_email_widget_size_setting";i:2;s:50:"field_post_update_entity_reference_handler_setting";i:3;s:46:"field_post_update_save_custom_storage_property";i:4;s:54:"block_post_update_disable_blocks_with_missing_contexts";}
state	system.cron_key	s:74:"SnCcaBf-VORsN9SjxCwJ_57zjew7r8Gw8SktdTvI5DIujhD3OlRJYjh1Owv9TGipsdg6QIZSTA";
state	routing.menu_masks.router	a:22:{i:0;i:253;i:1;i:126;i:2;i:125;i:3;i:63;i:4;i:62;i:5;i:61;i:6;i:42;i:7;i:31;i:8;i:30;i:9;i:24;i:10;i:21;i:11;i:15;i:12;i:14;i:13;i:12;i:14;i:11;i:15;i:8;i:16;i:7;i:17;i:6;i:18;i:5;i:19;i:3;i:20;i:2;i:21;i:1;}
entity.storage_schema.sql	node.field_schema_data.nid	a:4:{s:4:"node";a:1:{s:6:"fields";a:1:{s:3:"nid";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:6:"normal";s:8:"not null";b:1;}}}s:15:"node_field_data";a:1:{s:6:"fields";a:1:{s:3:"nid";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:6:"normal";s:8:"not null";b:1;}}}s:13:"node_revision";a:1:{s:6:"fields";a:1:{s:3:"nid";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:6:"normal";s:8:"not null";b:1;}}}s:19:"node_field_revision";a:1:{s:6:"fields";a:1:{s:3:"nid";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:6:"normal";s:8:"not null";b:1;}}}}
state	router.path_roots	a:14:{i:0;s:5:"admin";i:1;s:14:"block-category";i:2;s:4:"file";i:3;s:6:"filter";i:4;s:4:"node";i:5;s:6:"system";i:6;s:4:"cron";i:7;s:12:"machine_name";i:8;s:0:"";i:9;s:9:"<current>";i:10;s:5:"batch";i:11;s:10:"update.php";i:12;s:29:"entity_reference_autocomplete";i:13;s:4:"user";}
state	system.theme_engine.files	a:1:{s:4:"twig";s:38:"core/themes/engines/twig/twig.info.yml";}
entity.definitions.installed	user_role.entity_type	O:42:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityType":39:{s:16:"\\000*\\000config_prefix";s:4:"role";s:15:"\\000*\\000static_cache";b:1;s:14:"\\000*\\000lookup_keys";a:1:{i:0;s:4:"uuid";}s:16:"\\000*\\000config_export";a:5:{i:0;s:2:"id";i:1;s:5:"label";i:2;s:6:"weight";i:3;s:8:"is_admin";i:4;s:11:"permissions";}s:21:"\\000*\\000mergedConfigExport";a:0:{}s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:8:{s:2:"id";s:2:"id";s:6:"weight";s:6:"weight";s:5:"label";s:5:"label";s:8:"revision";s:0:"";s:6:"bundle";s:0:"";s:8:"langcode";s:8:"langcode";s:16:"default_langcode";s:16:"default_langcode";s:4:"uuid";s:4:"uuid";}s:5:"\\000*\\000id";s:9:"user_role";s:11:"\\000*\\000provider";s:4:"user";s:8:"\\000*\\000class";s:23:"Drupal\\\\user\\\\Entity\\\\Role";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:4:{s:7:"storage";s:23:"Drupal\\\\user\\\\RoleStorage";s:6:"access";s:36:"Drupal\\\\user\\\\RoleAccessControlHandler";s:12:"list_builder";s:27:"Drupal\\\\user\\\\RoleListBuilder";s:4:"form";a:2:{s:7:"default";s:20:"Drupal\\\\user\\\\RoleForm";s:6:"delete";s:35:"Drupal\\\\Core\\\\Entity\\\\EntityDeleteForm";}}s:19:"\\000*\\000admin_permission";s:22:"administer permissions";s:25:"\\000*\\000permission_granularity";s:11:"entity_type";s:8:"\\000*\\000links";a:4:{s:11:"delete-form";s:45:"/admin/people/roles/manage/{user_role}/delete";s:9:"edit-form";s:38:"/admin/people/roles/manage/{user_role}";s:21:"edit-permissions-form";s:37:"/admin/people/permissions/{user_role}";s:10:"collection";s:19:"/admin/people/roles";}s:17:"\\000*\\000label_callback";N;s:21:"\\000*\\000bundle_entity_type";N;s:12:"\\000*\\000bundle_of";N;s:15:"\\000*\\000bundle_label";N;s:13:"\\000*\\000base_table";N;s:22:"\\000*\\000revision_data_table";N;s:17:"\\000*\\000revision_table";N;s:13:"\\000*\\000data_table";N;s:15:"\\000*\\000translatable";b:0;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:4:"Role";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";s:0:"";s:15:"\\000*\\000label_plural";s:0:"";s:14:"\\000*\\000label_count";a:0:{}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:13:"configuration";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Configuration";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";N;s:26:"\\000*\\000common_reference_target";b:0;s:22:"\\000*\\000list_cache_contexts";a:0:{}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:21:"config:user_role_list";}s:14:"\\000*\\000constraints";a:0:{}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
entity.storage_schema.sql	user.field_schema_data.uid	a:2:{s:5:"users";a:1:{s:6:"fields";a:1:{s:3:"uid";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:6:"normal";s:8:"not null";b:1;}}}s:16:"users_field_data";a:1:{s:6:"fields";a:1:{s:3:"uid";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:6:"normal";s:8:"not null";b:1;}}}}
entity.storage_schema.sql	user.field_schema_data.uuid	a:1:{s:5:"users";a:2:{s:6:"fields";a:1:{s:4:"uuid";a:4:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:128;s:6:"binary";b:0;s:8:"not null";b:1;}}s:11:"unique keys";a:1:{s:23:"user_field__uuid__value";a:1:{i:0;s:4:"uuid";}}}}
entity.storage_schema.sql	user.field_schema_data.langcode	a:2:{s:5:"users";a:1:{s:6:"fields";a:1:{s:8:"langcode";a:3:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:12;s:8:"not null";b:1;}}}s:16:"users_field_data";a:1:{s:6:"fields";a:1:{s:8:"langcode";a:3:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:12;s:8:"not null";b:1;}}}}
entity.storage_schema.sql	user.field_schema_data.preferred_langcode	a:1:{s:16:"users_field_data";a:1:{s:6:"fields";a:1:{s:18:"preferred_langcode";a:3:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:12;s:8:"not null";b:0;}}}}
entity.storage_schema.sql	user.field_schema_data.preferred_admin_langcode	a:1:{s:16:"users_field_data";a:1:{s:6:"fields";a:1:{s:24:"preferred_admin_langcode";a:3:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:12;s:8:"not null";b:0;}}}}
entity.storage_schema.sql	user.field_schema_data.name	a:1:{s:16:"users_field_data";a:1:{s:6:"fields";a:1:{s:4:"name";a:4:{s:4:"type";s:7:"varchar";s:6:"length";i:60;s:6:"binary";b:0;s:8:"not null";b:1;}}}}
entity.storage_schema.sql	user.field_schema_data.pass	a:1:{s:16:"users_field_data";a:1:{s:6:"fields";a:1:{s:4:"pass";a:4:{s:4:"type";s:7:"varchar";s:6:"length";i:255;s:6:"binary";b:0;s:8:"not null";b:0;}}}}
entity.storage_schema.sql	user.field_schema_data.mail	a:1:{s:16:"users_field_data";a:2:{s:6:"fields";a:1:{s:4:"mail";a:3:{s:4:"type";s:7:"varchar";s:6:"length";i:254;s:8:"not null";b:0;}}s:7:"indexes";a:1:{s:16:"user_field__mail";a:1:{i:0;s:4:"mail";}}}}
entity.storage_schema.sql	user.field_schema_data.timezone	a:1:{s:16:"users_field_data";a:1:{s:6:"fields";a:1:{s:8:"timezone";a:4:{s:4:"type";s:7:"varchar";s:6:"length";i:32;s:6:"binary";b:0;s:8:"not null";b:0;}}}}
entity.storage_schema.sql	user.field_schema_data.status	a:1:{s:16:"users_field_data";a:1:{s:6:"fields";a:1:{s:6:"status";a:3:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";s:8:"not null";b:0;}}}}
entity.storage_schema.sql	user.field_schema_data.created	a:1:{s:16:"users_field_data";a:2:{s:6:"fields";a:1:{s:7:"created";a:2:{s:4:"type";s:3:"int";s:8:"not null";b:1;}}s:7:"indexes";a:1:{s:19:"user_field__created";a:1:{i:0;s:7:"created";}}}}
entity.storage_schema.sql	user.field_schema_data.changed	a:1:{s:16:"users_field_data";a:1:{s:6:"fields";a:1:{s:7:"changed";a:2:{s:4:"type";s:3:"int";s:8:"not null";b:0;}}}}
entity.storage_schema.sql	user.field_schema_data.access	a:1:{s:16:"users_field_data";a:2:{s:6:"fields";a:1:{s:6:"access";a:2:{s:4:"type";s:3:"int";s:8:"not null";b:1;}}s:7:"indexes";a:1:{s:18:"user_field__access";a:1:{i:0;s:6:"access";}}}}
entity.storage_schema.sql	user.field_schema_data.login	a:1:{s:16:"users_field_data";a:1:{s:6:"fields";a:1:{s:5:"login";a:2:{s:4:"type";s:3:"int";s:8:"not null";b:0;}}}}
entity.storage_schema.sql	user.field_schema_data.init	a:1:{s:16:"users_field_data";a:1:{s:6:"fields";a:1:{s:4:"init";a:3:{s:4:"type";s:7:"varchar";s:6:"length";i:254;s:8:"not null";b:0;}}}}
entity.storage_schema.sql	user.field_schema_data.roles	a:1:{s:11:"user__roles";a:4:{s:11:"description";s:34:"Data storage for user field roles.";s:6:"fields";a:7:{s:6:"bundle";a:5:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:128;s:8:"not null";b:1;s:7:"default";s:0:"";s:11:"description";s:88:"The field instance bundle to which this row belongs, used when deleting a field instance";}s:7:"deleted";a:5:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";s:8:"not null";b:1;s:7:"default";i:0;s:11:"description";s:60:"A boolean indicating whether this data item has been deleted";}s:9:"entity_id";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:8:"not null";b:1;s:11:"description";s:38:"The entity id this data is attached to";}s:11:"revision_id";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:8:"not null";b:1;s:11:"description";s:114:"The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id";}s:8:"langcode";a:5:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:32;s:8:"not null";b:1;s:7:"default";s:0:"";s:11:"description";s:37:"The language code for this data item.";}s:5:"delta";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:8:"not null";b:1;s:11:"description";s:67:"The sequence number for this data item, used for multi-value fields";}s:15:"roles_target_id";a:4:{s:11:"description";s:28:"The ID of the target entity.";s:4:"type";s:13:"varchar_ascii";s:6:"length";i:255;s:8:"not null";b:1;}}s:11:"primary key";a:4:{i:0;s:9:"entity_id";i:1;s:7:"deleted";i:2;s:5:"delta";i:3;s:8:"langcode";}s:7:"indexes";a:3:{s:6:"bundle";a:1:{i:0;s:6:"bundle";}s:11:"revision_id";a:1:{i:0;s:11:"revision_id";}s:15:"roles_target_id";a:1:{i:0;s:15:"roles_target_id";}}}}
entity.storage_schema.sql	user.field_schema_data.default_langcode	a:1:{s:16:"users_field_data";a:1:{s:6:"fields";a:1:{s:16:"default_langcode";a:3:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";s:8:"not null";b:1;}}}}
entity.storage_schema.sql	user.entity_schema_data	a:2:{s:5:"users";a:1:{s:11:"primary key";a:1:{i:0;s:3:"uid";}}s:16:"users_field_data";a:3:{s:11:"primary key";a:2:{i:0;s:3:"uid";i:1;s:8:"langcode";}s:7:"indexes";a:1:{s:36:"user__id__default_langcode__langcode";a:3:{i:0;s:3:"uid";i:1;s:16:"default_langcode";i:2;s:8:"langcode";}}s:11:"unique keys";a:1:{s:10:"user__name";a:2:{i:0;s:4:"name";i:1;s:8:"langcode";}}}}
entity.storage_schema.sql	node.field_schema_data.uuid	a:1:{s:4:"node";a:2:{s:6:"fields";a:1:{s:4:"uuid";a:4:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:128;s:6:"binary";b:0;s:8:"not null";b:1;}}s:11:"unique keys";a:1:{s:23:"node_field__uuid__value";a:1:{i:0;s:4:"uuid";}}}}
entity.definitions.installed	user.entity_type	O:36:"Drupal\\\\Core\\\\Entity\\\\ContentEntityType":35:{s:15:"\\000*\\000static_cache";b:1;s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:6:{s:2:"id";s:3:"uid";s:8:"langcode";s:8:"langcode";s:4:"uuid";s:4:"uuid";s:8:"revision";s:0:"";s:6:"bundle";s:0:"";s:16:"default_langcode";s:16:"default_langcode";}s:5:"\\000*\\000id";s:4:"user";s:11:"\\000*\\000provider";s:4:"user";s:8:"\\000*\\000class";s:23:"Drupal\\\\user\\\\Entity\\\\User";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:9:{s:7:"storage";s:23:"Drupal\\\\user\\\\UserStorage";s:14:"storage_schema";s:29:"Drupal\\\\user\\\\UserStorageSchema";s:6:"access";s:36:"Drupal\\\\user\\\\UserAccessControlHandler";s:12:"list_builder";s:27:"Drupal\\\\user\\\\UserListBuilder";s:10:"views_data";s:25:"Drupal\\\\user\\\\UserViewsData";s:14:"route_provider";a:1:{s:4:"html";s:36:"Drupal\\\\user\\\\Entity\\\\UserRouteProvider";}s:4:"form";a:3:{s:7:"default";s:23:"Drupal\\\\user\\\\ProfileForm";s:6:"cancel";s:31:"Drupal\\\\user\\\\Form\\\\UserCancelForm";s:8:"register";s:24:"Drupal\\\\user\\\\RegisterForm";}s:11:"translation";s:37:"Drupal\\\\user\\\\ProfileTranslationHandler";s:12:"view_builder";s:36:"Drupal\\\\Core\\\\Entity\\\\EntityViewBuilder";}s:19:"\\000*\\000admin_permission";s:16:"administer users";s:25:"\\000*\\000permission_granularity";s:11:"entity_type";s:8:"\\000*\\000links";a:4:{s:9:"canonical";s:12:"/user/{user}";s:9:"edit-form";s:17:"/user/{user}/edit";s:11:"cancel-form";s:19:"/user/{user}/cancel";s:10:"collection";s:13:"/admin/people";}s:17:"\\000*\\000label_callback";s:16:"user_format_name";s:21:"\\000*\\000bundle_entity_type";N;s:12:"\\000*\\000bundle_of";N;s:15:"\\000*\\000bundle_label";N;s:13:"\\000*\\000base_table";s:5:"users";s:22:"\\000*\\000revision_data_table";N;s:17:"\\000*\\000revision_table";N;s:13:"\\000*\\000data_table";s:16:"users_field_data";s:15:"\\000*\\000translatable";b:1;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:4:"User";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";s:0:"";s:15:"\\000*\\000label_plural";s:0:"";s:14:"\\000*\\000label_count";a:0:{}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:7:"content";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:7:"Content";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";s:22:"entity.user.admin_form";s:26:"\\000*\\000common_reference_target";b:1;s:22:"\\000*\\000list_cache_contexts";a:0:{}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:9:"user_list";}s:14:"\\000*\\000constraints";a:1:{s:13:"EntityChanged";N;}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
entity.definitions.installed	user.field_storage_definitions	a:17:{s:3:"uid";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"integer";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:3:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:6:"normal";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:2;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:integer";s:8:"settings";a:6:{s:8:"unsigned";b:1;s:4:"size";s:6:"normal";s:3:"min";s:0:"";s:3:"max";s:0:"";s:6:"prefix";s:0:"";s:6:"suffix";s:0:"";}}}s:13:"\\000*\\000definition";a:7:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:7:"User ID";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:12:"The user ID.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"read-only";b:1;s:8:"provider";s:4:"user";s:10:"field_name";s:3:"uid";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}s:4:"uuid";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:4:"uuid";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:3:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:128;s:6:"binary";b:0;}}s:11:"unique keys";a:1:{s:5:"value";a:1:{i:0;s:5:"value";}}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:39;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:15:"field_item:uuid";s:8:"settings";a:3:{s:10:"max_length";i:128;s:8:"is_ascii";b:1;s:14:"case_sensitive";b:0;}}}s:13:"\\000*\\000definition";a:7:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:4:"UUID";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:14:"The user UUID.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"read-only";b:1;s:8:"provider";s:4:"user";s:10:"field_name";s:4:"uuid";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}s:8:"langcode";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:8:"language";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:2:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:12;}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:75;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:19:"field_item:language";s:8:"settings";a:0:{}}}s:13:"\\000*\\000definition";a:7:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Language code";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:23:"The user language code.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:12:"translatable";b:1;s:8:"provider";s:4:"user";s:10:"field_name";s:8:"langcode";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}s:18:"preferred_langcode";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:8:"language";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:2:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:12;}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:105;s:13:"\\000*\\000definition";a:3:{s:4:"type";s:19:"field_item:language";s:8:"settings";a:0:{}s:11:"constraints";a:1:{s:11:"ComplexData";a:1:{s:5:"value";a:2:{s:13:"AllowedValues";a:1:{s:8:"callback";s:60:"Drupal\\\\user\\\\Entity\\\\User::getAllowedConfigurableLanguageCodes";}s:6:"Length";a:1:{s:3:"max";i:12;}}}}}}s:13:"\\000*\\000definition";a:6:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:23:"Preferred language code";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:77:"The user's preferred language code for receiving emails and viewing the site.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:8:"provider";s:4:"user";s:10:"field_name";s:18:"preferred_langcode";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}s:24:"preferred_admin_langcode";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:8:"language";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:2:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:12;}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:141;s:13:"\\000*\\000definition";a:3:{s:4:"type";s:19:"field_item:language";s:8:"settings";a:0:{}s:11:"constraints";a:1:{s:11:"ComplexData";a:1:{s:5:"value";a:2:{s:13:"AllowedValues";a:1:{s:8:"callback";s:60:"Drupal\\\\user\\\\Entity\\\\User::getAllowedConfigurableLanguageCodes";}s:6:"Length";a:1:{s:3:"max";i:12;}}}}}}s:13:"\\000*\\000definition";a:7:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:29:"Preferred admin language code";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:68:"The user's preferred language code for viewing administration pages.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:13:"default_value";a:1:{i:0;a:1:{s:5:"value";N;}}s:8:"provider";s:4:"user";s:10:"field_name";s:24:"preferred_admin_langcode";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}s:4:"name";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:6:"string";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:3:{s:4:"type";s:7:"varchar";s:6:"length";i:255;s:6:"binary";b:0;}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:180;s:13:"\\000*\\000definition";a:3:{s:4:"type";s:17:"field_item:string";s:8:"settings";a:3:{s:10:"max_length";i:255;s:8:"is_ascii";b:0;s:14:"case_sensitive";b:0;}s:5:"class";s:25:"\\\\Drupal\\\\user\\\\UserNameItem";}}s:13:"\\000*\\000definition";a:8:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:4:"Name";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:22:"The name of this user.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:8:"required";b:1;s:11:"constraints";a:2:{s:8:"UserName";a:0:{}s:14:"UserNameUnique";a:0:{}}s:8:"provider";s:4:"user";s:10:"field_name";s:4:"name";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}s:4:"pass";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:8:"password";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:3:{s:4:"type";s:7:"varchar";s:6:"length";i:255;s:6:"binary";b:0;}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:218;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:19:"field_item:password";s:8:"settings";a:3:{s:10:"max_length";i:255;s:8:"is_ascii";b:0;s:14:"case_sensitive";b:0;}}}s:13:"\\000*\\000definition";a:7:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:8:"Password";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:35:"The password of this user (hashed).";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"constraints";a:1:{s:18:"ProtectedUserField";N;}s:8:"provider";s:4:"user";s:10:"field_name";s:4:"pass";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}s:4:"mail";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:5:"email";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:2:{s:4:"type";s:7:"varchar";s:6:"length";i:254;}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:253;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:16:"field_item:email";s:8:"settings";a:0:{}}}s:13:"\\000*\\000definition";a:8:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:5:"Email";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:23:"The email of this user.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:13:"default_value";a:1:{i:0;a:1:{s:5:"value";s:0:"";}}s:11:"constraints";a:3:{s:14:"UserMailUnique";N;s:16:"UserMailRequired";N;s:18:"ProtectedUserField";N;}s:8:"provider";s:4:"user";s:10:"field_name";s:4:"mail";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}s:8:"timezone";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:6:"string";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:3:{s:4:"type";s:7:"varchar";s:6:"length";i:32;s:6:"binary";b:0;}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:289;s:13:"\\000*\\000definition";a:3:{s:4:"type";s:17:"field_item:string";s:8:"settings";a:3:{s:10:"max_length";i:32;s:8:"is_ascii";b:0;s:14:"case_sensitive";b:0;}s:11:"constraints";a:1:{s:11:"ComplexData";a:1:{s:5:"value";a:1:{s:13:"AllowedValues";a:1:{s:8:"callback";s:44:"Drupal\\\\user\\\\Entity\\\\User::getAllowedTimezones";}}}}}}s:13:"\\000*\\000definition";a:6:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:8:"Timezone";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:26:"The timezone of this user.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:8:"provider";s:4:"user";s:10:"field_name";s:8:"timezone";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}s:6:"status";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"boolean";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:2:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:327;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:boolean";s:8:"settings";a:2:{s:8:"on_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:2:"On";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"off_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:3:"Off";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}}}}s:13:"\\000*\\000definition";a:7:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:11:"User status";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:38:"Whether the user is active or blocked.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:13:"default_value";a:1:{i:0;a:1:{s:5:"value";b:0;}}s:8:"provider";s:4:"user";s:10:"field_name";s:6:"status";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}s:7:"created";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"created";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:1:{s:4:"type";s:3:"int";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:367;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:created";s:8:"settings";a:0:{}}}s:13:"\\000*\\000definition";a:6:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:7:"Created";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:35:"The time that the user was created.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:8:"provider";s:4:"user";s:10:"field_name";s:7:"created";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}s:7:"changed";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"changed";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:1:{s:4:"type";s:3:"int";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:395;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:changed";s:8:"settings";a:0:{}}}s:13:"\\000*\\000definition";a:7:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:7:"Changed";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:39:"The time that the user was last edited.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:12:"translatable";b:1;s:8:"provider";s:4:"user";s:10:"field_name";s:7:"changed";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}s:6:"access";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:9:"timestamp";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:1:{s:4:"type";s:3:"int";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:424;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:20:"field_item:timestamp";s:8:"settings";a:0:{}}}s:13:"\\000*\\000definition";a:7:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:11:"Last access";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:46:"The time that the user last accessed the site.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:13:"default_value";a:1:{i:0;a:1:{s:5:"value";i:0;}}s:8:"provider";s:4:"user";s:10:"field_name";s:6:"access";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}s:5:"login";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:9:"timestamp";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:1:{s:4:"type";s:3:"int";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:455;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:20:"field_item:timestamp";s:8:"settings";a:0:{}}}s:13:"\\000*\\000definition";a:7:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:10:"Last login";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:38:"The time that the user last logged in.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:13:"default_value";a:1:{i:0;a:1:{s:5:"value";i:0;}}s:8:"provider";s:4:"user";s:10:"field_name";s:5:"login";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}s:4:"init";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:5:"email";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:2:{s:4:"type";s:7:"varchar";s:6:"length";i:254;}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:486;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:16:"field_item:email";s:8:"settings";a:0:{}}}s:13:"\\000*\\000definition";a:7:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Initial email";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:52:"The email address used for initial account creation.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:13:"default_value";a:1:{i:0;a:1:{s:5:"value";s:0:"";}}s:8:"provider";s:4:"user";s:10:"field_name";s:4:"init";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}s:5:"roles";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:16:"entity_reference";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:9:"target_id";a:3:{s:11:"description";s:28:"The ID of the target entity.";s:4:"type";s:13:"varchar_ascii";s:6:"length";i:255;}}s:7:"indexes";a:1:{s:9:"target_id";a:1:{i:0;s:9:"target_id";}}s:11:"unique keys";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:518;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:27:"field_item:entity_reference";s:8:"settings";a:3:{s:11:"target_type";s:9:"user_role";s:7:"handler";s:7:"default";s:16:"handler_settings";a:0:{}}}}s:13:"\\000*\\000definition";a:7:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:5:"Roles";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"cardinality";i:-1;s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:23:"The roles the user has.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:8:"provider";s:4:"user";s:10:"field_name";s:5:"roles";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}s:16:"default_langcode";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"boolean";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:2:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:554;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:boolean";s:8:"settings";a:2:{s:8:"on_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:2:"On";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"off_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:3:"Off";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}}}}s:13:"\\000*\\000definition";a:9:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:19:"Default translation";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:58:"A flag indicating whether this is the default translation.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:12:"translatable";b:1;s:12:"revisionable";b:1;s:13:"default_value";a:1:{i:0;a:1:{s:5:"value";b:1;}}s:8:"provider";s:4:"user";s:10:"field_name";s:16:"default_langcode";s:11:"entity_type";s:4:"user";s:6:"bundle";N;}}}
config.entity.key_store.entity_form_mode	uuid:c20e65c8-0758-4da0-8f08-0fd1ec6550ca	a:1:{i:0;s:35:"core.entity_form_mode.user.register";}
config.entity.key_store.entity_view_mode	uuid:1738e8cf-44eb-4a5e-97b4-b502bec4ad0a	a:1:{i:0;s:34:"core.entity_view_mode.user.compact";}
config.entity.key_store.entity_view_mode	uuid:ab4a4582-1641-45b3-95af-4840e3fa0bb5	a:1:{i:0;s:31:"core.entity_view_mode.user.full";}
config.entity.key_store.action	uuid:aa5e4e36-35cd-47e2-a44b-86ba53104e69	a:1:{i:0;s:36:"system.action.user_block_user_action";}
config.entity.key_store.action	uuid:83c3b783-4235-4786-b7e7-de51861126dc	a:1:{i:0;s:37:"system.action.user_cancel_user_action";}
config.entity.key_store.action	uuid:cdf8f740-43b5-4658-aa94-57556305490b	a:1:{i:0;s:38:"system.action.user_unblock_user_action";}
config.entity.key_store.user_role	uuid:a8b07ef0-4489-45c0-82d9-f4061afeeaf4	a:1:{i:0;s:19:"user.role.anonymous";}
config.entity.key_store.user_role	uuid:ff471ab3-0009-42db-a44e-469038ee0d15	a:1:{i:0;s:23:"user.role.authenticated";}
system.schema	user	s:4:"8100";
entity.definitions.installed	date_format.entity_type	O:42:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityType":39:{s:16:"\\000*\\000config_prefix";N;s:15:"\\000*\\000static_cache";b:0;s:14:"\\000*\\000lookup_keys";a:1:{i:0;s:4:"uuid";}s:16:"\\000*\\000config_export";a:4:{i:0;s:2:"id";i:1;s:5:"label";i:2;s:6:"locked";i:3;s:7:"pattern";}s:21:"\\000*\\000mergedConfigExport";a:0:{}s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:7:{s:2:"id";s:2:"id";s:5:"label";s:5:"label";s:8:"revision";s:0:"";s:6:"bundle";s:0:"";s:8:"langcode";s:8:"langcode";s:16:"default_langcode";s:16:"default_langcode";s:4:"uuid";s:4:"uuid";}s:5:"\\000*\\000id";s:11:"date_format";s:11:"\\000*\\000provider";s:4:"core";s:8:"\\000*\\000class";s:38:"Drupal\\\\Core\\\\Datetime\\\\Entity\\\\DateFormat";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:4:{s:6:"access";s:44:"Drupal\\\\system\\\\DateFormatAccessControlHandler";s:7:"storage";s:45:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityStorage";s:4:"form";a:3:{s:3:"add";s:36:"Drupal\\\\system\\\\Form\\\\DateFormatAddForm";s:4:"edit";s:37:"Drupal\\\\system\\\\Form\\\\DateFormatEditForm";s:6:"delete";s:39:"Drupal\\\\system\\\\Form\\\\DateFormatDeleteForm";}s:12:"list_builder";s:35:"Drupal\\\\system\\\\DateFormatListBuilder";}s:19:"\\000*\\000admin_permission";s:29:"administer site configuration";s:25:"\\000*\\000permission_granularity";s:11:"entity_type";s:8:"\\000*\\000links";a:3:{s:9:"edit-form";s:61:"/admin/config/regional/date-time/formats/manage/{date_format}";s:11:"delete-form";s:68:"/admin/config/regional/date-time/formats/manage/{date_format}/delete";s:10:"collection";s:40:"/admin/config/regional/date-time/formats";}s:17:"\\000*\\000label_callback";N;s:21:"\\000*\\000bundle_entity_type";N;s:12:"\\000*\\000bundle_of";N;s:15:"\\000*\\000bundle_label";N;s:13:"\\000*\\000base_table";N;s:22:"\\000*\\000revision_data_table";N;s:17:"\\000*\\000revision_table";N;s:13:"\\000*\\000data_table";N;s:15:"\\000*\\000translatable";b:0;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:11:"Date format";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";s:0:"";s:15:"\\000*\\000label_plural";s:0:"";s:14:"\\000*\\000label_count";a:0:{}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:13:"configuration";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Configuration";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";N;s:26:"\\000*\\000common_reference_target";b:0;s:22:"\\000*\\000list_cache_contexts";a:0:{}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:8:"rendered";}s:14:"\\000*\\000constraints";a:0:{}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
entity.definitions.installed	entity_form_display.entity_type	O:42:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityType":39:{s:16:"\\000*\\000config_prefix";N;s:15:"\\000*\\000static_cache";b:0;s:14:"\\000*\\000lookup_keys";a:1:{i:0;s:4:"uuid";}s:16:"\\000*\\000config_export";a:6:{i:0;s:2:"id";i:1;s:16:"targetEntityType";i:2;s:6:"bundle";i:3;s:4:"mode";i:4;s:7:"content";i:5;s:6:"hidden";}s:21:"\\000*\\000mergedConfigExport";a:0:{}s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:7:{s:2:"id";s:2:"id";s:6:"status";s:6:"status";s:8:"revision";s:0:"";s:6:"bundle";s:0:"";s:8:"langcode";s:8:"langcode";s:16:"default_langcode";s:16:"default_langcode";s:4:"uuid";s:4:"uuid";}s:5:"\\000*\\000id";s:19:"entity_form_display";s:11:"\\000*\\000provider";s:4:"core";s:8:"\\000*\\000class";s:43:"Drupal\\\\Core\\\\Entity\\\\Entity\\\\EntityFormDisplay";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:2:{s:6:"access";s:45:"Drupal\\\\Core\\\\Entity\\\\EntityAccessControlHandler";s:7:"storage";s:45:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityStorage";}s:19:"\\000*\\000admin_permission";N;s:25:"\\000*\\000permission_granularity";s:11:"entity_type";s:8:"\\000*\\000links";a:0:{}s:17:"\\000*\\000label_callback";N;s:21:"\\000*\\000bundle_entity_type";N;s:12:"\\000*\\000bundle_of";N;s:15:"\\000*\\000bundle_label";N;s:13:"\\000*\\000base_table";N;s:22:"\\000*\\000revision_data_table";N;s:17:"\\000*\\000revision_table";N;s:13:"\\000*\\000data_table";N;s:15:"\\000*\\000translatable";b:0;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:19:"Entity form display";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";s:0:"";s:15:"\\000*\\000label_plural";s:0:"";s:14:"\\000*\\000label_count";a:0:{}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:13:"configuration";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Configuration";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";N;s:26:"\\000*\\000common_reference_target";b:0;s:22:"\\000*\\000list_cache_contexts";a:0:{}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:31:"config:entity_form_display_list";}s:14:"\\000*\\000constraints";a:0:{}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
entity.definitions.installed	entity_form_mode.entity_type	O:42:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityType":39:{s:16:"\\000*\\000config_prefix";N;s:15:"\\000*\\000static_cache";b:0;s:14:"\\000*\\000lookup_keys";a:1:{i:0;s:4:"uuid";}s:16:"\\000*\\000config_export";a:4:{i:0;s:2:"id";i:1;s:5:"label";i:2;s:16:"targetEntityType";i:3;s:5:"cache";}s:21:"\\000*\\000mergedConfigExport";a:10:{s:4:"uuid";s:4:"uuid";s:8:"langcode";s:8:"langcode";s:6:"status";s:6:"status";s:12:"dependencies";s:12:"dependencies";s:20:"third_party_settings";s:20:"third_party_settings";s:5:"_core";s:5:"_core";s:2:"id";s:2:"id";s:5:"label";s:5:"label";s:16:"targetEntityType";s:16:"targetEntityType";s:5:"cache";s:5:"cache";}s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:7:{s:2:"id";s:2:"id";s:5:"label";s:5:"label";s:8:"revision";s:0:"";s:6:"bundle";s:0:"";s:8:"langcode";s:8:"langcode";s:16:"default_langcode";s:16:"default_langcode";s:4:"uuid";s:4:"uuid";}s:5:"\\000*\\000id";s:16:"entity_form_mode";s:11:"\\000*\\000provider";s:4:"core";s:8:"\\000*\\000class";s:40:"Drupal\\\\Core\\\\Entity\\\\Entity\\\\EntityFormMode";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:2:{s:6:"access";s:45:"Drupal\\\\Core\\\\Entity\\\\EntityAccessControlHandler";s:7:"storage";s:45:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityStorage";}s:19:"\\000*\\000admin_permission";N;s:25:"\\000*\\000permission_granularity";s:11:"entity_type";s:8:"\\000*\\000links";a:0:{}s:17:"\\000*\\000label_callback";N;s:21:"\\000*\\000bundle_entity_type";N;s:12:"\\000*\\000bundle_of";N;s:15:"\\000*\\000bundle_label";N;s:13:"\\000*\\000base_table";N;s:22:"\\000*\\000revision_data_table";N;s:17:"\\000*\\000revision_table";N;s:13:"\\000*\\000data_table";N;s:15:"\\000*\\000translatable";b:0;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:9:"Form mode";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";s:0:"";s:15:"\\000*\\000label_plural";s:0:"";s:14:"\\000*\\000label_count";a:0:{}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:13:"configuration";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Configuration";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";N;s:26:"\\000*\\000common_reference_target";b:0;s:22:"\\000*\\000list_cache_contexts";a:0:{}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:28:"config:entity_form_mode_list";}s:14:"\\000*\\000constraints";a:0:{}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
entity.definitions.installed	entity_view_display.entity_type	O:42:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityType":39:{s:16:"\\000*\\000config_prefix";N;s:15:"\\000*\\000static_cache";b:0;s:14:"\\000*\\000lookup_keys";a:1:{i:0;s:4:"uuid";}s:16:"\\000*\\000config_export";a:6:{i:0;s:2:"id";i:1;s:16:"targetEntityType";i:2;s:6:"bundle";i:3;s:4:"mode";i:4;s:7:"content";i:5;s:6:"hidden";}s:21:"\\000*\\000mergedConfigExport";a:0:{}s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:7:{s:2:"id";s:2:"id";s:6:"status";s:6:"status";s:8:"revision";s:0:"";s:6:"bundle";s:0:"";s:8:"langcode";s:8:"langcode";s:16:"default_langcode";s:16:"default_langcode";s:4:"uuid";s:4:"uuid";}s:5:"\\000*\\000id";s:19:"entity_view_display";s:11:"\\000*\\000provider";s:4:"core";s:8:"\\000*\\000class";s:43:"Drupal\\\\Core\\\\Entity\\\\Entity\\\\EntityViewDisplay";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:2:{s:6:"access";s:45:"Drupal\\\\Core\\\\Entity\\\\EntityAccessControlHandler";s:7:"storage";s:45:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityStorage";}s:19:"\\000*\\000admin_permission";N;s:25:"\\000*\\000permission_granularity";s:11:"entity_type";s:8:"\\000*\\000links";a:0:{}s:17:"\\000*\\000label_callback";N;s:21:"\\000*\\000bundle_entity_type";N;s:12:"\\000*\\000bundle_of";N;s:15:"\\000*\\000bundle_label";N;s:13:"\\000*\\000base_table";N;s:22:"\\000*\\000revision_data_table";N;s:17:"\\000*\\000revision_table";N;s:13:"\\000*\\000data_table";N;s:15:"\\000*\\000translatable";b:0;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:19:"Entity view display";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";s:0:"";s:15:"\\000*\\000label_plural";s:0:"";s:14:"\\000*\\000label_count";a:0:{}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:13:"configuration";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Configuration";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";N;s:26:"\\000*\\000common_reference_target";b:0;s:22:"\\000*\\000list_cache_contexts";a:0:{}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:31:"config:entity_view_display_list";}s:14:"\\000*\\000constraints";a:0:{}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
entity.storage_schema.sql	node.field_schema_data.vid	a:4:{s:4:"node";a:1:{s:6:"fields";a:1:{s:3:"vid";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:6:"normal";s:8:"not null";b:0;}}}s:15:"node_field_data";a:1:{s:6:"fields";a:1:{s:3:"vid";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:6:"normal";s:8:"not null";b:1;}}}s:13:"node_revision";a:1:{s:6:"fields";a:1:{s:3:"vid";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:6:"normal";s:8:"not null";b:1;}}}s:19:"node_field_revision";a:1:{s:6:"fields";a:1:{s:3:"vid";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:6:"normal";s:8:"not null";b:1;}}}}
state	install_task	s:4:"done";
entity.definitions.installed	entity_view_mode.entity_type	O:42:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityType":39:{s:16:"\\000*\\000config_prefix";N;s:15:"\\000*\\000static_cache";b:0;s:14:"\\000*\\000lookup_keys";a:1:{i:0;s:4:"uuid";}s:16:"\\000*\\000config_export";a:4:{i:0;s:2:"id";i:1;s:5:"label";i:2;s:16:"targetEntityType";i:3;s:5:"cache";}s:21:"\\000*\\000mergedConfigExport";a:10:{s:4:"uuid";s:4:"uuid";s:8:"langcode";s:8:"langcode";s:6:"status";s:6:"status";s:12:"dependencies";s:12:"dependencies";s:20:"third_party_settings";s:20:"third_party_settings";s:5:"_core";s:5:"_core";s:2:"id";s:2:"id";s:5:"label";s:5:"label";s:16:"targetEntityType";s:16:"targetEntityType";s:5:"cache";s:5:"cache";}s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:7:{s:2:"id";s:2:"id";s:5:"label";s:5:"label";s:8:"revision";s:0:"";s:6:"bundle";s:0:"";s:8:"langcode";s:8:"langcode";s:16:"default_langcode";s:16:"default_langcode";s:4:"uuid";s:4:"uuid";}s:5:"\\000*\\000id";s:16:"entity_view_mode";s:11:"\\000*\\000provider";s:4:"core";s:8:"\\000*\\000class";s:40:"Drupal\\\\Core\\\\Entity\\\\Entity\\\\EntityViewMode";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:2:{s:6:"access";s:45:"Drupal\\\\Core\\\\Entity\\\\EntityAccessControlHandler";s:7:"storage";s:45:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityStorage";}s:19:"\\000*\\000admin_permission";N;s:25:"\\000*\\000permission_granularity";s:11:"entity_type";s:8:"\\000*\\000links";a:0:{}s:17:"\\000*\\000label_callback";N;s:21:"\\000*\\000bundle_entity_type";N;s:12:"\\000*\\000bundle_of";N;s:15:"\\000*\\000bundle_label";N;s:13:"\\000*\\000base_table";N;s:22:"\\000*\\000revision_data_table";N;s:17:"\\000*\\000revision_table";N;s:13:"\\000*\\000data_table";N;s:15:"\\000*\\000translatable";b:0;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:9:"View mode";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";s:0:"";s:15:"\\000*\\000label_plural";s:0:"";s:14:"\\000*\\000label_count";a:0:{}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:13:"configuration";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Configuration";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";N;s:26:"\\000*\\000common_reference_target";b:0;s:22:"\\000*\\000list_cache_contexts";a:0:{}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:28:"config:entity_view_mode_list";}s:14:"\\000*\\000constraints";a:0:{}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
entity.definitions.installed	base_field_override.entity_type	O:42:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityType":39:{s:16:"\\000*\\000config_prefix";s:19:"base_field_override";s:15:"\\000*\\000static_cache";b:0;s:14:"\\000*\\000lookup_keys";a:1:{i:0;s:4:"uuid";}s:16:"\\000*\\000config_export";a:12:{i:0;s:2:"id";i:1;s:10:"field_name";i:2;s:11:"entity_type";i:3;s:6:"bundle";i:4;s:5:"label";i:5;s:11:"description";i:6;s:8:"required";i:7;s:12:"translatable";i:8;s:13:"default_value";i:9;s:22:"default_value_callback";i:10;s:8:"settings";i:11;s:10:"field_type";}s:21:"\\000*\\000mergedConfigExport";a:0:{}s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:7:{s:2:"id";s:2:"id";s:5:"label";s:5:"label";s:8:"revision";s:0:"";s:6:"bundle";s:0:"";s:8:"langcode";s:8:"langcode";s:16:"default_langcode";s:16:"default_langcode";s:4:"uuid";s:4:"uuid";}s:5:"\\000*\\000id";s:19:"base_field_override";s:11:"\\000*\\000provider";s:4:"core";s:8:"\\000*\\000class";s:42:"Drupal\\\\Core\\\\Field\\\\Entity\\\\BaseFieldOverride";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:2:{s:7:"storage";s:42:"Drupal\\\\Core\\\\Field\\\\BaseFieldOverrideStorage";s:6:"access";s:45:"Drupal\\\\Core\\\\Entity\\\\EntityAccessControlHandler";}s:19:"\\000*\\000admin_permission";N;s:25:"\\000*\\000permission_granularity";s:11:"entity_type";s:8:"\\000*\\000links";a:0:{}s:17:"\\000*\\000label_callback";N;s:21:"\\000*\\000bundle_entity_type";N;s:12:"\\000*\\000bundle_of";N;s:15:"\\000*\\000bundle_label";N;s:13:"\\000*\\000base_table";N;s:22:"\\000*\\000revision_data_table";N;s:17:"\\000*\\000revision_table";N;s:13:"\\000*\\000data_table";N;s:15:"\\000*\\000translatable";b:0;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:19:"Base field override";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";s:0:"";s:15:"\\000*\\000label_plural";s:0:"";s:14:"\\000*\\000label_count";a:0:{}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:13:"configuration";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Configuration";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";N;s:26:"\\000*\\000common_reference_target";b:0;s:22:"\\000*\\000list_cache_contexts";a:0:{}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:31:"config:base_field_override_list";}s:14:"\\000*\\000constraints";a:0:{}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
state	system.private_key	s:74:"7NtpVVhlb_hZB6vy3HRr9U-yFZDfw1XN7MGXeBkiiSBxCYnga4ExWMGm2MemSTeUE_KV1H-U9Q";
entity.definitions.installed	field_config.entity_type	O:42:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityType":39:{s:16:"\\000*\\000config_prefix";s:5:"field";s:15:"\\000*\\000static_cache";b:0;s:14:"\\000*\\000lookup_keys";a:1:{i:0;s:4:"uuid";}s:16:"\\000*\\000config_export";a:12:{i:0;s:2:"id";i:1;s:10:"field_name";i:2;s:11:"entity_type";i:3;s:6:"bundle";i:4;s:5:"label";i:5;s:11:"description";i:6;s:8:"required";i:7;s:12:"translatable";i:8;s:13:"default_value";i:9;s:22:"default_value_callback";i:10;s:8:"settings";i:11;s:10:"field_type";}s:21:"\\000*\\000mergedConfigExport";a:0:{}s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:7:{s:2:"id";s:2:"id";s:5:"label";s:5:"label";s:8:"revision";s:0:"";s:6:"bundle";s:0:"";s:8:"langcode";s:8:"langcode";s:16:"default_langcode";s:16:"default_langcode";s:4:"uuid";s:4:"uuid";}s:5:"\\000*\\000id";s:12:"field_config";s:11:"\\000*\\000provider";s:5:"field";s:8:"\\000*\\000class";s:31:"Drupal\\\\field\\\\Entity\\\\FieldConfig";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:2:{s:6:"access";s:44:"Drupal\\\\field\\\\FieldConfigAccessControlHandler";s:7:"storage";s:31:"Drupal\\\\field\\\\FieldConfigStorage";}s:19:"\\000*\\000admin_permission";N;s:25:"\\000*\\000permission_granularity";s:11:"entity_type";s:8:"\\000*\\000links";a:0:{}s:17:"\\000*\\000label_callback";N;s:21:"\\000*\\000bundle_entity_type";N;s:12:"\\000*\\000bundle_of";N;s:15:"\\000*\\000bundle_label";N;s:13:"\\000*\\000base_table";N;s:22:"\\000*\\000revision_data_table";N;s:17:"\\000*\\000revision_table";N;s:13:"\\000*\\000data_table";N;s:15:"\\000*\\000translatable";b:0;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:5:"Field";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";s:0:"";s:15:"\\000*\\000label_plural";s:0:"";s:14:"\\000*\\000label_count";a:0:{}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:13:"configuration";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Configuration";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";N;s:26:"\\000*\\000common_reference_target";b:0;s:22:"\\000*\\000list_cache_contexts";a:0:{}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:24:"config:field_config_list";}s:14:"\\000*\\000constraints";a:0:{}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
entity.definitions.installed	field_storage_config.entity_type	O:42:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityType":39:{s:16:"\\000*\\000config_prefix";s:7:"storage";s:15:"\\000*\\000static_cache";b:0;s:14:"\\000*\\000lookup_keys";a:1:{i:0;s:4:"uuid";}s:16:"\\000*\\000config_export";a:12:{i:0;s:2:"id";i:1;s:10:"field_name";i:2;s:11:"entity_type";i:3;s:4:"type";i:4;s:8:"settings";i:5;s:6:"module";i:6;s:6:"locked";i:7;s:11:"cardinality";i:8;s:12:"translatable";i:9;s:7:"indexes";i:10;s:22:"persist_with_no_fields";i:11;s:14:"custom_storage";}s:21:"\\000*\\000mergedConfigExport";a:0:{}s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:7:{s:2:"id";s:2:"id";s:5:"label";s:2:"id";s:8:"revision";s:0:"";s:6:"bundle";s:0:"";s:8:"langcode";s:8:"langcode";s:16:"default_langcode";s:16:"default_langcode";s:4:"uuid";s:4:"uuid";}s:5:"\\000*\\000id";s:20:"field_storage_config";s:11:"\\000*\\000provider";s:5:"field";s:8:"\\000*\\000class";s:38:"Drupal\\\\field\\\\Entity\\\\FieldStorageConfig";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:2:{s:7:"storage";s:38:"Drupal\\\\field\\\\FieldStorageConfigStorage";s:6:"access";s:45:"Drupal\\\\Core\\\\Entity\\\\EntityAccessControlHandler";}s:19:"\\000*\\000admin_permission";N;s:25:"\\000*\\000permission_granularity";s:11:"entity_type";s:8:"\\000*\\000links";a:0:{}s:17:"\\000*\\000label_callback";N;s:21:"\\000*\\000bundle_entity_type";N;s:12:"\\000*\\000bundle_of";N;s:15:"\\000*\\000bundle_label";N;s:13:"\\000*\\000base_table";N;s:22:"\\000*\\000revision_data_table";N;s:17:"\\000*\\000revision_table";N;s:13:"\\000*\\000data_table";N;s:15:"\\000*\\000translatable";b:0;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Field storage";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";s:0:"";s:15:"\\000*\\000label_plural";s:0:"";s:14:"\\000*\\000label_count";a:0:{}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:13:"configuration";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Configuration";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";N;s:26:"\\000*\\000common_reference_target";b:0;s:22:"\\000*\\000list_cache_contexts";a:0:{}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:32:"config:field_storage_config_list";}s:14:"\\000*\\000constraints";a:0:{}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
system.schema	field	s:4:"8003";
entity.definitions.installed	filter_format.entity_type	O:42:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityType":39:{s:16:"\\000*\\000config_prefix";s:6:"format";s:15:"\\000*\\000static_cache";b:0;s:14:"\\000*\\000lookup_keys";a:1:{i:0;s:4:"uuid";}s:16:"\\000*\\000config_export";a:5:{i:0;s:4:"name";i:1;s:6:"format";i:2;s:6:"weight";i:3;s:5:"roles";i:4;s:7:"filters";}s:21:"\\000*\\000mergedConfigExport";a:0:{}s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:9:{s:2:"id";s:6:"format";s:5:"label";s:4:"name";s:6:"weight";s:6:"weight";s:6:"status";s:6:"status";s:8:"revision";s:0:"";s:6:"bundle";s:0:"";s:8:"langcode";s:8:"langcode";s:16:"default_langcode";s:16:"default_langcode";s:4:"uuid";s:4:"uuid";}s:5:"\\000*\\000id";s:13:"filter_format";s:11:"\\000*\\000provider";s:6:"filter";s:8:"\\000*\\000class";s:33:"Drupal\\\\filter\\\\Entity\\\\FilterFormat";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:4:{s:4:"form";a:3:{s:3:"add";s:33:"Drupal\\\\filter\\\\FilterFormatAddForm";s:4:"edit";s:34:"Drupal\\\\filter\\\\FilterFormatEditForm";s:7:"disable";s:36:"Drupal\\\\filter\\\\Form\\\\FilterDisableForm";}s:12:"list_builder";s:37:"Drupal\\\\filter\\\\FilterFormatListBuilder";s:6:"access";s:46:"Drupal\\\\filter\\\\FilterFormatAccessControlHandler";s:7:"storage";s:45:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityStorage";}s:19:"\\000*\\000admin_permission";s:18:"administer filters";s:25:"\\000*\\000permission_granularity";s:11:"entity_type";s:8:"\\000*\\000links";a:2:{s:9:"edit-form";s:52:"/admin/config/content/formats/manage/{filter_format}";s:7:"disable";s:60:"/admin/config/content/formats/manage/{filter_format}/disable";}s:17:"\\000*\\000label_callback";N;s:21:"\\000*\\000bundle_entity_type";N;s:12:"\\000*\\000bundle_of";N;s:15:"\\000*\\000bundle_label";N;s:13:"\\000*\\000base_table";N;s:22:"\\000*\\000revision_data_table";N;s:17:"\\000*\\000revision_table";N;s:13:"\\000*\\000data_table";N;s:15:"\\000*\\000translatable";b:0;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:11:"Text format";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";s:0:"";s:15:"\\000*\\000label_plural";s:0:"";s:14:"\\000*\\000label_count";a:0:{}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:13:"configuration";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Configuration";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";N;s:26:"\\000*\\000common_reference_target";b:0;s:22:"\\000*\\000list_cache_contexts";a:0:{}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:25:"config:filter_format_list";}s:14:"\\000*\\000constraints";a:0:{}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
config.entity.key_store.filter_format	uuid:1f34c846-0c64-41db-9704-2a68568b8b97	a:1:{i:0;s:24:"filter.format.plain_text";}
system.schema	filter	i:8000;
system.schema	text	i:8000;
entity.definitions.installed	block.entity_type	O:42:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityType":39:{s:16:"\\000*\\000config_prefix";N;s:15:"\\000*\\000static_cache";b:0;s:14:"\\000*\\000lookup_keys";a:2:{i:0;s:5:"theme";i:1;s:4:"uuid";}s:16:"\\000*\\000config_export";a:8:{i:0;s:2:"id";i:1;s:5:"theme";i:2;s:6:"region";i:3;s:6:"weight";i:4;s:8:"provider";i:5;s:6:"plugin";i:6;s:8:"settings";i:7;s:10:"visibility";}s:21:"\\000*\\000mergedConfigExport";a:0:{}s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:6:{s:2:"id";s:2:"id";s:8:"revision";s:0:"";s:6:"bundle";s:0:"";s:8:"langcode";s:8:"langcode";s:16:"default_langcode";s:16:"default_langcode";s:4:"uuid";s:4:"uuid";}s:5:"\\000*\\000id";s:5:"block";s:11:"\\000*\\000provider";s:5:"block";s:8:"\\000*\\000class";s:25:"Drupal\\\\block\\\\Entity\\\\Block";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:5:{s:6:"access";s:38:"Drupal\\\\block\\\\BlockAccessControlHandler";s:12:"view_builder";s:29:"Drupal\\\\block\\\\BlockViewBuilder";s:12:"list_builder";s:29:"Drupal\\\\block\\\\BlockListBuilder";s:4:"form";a:2:{s:7:"default";s:22:"Drupal\\\\block\\\\BlockForm";s:6:"delete";s:33:"Drupal\\\\block\\\\Form\\\\BlockDeleteForm";}s:7:"storage";s:45:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityStorage";}s:19:"\\000*\\000admin_permission";s:17:"administer blocks";s:25:"\\000*\\000permission_granularity";s:11:"entity_type";s:8:"\\000*\\000links";a:2:{s:11:"delete-form";s:44:"/admin/structure/block/manage/{block}/delete";s:9:"edit-form";s:37:"/admin/structure/block/manage/{block}";}s:17:"\\000*\\000label_callback";N;s:21:"\\000*\\000bundle_entity_type";N;s:12:"\\000*\\000bundle_of";N;s:15:"\\000*\\000bundle_label";N;s:13:"\\000*\\000base_table";N;s:22:"\\000*\\000revision_data_table";N;s:17:"\\000*\\000revision_table";N;s:13:"\\000*\\000data_table";N;s:15:"\\000*\\000translatable";b:0;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:5:"Block";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";s:0:"";s:15:"\\000*\\000label_plural";s:0:"";s:14:"\\000*\\000label_count";a:0:{}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:13:"configuration";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Configuration";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";N;s:26:"\\000*\\000common_reference_target";b:0;s:22:"\\000*\\000list_cache_contexts";a:0:{}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:17:"config:block_list";}s:14:"\\000*\\000constraints";a:0:{}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
system.schema	block	s:4:"8003";
state	system.module.files	a:125:{s:6:"action";s:35:"core/modules/action/action.info.yml";s:10:"aggregator";s:43:"core/modules/aggregator/aggregator.info.yml";s:14:"automated_cron";s:51:"core/modules/automated_cron/automated_cron.info.yml";s:14:"backup_migrate";s:54:"modules/contrib/backup_migrate/backup_migrate.info.yml";s:3:"ban";s:29:"core/modules/ban/ban.info.yml";s:10:"basic_auth";s:43:"core/modules/basic_auth/basic_auth.info.yml";s:8:"big_pipe";s:39:"core/modules/big_pipe/big_pipe.info.yml";s:5:"block";s:33:"core/modules/block/block.info.yml";s:13:"block_content";s:49:"core/modules/block_content/block_content.info.yml";s:17:"block_page_layout";s:82:"modules/contrib/layout_plugin/modules/block_page_layout/block_page_layout.info.yml";s:4:"book";s:31:"core/modules/book/book.info.yml";s:17:"bootstrap_layouts";s:60:"modules/contrib/bootstrap_layouts/bootstrap_layouts.info.yml";s:10:"breakpoint";s:43:"core/modules/breakpoint/breakpoint.info.yml";s:8:"ckeditor";s:39:"core/modules/ckeditor/ckeditor.info.yml";s:5:"color";s:33:"core/modules/color/color.info.yml";s:7:"comment";s:37:"core/modules/comment/comment.info.yml";s:6:"config";s:35:"core/modules/config/config.info.yml";s:18:"config_translation";s:59:"core/modules/config_translation/config_translation.info.yml";s:7:"contact";s:37:"core/modules/contact/contact.info.yml";s:19:"content_translation";s:61:"core/modules/content_translation/content_translation.info.yml";s:10:"contextual";s:43:"core/modules/contextual/contextual.info.yml";s:18:"core_search_facets";s:69:"modules/contrib/facets/core_search_facets/core_search_facets.info.yml";s:17:"csv_serialization";s:60:"modules/contrib/csv_serialization/csv_serialization.info.yml";s:6:"ctools";s:38:"modules/contrib/ctools/ctools.info.yml";s:12:"ctools_block";s:65:"modules/contrib/ctools/modules/ctools_block/ctools_block.info.yml";s:12:"ctools_views";s:65:"modules/contrib/ctools/modules/ctools_views/ctools_views.info.yml";s:8:"datetime";s:39:"core/modules/datetime/datetime.info.yml";s:5:"dblog";s:33:"core/modules/dblog/dblog.info.yml";s:15:"default_content";s:56:"modules/contrib/default_content/default_content.info.yml";s:6:"deploy";s:38:"modules/contrib/deploy/deploy.info.yml";s:8:"dev_mode";s:41:"modules/custom/dev_mode/dev_mode.info.yml";s:5:"devel";s:36:"modules/contrib/devel/devel.info.yml";s:14:"devel_generate";s:60:"modules/contrib/devel/devel_generate/devel_generate.info.yml";s:17:"devel_node_access";s:66:"modules/contrib/devel/devel_node_access/devel_node_access.info.yml";s:2:"ds";s:30:"modules/contrib/ds/ds.info.yml";s:8:"ds_devel";s:53:"modules/contrib/ds/modules/ds_devel/ds_devel.info.yml";s:9:"ds_extras";s:55:"modules/contrib/ds/modules/ds_extras/ds_extras.info.yml";s:19:"ds_switch_view_mode";s:75:"modules/contrib/ds/modules/ds_switch_view_mode/ds_switch_view_mode.info.yml";s:18:"dynamic_page_cache";s:59:"core/modules/dynamic_page_cache/dynamic_page_cache.info.yml";s:6:"editor";s:35:"core/modules/editor/editor.info.yml";s:16:"entity_reference";s:55:"core/modules/entity_reference/entity_reference.info.yml";s:26:"entity_reference_revisions";s:78:"modules/contrib/entity_reference_revisions/entity_reference_revisions.info.yml";s:22:"entity_storage_migrate";s:70:"modules/contrib/entity_storage_migrate/entity_storage_migrate.info.yml";s:6:"facets";s:38:"modules/contrib/facets/facets.info.yml";s:5:"field";s:33:"core/modules/field/field.info.yml";s:11:"field_group";s:48:"modules/contrib/field_group/field_group.info.yml";s:19:"field_group_migrate";s:84:"modules/contrib/field_group/contrib/field_group_migrate/field_group_migrate.info.yml";s:17:"field_permissions";s:60:"modules/contrib/field_permissions/field_permissions.info.yml";s:8:"field_ui";s:39:"core/modules/field_ui/field_ui.info.yml";s:4:"file";s:31:"core/modules/file/file.info.yml";s:6:"filter";s:35:"core/modules/filter/filter.info.yml";s:9:"flysystem";s:44:"modules/contrib/flysystem/flysystem.info.yml";s:12:"flysystem_s3";s:50:"modules/contrib/flysystem_s3/flysystem_s3.info.yml";s:5:"forum";s:33:"core/modules/forum/forum.info.yml";s:3:"hal";s:29:"core/modules/hal/hal.info.yml";s:4:"help";s:31:"core/modules/help/help.info.yml";s:7:"history";s:37:"core/modules/history/history.info.yml";s:5:"image";s:33:"core/modules/image/image.info.yml";s:18:"inline_form_errors";s:59:"core/modules/inline_form_errors/inline_form_errors.info.yml";s:13:"kanban_entity";s:51:"modules/custom/kanban_entity/kanban_entity.info.yml";s:9:"key_value";s:44:"modules/contrib/key_value/key_value.info.yml";s:4:"kint";s:40:"modules/contrib/devel/kint/kint.info.yml";s:8:"language";s:39:"core/modules/language/language.info.yml";s:13:"layout_plugin";s:52:"modules/contrib/layout_plugin/layout_plugin.info.yml";s:21:"layout_plugin_example";s:90:"modules/contrib/layout_plugin/modules/layout_plugin_example/layout_plugin_example.info.yml";s:4:"link";s:31:"core/modules/link/link.info.yml";s:20:"local_task_processor";s:65:"modules/custom/local_task_processor/local_task_processor.info.yml";s:6:"locale";s:35:"core/modules/locale/locale.info.yml";s:16:"menu_link_config";s:58:"modules/contrib/menu_link_config/menu_link_config.info.yml";s:17:"menu_link_content";s:57:"core/modules/menu_link_content/menu_link_content.info.yml";s:7:"menu_ui";s:37:"core/modules/menu_ui/menu_ui.info.yml";s:7:"migrate";s:37:"core/modules/migrate/migrate.info.yml";s:14:"migrate_drupal";s:51:"core/modules/migrate_drupal/migrate_drupal.info.yml";s:17:"migrate_drupal_ui";s:57:"core/modules/migrate_drupal_ui/migrate_drupal_ui.info.yml";s:7:"minimal";s:38:"core/profiles/minimal/minimal.info.yml";s:12:"multiversion";s:50:"modules/contrib/multiversion/multiversion.info.yml";s:10:"navigation";s:45:"modules/custom/navigation/navigation.info.yml";s:4:"node";s:31:"core/modules/node/node.info.yml";s:7:"options";s:37:"core/modules/options/options.info.yml";s:10:"page_cache";s:43:"core/modules/page_cache/page_cache.info.yml";s:12:"page_manager";s:50:"modules/contrib/page_manager/page_manager.info.yml";s:15:"page_manager_ui";s:69:"modules/contrib/page_manager/page_manager_ui/page_manager_ui.info.yml";s:9:"panelizer";s:44:"modules/contrib/panelizer/panelizer.info.yml";s:14:"panelizer_user";s:53:"modules/custom/panelizer_user/panelizer_user.info.yml";s:6:"panels";s:38:"modules/contrib/panels/panels.info.yml";s:10:"panels_ipe";s:53:"modules/contrib/panels/panels_ipe/panels_ipe.info.yml";s:4:"path";s:31:"core/modules/path/path.info.yml";s:9:"quickedit";s:41:"core/modules/quickedit/quickedit.info.yml";s:3:"rdf";s:29:"core/modules/rdf/rdf.info.yml";s:7:"relaxed";s:40:"modules/contrib/relaxed/relaxed.info.yml";s:11:"replication";s:48:"modules/contrib/replication/replication.info.yml";s:16:"responsive_image";s:55:"core/modules/responsive_image/responsive_image.info.yml";s:4:"rest";s:31:"core/modules/rest/rest.info.yml";s:6:"restui";s:38:"modules/contrib/restui/restui.info.yml";s:5:"rules";s:36:"modules/contrib/rules/rules.info.yml";s:6:"search";s:35:"core/modules/search/search.info.yml";s:10:"search_api";s:46:"modules/contrib/search_api/search_api.info.yml";s:13:"search_api_db";s:63:"modules/contrib/search_api/search_api_db/search_api_db.info.yml";s:22:"search_api_db_defaults";s:95:"modules/contrib/search_api/search_api_db/search_api_db_defaults/search_api_db_defaults.info.yml";s:13:"serialization";s:49:"core/modules/serialization/serialization.info.yml";s:8:"shortcut";s:39:"core/modules/shortcut/shortcut.info.yml";s:12:"simple_oauth";s:50:"modules/contrib/simple_oauth/simple_oauth.info.yml";s:10:"simpletest";s:43:"core/modules/simpletest/simpletest.info.yml";s:10:"statistics";s:43:"core/modules/statistics/statistics.info.yml";s:6:"syslog";s:35:"core/modules/syslog/syslog.info.yml";s:6:"system";s:35:"core/modules/system/system.info.yml";s:8:"taxonomy";s:39:"core/modules/taxonomy/taxonomy.info.yml";s:9:"telephone";s:41:"core/modules/telephone/telephone.info.yml";s:4:"text";s:31:"core/modules/text/text.info.yml";s:7:"toolbar";s:37:"core/modules/toolbar/toolbar.info.yml";s:4:"tour";s:31:"core/modules/tour/tour.info.yml";s:7:"tracker";s:37:"core/modules/tracker/tracker.info.yml";s:6:"update";s:35:"core/modules/update/update.info.yml";s:4:"user";s:31:"core/modules/user/user.info.yml";s:5:"views";s:33:"core/modules/views/views.info.yml";s:8:"views_ui";s:39:"core/modules/views_ui/views_ui.info.yml";s:11:"webprofiler";s:54:"modules/contrib/devel/webprofiler/webprofiler.info.yml";s:8:"workflow";s:42:"modules/contrib/workflow/workflow.info.yml";s:15:"workflow_access";s:73:"modules/contrib/workflow/modules/workflow_access/workflow_access.info.yml";s:16:"workflow_cleanup";s:75:"modules/contrib/workflow/modules/workflow_cleanup/workflow_cleanup.info.yml";s:14:"workflow_devel";s:71:"modules/contrib/workflow/modules/workflow_devel/workflow_devel.info.yml";s:19:"workflow_operations";s:81:"modules/contrib/workflow/modules/workflow_operations/workflow_operations.info.yml";s:11:"workflow_ui";s:65:"modules/contrib/workflow/modules/workflow_ui/workflow_ui.info.yml";s:13:"workflowfield";s:70:"modules/contrib/workflow/modules/workflow_field/workflowfield.info.yml";s:9:"workspace";s:44:"modules/contrib/workspace/workspace.info.yml";}
entity.storage_schema.sql	file.field_schema_data.filesize	a:1:{s:12:"file_managed";a:1:{s:6:"fields";a:1:{s:8:"filesize";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:3:"big";s:8:"not null";b:0;}}}}
entity.storage_schema.sql	node.field_schema_data.langcode	a:4:{s:4:"node";a:1:{s:6:"fields";a:1:{s:8:"langcode";a:3:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:12;s:8:"not null";b:1;}}}s:15:"node_field_data";a:1:{s:6:"fields";a:1:{s:8:"langcode";a:3:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:12;s:8:"not null";b:1;}}}s:13:"node_revision";a:2:{s:6:"fields";a:1:{s:8:"langcode";a:3:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:12;s:8:"not null";b:1;}}s:7:"indexes";a:1:{s:20:"node_field__langcode";a:1:{i:0;s:8:"langcode";}}}s:19:"node_field_revision";a:1:{s:6:"fields";a:1:{s:8:"langcode";a:3:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:12;s:8:"not null";b:1;}}}}
entity.storage_schema.sql	node.field_schema_data.type	a:2:{s:4:"node";a:2:{s:6:"fields";a:1:{s:4:"type";a:4:{s:11:"description";s:28:"The ID of the target entity.";s:4:"type";s:13:"varchar_ascii";s:6:"length";i:32;s:8:"not null";b:1;}}s:7:"indexes";a:1:{s:27:"node_field__type__target_id";a:1:{i:0;s:4:"type";}}}s:15:"node_field_data";a:2:{s:6:"fields";a:1:{s:4:"type";a:4:{s:11:"description";s:28:"The ID of the target entity.";s:4:"type";s:13:"varchar_ascii";s:6:"length";i:32;s:8:"not null";b:1;}}s:7:"indexes";a:1:{s:27:"node_field__type__target_id";a:1:{i:0;s:4:"type";}}}}
entity.storage_schema.sql	node.field_schema_data.title	a:2:{s:15:"node_field_data";a:1:{s:6:"fields";a:1:{s:5:"title";a:4:{s:4:"type";s:7:"varchar";s:6:"length";i:255;s:6:"binary";b:0;s:8:"not null";b:1;}}}s:19:"node_field_revision";a:1:{s:6:"fields";a:1:{s:5:"title";a:4:{s:4:"type";s:7:"varchar";s:6:"length";i:255;s:6:"binary";b:0;s:8:"not null";b:0;}}}}
entity.storage_schema.sql	node.field_schema_data.uid	a:2:{s:15:"node_field_data";a:2:{s:6:"fields";a:1:{s:3:"uid";a:4:{s:11:"description";s:28:"The ID of the target entity.";s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:8:"not null";b:1;}}s:7:"indexes";a:1:{s:26:"node_field__uid__target_id";a:1:{i:0;s:3:"uid";}}}s:19:"node_field_revision";a:2:{s:6:"fields";a:1:{s:3:"uid";a:4:{s:11:"description";s:28:"The ID of the target entity.";s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:8:"not null";b:1;}}s:7:"indexes";a:1:{s:26:"node_field__uid__target_id";a:1:{i:0;s:3:"uid";}}}}
entity.storage_schema.sql	node.field_schema_data.status	a:2:{s:15:"node_field_data";a:1:{s:6:"fields";a:1:{s:6:"status";a:3:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";s:8:"not null";b:1;}}}s:19:"node_field_revision";a:1:{s:6:"fields";a:1:{s:6:"status";a:3:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";s:8:"not null";b:1;}}}}
entity.storage_schema.sql	node.field_schema_data.created	a:2:{s:15:"node_field_data";a:2:{s:6:"fields";a:1:{s:7:"created";a:2:{s:4:"type";s:3:"int";s:8:"not null";b:1;}}s:7:"indexes";a:1:{s:19:"node_field__created";a:1:{i:0;s:7:"created";}}}s:19:"node_field_revision";a:1:{s:6:"fields";a:1:{s:7:"created";a:2:{s:4:"type";s:3:"int";s:8:"not null";b:0;}}}}
entity.storage_schema.sql	node.field_schema_data.changed	a:2:{s:15:"node_field_data";a:2:{s:6:"fields";a:1:{s:7:"changed";a:2:{s:4:"type";s:3:"int";s:8:"not null";b:1;}}s:7:"indexes";a:1:{s:19:"node_field__changed";a:1:{i:0;s:7:"changed";}}}s:19:"node_field_revision";a:1:{s:6:"fields";a:1:{s:7:"changed";a:2:{s:4:"type";s:3:"int";s:8:"not null";b:0;}}}}
entity.storage_schema.sql	node.field_schema_data.promote	a:2:{s:15:"node_field_data";a:1:{s:6:"fields";a:1:{s:7:"promote";a:3:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";s:8:"not null";b:1;}}}s:19:"node_field_revision";a:1:{s:6:"fields";a:1:{s:7:"promote";a:3:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";s:8:"not null";b:0;}}}}
entity.storage_schema.sql	node.field_schema_data.sticky	a:2:{s:15:"node_field_data";a:1:{s:6:"fields";a:1:{s:6:"sticky";a:3:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";s:8:"not null";b:1;}}}s:19:"node_field_revision";a:1:{s:6:"fields";a:1:{s:6:"sticky";a:3:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";s:8:"not null";b:0;}}}}
entity.storage_schema.sql	node.field_schema_data.revision_timestamp	a:1:{s:13:"node_revision";a:1:{s:6:"fields";a:1:{s:18:"revision_timestamp";a:2:{s:4:"type";s:3:"int";s:8:"not null";b:0;}}}}
entity.storage_schema.sql	node.field_schema_data.revision_uid	a:1:{s:13:"node_revision";a:3:{s:6:"fields";a:1:{s:12:"revision_uid";a:4:{s:11:"description";s:28:"The ID of the target entity.";s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:8:"not null";b:0;}}s:7:"indexes";a:1:{s:35:"node_field__revision_uid__target_id";a:1:{i:0;s:12:"revision_uid";}}s:12:"foreign keys";a:1:{s:24:"node_field__revision_uid";a:2:{s:5:"table";s:5:"users";s:7:"columns";a:1:{s:12:"revision_uid";s:3:"uid";}}}}}
entity.storage_schema.sql	node.field_schema_data.revision_log	a:1:{s:13:"node_revision";a:1:{s:6:"fields";a:1:{s:12:"revision_log";a:3:{s:4:"type";s:4:"text";s:4:"size";s:3:"big";s:8:"not null";b:0;}}}}
entity.storage_schema.sql	node.field_schema_data.revision_translation_affected	a:2:{s:15:"node_field_data";a:1:{s:6:"fields";a:1:{s:29:"revision_translation_affected";a:3:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";s:8:"not null";b:0;}}}s:19:"node_field_revision";a:1:{s:6:"fields";a:1:{s:29:"revision_translation_affected";a:3:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";s:8:"not null";b:0;}}}}
entity.storage_schema.sql	node.field_schema_data.default_langcode	a:2:{s:15:"node_field_data";a:1:{s:6:"fields";a:1:{s:16:"default_langcode";a:3:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";s:8:"not null";b:1;}}}s:19:"node_field_revision";a:1:{s:6:"fields";a:1:{s:16:"default_langcode";a:3:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";s:8:"not null";b:1;}}}}
entity.storage_schema.sql	node.entity_schema_data	a:4:{s:4:"node";a:2:{s:11:"primary key";a:1:{i:0;s:3:"nid";}s:11:"unique keys";a:1:{s:9:"node__vid";a:1:{i:0;s:3:"vid";}}}s:13:"node_revision";a:2:{s:11:"primary key";a:1:{i:0;s:3:"vid";}s:7:"indexes";a:1:{s:9:"node__nid";a:1:{i:0;s:3:"nid";}}}s:15:"node_field_data";a:2:{s:11:"primary key";a:2:{i:0;s:3:"nid";i:1;s:8:"langcode";}s:7:"indexes";a:5:{s:36:"node__id__default_langcode__langcode";a:3:{i:0;s:3:"nid";i:1;s:16:"default_langcode";i:2;s:8:"langcode";}s:9:"node__vid";a:1:{i:0;s:3:"vid";}s:15:"node__frontpage";a:4:{i:0;s:7:"promote";i:1;s:6:"status";i:2;s:6:"sticky";i:3;s:7:"created";}s:17:"node__status_type";a:3:{i:0;s:6:"status";i:1;s:4:"type";i:2;s:3:"nid";}s:16:"node__title_type";a:2:{i:0;s:5:"title";i:1;a:2:{i:0;s:4:"type";i:1;i:4;}}}}s:19:"node_field_revision";a:2:{s:11:"primary key";a:2:{i:0;s:3:"vid";i:1;s:8:"langcode";}s:7:"indexes";a:1:{s:36:"node__id__default_langcode__langcode";a:3:{i:0;s:3:"nid";i:1;s:16:"default_langcode";i:2;s:8:"langcode";}}}}
entity.storage_schema.sql	file.field_schema_data.status	a:1:{s:12:"file_managed";a:2:{s:6:"fields";a:1:{s:6:"status";a:3:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";s:8:"not null";b:1;}}s:7:"indexes";a:1:{s:18:"file_field__status";a:1:{i:0;s:6:"status";}}}}
entity.storage_schema.sql	file.field_schema_data.created	a:1:{s:12:"file_managed";a:1:{s:6:"fields";a:1:{s:7:"created";a:2:{s:4:"type";s:3:"int";s:8:"not null";b:0;}}}}
entity.storage_schema.sql	file.field_schema_data.changed	a:1:{s:12:"file_managed";a:2:{s:6:"fields";a:1:{s:7:"changed";a:2:{s:4:"type";s:3:"int";s:8:"not null";b:1;}}s:7:"indexes";a:1:{s:19:"file_field__changed";a:1:{i:0;s:7:"changed";}}}}
entity.storage_schema.sql	file.entity_schema_data	a:1:{s:12:"file_managed";a:1:{s:11:"primary key";a:1:{i:0;s:3:"fid";}}}
entity.definitions.installed	node.entity_type	O:36:"Drupal\\\\Core\\\\Entity\\\\ContentEntityType":35:{s:15:"\\000*\\000static_cache";b:1;s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:9:{s:2:"id";s:3:"nid";s:8:"revision";s:3:"vid";s:6:"bundle";s:4:"type";s:5:"label";s:5:"title";s:8:"langcode";s:8:"langcode";s:4:"uuid";s:4:"uuid";s:6:"status";s:6:"status";s:3:"uid";s:3:"uid";s:16:"default_langcode";s:16:"default_langcode";}s:5:"\\000*\\000id";s:4:"node";s:11:"\\000*\\000provider";s:4:"node";s:8:"\\000*\\000class";s:23:"Drupal\\\\node\\\\Entity\\\\Node";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:9:{s:7:"storage";s:23:"Drupal\\\\node\\\\NodeStorage";s:14:"storage_schema";s:29:"Drupal\\\\node\\\\NodeStorageSchema";s:12:"view_builder";s:27:"Drupal\\\\node\\\\NodeViewBuilder";s:6:"access";s:36:"Drupal\\\\node\\\\NodeAccessControlHandler";s:10:"views_data";s:25:"Drupal\\\\node\\\\NodeViewsData";s:4:"form";a:3:{s:7:"default";s:20:"Drupal\\\\node\\\\NodeForm";s:6:"delete";s:31:"Drupal\\\\node\\\\Form\\\\NodeDeleteForm";s:4:"edit";s:20:"Drupal\\\\node\\\\NodeForm";}s:14:"route_provider";a:1:{s:4:"html";s:36:"Drupal\\\\node\\\\Entity\\\\NodeRouteProvider";}s:12:"list_builder";s:27:"Drupal\\\\node\\\\NodeListBuilder";s:11:"translation";s:34:"Drupal\\\\node\\\\NodeTranslationHandler";}s:19:"\\000*\\000admin_permission";N;s:25:"\\000*\\000permission_granularity";s:6:"bundle";s:8:"\\000*\\000links";a:5:{s:9:"canonical";s:12:"/node/{node}";s:11:"delete-form";s:19:"/node/{node}/delete";s:9:"edit-form";s:17:"/node/{node}/edit";s:15:"version-history";s:22:"/node/{node}/revisions";s:8:"revision";s:43:"/node/{node}/revisions/{node_revision}/view";}s:17:"\\000*\\000label_callback";N;s:21:"\\000*\\000bundle_entity_type";s:9:"node_type";s:12:"\\000*\\000bundle_of";N;s:15:"\\000*\\000bundle_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:12:"Content type";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:13:"\\000*\\000base_table";s:4:"node";s:22:"\\000*\\000revision_data_table";s:19:"node_field_revision";s:17:"\\000*\\000revision_table";s:13:"node_revision";s:13:"\\000*\\000data_table";s:15:"node_field_data";s:15:"\\000*\\000translatable";b:1;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:7:"Content";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:12:"content item";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:15:"\\000*\\000label_plural";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"content items";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:14:"\\000*\\000label_count";a:3:{s:8:"singular";s:19:"@count content item";s:6:"plural";s:20:"@count content items";s:7:"context";N;}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:7:"content";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:7:"Content";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";s:26:"entity.node_type.edit_form";s:26:"\\000*\\000common_reference_target";b:1;s:22:"\\000*\\000list_cache_contexts";a:1:{i:0;s:21:"user.node_grants:view";}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:9:"node_list";}s:14:"\\000*\\000constraints";a:1:{s:13:"EntityChanged";N;}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
entity.definitions.installed	node_type.entity_type	O:42:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityType":39:{s:16:"\\000*\\000config_prefix";s:4:"type";s:15:"\\000*\\000static_cache";b:0;s:14:"\\000*\\000lookup_keys";a:1:{i:0;s:4:"uuid";}s:16:"\\000*\\000config_export";a:7:{i:0;s:4:"name";i:1;s:4:"type";i:2;s:11:"description";i:3;s:4:"help";i:4;s:12:"new_revision";i:5;s:12:"preview_mode";i:6;s:17:"display_submitted";}s:21:"\\000*\\000mergedConfigExport";a:0:{}s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:7:{s:2:"id";s:4:"type";s:5:"label";s:4:"name";s:8:"revision";s:0:"";s:6:"bundle";s:0:"";s:8:"langcode";s:8:"langcode";s:16:"default_langcode";s:16:"default_langcode";s:4:"uuid";s:4:"uuid";}s:5:"\\000*\\000id";s:9:"node_type";s:11:"\\000*\\000provider";s:4:"node";s:8:"\\000*\\000class";s:27:"Drupal\\\\node\\\\Entity\\\\NodeType";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:4:{s:6:"access";s:40:"Drupal\\\\node\\\\NodeTypeAccessControlHandler";s:4:"form";a:3:{s:3:"add";s:24:"Drupal\\\\node\\\\NodeTypeForm";s:4:"edit";s:24:"Drupal\\\\node\\\\NodeTypeForm";s:6:"delete";s:38:"Drupal\\\\node\\\\Form\\\\NodeTypeDeleteConfirm";}s:12:"list_builder";s:31:"Drupal\\\\node\\\\NodeTypeListBuilder";s:7:"storage";s:45:"Drupal\\\\Core\\\\Config\\\\Entity\\\\ConfigEntityStorage";}s:19:"\\000*\\000admin_permission";s:24:"administer content types";s:25:"\\000*\\000permission_granularity";s:11:"entity_type";s:8:"\\000*\\000links";a:3:{s:9:"edit-form";s:41:"/admin/structure/types/manage/{node_type}";s:11:"delete-form";s:48:"/admin/structure/types/manage/{node_type}/delete";s:10:"collection";s:22:"/admin/structure/types";}s:17:"\\000*\\000label_callback";N;s:21:"\\000*\\000bundle_entity_type";N;s:12:"\\000*\\000bundle_of";s:4:"node";s:15:"\\000*\\000bundle_label";N;s:13:"\\000*\\000base_table";N;s:22:"\\000*\\000revision_data_table";N;s:17:"\\000*\\000revision_table";N;s:13:"\\000*\\000data_table";N;s:15:"\\000*\\000translatable";b:0;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:12:"Content type";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";s:0:"";s:15:"\\000*\\000label_plural";s:0:"";s:14:"\\000*\\000label_count";a:0:{}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:13:"configuration";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Configuration";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";N;s:26:"\\000*\\000common_reference_target";b:0;s:22:"\\000*\\000list_cache_contexts";a:0:{}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:21:"config:node_type_list";}s:14:"\\000*\\000constraints";a:0:{}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
config.entity.key_store.entity_view_mode	uuid:79db923d-61cb-466a-aadd-1f0dd900f49f	a:1:{i:0;s:31:"core.entity_view_mode.node.full";}
config.entity.key_store.entity_view_mode	uuid:30dd5937-104b-4038-9243-ca3284e1a756	a:1:{i:0;s:30:"core.entity_view_mode.node.rss";}
config.entity.key_store.entity_view_mode	uuid:33d74b88-d495-40a5-845f-e213a579dd8d	a:1:{i:0;s:39:"core.entity_view_mode.node.search_index";}
config.entity.key_store.entity_view_mode	uuid:650a4e5a-4539-472b-9223-b590b03615ca	a:1:{i:0;s:40:"core.entity_view_mode.node.search_result";}
config.entity.key_store.entity_view_mode	uuid:221682e7-4df7-4f58-a35e-bce1b22e780c	a:1:{i:0;s:33:"core.entity_view_mode.node.teaser";}
entity.storage_schema.sql	node.field_schema_data.body	a:2:{s:10:"node__body";a:4:{s:11:"description";s:33:"Data storage for node field body.";s:6:"fields";a:9:{s:6:"bundle";a:5:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:128;s:8:"not null";b:1;s:7:"default";s:0:"";s:11:"description";s:88:"The field instance bundle to which this row belongs, used when deleting a field instance";}s:7:"deleted";a:5:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";s:8:"not null";b:1;s:7:"default";i:0;s:11:"description";s:60:"A boolean indicating whether this data item has been deleted";}s:9:"entity_id";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:8:"not null";b:1;s:11:"description";s:38:"The entity id this data is attached to";}s:11:"revision_id";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:8:"not null";b:1;s:11:"description";s:47:"The entity revision id this data is attached to";}s:8:"langcode";a:5:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:32;s:8:"not null";b:1;s:7:"default";s:0:"";s:11:"description";s:37:"The language code for this data item.";}s:5:"delta";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:8:"not null";b:1;s:11:"description";s:67:"The sequence number for this data item, used for multi-value fields";}s:10:"body_value";a:3:{s:4:"type";s:4:"text";s:4:"size";s:3:"big";s:8:"not null";b:1;}s:12:"body_summary";a:3:{s:4:"type";s:4:"text";s:4:"size";s:3:"big";s:8:"not null";b:0;}s:11:"body_format";a:3:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:255;s:8:"not null";b:0;}}s:11:"primary key";a:4:{i:0;s:9:"entity_id";i:1;s:7:"deleted";i:2;s:5:"delta";i:3;s:8:"langcode";}s:7:"indexes";a:3:{s:6:"bundle";a:1:{i:0;s:6:"bundle";}s:11:"revision_id";a:1:{i:0;s:11:"revision_id";}s:11:"body_format";a:1:{i:0;s:11:"body_format";}}}s:19:"node_revision__body";a:4:{s:11:"description";s:45:"Revision archive storage for node field body.";s:6:"fields";a:9:{s:6:"bundle";a:5:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:128;s:8:"not null";b:1;s:7:"default";s:0:"";s:11:"description";s:88:"The field instance bundle to which this row belongs, used when deleting a field instance";}s:7:"deleted";a:5:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";s:8:"not null";b:1;s:7:"default";i:0;s:11:"description";s:60:"A boolean indicating whether this data item has been deleted";}s:9:"entity_id";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:8:"not null";b:1;s:11:"description";s:38:"The entity id this data is attached to";}s:11:"revision_id";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:8:"not null";b:1;s:11:"description";s:47:"The entity revision id this data is attached to";}s:8:"langcode";a:5:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:32;s:8:"not null";b:1;s:7:"default";s:0:"";s:11:"description";s:37:"The language code for this data item.";}s:5:"delta";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:8:"not null";b:1;s:11:"description";s:67:"The sequence number for this data item, used for multi-value fields";}s:10:"body_value";a:3:{s:4:"type";s:4:"text";s:4:"size";s:3:"big";s:8:"not null";b:1;}s:12:"body_summary";a:3:{s:4:"type";s:4:"text";s:4:"size";s:3:"big";s:8:"not null";b:0;}s:11:"body_format";a:3:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:255;s:8:"not null";b:0;}}s:11:"primary key";a:5:{i:0;s:9:"entity_id";i:1;s:11:"revision_id";i:2;s:7:"deleted";i:3;s:5:"delta";i:4;s:8:"langcode";}s:7:"indexes";a:3:{s:6:"bundle";a:1:{i:0;s:6:"bundle";}s:11:"revision_id";a:1:{i:0;s:11:"revision_id";}s:11:"body_format";a:1:{i:0;s:11:"body_format";}}}}
entity.definitions.installed	node.field_storage_definitions	a:18:{s:3:"nid";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"integer";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:3:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:6:"normal";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:2;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:integer";s:8:"settings";a:6:{s:8:"unsigned";b:1;s:4:"size";s:6:"normal";s:3:"min";s:0:"";s:3:"max";s:0:"";s:6:"prefix";s:0:"";s:6:"suffix";s:0:"";}}}s:13:"\\000*\\000definition";a:6:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:2:"ID";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"read-only";b:1;s:8:"provider";s:4:"node";s:10:"field_name";s:3:"nid";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:4:"uuid";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:4:"uuid";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:3:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:128;s:6:"binary";b:0;}}s:11:"unique keys";a:1:{s:5:"value";a:1:{i:0;s:5:"value";}}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:35;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:15:"field_item:uuid";s:8:"settings";a:3:{s:10:"max_length";i:128;s:8:"is_ascii";b:1;s:14:"case_sensitive";b:0;}}}s:13:"\\000*\\000definition";a:6:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:4:"UUID";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"read-only";b:1;s:8:"provider";s:4:"node";s:10:"field_name";s:4:"uuid";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:3:"vid";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"integer";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:3:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:6:"normal";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:67;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:integer";s:8:"settings";a:6:{s:8:"unsigned";b:1;s:4:"size";s:6:"normal";s:3:"min";s:0:"";s:3:"max";s:0:"";s:6:"prefix";s:0:"";s:6:"suffix";s:0:"";}}}s:13:"\\000*\\000definition";a:6:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:11:"Revision ID";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"read-only";b:1;s:8:"provider";s:4:"node";s:10:"field_name";s:3:"vid";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:8:"langcode";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:8:"language";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:2:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:12;}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:100;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:19:"field_item:language";s:8:"settings";a:0:{}}}s:13:"\\000*\\000definition";a:8:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:8:"Language";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:7:"display";a:2:{s:4:"view";a:1:{s:7:"options";a:1:{s:4:"type";s:6:"hidden";}}s:4:"form";a:1:{s:7:"options";a:2:{s:4:"type";s:15:"language_select";s:6:"weight";i:2;}}}s:12:"revisionable";b:1;s:12:"translatable";b:1;s:8:"provider";s:4:"node";s:10:"field_name";s:8:"langcode";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:4:"type";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:16:"entity_reference";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:9:"target_id";a:3:{s:11:"description";s:28:"The ID of the target entity.";s:4:"type";s:13:"varchar_ascii";s:6:"length";i:32;}}s:7:"indexes";a:1:{s:9:"target_id";a:1:{i:0;s:9:"target_id";}}s:11:"unique keys";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:135;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:27:"field_item:entity_reference";s:8:"settings";a:3:{s:11:"target_type";s:9:"node_type";s:7:"handler";s:7:"default";s:16:"handler_settings";a:0:{}}}}s:13:"\\000*\\000definition";a:7:{s:5:"label";s:12:"Content type";s:8:"required";b:1;s:9:"read-only";b:1;s:8:"provider";s:4:"node";s:10:"field_name";s:4:"type";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:5:"title";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:6:"string";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:3:{s:4:"type";s:7:"varchar";s:6:"length";i:255;s:6:"binary";b:0;}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:165;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:17:"field_item:string";s:8:"settings";a:3:{s:10:"max_length";i:255;s:8:"is_ascii";b:0;s:14:"case_sensitive";b:0;}}}s:13:"\\000*\\000definition";a:9:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:5:"Title";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:8:"required";b:1;s:12:"translatable";b:1;s:12:"revisionable";b:1;s:7:"display";a:2:{s:4:"view";a:1:{s:7:"options";a:3:{s:5:"label";s:6:"hidden";s:4:"type";s:6:"string";s:6:"weight";i:-5;}}s:4:"form";a:2:{s:7:"options";a:2:{s:4:"type";s:16:"string_textfield";s:6:"weight";i:-5;}s:12:"configurable";b:1;}}s:8:"provider";s:4:"node";s:10:"field_name";s:5:"title";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:3:"uid";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:16:"entity_reference";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:9:"target_id";a:3:{s:11:"description";s:28:"The ID of the target entity.";s:4:"type";s:3:"int";s:8:"unsigned";b:1;}}s:7:"indexes";a:1:{s:9:"target_id";a:1:{i:0;s:9:"target_id";}}s:11:"unique keys";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:208;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:27:"field_item:entity_reference";s:8:"settings";a:3:{s:11:"target_type";s:4:"user";s:7:"handler";s:7:"default";s:16:"handler_settings";a:0:{}}}}s:13:"\\000*\\000definition";a:10:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:11:"Authored by";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:35:"The username of the content author.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:12:"revisionable";b:1;s:22:"default_value_callback";s:41:"Drupal\\\\node\\\\Entity\\\\Node::getCurrentUserId";s:12:"translatable";b:1;s:7:"display";a:2:{s:4:"view";a:1:{s:7:"options";a:3:{s:5:"label";s:6:"hidden";s:4:"type";s:6:"author";s:6:"weight";i:0;}}s:4:"form";a:2:{s:7:"options";a:3:{s:4:"type";s:29:"entity_reference_autocomplete";s:6:"weight";i:5;s:8:"settings";a:3:{s:14:"match_operator";s:8:"CONTAINS";s:4:"size";s:2:"60";s:11:"placeholder";s:0:"";}}s:12:"configurable";b:1;}}s:8:"provider";s:4:"node";s:10:"field_name";s:3:"uid";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:6:"status";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"boolean";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:2:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:261;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:boolean";s:8:"settings";a:2:{s:8:"on_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:2:"On";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"off_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:3:"Off";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}}}}s:13:"\\000*\\000definition";a:9:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:17:"Publishing status";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:51:"A boolean indicating whether the node is published.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:12:"revisionable";b:1;s:12:"translatable";b:1;s:13:"default_value";a:1:{i:0;a:1:{s:5:"value";b:1;}}s:8:"provider";s:4:"node";s:10:"field_name";s:6:"status";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:7:"created";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"created";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:1:{s:4:"type";s:3:"int";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:303;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:created";s:8:"settings";a:0:{}}}s:13:"\\000*\\000definition";a:9:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:11:"Authored on";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:35:"The time that the node was created.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:12:"revisionable";b:1;s:12:"translatable";b:1;s:7:"display";a:2:{s:4:"view";a:1:{s:7:"options";a:3:{s:5:"label";s:6:"hidden";s:4:"type";s:9:"timestamp";s:6:"weight";i:0;}}s:4:"form";a:2:{s:7:"options";a:2:{s:4:"type";s:18:"datetime_timestamp";s:6:"weight";i:10;}s:12:"configurable";b:1;}}s:8:"provider";s:4:"node";s:10:"field_name";s:7:"created";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:7:"changed";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"changed";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:1:{s:4:"type";s:3:"int";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:344;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:changed";s:8:"settings";a:0:{}}}s:13:"\\000*\\000definition";a:8:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:7:"Changed";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:39:"The time that the node was last edited.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:12:"revisionable";b:1;s:12:"translatable";b:1;s:8:"provider";s:4:"node";s:10:"field_name";s:7:"changed";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:7:"promote";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"boolean";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:2:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:374;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:boolean";s:8:"settings";a:2:{s:8:"on_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:2:"On";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"off_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:3:"Off";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}}}}s:13:"\\000*\\000definition";a:9:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:22:"Promoted to front page";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:12:"revisionable";b:1;s:12:"translatable";b:1;s:13:"default_value";a:1:{i:0;a:1:{s:5:"value";b:1;}}s:7:"display";a:1:{s:4:"form";a:2:{s:7:"options";a:3:{s:4:"type";s:16:"boolean_checkbox";s:8:"settings";a:1:{s:13:"display_label";b:1;}s:6:"weight";i:15;}s:12:"configurable";b:1;}}s:8:"provider";s:4:"node";s:10:"field_name";s:7:"promote";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:6:"sticky";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"boolean";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:2:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:420;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:boolean";s:8:"settings";a:2:{s:8:"on_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:2:"On";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"off_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:3:"Off";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}}}}s:13:"\\000*\\000definition";a:9:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:22:"Sticky at top of lists";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:12:"revisionable";b:1;s:12:"translatable";b:1;s:13:"default_value";a:1:{i:0;a:1:{s:5:"value";b:0;}}s:7:"display";a:1:{s:4:"form";a:2:{s:7:"options";a:3:{s:4:"type";s:16:"boolean_checkbox";s:8:"settings";a:1:{s:13:"display_label";b:1;}s:6:"weight";i:16;}s:12:"configurable";b:1;}}s:8:"provider";s:4:"node";s:10:"field_name";s:6:"sticky";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:18:"revision_timestamp";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"created";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:1:{s:4:"type";s:3:"int";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:466;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:created";s:8:"settings";a:0:{}}}s:13:"\\000*\\000definition";a:8:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:18:"Revision timestamp";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:47:"The time that the current revision was created.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"queryable";b:0;s:12:"revisionable";b:1;s:8:"provider";s:4:"node";s:10:"field_name";s:18:"revision_timestamp";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:12:"revision_uid";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:16:"entity_reference";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:9:"target_id";a:3:{s:11:"description";s:28:"The ID of the target entity.";s:4:"type";s:3:"int";s:8:"unsigned";b:1;}}s:7:"indexes";a:1:{s:9:"target_id";a:1:{i:0;s:9:"target_id";}}s:11:"unique keys";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:496;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:27:"field_item:entity_reference";s:8:"settings";a:3:{s:11:"target_type";s:4:"user";s:7:"handler";s:7:"default";s:16:"handler_settings";a:0:{}}}}s:13:"\\000*\\000definition";a:8:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:16:"Revision user ID";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:50:"The user ID of the author of the current revision.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"queryable";b:0;s:12:"revisionable";b:1;s:8:"provider";s:4:"node";s:10:"field_name";s:12:"revision_uid";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:12:"revision_log";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:11:"string_long";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:2:{s:4:"type";s:4:"text";s:4:"size";s:3:"big";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:533;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:22:"field_item:string_long";s:8:"settings";a:1:{s:14:"case_sensitive";b:0;}}}s:13:"\\000*\\000definition";a:9:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:20:"Revision log message";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:43:"Briefly describe the changes you have made.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:12:"revisionable";b:1;s:13:"default_value";a:1:{i:0;a:1:{s:5:"value";s:0:"";}}s:7:"display";a:1:{s:4:"form";a:1:{s:7:"options";a:3:{s:4:"type";s:15:"string_textarea";s:6:"weight";i:25;s:8:"settings";a:1:{s:4:"rows";i:4;}}}}s:8:"provider";s:4:"node";s:10:"field_name";s:12:"revision_log";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:29:"revision_translation_affected";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"boolean";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:2:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:574;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:boolean";s:8:"settings";a:2:{s:8:"on_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:2:"On";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"off_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:3:"Off";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}}}}s:13:"\\000*\\000definition";a:9:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:29:"Revision translation affected";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:72:"Indicates if the last edit of a translation belongs to current revision.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"read-only";b:1;s:12:"revisionable";b:1;s:12:"translatable";b:1;s:8:"provider";s:4:"node";s:10:"field_name";s:29:"revision_translation_affected";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:16:"default_langcode";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"boolean";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:2:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:614;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:boolean";s:8:"settings";a:2:{s:8:"on_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:2:"On";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"off_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:3:"Off";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}}}}s:13:"\\000*\\000definition";a:9:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:19:"Default translation";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:58:"A flag indicating whether this is the default translation.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:12:"translatable";b:1;s:12:"revisionable";b:1;s:13:"default_value";a:1:{i:0;a:1:{s:5:"value";b:1;}}s:8:"provider";s:4:"node";s:10:"field_name";s:16:"default_langcode";s:11:"entity_type";s:4:"node";s:6:"bundle";N;}}s:4:"body";O:38:"Drupal\\\\field\\\\Entity\\\\FieldStorageConfig":28:{s:5:"\\000*\\000id";s:9:"node.body";s:13:"\\000*\\000field_name";s:4:"body";s:14:"\\000*\\000entity_type";s:4:"node";s:7:"\\000*\\000type";s:17:"text_with_summary";s:9:"\\000*\\000module";s:4:"text";s:11:"\\000*\\000settings";a:0:{}s:14:"\\000*\\000cardinality";i:1;s:15:"\\000*\\000translatable";b:1;s:9:"\\000*\\000locked";b:0;s:25:"\\000*\\000persist_with_no_fields";b:1;s:14:"custom_storage";b:0;s:10:"\\000*\\000indexes";a:0:{}s:10:"\\000*\\000deleted";b:0;s:13:"\\000*\\000originalId";s:9:"node.body";s:9:"\\000*\\000status";b:1;s:7:"\\000*\\000uuid";s:36:"be65f75d-5fa0-4343-aa5f-0f1e689b2782";s:11:"\\000*\\000langcode";s:2:"en";s:23:"\\000*\\000third_party_settings";a:0:{}s:8:"\\000*\\000_core";a:1:{s:19:"default_config_hash";s:43:"EBUo7qOWqaiZaQ_RC9sLY5IoDKphS34v77VIHSACmVY";}s:14:"\\000*\\000trustedData";b:1;s:15:"\\000*\\000entityTypeId";s:20:"field_storage_config";s:15:"\\000*\\000enforceIsNew";b:1;s:12:"\\000*\\000typedData";N;s:16:"\\000*\\000cacheContexts";a:0:{}s:12:"\\000*\\000cacheTags";a:0:{}s:14:"\\000*\\000cacheMaxAge";i:-1;s:14:"\\000*\\000_serviceIds";a:0:{}s:15:"\\000*\\000dependencies";a:1:{s:6:"module";a:2:{i:0;s:4:"node";i:1;s:4:"text";}}}}
config.entity.key_store.field_storage_config	uuid:be65f75d-5fa0-4343-aa5f-0f1e689b2782	a:1:{i:0;s:23:"field.storage.node.body";}
config.entity.key_store.action	uuid:6edf514f-e89c-4371-b3c5-2e192f1d201b	a:1:{i:0;s:32:"system.action.node_delete_action";}
config.entity.key_store.action	uuid:a1a19d64-7a11-4cb6-91fd-65722a2bc14e	a:1:{i:0;s:37:"system.action.node_make_sticky_action";}
config.entity.key_store.action	uuid:3bf212b6-7e24-4d0a-ac01-c4ab31074c1c	a:1:{i:0;s:39:"system.action.node_make_unsticky_action";}
config.entity.key_store.action	uuid:4526b41e-b086-46d6-812f-3e411bf52684	a:1:{i:0;s:33:"system.action.node_promote_action";}
config.entity.key_store.action	uuid:0667e9ca-dda6-4e4e-85ad-115b3a3b130e	a:1:{i:0;s:33:"system.action.node_publish_action";}
config.entity.key_store.action	uuid:4778db72-9b23-4b12-a668-ea304c1b6f9c	a:1:{i:0;s:30:"system.action.node_save_action";}
config.entity.key_store.action	uuid:52c908e0-2f11-4874-8423-179f46c7e3a5	a:1:{i:0;s:35:"system.action.node_unpromote_action";}
config.entity.key_store.action	uuid:36bdf044-727d-48f0-8e4c-961dc97dad3c	a:1:{i:0;s:35:"system.action.node_unpublish_action";}
system.schema	node	s:4:"8003";
state	system.theme.files	a:7:{s:6:"bartik";s:34:"core/themes/bartik/bartik.info.yml";s:5:"stark";s:32:"core/themes/stark/stark.info.yml";s:6:"stable";s:34:"core/themes/stable/stable.info.yml";s:5:"seven";s:32:"core/themes/seven/seven.info.yml";s:6:"classy";s:34:"core/themes/classy/classy.info.yml";s:9:"bootstrap";s:43:"themes/contrib/bootstrap/bootstrap.info.yml";s:13:"bootstrap_18f";s:50:"themes/custom/bootstrap_18f/bootstrap_18f.info.yml";}
system.schema	dblog	i:8000;
system.schema	dynamic_page_cache	i:8000;
config.entity.key_store.block	uuid:99d07e15-91a7-4b58-9fbf-c67899985951	a:1:{i:0;s:31:"block.block.stark_local_actions";}
system.schema	page_cache	i:8000;
config.entity.key_store.block	uuid:fa69d33a-df76-4e48-93d6-06574d7d5b75	a:1:{i:0;s:23:"block.block.stark_admin";}
entity.storage_schema.sql	file.field_schema_data.fid	a:1:{s:12:"file_managed";a:1:{s:6:"fields";a:1:{s:3:"fid";a:4:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:6:"normal";s:8:"not null";b:1;}}}}
config.entity.key_store.block	uuid:f3bfa429-a2a4-4bb2-9e53-02619428526d	a:1:{i:0;s:26:"block.block.stark_branding";}
entity.storage_schema.sql	file.field_schema_data.uuid	a:1:{s:12:"file_managed";a:2:{s:6:"fields";a:1:{s:4:"uuid";a:4:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:128;s:6:"binary";b:0;s:8:"not null";b:1;}}s:11:"unique keys";a:1:{s:23:"file_field__uuid__value";a:1:{i:0;s:4:"uuid";}}}}
config.entity.key_store.block	uuid:de79c9f1-cf2d-449c-8381-14642e01a6b4	a:1:{i:0;s:29:"block.block.stark_local_tasks";}
entity.storage_schema.sql	file.field_schema_data.langcode	a:1:{s:12:"file_managed";a:1:{s:6:"fields";a:1:{s:8:"langcode";a:3:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:12;s:8:"not null";b:1;}}}}
config.entity.key_store.block	uuid:2d2669eb-561b-4ed3-a5d7-0da811be0e15	a:1:{i:0;s:23:"block.block.stark_login";}
entity.storage_schema.sql	file.field_schema_data.uid	a:1:{s:12:"file_managed";a:2:{s:6:"fields";a:1:{s:3:"uid";a:4:{s:11:"description";s:28:"The ID of the target entity.";s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:8:"not null";b:0;}}s:7:"indexes";a:1:{s:26:"file_field__uid__target_id";a:1:{i:0;s:3:"uid";}}}}
config.entity.key_store.block	uuid:5094077e-aceb-418a-88aa-6647649fa046	a:1:{i:0;s:26:"block.block.stark_messages";}
entity.storage_schema.sql	file.field_schema_data.filename	a:1:{s:12:"file_managed";a:1:{s:6:"fields";a:1:{s:8:"filename";a:4:{s:4:"type";s:7:"varchar";s:6:"length";i:255;s:6:"binary";b:0;s:8:"not null";b:0;}}}}
config.entity.key_store.block	uuid:19652566-787b-4810-8c62-f0310a2056e2	a:1:{i:0;s:28:"block.block.stark_page_title";}
config.entity.key_store.block	theme:stark	a:8:{i:0;s:23:"block.block.stark_admin";i:1;s:26:"block.block.stark_branding";i:2;s:31:"block.block.stark_local_actions";i:3;s:29:"block.block.stark_local_tasks";i:4;s:23:"block.block.stark_login";i:5;s:26:"block.block.stark_messages";i:6;s:28:"block.block.stark_page_title";i:7;s:23:"block.block.stark_tools";}
config.entity.key_store.block	uuid:7eead4c7-6df4-4f33-ae2b-485e5a657765	a:1:{i:0;s:23:"block.block.stark_tools";}
system.schema	minimal	i:8000;
state	routing.non_admin_routes	a:41:{i:0;s:27:"block.category_autocomplete";i:1;s:18:"file.ajax_progress";i:2;s:15:"filter.tips_all";i:3;s:11:"filter.tips";i:4;s:13:"node.add_page";i:5;s:8:"node.add";i:6;s:19:"entity.node.preview";i:7;s:27:"entity.node.version_history";i:8;s:20:"entity.node.revision";i:9;s:28:"node.revision_revert_confirm";i:10;s:40:"node.revision_revert_translation_confirm";i:11;s:28:"node.revision_delete_confirm";i:12;s:10:"system.401";i:13;s:10:"system.403";i:14;s:10:"system.404";i:15;s:11:"system.cron";i:16;s:33:"system.machine_name_transliterate";i:17;s:12:"system.files";i:18;s:28:"system.private_file_download";i:19;s:16:"system.temporary";i:20;s:7:"<front>";i:21;s:6:"<none>";i:22;s:9:"<current>";i:23;s:15:"system.timezone";i:24;s:22:"system.batch_page.html";i:25;s:22:"system.batch_page.json";i:26;s:16:"system.db_update";i:27;s:26:"system.entity_autocomplete";i:28;s:13:"user.register";i:29;s:11:"user.logout";i:30;s:9:"user.pass";i:31;s:9:"user.page";i:32;s:10:"user.login";i:33;s:19:"user.cancel_confirm";i:34;s:10:"user.reset";i:35;s:21:"entity.node.canonical";i:36;s:23:"entity.node.delete_form";i:37;s:21:"entity.node.edit_form";i:38;s:21:"entity.user.canonical";i:39;s:21:"entity.user.edit_form";i:40;s:23:"entity.user.cancel_form";}
entity.storage_schema.sql	file.field_schema_data.uri	a:1:{s:12:"file_managed";a:2:{s:6:"fields";a:1:{s:3:"uri";a:4:{s:4:"type";s:7:"varchar";s:6:"length";i:255;s:6:"binary";b:1;s:8:"not null";b:1;}}s:7:"indexes";a:1:{s:15:"file_field__uri";a:1:{i:0;s:3:"uri";}}}}
entity.storage_schema.sql	file.field_schema_data.filemime	a:1:{s:12:"file_managed";a:1:{s:6:"fields";a:1:{s:8:"filemime";a:4:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:255;s:6:"binary";b:0;s:8:"not null";b:0;}}}}
entity.definitions.installed	file.entity_type	O:36:"Drupal\\\\Core\\\\Entity\\\\ContentEntityType":35:{s:15:"\\000*\\000static_cache";b:1;s:15:"\\000*\\000render_cache";b:1;s:19:"\\000*\\000persistent_cache";b:1;s:14:"\\000*\\000entity_keys";a:7:{s:2:"id";s:3:"fid";s:5:"label";s:8:"filename";s:8:"langcode";s:8:"langcode";s:4:"uuid";s:4:"uuid";s:8:"revision";s:0:"";s:6:"bundle";s:0:"";s:16:"default_langcode";s:16:"default_langcode";}s:5:"\\000*\\000id";s:4:"file";s:11:"\\000*\\000provider";s:4:"file";s:8:"\\000*\\000class";s:23:"Drupal\\\\file\\\\Entity\\\\File";s:16:"\\000*\\000originalClass";N;s:11:"\\000*\\000handlers";a:5:{s:7:"storage";s:23:"Drupal\\\\file\\\\FileStorage";s:14:"storage_schema";s:29:"Drupal\\\\file\\\\FileStorageSchema";s:6:"access";s:36:"Drupal\\\\file\\\\FileAccessControlHandler";s:10:"views_data";s:25:"Drupal\\\\file\\\\FileViewsData";s:12:"view_builder";s:36:"Drupal\\\\Core\\\\Entity\\\\EntityViewBuilder";}s:19:"\\000*\\000admin_permission";N;s:25:"\\000*\\000permission_granularity";s:11:"entity_type";s:8:"\\000*\\000links";a:0:{}s:17:"\\000*\\000label_callback";N;s:21:"\\000*\\000bundle_entity_type";N;s:12:"\\000*\\000bundle_of";N;s:15:"\\000*\\000bundle_label";N;s:13:"\\000*\\000base_table";s:12:"file_managed";s:22:"\\000*\\000revision_data_table";N;s:17:"\\000*\\000revision_table";N;s:13:"\\000*\\000data_table";N;s:15:"\\000*\\000translatable";b:0;s:8:"\\000*\\000label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:4:"File";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:17:"\\000*\\000label_singular";s:0:"";s:15:"\\000*\\000label_plural";s:0:"";s:14:"\\000*\\000label_count";a:0:{}s:15:"\\000*\\000uri_callback";N;s:8:"\\000*\\000group";s:7:"content";s:14:"\\000*\\000group_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:7:"Content";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:1:{s:7:"context";s:17:"Entity type group";}}s:22:"\\000*\\000field_ui_base_route";N;s:26:"\\000*\\000common_reference_target";b:0;s:22:"\\000*\\000list_cache_contexts";a:0:{}s:18:"\\000*\\000list_cache_tags";a:1:{i:0;s:9:"file_list";}s:14:"\\000*\\000constraints";a:1:{s:13:"EntityChanged";N;}s:13:"\\000*\\000additional";a:0:{}s:20:"\\000*\\000stringTranslation";N;}
entity.definitions.installed	file.field_storage_definitions	a:11:{s:3:"fid";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"integer";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:3:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:6:"normal";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:2;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:integer";s:8:"settings";a:6:{s:8:"unsigned";b:1;s:4:"size";s:6:"normal";s:3:"min";s:0:"";s:3:"max";s:0:"";s:6:"prefix";s:0:"";s:6:"suffix";s:0:"";}}}s:13:"\\000*\\000definition";a:7:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:7:"File ID";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:12:"The file ID.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"read-only";b:1;s:8:"provider";s:4:"file";s:10:"field_name";s:3:"fid";s:11:"entity_type";s:4:"file";s:6:"bundle";N;}}s:4:"uuid";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:4:"uuid";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:3:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:128;s:6:"binary";b:0;}}s:11:"unique keys";a:1:{s:5:"value";a:1:{i:0;s:5:"value";}}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:39;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:15:"field_item:uuid";s:8:"settings";a:3:{s:10:"max_length";i:128;s:8:"is_ascii";b:1;s:14:"case_sensitive";b:0;}}}s:13:"\\000*\\000definition";a:7:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:4:"UUID";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:14:"The file UUID.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"read-only";b:1;s:8:"provider";s:4:"file";s:10:"field_name";s:4:"uuid";s:11:"entity_type";s:4:"file";s:6:"bundle";N;}}s:8:"langcode";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:8:"language";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:2:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:12;}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:75;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:19:"field_item:language";s:8:"settings";a:0:{}}}s:13:"\\000*\\000definition";a:6:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Language code";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:23:"The file language code.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:8:"provider";s:4:"file";s:10:"field_name";s:8:"langcode";s:11:"entity_type";s:4:"file";s:6:"bundle";N;}}s:3:"uid";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:16:"entity_reference";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:9:"target_id";a:3:{s:11:"description";s:28:"The ID of the target entity.";s:4:"type";s:3:"int";s:8:"unsigned";b:1;}}s:7:"indexes";a:1:{s:9:"target_id";a:1:{i:0;s:9:"target_id";}}s:11:"unique keys";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:104;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:27:"field_item:entity_reference";s:8:"settings";a:3:{s:11:"target_type";s:4:"user";s:7:"handler";s:7:"default";s:16:"handler_settings";a:0:{}}}}s:13:"\\000*\\000definition";a:6:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:7:"User ID";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:24:"The user ID of the file.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:8:"provider";s:4:"file";s:10:"field_name";s:3:"uid";s:11:"entity_type";s:4:"file";s:6:"bundle";N;}}s:8:"filename";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:6:"string";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:3:{s:4:"type";s:7:"varchar";s:6:"length";i:255;s:6:"binary";b:0;}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:139;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:17:"field_item:string";s:8:"settings";a:3:{s:10:"max_length";i:255;s:8:"is_ascii";b:0;s:14:"case_sensitive";b:0;}}}s:13:"\\000*\\000definition";a:6:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:8:"Filename";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:41:"Name of the file with no path components.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:8:"provider";s:4:"file";s:10:"field_name";s:8:"filename";s:11:"entity_type";s:4:"file";s:6:"bundle";N;}}s:3:"uri";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:3:"uri";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:3:{s:4:"type";s:7:"varchar";s:6:"length";i:255;s:6:"binary";b:1;}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:172;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:14:"field_item:uri";s:8:"settings";a:2:{s:10:"max_length";i:255;s:14:"case_sensitive";b:1;}}}s:13:"\\000*\\000definition";a:7:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:3:"URI";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:52:"The URI to access the file (either local or remote).";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"constraints";a:1:{s:13:"FileUriUnique";N;}s:8:"provider";s:4:"file";s:10:"field_name";s:3:"uri";s:11:"entity_type";s:4:"file";s:6:"bundle";N;}}s:8:"filemime";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:6:"string";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:3:{s:4:"type";s:13:"varchar_ascii";s:6:"length";i:255;s:6:"binary";b:0;}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:206;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:17:"field_item:string";s:8:"settings";a:3:{s:10:"max_length";i:255;s:8:"is_ascii";b:1;s:14:"case_sensitive";b:0;}}}s:13:"\\000*\\000definition";a:6:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:14:"File MIME type";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:21:"The file's MIME type.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:8:"provider";s:4:"file";s:10:"field_name";s:8:"filemime";s:11:"entity_type";s:4:"file";s:6:"bundle";N;}}s:8:"filesize";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"integer";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:3:{s:4:"type";s:3:"int";s:8:"unsigned";b:1;s:4:"size";s:3:"big";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:239;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:integer";s:8:"settings";a:6:{s:8:"unsigned";b:1;s:4:"size";s:3:"big";s:3:"min";s:0:"";s:3:"max";s:0:"";s:6:"prefix";s:0:"";s:6:"suffix";s:0:"";}}}s:13:"\\000*\\000definition";a:6:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:9:"File size";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:30:"The size of the file in bytes.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:8:"provider";s:4:"file";s:10:"field_name";s:8:"filesize";s:11:"entity_type";s:4:"file";s:6:"bundle";N;}}s:6:"status";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"boolean";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:2:{s:4:"type";s:3:"int";s:4:"size";s:4:"tiny";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:275;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:boolean";s:8:"settings";a:2:{s:8:"on_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:2:"On";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:9:"off_label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:3:"Off";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}}}}s:13:"\\000*\\000definition";a:7:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:6:"Status";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:63:"The status of the file, temporary (FALSE) and permanent (TRUE).";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:13:"default_value";a:1:{i:0;a:1:{s:5:"value";b:0;}}s:8:"provider";s:4:"file";s:10:"field_name";s:6:"status";s:11:"entity_type";s:4:"file";s:6:"bundle";N;}}s:7:"created";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"created";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:1:{s:4:"type";s:3:"int";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:315;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:created";s:8:"settings";a:0:{}}}s:13:"\\000*\\000definition";a:6:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:7:"Created";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:40:"The timestamp that the file was created.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:8:"provider";s:4:"file";s:10:"field_name";s:7:"created";s:11:"entity_type";s:4:"file";s:6:"bundle";N;}}s:7:"changed";O:37:"Drupal\\\\Core\\\\Field\\\\BaseFieldDefinition":5:{s:7:"\\000*\\000type";s:7:"changed";s:9:"\\000*\\000schema";a:4:{s:7:"columns";a:1:{s:5:"value";a:1:{s:4:"type";s:3:"int";}}s:11:"unique keys";a:0:{}s:7:"indexes";a:0:{}s:12:"foreign keys";a:0:{}}s:10:"\\000*\\000indexes";a:0:{}s:17:"\\000*\\000itemDefinition";O:51:"Drupal\\\\Core\\\\Field\\\\TypedData\\\\FieldItemDataDefinition":2:{s:18:"\\000*\\000fieldDefinition";r:343;s:13:"\\000*\\000definition";a:2:{s:4:"type";s:18:"field_item:changed";s:8:"settings";a:0:{}}}s:13:"\\000*\\000definition";a:6:{s:5:"label";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:7:"Changed";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:11:"description";O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:45:"The timestamp that the file was last changed.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}s:8:"provider";s:4:"file";s:10:"field_name";s:7:"changed";s:11:"entity_type";s:4:"file";s:6:"bundle";N;}}}
system.schema	file	i:8000;
system.schema	update	s:4:"8001";
state	system.theme.data	a:1:{s:5:"stark";C:31:"Drupal\\\\Core\\\\Extension\\\\Extension":1520:{a:13:{s:4:"type";s:5:"theme";s:8:"pathname";s:32:"core/themes/stark/stark.info.yml";s:8:"filename";N;s:7:"subpath";s:12:"themes/stark";s:6:"origin";s:4:"core";s:6:"status";i:1;s:4:"info";a:14:{s:4:"name";s:5:"Stark";s:4:"type";s:5:"theme";s:11:"description";s:208:"An intentionally plain theme with no styling to demonstrate default Drupal\\342\\200\\231s HTML and CSS. Learn how to build a custom theme from Stark in the <a href="https://www.drupal.org/theme-guide">Theming Guide</a>.";s:7:"package";s:4:"Core";s:7:"version";s:5:"8.1.3";s:4:"core";s:3:"8.x";s:6:"engine";s:4:"twig";s:7:"regions";a:12:{s:13:"sidebar_first";s:12:"Left sidebar";s:14:"sidebar_second";s:13:"Right sidebar";s:7:"content";s:7:"Content";s:6:"header";s:6:"Header";s:12:"primary_menu";s:12:"Primary menu";s:14:"secondary_menu";s:14:"Secondary menu";s:6:"footer";s:6:"Footer";s:11:"highlighted";s:11:"Highlighted";s:4:"help";s:4:"Help";s:8:"page_top";s:8:"Page top";s:11:"page_bottom";s:11:"Page bottom";s:10:"breadcrumb";s:10:"Breadcrumb";}s:8:"features";a:5:{i:0;s:7:"favicon";i:1;s:4:"logo";i:2;s:17:"node_user_picture";i:3;s:20:"comment_user_picture";i:4;s:25:"comment_user_verification";}s:10:"screenshot";s:32:"core/themes/stark/screenshot.png";s:3:"php";s:5:"5.5.9";s:9:"libraries";a:0:{}s:5:"mtime";i:1466376314;s:14:"regions_hidden";a:2:{i:0;s:8:"page_top";i:1;s:11:"page_bottom";}}s:5:"owner";s:36:"core/themes/engines/twig/twig.engine";s:6:"prefix";s:4:"twig";s:11:"required_by";a:0:{}s:8:"requires";a:0:{}s:4:"sort";i:0;s:6:"engine";s:4:"twig";}}}
state	install_time	i:1469959318;
state	update.last_check	i:1469959326;
state	system.cron_last	i:1469959318;
state	drupal_css_cache_files	a:1:{s:64:"41f3f5c6e7c40b91926a60c6c0b64b4de547db83f0d92bbcb788875ed9b000b1";s:64:"public://css/css_4w6DyMZOD_Fu1oxqpACBFcOPDgVYtgOuayu9S6-8btc.css";}
state	system.js_cache_files	a:4:{s:64:"ef5219d33ebedcd4b9b0ccc64f741d50bebb463122945dd3b12519b97e268ab4";s:61:"public://js/js_VtafjXmRvoUgAzqzYTA3Wrjkx9wcWhjP0G4ZnnqRamA.js";s:64:"22b57c12b5f7dfa20d16a8fb27842e2c48a55df949019086a2e14bfa9b53ed21";s:61:"public://js/js_BKcMdIbOMdbTdLn9dkUq3KCJfIKKo2SvKoQ1AnB8D-g.js";s:64:"c839df7c4fcaff2cb7890a0c2e9316f456b4c990c363fb4eb87a2a601c594055";s:61:"public://js/js_VhqXmo4azheUjYC30rijnR_Dddo0WjWkF27k5gTL8S4.js";s:64:"1bd990b9d767411171ce178097385040923e108a23224827bcdc545446b7db08";s:61:"public://js/js_etv0n6LzBQ73KOJ0ki0pWCqeNC9VseaTNrxFAnjwMQE.js";}
\.


--
-- Data for Name: key_value_expire; Type: TABLE DATA; Schema: public; Owner: -
--

COPY key_value_expire (collection, name, value, expire) FROM stdin;
update	update_project_projects	a:1:{s:6:"drupal";a:6:{s:4:"name";s:6:"drupal";s:4:"info";a:6:{s:4:"name";s:5:"Block";s:7:"package";s:4:"Core";s:7:"version";s:5:"8.1.3";s:7:"project";s:6:"drupal";s:16:"_info_file_ctime";i:1466376290;s:9:"datestamp";i:0;}s:9:"datestamp";i:0;s:8:"includes";a:12:{s:5:"block";s:5:"Block";s:5:"dblog";s:16:"Database Logging";s:18:"dynamic_page_cache";s:27:"Internal Dynamic Page Cache";s:5:"field";s:5:"Field";s:4:"file";s:4:"File";s:6:"filter";s:6:"Filter";s:4:"node";s:4:"Node";s:10:"page_cache";s:19:"Internal Page Cache";s:6:"system";s:6:"System";s:4:"text";s:4:"Text";s:6:"update";s:14:"Update Manager";s:4:"user";s:4:"User";}s:12:"project_type";s:4:"core";s:14:"project_status";b:1;}}	1469962918
update_available_releases	drupal	a:12:{s:5:"title";s:11:"Drupal core";s:10:"short_name";s:6:"drupal";s:4:"type";s:12:"project_core";s:11:"api_version";s:3:"8.x";s:17:"recommended_major";s:1:"8";s:16:"supported_majors";s:1:"8";s:13:"default_major";s:1:"8";s:14:"project_status";s:9:"published";s:4:"link";s:37:"https://www.drupal.org/project/drupal";s:5:"terms";s:0:"";s:8:"releases";a:53:{s:5:"8.1.7";a:14:{s:4:"name";s:12:"drupal 8.1.7";s:7:"version";s:5:"8.1.7";s:3:"tag";s:5:"8.1.7";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"1";s:13:"version_patch";s:1:"7";s:6:"status";s:9:"published";s:12:"release_link";s:52:"https://www.drupal.org/project/drupal/releases/8.1.7";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.1.7.tar.gz";s:4:"date";s:10:"1468855358";s:6:"mdhash";s:32:"19e95079e50dd3c19222b91ef1b57036";s:8:"filesize";s:8:"12601662";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:15:"Security update";}}}s:5:"8.1.6";a:14:{s:4:"name";s:12:"drupal 8.1.6";s:7:"version";s:5:"8.1.6";s:3:"tag";s:5:"8.1.6";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"1";s:13:"version_patch";s:1:"6";s:6:"status";s:9:"published";s:12:"release_link";s:52:"https://www.drupal.org/project/drupal/releases/8.1.6";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.1.6.tar.gz";s:4:"date";s:10:"1468242539";s:6:"mdhash";s:32:"f3fdd2f9266938c2c7afc091e8d6e6d1";s:8:"filesize";s:8:"12595889";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:9:"Bug fixes";}}}s:5:"8.1.5";a:14:{s:4:"name";s:12:"drupal 8.1.5";s:7:"version";s:5:"8.1.5";s:3:"tag";s:5:"8.1.5";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"1";s:13:"version_patch";s:1:"5";s:6:"status";s:9:"published";s:12:"release_link";s:52:"https://www.drupal.org/project/drupal/releases/8.1.5";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.1.5.tar.gz";s:4:"date";s:10:"1467884639";s:6:"mdhash";s:32:"0b30a3711d922c5348d6119e5124243b";s:8:"filesize";s:8:"12596430";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:9:"Bug fixes";}}}s:5:"8.1.4";a:14:{s:4:"name";s:12:"drupal 8.1.4";s:7:"version";s:5:"8.1.4";s:3:"tag";s:5:"8.1.4";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"1";s:13:"version_patch";s:1:"4";s:6:"status";s:9:"published";s:12:"release_link";s:52:"https://www.drupal.org/project/drupal/releases/8.1.4";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.1.4.tar.gz";s:4:"date";s:10:"1467810839";s:6:"mdhash";s:32:"8c07b855ffd028124eb8848526abf4d9";s:8:"filesize";s:8:"12595731";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:9:"Bug fixes";}}}s:5:"8.1.3";a:14:{s:4:"name";s:12:"drupal 8.1.3";s:7:"version";s:5:"8.1.3";s:3:"tag";s:5:"8.1.3";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"1";s:13:"version_patch";s:1:"3";s:6:"status";s:9:"published";s:12:"release_link";s:52:"https://www.drupal.org/project/drupal/releases/8.1.3";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.1.3.tar.gz";s:4:"date";s:10:"1466021480";s:6:"mdhash";s:32:"f2eef421c2a0610b32519f8f2e094b7c";s:8:"filesize";s:8:"12552870";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:15:"Security update";}}}s:5:"8.1.2";a:14:{s:4:"name";s:12:"drupal 8.1.2";s:7:"version";s:5:"8.1.2";s:3:"tag";s:5:"8.1.2";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"1";s:13:"version_patch";s:1:"2";s:6:"status";s:9:"published";s:12:"release_link";s:52:"https://www.drupal.org/project/drupal/releases/8.1.2";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.1.2.tar.gz";s:4:"date";s:10:"1464824339";s:6:"mdhash";s:32:"91fdfbd1c28512e41f2a61bf69214900";s:8:"filesize";s:8:"12553455";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:9:"Bug fixes";}}}s:5:"8.1.1";a:14:{s:4:"name";s:12:"drupal 8.1.1";s:7:"version";s:5:"8.1.1";s:3:"tag";s:5:"8.1.1";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"1";s:13:"version_patch";s:1:"1";s:6:"status";s:9:"published";s:12:"release_link";s:52:"https://www.drupal.org/project/drupal/releases/8.1.1";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.1.1.tar.gz";s:4:"date";s:10:"1462361039";s:6:"mdhash";s:32:"529f3d72964c612695f68e0a6078b8ae";s:8:"filesize";s:8:"12533960";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:9:"Bug fixes";}}}s:5:"8.1.0";a:14:{s:4:"name";s:12:"drupal 8.1.0";s:7:"version";s:5:"8.1.0";s:3:"tag";s:5:"8.1.0";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"1";s:13:"version_patch";s:1:"0";s:6:"status";s:9:"published";s:12:"release_link";s:52:"https://www.drupal.org/project/drupal/releases/8.1.0";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.1.0.tar.gz";s:4:"date";s:10:"1461118190";s:6:"mdhash";s:32:"a6bf3c366ba9ee5e0af3f2a80e274240";s:8:"filesize";s:8:"12520120";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:2:{i:0;s:9:"Bug fixes";i:1;s:12:"New features";}}}s:9:"8.1.0-rc1";a:15:{s:4:"name";s:16:"drupal 8.1.0-rc1";s:7:"version";s:9:"8.1.0-rc1";s:3:"tag";s:9:"8.1.0-rc1";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"1";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:3:"rc1";s:6:"status";s:9:"published";s:12:"release_link";s:56:"https://www.drupal.org/project/drupal/releases/8.1.0-rc1";s:13:"download_link";s:61:"https://ftp.drupal.org/files/projects/drupal-8.1.0-rc1.tar.gz";s:4:"date";s:10:"1459976639";s:6:"mdhash";s:32:"337de1b28e915e865a5385818ca82603";s:8:"filesize";s:8:"12459083";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:2:{i:0;s:9:"Bug fixes";i:1;s:12:"New features";}}}s:11:"8.1.0-beta2";a:15:{s:4:"name";s:18:"drupal 8.1.0-beta2";s:7:"version";s:11:"8.1.0-beta2";s:3:"tag";s:11:"8.1.0-beta2";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"1";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:5:"beta2";s:6:"status";s:9:"published";s:12:"release_link";s:58:"https://www.drupal.org/project/drupal/releases/8.1.0-beta2";s:13:"download_link";s:63:"https://ftp.drupal.org/files/projects/drupal-8.1.0-beta2.tar.gz";s:4:"date";s:10:"1458699840";s:6:"mdhash";s:32:"e916a10fb2dedaf3ebd88ddc010031be";s:8:"filesize";s:8:"12426385";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:2:{i:0;s:9:"Bug fixes";i:1;s:12:"New features";}}}s:11:"8.1.0-beta1";a:15:{s:4:"name";s:18:"drupal 8.1.0-beta1";s:7:"version";s:11:"8.1.0-beta1";s:3:"tag";s:11:"8.1.0-beta1";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"1";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:5:"beta1";s:6:"status";s:9:"published";s:12:"release_link";s:58:"https://www.drupal.org/project/drupal/releases/8.1.0-beta1";s:13:"download_link";s:63:"https://ftp.drupal.org/files/projects/drupal-8.1.0-beta1.tar.gz";s:4:"date";s:10:"1456975758";s:6:"mdhash";s:32:"3dc3b2354c54e35070052a175b957da0";s:8:"filesize";s:8:"11906519";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:2:{i:0;s:9:"Bug fixes";i:1;s:12:"New features";}}}s:5:"8.0.6";a:14:{s:4:"name";s:12:"drupal 8.0.6";s:7:"version";s:5:"8.0.6";s:3:"tag";s:5:"8.0.6";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"6";s:6:"status";s:9:"published";s:12:"release_link";s:52:"https://www.drupal.org/project/drupal/releases/8.0.6";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.0.6.tar.gz";s:4:"date";s:10:"1459900439";s:6:"mdhash";s:32:"952c14d46f0b02bcb29de5c3349c19ee";s:8:"filesize";s:8:"11782652";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:9:"Bug fixes";}}}s:5:"8.0.5";a:14:{s:4:"name";s:12:"drupal 8.0.5";s:7:"version";s:5:"8.0.5";s:3:"tag";s:5:"8.0.5";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"5";s:6:"status";s:9:"published";s:12:"release_link";s:52:"https://www.drupal.org/project/drupal/releases/8.0.5";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.0.5.tar.gz";s:4:"date";s:10:"1456914839";s:6:"mdhash";s:32:"c13a69b0f99d70ecb6415d77f484bc7f";s:8:"filesize";s:8:"11770913";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:9:"Bug fixes";}}}s:5:"8.0.4";a:14:{s:4:"name";s:12:"drupal 8.0.4";s:7:"version";s:5:"8.0.4";s:3:"tag";s:5:"8.0.4";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"4";s:6:"status";s:9:"published";s:12:"release_link";s:52:"https://www.drupal.org/project/drupal/releases/8.0.4";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.0.4.tar.gz";s:4:"date";s:10:"1456341749";s:6:"mdhash";s:32:"7516dd4c18415020f80f000035e970ce";s:8:"filesize";s:8:"11746172";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:15:"Security update";}}}s:5:"8.0.3";a:14:{s:4:"name";s:12:"drupal 8.0.3";s:7:"version";s:5:"8.0.3";s:3:"tag";s:5:"8.0.3";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"3";s:6:"status";s:9:"published";s:12:"release_link";s:49:"https://www.drupal.org/drupal-8.0.3-release-notes";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.0.3.tar.gz";s:4:"date";s:10:"1454489043";s:6:"mdhash";s:32:"7d5f5278a870b8f4a29cda4fe915d619";s:8:"filesize";s:8:"11741502";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:9:"Bug fixes";}}}s:5:"8.0.2";a:14:{s:4:"name";s:12:"drupal 8.0.2";s:7:"version";s:5:"8.0.2";s:3:"tag";s:5:"8.0.2";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"2";s:6:"status";s:9:"published";s:12:"release_link";s:49:"https://www.drupal.org/drupal-8.0.2-release-notes";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.0.2.tar.gz";s:4:"date";s:10:"1452119939";s:6:"mdhash";s:32:"9c39dec82c6d1a6d2004c30b11fb052e";s:8:"filesize";s:8:"11720487";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:9:"Bug fixes";}}}s:5:"8.0.1";a:14:{s:4:"name";s:12:"drupal 8.0.1";s:7:"version";s:5:"8.0.1";s:3:"tag";s:5:"8.0.1";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"1";s:6:"status";s:9:"published";s:12:"release_link";s:52:"https://www.drupal.org/project/drupal/releases/8.0.1";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.0.1.tar.gz";s:4:"date";s:10:"1449066839";s:6:"mdhash";s:32:"423cc4d28da066d099986ac0844f6abb";s:8:"filesize";s:8:"11697695";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:9:"Bug fixes";}}}s:5:"8.0.0";a:14:{s:4:"name";s:12:"drupal 8.0.0";s:7:"version";s:5:"8.0.0";s:3:"tag";s:5:"8.0.0";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:6:"status";s:9:"published";s:12:"release_link";s:52:"https://www.drupal.org/project/drupal/releases/8.0.0";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.0.0.tar.gz";s:4:"date";s:10:"1447941840";s:6:"mdhash";s:32:"92ce9a54fa926b58032a4e39b0f9a9f1";s:8:"filesize";s:8:"11692820";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:9:"8.0.0-rc4";a:15:{s:4:"name";s:16:"drupal 8.0.0-rc4";s:7:"version";s:9:"8.0.0-rc4";s:3:"tag";s:9:"8.0.0-rc4";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:3:"rc4";s:6:"status";s:9:"published";s:12:"release_link";s:56:"https://www.drupal.org/project/drupal/releases/8.0.0-rc4";s:13:"download_link";s:61:"https://ftp.drupal.org/files/projects/drupal-8.0.0-rc4.tar.gz";s:4:"date";s:10:"1447413840";s:6:"mdhash";s:32:"33a4738989e4b571176e47d26443cb26";s:8:"filesize";s:8:"11687995";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:9:"8.0.0-rc3";a:15:{s:4:"name";s:16:"drupal 8.0.0-rc3";s:7:"version";s:9:"8.0.0-rc3";s:3:"tag";s:9:"8.0.0-rc3";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:3:"rc3";s:6:"status";s:9:"published";s:12:"release_link";s:56:"https://www.drupal.org/project/drupal/releases/8.0.0-rc3";s:13:"download_link";s:61:"https://ftp.drupal.org/files/projects/drupal-8.0.0-rc3.tar.gz";s:4:"date";s:10:"1446633239";s:6:"mdhash";s:32:"dedd68b8f39002d64fe64a0c5085e573";s:8:"filesize";s:8:"11557156";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:9:"8.0.0-rc2";a:15:{s:4:"name";s:16:"drupal 8.0.0-rc2";s:7:"version";s:9:"8.0.0-rc2";s:3:"tag";s:9:"8.0.0-rc2";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:3:"rc2";s:6:"status";s:9:"published";s:12:"release_link";s:56:"https://www.drupal.org/project/drupal/releases/8.0.0-rc2";s:13:"download_link";s:61:"https://ftp.drupal.org/files/projects/drupal-8.0.0-rc2.tar.gz";s:4:"date";s:10:"1445468639";s:6:"mdhash";s:32:"66f0032af1350410a502f3a8cde5ab3f";s:8:"filesize";s:8:"10728216";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:9:"Bug fixes";}}}s:9:"8.0.0-rc1";a:15:{s:4:"name";s:16:"drupal 8.0.0-rc1";s:7:"version";s:9:"8.0.0-rc1";s:3:"tag";s:9:"8.0.0-rc1";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:3:"rc1";s:6:"status";s:9:"published";s:12:"release_link";s:56:"https://www.drupal.org/project/drupal/releases/8.0.0-rc1";s:13:"download_link";s:61:"https://ftp.drupal.org/files/projects/drupal-8.0.0-rc1.tar.gz";s:4:"date";s:10:"1444253039";s:6:"mdhash";s:32:"58841f02728a85c105ce988e5605e4e5";s:8:"filesize";s:8:"11498104";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:9:"Bug fixes";}}}s:12:"8.0.0-beta16";a:15:{s:4:"name";s:19:"drupal 8.0.0-beta16";s:7:"version";s:12:"8.0.0-beta16";s:3:"tag";s:12:"8.0.0-beta16";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:6:"beta16";s:6:"status";s:9:"published";s:12:"release_link";s:59:"https://www.drupal.org/project/drupal/releases/8.0.0-beta16";s:13:"download_link";s:64:"https://ftp.drupal.org/files/projects/drupal-8.0.0-beta16.tar.gz";s:4:"date";s:10:"1443746640";s:6:"mdhash";s:32:"3204db355d8163616f10263074285aee";s:8:"filesize";s:8:"11433695";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:9:"Bug fixes";}}}s:12:"8.0.0-beta15";a:15:{s:4:"name";s:19:"drupal 8.0.0-beta15";s:7:"version";s:12:"8.0.0-beta15";s:3:"tag";s:12:"8.0.0-beta15";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:6:"beta15";s:6:"status";s:9:"published";s:12:"release_link";s:59:"https://www.drupal.org/project/drupal/releases/8.0.0-beta15";s:13:"download_link";s:64:"https://ftp.drupal.org/files/projects/drupal-8.0.0-beta15.tar.gz";s:4:"date";s:10:"1441357140";s:6:"mdhash";s:32:"727e700eab75395663d6c5dbd20fe6ee";s:8:"filesize";s:8:"11273890";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:12:"8.0.0-beta14";a:15:{s:4:"name";s:19:"drupal 8.0.0-beta14";s:7:"version";s:12:"8.0.0-beta14";s:3:"tag";s:12:"8.0.0-beta14";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:6:"beta14";s:6:"status";s:9:"published";s:12:"release_link";s:59:"https://www.drupal.org/project/drupal/releases/8.0.0-beta14";s:13:"download_link";s:64:"https://ftp.drupal.org/files/projects/drupal-8.0.0-beta14.tar.gz";s:4:"date";s:10:"1438593539";s:6:"mdhash";s:32:"ace8bfa17488faf80b6181cf9fb8035a";s:8:"filesize";s:8:"10493263";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:12:"8.0.0-beta13";a:15:{s:4:"name";s:19:"drupal 8.0.0-beta13";s:7:"version";s:12:"8.0.0-beta13";s:3:"tag";s:12:"8.0.0-beta13";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:6:"beta13";s:6:"status";s:9:"published";s:12:"release_link";s:59:"https://www.drupal.org/project/drupal/releases/8.0.0-beta13";s:13:"download_link";s:64:"https://ftp.drupal.org/files/projects/drupal-8.0.0-beta13.tar.gz";s:4:"date";s:10:"1438194539";s:6:"mdhash";s:32:"1e872066cc6bf8c072341740825ff141";s:8:"filesize";s:8:"10481509";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:12:"8.0.0-beta12";a:15:{s:4:"name";s:19:"drupal 8.0.0-beta12";s:7:"version";s:12:"8.0.0-beta12";s:3:"tag";s:12:"8.0.0-beta12";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:6:"beta12";s:6:"status";s:9:"published";s:12:"release_link";s:59:"https://www.drupal.org/project/drupal/releases/8.0.0-beta12";s:13:"download_link";s:64:"https://ftp.drupal.org/files/projects/drupal-8.0.0-beta12.tar.gz";s:4:"date";s:10:"1435601583";s:6:"mdhash";s:32:"7714744da283b70c14a2aa7fbb50eeeb";s:8:"filesize";s:8:"10662165";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:12:"8.0.0-beta11";a:15:{s:4:"name";s:19:"drupal 8.0.0-beta11";s:7:"version";s:12:"8.0.0-beta11";s:3:"tag";s:12:"8.0.0-beta11";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:6:"beta11";s:6:"status";s:9:"published";s:12:"release_link";s:59:"https://www.drupal.org/project/drupal/releases/8.0.0-beta11";s:13:"download_link";s:64:"https://ftp.drupal.org/files/projects/drupal-8.0.0-beta11.tar.gz";s:4:"date";s:10:"1432758481";s:6:"mdhash";s:32:"885500fef1a692d0598daa27134a440a";s:8:"filesize";s:8:"10500627";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:12:"8.0.0-beta10";a:15:{s:4:"name";s:19:"drupal 8.0.0-beta10";s:7:"version";s:12:"8.0.0-beta10";s:3:"tag";s:12:"8.0.0-beta10";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:6:"beta10";s:6:"status";s:9:"published";s:12:"release_link";s:59:"https://www.drupal.org/project/drupal/releases/8.0.0-beta10";s:13:"download_link";s:64:"https://ftp.drupal.org/files/projects/drupal-8.0.0-beta10.tar.gz";s:4:"date";s:10:"1430314681";s:6:"mdhash";s:32:"cfe68b642776818a9df71211495fbb44";s:8:"filesize";s:8:"10296679";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:11:"8.0.0-beta9";a:15:{s:4:"name";s:18:"drupal 8.0.0-beta9";s:7:"version";s:11:"8.0.0-beta9";s:3:"tag";s:11:"8.0.0-beta9";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:5:"beta9";s:6:"status";s:9:"published";s:12:"release_link";s:58:"https://www.drupal.org/project/drupal/releases/8.0.0-beta9";s:13:"download_link";s:63:"https://ftp.drupal.org/files/projects/drupal-8.0.0-beta9.tar.gz";s:4:"date";s:10:"1427299981";s:6:"mdhash";s:32:"109172962c779f26528f697604695bec";s:8:"filesize";s:8:"10044027";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:11:"8.0.0-beta7";a:15:{s:4:"name";s:18:"drupal 8.0.0-beta7";s:7:"version";s:11:"8.0.0-beta7";s:3:"tag";s:11:"8.0.0-beta7";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:5:"beta7";s:6:"status";s:9:"published";s:12:"release_link";s:58:"https://www.drupal.org/project/drupal/releases/8.0.0-beta7";s:13:"download_link";s:63:"https://ftp.drupal.org/files/projects/drupal-8.0.0-beta7.tar.gz";s:4:"date";s:10:"1424875381";s:6:"mdhash";s:32:"b730108fbdd33ffe57fb94e94d293ebe";s:8:"filesize";s:7:"9694970";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:11:"8.0.0-beta6";a:15:{s:4:"name";s:18:"drupal 8.0.0-beta6";s:7:"version";s:11:"8.0.0-beta6";s:3:"tag";s:11:"8.0.0-beta6";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:5:"beta6";s:6:"status";s:9:"published";s:12:"release_link";s:58:"https://www.drupal.org/project/drupal/releases/8.0.0-beta6";s:13:"download_link";s:63:"https://ftp.drupal.org/files/projects/drupal-8.0.0-beta6.tar.gz";s:4:"date";s:10:"1422443800";s:6:"mdhash";s:32:"b2470e3e2ab4fa6adce0e9152d6ad4b9";s:8:"filesize";s:7:"9562882";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:11:"8.0.0-beta4";a:15:{s:4:"name";s:18:"drupal 8.0.0-beta4";s:7:"version";s:11:"8.0.0-beta4";s:3:"tag";s:11:"8.0.0-beta4";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:5:"beta4";s:6:"status";s:9:"published";s:12:"release_link";s:58:"https://www.drupal.org/project/drupal/releases/8.0.0-beta4";s:13:"download_link";s:63:"https://ftp.drupal.org/files/projects/drupal-8.0.0-beta4.tar.gz";s:4:"date";s:10:"1418825280";s:6:"mdhash";s:32:"66cf899e456bd27b7ff9beaf61dcf45f";s:8:"filesize";s:7:"9555745";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:11:"8.0.0-beta3";a:15:{s:4:"name";s:18:"drupal 8.0.0-beta3";s:7:"version";s:11:"8.0.0-beta3";s:3:"tag";s:11:"8.0.0-beta3";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:5:"beta3";s:6:"status";s:9:"published";s:12:"release_link";s:58:"https://www.drupal.org/project/drupal/releases/8.0.0-beta3";s:13:"download_link";s:63:"https://ftp.drupal.org/files/projects/drupal-8.0.0-beta3.tar.gz";s:4:"date";s:10:"1415797380";s:6:"mdhash";s:32:"89eb46c597eb9c8ef7423783aef7f340";s:8:"filesize";s:7:"9445245";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:11:"8.0.0-beta2";a:15:{s:4:"name";s:18:"drupal 8.0.0-beta2";s:7:"version";s:11:"8.0.0-beta2";s:3:"tag";s:11:"8.0.0-beta2";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:5:"beta2";s:6:"status";s:9:"published";s:12:"release_link";s:58:"https://www.drupal.org/project/drupal/releases/8.0.0-beta2";s:13:"download_link";s:63:"https://ftp.drupal.org/files/projects/drupal-8.0.0-beta2.tar.gz";s:4:"date";s:10:"1413394161";s:6:"mdhash";s:32:"5130f44ed3c0b3fa709eb1d92e7def33";s:8:"filesize";s:7:"9480603";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:15:"Security update";}}}s:11:"8.0.0-beta1";a:15:{s:4:"name";s:18:"drupal 8.0.0-beta1";s:7:"version";s:11:"8.0.0-beta1";s:3:"tag";s:11:"8.0.0-beta1";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:5:"beta1";s:6:"status";s:9:"published";s:12:"release_link";s:58:"https://www.drupal.org/project/drupal/releases/8.0.0-beta1";s:13:"download_link";s:63:"https://ftp.drupal.org/files/projects/drupal-8.0.0-beta1.tar.gz";s:4:"date";s:10:"1412147030";s:6:"mdhash";s:32:"9efea37c74bed8208133dc1aae76e53f";s:8:"filesize";s:7:"9389838";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:13:"8.0.0-alpha15";a:15:{s:4:"name";s:20:"drupal 8.0.0-alpha15";s:7:"version";s:13:"8.0.0-alpha15";s:3:"tag";s:13:"8.0.0-alpha15";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:7:"alpha15";s:6:"status";s:9:"published";s:12:"release_link";s:60:"https://www.drupal.org/project/drupal/releases/8.0.0-alpha15";s:13:"download_link";s:65:"https://ftp.drupal.org/files/projects/drupal-8.0.0-alpha15.tar.gz";s:4:"date";s:10:"1411139628";s:6:"mdhash";s:32:"a5ea2deb1776a3703315e90772d9ec58";s:8:"filesize";s:7:"9344566";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:13:"8.0.0-alpha14";a:15:{s:4:"name";s:20:"drupal 8.0.0-alpha14";s:7:"version";s:13:"8.0.0-alpha14";s:3:"tag";s:13:"8.0.0-alpha14";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:7:"alpha14";s:6:"status";s:9:"published";s:12:"release_link";s:60:"https://www.drupal.org/project/drupal/releases/8.0.0-alpha14";s:13:"download_link";s:65:"https://ftp.drupal.org/files/projects/drupal-8.0.0-alpha14.tar.gz";s:4:"date";s:10:"1407344628";s:6:"mdhash";s:32:"9d71afdd0ce541f2ff5ca2fbbca00df7";s:8:"filesize";s:7:"9172832";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:11:"8.0-alpha13";a:14:{s:4:"name";s:18:"drupal 8.0-alpha13";s:7:"version";s:11:"8.0-alpha13";s:3:"tag";s:11:"8.0-alpha13";s:13:"version_major";s:1:"8";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:7:"alpha13";s:6:"status";s:9:"published";s:12:"release_link";s:58:"https://www.drupal.org/project/drupal/releases/8.0-alpha13";s:13:"download_link";s:63:"https://ftp.drupal.org/files/projects/drupal-8.0-alpha13.tar.gz";s:4:"date";s:10:"1404296627";s:6:"mdhash";s:32:"6fb0325f937b870fbfab2f9526dd6e14";s:8:"filesize";s:7:"9089848";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:11:"8.0-alpha12";a:14:{s:4:"name";s:18:"drupal 8.0-alpha12";s:7:"version";s:11:"8.0-alpha12";s:3:"tag";s:11:"8.0-alpha12";s:13:"version_major";s:1:"8";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:7:"alpha12";s:6:"status";s:9:"published";s:12:"release_link";s:58:"https://www.drupal.org/project/drupal/releases/8.0-alpha12";s:13:"download_link";s:63:"https://ftp.drupal.org/files/projects/drupal-8.0-alpha12.tar.gz";s:4:"date";s:10:"1401293627";s:6:"mdhash";s:32:"fdf022c5375e77c59bd35a61e6ec68e5";s:8:"filesize";s:7:"8792935";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:9:"Bug fixes";}}}s:11:"8.0-alpha11";a:14:{s:4:"name";s:18:"drupal 8.0-alpha11";s:7:"version";s:11:"8.0-alpha11";s:3:"tag";s:11:"8.0-alpha11";s:13:"version_major";s:1:"8";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:7:"alpha11";s:6:"status";s:9:"published";s:12:"release_link";s:58:"https://www.drupal.org/project/drupal/releases/8.0-alpha11";s:13:"download_link";s:63:"https://ftp.drupal.org/files/projects/drupal-8.0-alpha11.tar.gz";s:4:"date";s:10:"1398249227";s:6:"mdhash";s:32:"3b1a74ec242b145c7a6fa0fe5070a4ee";s:8:"filesize";s:7:"8613989";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:11:"8.0-alpha10";a:14:{s:4:"name";s:18:"drupal 8.0-alpha10";s:7:"version";s:11:"8.0-alpha10";s:3:"tag";s:11:"8.0-alpha10";s:13:"version_major";s:1:"8";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:7:"alpha10";s:6:"status";s:9:"published";s:12:"release_link";s:58:"https://www.drupal.org/project/drupal/releases/8.0-alpha10";s:13:"download_link";s:63:"https://ftp.drupal.org/files/projects/drupal-8.0-alpha10.tar.gz";s:4:"date";s:10:"1395231556";s:6:"mdhash";s:32:"b542bd467beeb7ea3c63c8f0027a3439";s:8:"filesize";s:7:"8109552";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:10:"8.0-alpha9";a:14:{s:4:"name";s:17:"drupal 8.0-alpha9";s:7:"version";s:10:"8.0-alpha9";s:3:"tag";s:10:"8.0-alpha9";s:13:"version_major";s:1:"8";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:6:"alpha9";s:6:"status";s:9:"published";s:12:"release_link";s:57:"https://www.drupal.org/project/drupal/releases/8.0-alpha9";s:13:"download_link";s:62:"https://ftp.drupal.org/files/projects/drupal-8.0-alpha9.tar.gz";s:4:"date";s:10:"1392806005";s:6:"mdhash";s:32:"cb5af8f8fe865a7f834b99d421e23839";s:8:"filesize";s:7:"8105277";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:12:"New features";}}}s:10:"8.0-alpha8";a:14:{s:4:"name";s:17:"drupal 8.0-alpha8";s:7:"version";s:10:"8.0-alpha8";s:3:"tag";s:10:"8.0-alpha8";s:13:"version_major";s:1:"8";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:6:"alpha8";s:6:"status";s:9:"published";s:12:"release_link";s:57:"https://www.drupal.org/project/drupal/releases/8.0-alpha8";s:13:"download_link";s:62:"https://ftp.drupal.org/files/projects/drupal-8.0-alpha8.tar.gz";s:4:"date";s:10:"1390393105";s:6:"mdhash";s:32:"5c970df83a2f4027b0377fbcf890eb79";s:8:"filesize";s:7:"8037378";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:2:{i:0;s:9:"Bug fixes";i:1;s:12:"New features";}}}s:10:"8.0-alpha7";a:14:{s:4:"name";s:17:"drupal 8.0-alpha7";s:7:"version";s:10:"8.0-alpha7";s:3:"tag";s:10:"8.0-alpha7";s:13:"version_major";s:1:"8";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:6:"alpha7";s:6:"status";s:9:"published";s:12:"release_link";s:57:"https://www.drupal.org/project/drupal/releases/8.0-alpha7";s:13:"download_link";s:62:"https://ftp.drupal.org/files/projects/drupal-8.0-alpha7.tar.gz";s:4:"date";s:10:"1387399705";s:6:"mdhash";s:32:"49228c4537941eb1f63f5bf0eb742d1f";s:8:"filesize";s:7:"7913974";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:2:{i:0;s:9:"Bug fixes";i:1;s:12:"New features";}}}s:10:"8.0-alpha6";a:14:{s:4:"name";s:17:"drupal 8.0-alpha6";s:7:"version";s:10:"8.0-alpha6";s:3:"tag";s:10:"8.0-alpha6";s:13:"version_major";s:1:"8";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:6:"alpha6";s:6:"status";s:9:"published";s:12:"release_link";s:57:"https://www.drupal.org/project/drupal/releases/8.0-alpha6";s:13:"download_link";s:62:"https://ftp.drupal.org/files/projects/drupal-8.0-alpha6.tar.gz";s:4:"date";s:10:"1385153305";s:6:"mdhash";s:32:"6fb6eb93826c9f75cbc2bf62fa61f28d";s:8:"filesize";s:7:"7914981";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:9:"Bug fixes";}}}s:10:"8.0-alpha5";a:14:{s:4:"name";s:17:"drupal 8.0-alpha5";s:7:"version";s:10:"8.0-alpha5";s:3:"tag";s:10:"8.0-alpha5";s:13:"version_major";s:1:"8";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:6:"alpha5";s:6:"status";s:9:"published";s:12:"release_link";s:57:"https://www.drupal.org/project/drupal/releases/8.0-alpha5";s:13:"download_link";s:62:"https://ftp.drupal.org/files/projects/drupal-8.0-alpha5.tar.gz";s:4:"date";s:10:"1384850305";s:6:"mdhash";s:32:"4b3c1a6ab88a68ca17482035dbde8f4f";s:8:"filesize";s:7:"7883692";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:10:"8.0-alpha4";a:14:{s:4:"name";s:17:"drupal 8.0-alpha4";s:7:"version";s:10:"8.0-alpha4";s:3:"tag";s:10:"8.0-alpha4";s:13:"version_major";s:1:"8";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:6:"alpha4";s:6:"status";s:9:"published";s:12:"release_link";s:57:"https://www.drupal.org/project/drupal/releases/8.0-alpha4";s:13:"download_link";s:62:"https://ftp.drupal.org/files/projects/drupal-8.0-alpha4.tar.gz";s:4:"date";s:10:"1382092313";s:6:"mdhash";s:32:"793447ac11e240b1f1743adf33239ed6";s:8:"filesize";s:7:"7804215";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:2:{i:0;s:12:"New features";i:1;s:9:"Bug fixes";}}}s:10:"8.0-alpha3";a:14:{s:4:"name";s:17:"drupal 8.0-alpha3";s:7:"version";s:10:"8.0-alpha3";s:3:"tag";s:10:"8.0-alpha3";s:13:"version_major";s:1:"8";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:6:"alpha3";s:6:"status";s:9:"published";s:12:"release_link";s:57:"https://www.drupal.org/project/drupal/releases/8.0-alpha3";s:13:"download_link";s:62:"https://ftp.drupal.org/files/projects/drupal-8.0-alpha3.tar.gz";s:4:"date";s:10:"1378303307";s:6:"mdhash";s:32:"c786a027b87428fef5ddd7a946dcf07c";s:8:"filesize";s:7:"7647641";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:2:{i:0;s:12:"New features";i:1;s:9:"Bug fixes";}}}s:10:"8.0-alpha2";a:14:{s:4:"name";s:17:"drupal 8.0-alpha2";s:7:"version";s:10:"8.0-alpha2";s:3:"tag";s:10:"8.0-alpha2";s:13:"version_major";s:1:"8";s:13:"version_patch";s:1:"0";s:13:"version_extra";s:6:"alpha2";s:6:"status";s:9:"published";s:12:"release_link";s:57:"https://www.drupal.org/project/drupal/releases/8.0-alpha2";s:13:"download_link";s:62:"https://ftp.drupal.org/files/projects/drupal-8.0-alpha2.tar.gz";s:4:"date";s:10:"1372069563";s:6:"mdhash";s:32:"01f5589dcfd851c7d65c040f455bad19";s:8:"filesize";s:7:"7319631";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:9:"8.2.x-dev";a:14:{s:4:"name";s:16:"drupal 8.2.x-dev";s:7:"version";s:9:"8.2.x-dev";s:3:"tag";s:5:"8.2.x";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"2";s:13:"version_extra";s:3:"dev";s:6:"status";s:9:"published";s:12:"release_link";s:56:"https://www.drupal.org/project/drupal/releases/8.2.x-dev";s:13:"download_link";s:61:"https://ftp.drupal.org/files/projects/drupal-8.2.x-dev.tar.gz";s:4:"date";s:10:"1469891339";s:6:"mdhash";s:32:"d1bab8c63c2f4e539dda53c96bd58805";s:8:"filesize";s:8:"12725571";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:9:"8.1.x-dev";a:14:{s:4:"name";s:16:"drupal 8.1.x-dev";s:7:"version";s:9:"8.1.x-dev";s:3:"tag";s:5:"8.1.x";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"1";s:13:"version_extra";s:3:"dev";s:6:"status";s:9:"published";s:12:"release_link";s:56:"https://www.drupal.org/project/drupal/releases/8.1.x-dev";s:13:"download_link";s:61:"https://ftp.drupal.org/files/projects/drupal-8.1.x-dev.tar.gz";s:4:"date";s:10:"1469743439";s:6:"mdhash";s:32:"d5ee194906cc499bf42dbe10fca00c71";s:8:"filesize";s:8:"12635989";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:0:{}}s:9:"8.0.x-dev";a:14:{s:4:"name";s:16:"drupal 8.0.x-dev";s:7:"version";s:9:"8.0.x-dev";s:3:"tag";s:5:"8.0.x";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"0";s:13:"version_extra";s:3:"dev";s:6:"status";s:9:"published";s:12:"release_link";s:56:"https://www.drupal.org/project/drupal/releases/8.0.x-dev";s:13:"download_link";s:61:"https://ftp.drupal.org/files/projects/drupal-8.0.x-dev.tar.gz";s:4:"date";s:10:"1459900439";s:6:"mdhash";s:32:"8265a5c9ac0b4f1d90ae55c2f389265d";s:8:"filesize";s:8:"11792185";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:2:{i:0;s:9:"Bug fixes";i:1;s:12:"New features";}}}}s:10:"last_fetch";i:1469959326;}	1470045726
update	fetch_failures	N;	1469959626
update	update_project_data	a:1:{s:6:"drupal";a:16:{s:4:"name";s:6:"drupal";s:4:"info";a:6:{s:4:"name";s:5:"Block";s:7:"package";s:4:"Core";s:7:"version";s:5:"8.1.3";s:7:"project";s:6:"drupal";s:16:"_info_file_ctime";i:1466376290;s:9:"datestamp";i:0;}s:9:"datestamp";i:0;s:8:"includes";a:12:{s:5:"block";s:5:"Block";s:5:"dblog";s:16:"Database Logging";s:18:"dynamic_page_cache";s:27:"Internal Dynamic Page Cache";s:5:"field";s:5:"Field";s:4:"file";s:4:"File";s:6:"filter";s:6:"Filter";s:4:"node";s:4:"Node";s:10:"page_cache";s:19:"Internal Page Cache";s:6:"system";s:6:"System";s:4:"text";s:4:"Text";s:6:"update";s:14:"Update Manager";s:4:"user";s:4:"User";}s:12:"project_type";s:4:"core";s:14:"project_status";b:1;s:16:"existing_version";s:5:"8.1.3";s:14:"existing_major";s:1:"8";s:12:"install_type";s:8:"official";s:5:"title";s:11:"Drupal core";s:4:"link";s:37:"https://www.drupal.org/project/drupal";s:14:"latest_version";s:5:"8.1.7";s:8:"releases";a:1:{s:5:"8.1.7";a:14:{s:4:"name";s:12:"drupal 8.1.7";s:7:"version";s:5:"8.1.7";s:3:"tag";s:5:"8.1.7";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"1";s:13:"version_patch";s:1:"7";s:6:"status";s:9:"published";s:12:"release_link";s:52:"https://www.drupal.org/project/drupal/releases/8.1.7";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.1.7.tar.gz";s:4:"date";s:10:"1468855358";s:6:"mdhash";s:32:"19e95079e50dd3c19222b91ef1b57036";s:8:"filesize";s:8:"12601662";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:15:"Security update";}}}}s:11:"recommended";s:5:"8.1.7";s:16:"security updates";a:1:{i:0;a:14:{s:4:"name";s:12:"drupal 8.1.7";s:7:"version";s:5:"8.1.7";s:3:"tag";s:5:"8.1.7";s:13:"version_major";s:1:"8";s:13:"version_minor";s:1:"1";s:13:"version_patch";s:1:"7";s:6:"status";s:9:"published";s:12:"release_link";s:52:"https://www.drupal.org/project/drupal/releases/8.1.7";s:13:"download_link";s:57:"https://ftp.drupal.org/files/projects/drupal-8.1.7.tar.gz";s:4:"date";s:10:"1468855358";s:6:"mdhash";s:32:"19e95079e50dd3c19222b91ef1b57036";s:8:"filesize";s:8:"12601662";s:5:"files";s:11:"\\012   \\012   \\012  ";s:5:"terms";a:1:{s:12:"Release type";a:1:{i:0;s:15:"Security update";}}}}s:6:"status";i:1;}}	1469962918
\.


--
-- Data for Name: menu_tree; Type: TABLE DATA; Schema: public; Owner: -
--

COPY menu_tree (menu_name, mlid, id, parent, route_name, route_param_key, route_parameters, url, title, description, class, options, provider, enabled, discovered, expanded, weight, metadata, has_children, depth, p1, p2, p3, p4, p5, p6, p7, p8, p9, form_class) FROM stdin;
admin	2	system.admin_content	system.admin	system.admin_content		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:7:"Content";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:24:"Find and manage content.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-10	a:0:{}	0	2	1	2	0	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	3	system.admin_structure	system.admin	system.admin_structure		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:9:"Structure";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:45:"Administer blocks, content types, menus, etc.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-8	a:0:{}	1	2	1	3	0	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	4	system.themes_page	system.admin	system.themes_page		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:10:"Appearance";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:28:"Select and configure themes.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-6	a:0:{}	0	2	1	4	0	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	5	system.modules_list	system.admin	system.modules_list		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:6:"Extend";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:52:"Add and enable modules to extend site functionality.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-2	a:0:{}	0	2	1	5	0	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	8	system.file_system_settings	system.admin_config_media	system.file_system_settings		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:11:"File system";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:67:"Configure the location of uploaded files and how they are accessed.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	0	a:0:{}	0	4	1	6	7	8	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	9	system.image_toolkit_settings	system.admin_config_media	system.image_toolkit_settings		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Image toolkit";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:74:"Choose which image toolkit to use if you have installed optional toolkits.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	20	a:0:{}	0	4	1	6	7	9	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	7	system.admin_config_media	system.admin_config	system.admin_config_media		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:5:"Media";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	s:0:"";	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-10	a:0:{}	1	3	1	6	7	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	11	system.rss_feeds_settings	system.admin_config_services	system.rss_feeds_settings		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:14:"RSS publishing";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:115:"Configure the site description, the number of items per feed, and whether feeds should be titles/teasers/full-text.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	0	a:0:{}	0	4	1	6	10	11	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	19	system.admin_config_search	system.admin_config	system.admin_config_search		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:19:"Search and metadata";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:64:"Configure site search, metadata, and search engine optimization.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-10	a:0:{}	0	3	1	6	19	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	21	system.site_information_settings	system.admin_config_system	system.site_information_settings		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:19:"Basic site settings";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:77:"Change site name, email address, slogan, default front page, and error pages.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-20	a:0:{}	0	4	1	6	20	21	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	22	system.cron_settings	system.admin_config_system	system.cron_settings		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:4:"Cron";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:40:"Manage automatic site maintenance tasks.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	20	a:0:{}	0	4	1	6	20	22	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	6	system.admin_config	system.admin	system.admin_config		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Configuration";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:20:"Administer settings.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	0	a:0:{}	1	2	1	6	0	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	29	entity.user.admin_form	user.admin_index	entity.user.admin_form		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:16:"Account settings";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:105:"Configure default user account settings, including fields, registration requirements, and email messages.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	user	1	1	0	-10	a:0:{}	0	4	1	6	28	29	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	41	update.status	system.admin_reports	update.status		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:17:"Available updates";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:82:"Get a status report about available updates for your installed modules and themes.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	update	1	1	0	-50	a:0:{}	0	3	1	26	41	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	26	system.admin_reports	system.admin	system.admin_reports		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:7:"Reports";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:34:"View reports, updates, and errors.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	5	a:0:{}	1	2	1	26	0	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	12	system.admin_config_development	system.admin_config	system.admin_config_development		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:11:"Development";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:36:"Configure and use development tools.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-10	a:0:{}	1	3	1	6	12	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	30	entity.user.collection	system.admin	entity.user.collection		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:6:"People";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:45:"Manage user accounts, roles, and permissions.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	user	1	1	0	4	a:0:{}	0	2	1	30	0	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	1	system.admin		system.admin		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:14:"Administration";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	s:0:"";	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	9	a:0:{}	1	1	1	0	0	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
account	32	user.logout				a:0:{}		s:0:"";	s:0:"";	Drupal\\user\\Plugin\\Menu\\LoginLogoutMenuLink	a:0:{}	user	1	1	0	10	a:0:{}	0	1	32	0	0	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	10	system.admin_config_services	system.admin_config	system.admin_config_services		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:12:"Web services";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	s:0:"";	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	0	a:0:{}	1	3	1	6	10	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	13	system.site_maintenance_mode	system.admin_config_development	system.site_maintenance_mode		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:16:"Maintenance mode";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:62:"Take the site offline for updates and other maintenance tasks.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-10	a:0:{}	0	4	1	6	12	13	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	14	system.performance_settings	system.admin_config_development	system.performance_settings		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:11:"Performance";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:45:"Configure caching and bandwidth optimization.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-20	a:0:{}	0	4	1	6	12	14	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	15	system.logging_settings	system.admin_config_development	system.logging_settings		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:18:"Logging and errors";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:61:"Configure the display of error messages and database logging.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-15	a:0:{}	0	4	1	6	12	15	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	17	system.regional_settings	system.admin_config_regional	system.regional_settings		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:17:"Regional settings";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:43:"Configure the locale and timezone settings.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-20	a:0:{}	0	4	1	6	16	17	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	18	entity.date_format.collection	system.admin_config_regional	entity.date_format.collection		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:21:"Date and time formats";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:44:"Configure how dates and times are displayed.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-9	a:0:{}	0	4	1	6	16	18	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	16	system.admin_config_regional	system.admin_config	system.admin_config_regional		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:21:"Regional and language";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:59:"Configure regional settings, localization, and translation.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-5	a:0:{}	1	3	1	6	16	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	20	system.admin_config_system	system.admin_config	system.admin_config_system		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:6:"System";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:49:"Configure basic site settings, actions, and cron.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-20	a:0:{}	1	3	1	6	20	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
tools	33	filter.tips_all		filter.tips_all		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:12:"Compose tips";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	s:0:"";	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	filter	0	1	0	0	a:0:{}	0	1	33	0	0	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	23	system.admin_config_ui	system.admin_config	system.admin_config_ui		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:14:"User interface";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:44:"Configure the administrative user interface.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-15	a:0:{}	0	3	1	6	23	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	24	system.admin_config_workflow	system.admin_config	system.admin_config_workflow		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:8:"Workflow";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:28:"Manage the content workflow.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	5	a:0:{}	0	3	1	6	24	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	34	filter.admin_overview	system.admin_config_content	filter.admin_overview		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:12:"Text formats";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:125:"Configure how content is filtered when displayed, including which HTML tags are rendered, and enable module-provided filters.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	filter	1	1	0	0	a:0:{}	0	4	1	6	25	34	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	25	system.admin_config_content	system.admin_config	system.admin_config_content		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:17:"Content authoring";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:43:"Configure content formatting and authoring.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	-15	a:0:{}	1	3	1	6	25	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
account	31	user.page		user.page		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:10:"My account";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	s:0:"";	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	user	1	1	0	-10	a:0:{}	0	1	31	0	0	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	35	block.admin_display	system.admin_structure	block.admin_display		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:12:"Block layout";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:79:"Configure what block content appears in your site's sidebars and other regions.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	block	1	1	0	0	a:0:{}	0	3	1	3	35	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
tools	36	node.add_page		node.add_page		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:11:"Add content";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	s:0:"";	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	node	1	1	0	0	a:0:{}	0	1	36	0	0	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	37	entity.node_type.collection	system.admin_structure	entity.node_type.collection		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Content types";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:71:"Create and manage fields, forms, and display settings for your content.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	node	1	1	0	0	a:0:{}	0	3	1	3	37	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	28	user.admin_index	system.admin_config	user.admin_index		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:6:"People";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:24:"Configure user accounts.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	user	1	1	0	-20	a:0:{}	1	3	1	6	28	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	38	dblog.overview	system.admin_reports	dblog.overview		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:19:"Recent log messages";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:43:"View events that have recently been logged.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	dblog	1	1	0	-1	a:0:{}	0	3	1	26	38	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	39	dblog.page_not_found	system.admin_reports	dblog.page_not_found		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:27:"Top 'page not found' errors";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:36:"View 'page not found' errors (404s).";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	dblog	1	1	0	0	a:0:{}	0	3	1	26	39	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	40	dblog.access_denied	system.admin_reports	dblog.access_denied		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:26:"Top 'access denied' errors";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:35:"View 'access denied' errors (403s).";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	dblog	1	1	0	0	a:0:{}	0	3	1	26	40	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
admin	27	system.status	system.admin_reports	system.status		a:0:{}		O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:13:"Status report";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	O:48:"Drupal\\\\Core\\\\StringTranslation\\\\TranslatableMarkup":3:{s:9:"\\000*\\000string";s:48:"Get a status report about your site's operation.";s:12:"\\000*\\000arguments";a:0:{}s:10:"\\000*\\000options";a:0:{}}	Drupal\\Core\\Menu\\MenuLinkDefault	a:0:{}	system	1	1	0	0	a:0:{}	0	3	1	26	27	0	0	0	0	0	0	Drupal\\Core\\Menu\\Form\\MenuLinkDefaultForm
\.


--
-- Name: menu_tree_mlid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('menu_tree_mlid_seq', 41, true);


--
-- Data for Name: node; Type: TABLE DATA; Schema: public; Owner: -
--

COPY node (nid, vid, type, uuid, langcode) FROM stdin;
\.


--
-- Data for Name: node__body; Type: TABLE DATA; Schema: public; Owner: -
--

COPY node__body (bundle, deleted, entity_id, revision_id, langcode, delta, body_value, body_summary, body_format) FROM stdin;
\.


--
-- Data for Name: node_access; Type: TABLE DATA; Schema: public; Owner: -
--

COPY node_access (nid, langcode, fallback, gid, realm, grant_view, grant_update, grant_delete) FROM stdin;
0		1	0	all	1	0	0
\.


--
-- Data for Name: node_field_data; Type: TABLE DATA; Schema: public; Owner: -
--

COPY node_field_data (nid, vid, type, langcode, title, uid, status, created, changed, promote, sticky, revision_translation_affected, default_langcode) FROM stdin;
\.


--
-- Data for Name: node_field_revision; Type: TABLE DATA; Schema: public; Owner: -
--

COPY node_field_revision (nid, vid, langcode, title, uid, status, created, changed, promote, sticky, revision_translation_affected, default_langcode) FROM stdin;
\.


--
-- Name: node_nid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('node_nid_seq', 1, false);


--
-- Data for Name: node_revision; Type: TABLE DATA; Schema: public; Owner: -
--

COPY node_revision (nid, vid, langcode, revision_timestamp, revision_uid, revision_log) FROM stdin;
\.


--
-- Data for Name: node_revision__body; Type: TABLE DATA; Schema: public; Owner: -
--

COPY node_revision__body (bundle, deleted, entity_id, revision_id, langcode, delta, body_value, body_summary, body_format) FROM stdin;
\.


--
-- Name: node_revision_vid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('node_revision_vid_seq', 1, false);


--
-- Data for Name: queue; Type: TABLE DATA; Schema: public; Owner: -
--

COPY queue (item_id, name, data, expire, created) FROM stdin;
\.


--
-- Name: queue_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('queue_item_id_seq', 11, true);


--
-- Data for Name: router; Type: TABLE DATA; Schema: public; Owner: -
--

COPY router (name, path, pattern_outline, fit, route, number_parts) FROM stdin;
system.401	/system/401	/system/401	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1042:{a:9:{s:4:"path";s:11:"/system/401";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:49:"\\\\Drupal\\\\system\\\\Controller\\\\Http4xxController:on401";s:6:"_title";s:12:"Unauthorized";}s:12:"requirements";a:2:{s:7:"_access";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:4:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:20:"access_check.default";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":340:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:11:"/system/401";s:10:"path_regex";s:16:"#^/system/401$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:11:"/system/401";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:11:"/system/401";s:8:"numParts";i:2;}}}}	2
system.403	/system/403	/system/403	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1043:{a:9:{s:4:"path";s:11:"/system/403";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:49:"\\\\Drupal\\\\system\\\\Controller\\\\Http4xxController:on403";s:6:"_title";s:13:"Access denied";}s:12:"requirements";a:2:{s:7:"_access";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:4:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:20:"access_check.default";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":340:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:11:"/system/403";s:10:"path_regex";s:16:"#^/system/403$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:11:"/system/403";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:11:"/system/403";s:8:"numParts";i:2;}}}}	2
dblog.confirm	/admin/reports/dblog/confirm	/admin/reports/dblog/confirm	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1216:{a:9:{s:4:"path";s:28:"/admin/reports/dblog/confirm";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:43:"\\\\Drupal\\\\dblog\\\\Form\\\\DblogClearLogConfirmForm";s:6:"_title";s:34:"Confirm delete recent log messages";}s:12:"requirements";a:2:{s:11:"_permission";s:19:"access site reports";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":409:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:28:"/admin/reports/dblog/confirm";s:10:"path_regex";s:33:"#^/admin/reports/dblog/confirm$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:28:"/admin/reports/dblog/confirm";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:28:"/admin/reports/dblog/confirm";s:8:"numParts";i:4;}}}}	4
system.404	/system/404	/system/404	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1044:{a:9:{s:4:"path";s:11:"/system/404";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:49:"\\\\Drupal\\\\system\\\\Controller\\\\Http4xxController:on404";s:6:"_title";s:14:"Page not found";}s:12:"requirements";a:2:{s:7:"_access";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:4:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:20:"access_check.default";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":340:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:11:"/system/404";s:10:"path_regex";s:16:"#^/system/404$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:11:"/system/404";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:11:"/system/404";s:8:"numParts";i:2;}}}}	2
block.admin_demo	/admin/structure/block/demo/{theme}	/admin/structure/block/demo/%	30	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1381:{a:9:{s:4:"path";s:35:"/admin/structure/block/demo/{theme}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:46:"\\\\Drupal\\\\block\\\\Controller\\\\BlockController::demo";s:15:"_title_callback";s:21:"theme_handler:getName";}s:12:"requirements";a:3:{s:13:"_access_theme";s:4:"TRUE";s:11:"_permission";s:17:"administer blocks";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:0;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:2:{i:0;s:18:"access_check.theme";i:1;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":531:{a:11:{s:4:"vars";a:1:{i:0;s:5:"theme";}s:11:"path_prefix";s:27:"/admin/structure/block/demo";s:10:"path_regex";s:50:"#^/admin/structure/block/demo/(?P<theme>[^/]++)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:5:"theme";}i:1;a:2:{i:0;s:4:"text";i:1;s:27:"/admin/structure/block/demo";}}s:9:"path_vars";a:1:{i:0;s:5:"theme";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:30;s:14:"patternOutline";s:29:"/admin/structure/block/demo/%";s:8:"numParts";i:5;}}}}	5
entity.block.delete_form	/admin/structure/block/manage/{block}/delete	/admin/structure/block/manage/%/delete	61	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1534:{a:9:{s:4:"path";s:44:"/admin/structure/block/manage/{block}/delete";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:12:"block.delete";s:6:"_title";s:12:"Delete block";}s:12:"requirements";a:2:{s:11:"_permission";s:17:"administer blocks";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:5:"block";a:2:{s:4:"type";s:12:"entity:block";s:9:"converter";s:63:"drupal.proxy_original_service.paramconverter.configentity_admin";}}s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":596:{a:11:{s:4:"vars";a:1:{i:0;s:5:"block";}s:11:"path_prefix";s:29:"/admin/structure/block/manage";s:10:"path_regex";s:59:"#^/admin/structure/block/manage/(?P<block>[^/]++)/delete$#s";s:11:"path_tokens";a:3:{i:0;a:2:{i:0;s:4:"text";i:1;s:7:"/delete";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:5:"block";}i:2;a:2:{i:0;s:4:"text";i:1;s:29:"/admin/structure/block/manage";}}s:9:"path_vars";a:1:{i:0;s:5:"block";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:61;s:14:"patternOutline";s:38:"/admin/structure/block/manage/%/delete";s:8:"numParts";i:6;}}}}	6
entity.block.edit_form	/admin/structure/block/manage/{block}	/admin/structure/block/manage/%	30	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1468:{a:9:{s:4:"path";s:37:"/admin/structure/block/manage/{block}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:13:"block.default";s:6:"_title";s:15:"Configure block";}s:12:"requirements";a:2:{s:14:"_entity_access";s:12:"block.update";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:5:"block";a:2:{s:4:"type";s:12:"entity:block";s:9:"converter";s:63:"drupal.proxy_original_service.paramconverter.configentity_admin";}}s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":539:{a:11:{s:4:"vars";a:1:{i:0;s:5:"block";}s:11:"path_prefix";s:29:"/admin/structure/block/manage";s:10:"path_regex";s:52:"#^/admin/structure/block/manage/(?P<block>[^/]++)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:5:"block";}i:1;a:2:{i:0;s:4:"text";i:1;s:29:"/admin/structure/block/manage";}}s:9:"path_vars";a:1:{i:0;s:5:"block";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:30;s:14:"patternOutline";s:31:"/admin/structure/block/manage/%";s:8:"numParts";i:5;}}}}	5
block.admin_display	/admin/structure/block	/admin/structure/block	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1147:{a:9:{s:4:"path";s:22:"/admin/structure/block";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:53:"\\\\Drupal\\\\block\\\\Controller\\\\BlockListController::listing";s:6:"_title";s:12:"Block layout";}s:12:"requirements";a:2:{s:11:"_permission";s:17:"administer blocks";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":384:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:22:"/admin/structure/block";s:10:"path_regex";s:27:"#^/admin/structure/block$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:22:"/admin/structure/block";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:22:"/admin/structure/block";s:8:"numParts";i:3;}}}}	3
block.admin_display_theme	/admin/structure/block/list/{theme}	/admin/structure/block/list/%	30	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1369:{a:9:{s:4:"path";s:35:"/admin/structure/block/list/{theme}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:53:"\\\\Drupal\\\\block\\\\Controller\\\\BlockListController::listing";s:6:"_title";s:12:"Block layout";}s:12:"requirements";a:3:{s:13:"_access_theme";s:4:"TRUE";s:11:"_permission";s:17:"administer blocks";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:2:{i:0;s:18:"access_check.theme";i:1;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":531:{a:11:{s:4:"vars";a:1:{i:0;s:5:"theme";}s:11:"path_prefix";s:27:"/admin/structure/block/list";s:10:"path_regex";s:50:"#^/admin/structure/block/list/(?P<theme>[^/]++)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:5:"theme";}i:1;a:2:{i:0;s:4:"text";i:1;s:27:"/admin/structure/block/list";}}s:9:"path_vars";a:1:{i:0;s:5:"theme";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:30;s:14:"patternOutline";s:29:"/admin/structure/block/list/%";s:8:"numParts";i:5;}}}}	5
block.admin_library	/admin/structure/block/library/{theme}	/admin/structure/block/library/%	30	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1389:{a:9:{s:4:"path";s:38:"/admin/structure/block/library/{theme}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:59:"\\\\Drupal\\\\block\\\\Controller\\\\BlockLibraryController::listBlocks";s:6:"_title";s:11:"Place block";}s:12:"requirements";a:3:{s:13:"_access_theme";s:4:"TRUE";s:11:"_permission";s:17:"administer blocks";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:2:{i:0;s:18:"access_check.theme";i:1;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":543:{a:11:{s:4:"vars";a:1:{i:0;s:5:"theme";}s:11:"path_prefix";s:30:"/admin/structure/block/library";s:10:"path_regex";s:53:"#^/admin/structure/block/library/(?P<theme>[^/]++)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:5:"theme";}i:1;a:2:{i:0;s:4:"text";i:1;s:30:"/admin/structure/block/library";}}s:9:"path_vars";a:1:{i:0;s:5:"theme";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:30;s:14:"patternOutline";s:32:"/admin/structure/block/library/%";s:8:"numParts";i:5;}}}}	5
block.admin_add	/admin/structure/block/add/{plugin_id}/{theme}	/admin/structure/block/add/%	30	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1489:{a:9:{s:4:"path";s:46:"/admin/structure/block/add/{plugin_id}/{theme}";s:4:"host";s:0:"";s:8:"defaults";a:3:{s:11:"_controller";s:66:"\\\\Drupal\\\\block\\\\Controller\\\\BlockAddController::blockAddConfigureForm";s:5:"theme";N;s:6:"_title";s:15:"Configure block";}s:12:"requirements";a:2:{s:11:"_permission";s:17:"administer blocks";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":672:{a:11:{s:4:"vars";a:2:{i:0;s:9:"plugin_id";i:1;s:5:"theme";}s:11:"path_prefix";s:26:"/admin/structure/block/add";s:10:"path_regex";s:76:"#^/admin/structure/block/add/(?P<plugin_id>[^/]++)(?:/(?P<theme>[^/]++))?$#s";s:11:"path_tokens";a:3:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:5:"theme";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:9:"plugin_id";}i:2;a:2:{i:0;s:4:"text";i:1;s:26:"/admin/structure/block/add";}}s:9:"path_vars";a:2:{i:0;s:9:"plugin_id";i:1;s:5:"theme";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:30;s:14:"patternOutline";s:28:"/admin/structure/block/add/%";s:8:"numParts";i:6;}}}}	6
block.category_autocomplete	/block-category/autocomplete	/block-category/autocomplete	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1137:{a:9:{s:4:"path";s:28:"/block-category/autocomplete";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:11:"_controller";s:69:"\\\\Drupal\\\\block\\\\Controller\\\\CategoryAutocompleteController::autocomplete";}s:12:"requirements";a:2:{s:11:"_permission";s:17:"administer blocks";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:4:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":409:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:28:"/block-category/autocomplete";s:10:"path_regex";s:34:"#^/block\\\\-category/autocomplete$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:28:"/block-category/autocomplete";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:28:"/block-category/autocomplete";s:8:"numParts";i:2;}}}}	2
dblog.overview	/admin/reports/dblog	/admin/reports/dblog	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1143:{a:9:{s:4:"path";s:20:"/admin/reports/dblog";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:50:"\\\\Drupal\\\\dblog\\\\Controller\\\\DbLogController::overview";s:6:"_title";s:19:"Recent log messages";}s:12:"requirements";a:2:{s:11:"_permission";s:19:"access site reports";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":376:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:20:"/admin/reports/dblog";s:10:"path_regex";s:25:"#^/admin/reports/dblog$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:20:"/admin/reports/dblog";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:20:"/admin/reports/dblog";s:8:"numParts";i:3;}}}}	3
dblog.event	/admin/reports/dblog/event/{event_id}	/admin/reports/dblog/event/%	30	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1314:{a:9:{s:4:"path";s:37:"/admin/reports/dblog/event/{event_id}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:54:"\\\\Drupal\\\\dblog\\\\Controller\\\\DbLogController::eventDetails";s:6:"_title";s:7:"Details";}s:12:"requirements";a:2:{s:11:"_permission";s:19:"access site reports";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":539:{a:11:{s:4:"vars";a:1:{i:0;s:8:"event_id";}s:11:"path_prefix";s:26:"/admin/reports/dblog/event";s:10:"path_regex";s:52:"#^/admin/reports/dblog/event/(?P<event_id>[^/]++)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:8:"event_id";}i:1;a:2:{i:0;s:4:"text";i:1;s:26:"/admin/reports/dblog/event";}}s:9:"path_vars";a:1:{i:0;s:8:"event_id";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:30;s:14:"patternOutline";s:28:"/admin/reports/dblog/event/%";s:8:"numParts";i:5;}}}}	5
dblog.page_not_found	/admin/reports/page-not-found	/admin/reports/page-not-found	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1237:{a:9:{s:4:"path";s:29:"/admin/reports/page-not-found";s:4:"host";s:0:"";s:8:"defaults";a:3:{s:6:"_title";s:27:"Top 'page not found' errors";s:11:"_controller";s:56:"\\\\Drupal\\\\dblog\\\\Controller\\\\DbLogController::topLogMessages";s:4:"type";s:14:"page not found";}s:12:"requirements";a:2:{s:11:"_permission";s:19:"access site reports";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":414:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:29:"/admin/reports/page-not-found";s:10:"path_regex";s:36:"#^/admin/reports/page\\\\-not\\\\-found$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:29:"/admin/reports/page-not-found";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:29:"/admin/reports/page-not-found";s:8:"numParts";i:3;}}}}	3
dblog.access_denied	/admin/reports/access-denied	/admin/reports/access-denied	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1229:{a:9:{s:4:"path";s:28:"/admin/reports/access-denied";s:4:"host";s:0:"";s:8:"defaults";a:3:{s:6:"_title";s:26:"Top 'access denied' errors";s:11:"_controller";s:56:"\\\\Drupal\\\\dblog\\\\Controller\\\\DbLogController::topLogMessages";s:4:"type";s:13:"access denied";}s:12:"requirements";a:2:{s:11:"_permission";s:19:"access site reports";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":409:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:28:"/admin/reports/access-denied";s:10:"path_regex";s:34:"#^/admin/reports/access\\\\-denied$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:28:"/admin/reports/access-denied";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:28:"/admin/reports/access-denied";s:8:"numParts";i:3;}}}}	3
file.ajax_progress	/file/progress/{key}	/file/progress/%	6	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1176:{a:9:{s:4:"path";s:20:"/file/progress/{key}";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:11:"_controller";s:58:"\\\\Drupal\\\\file\\\\Controller\\\\FileWidgetAjaxController::progress";}s:12:"requirements";a:2:{s:11:"_permission";s:14:"access content";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:4:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":470:{a:11:{s:4:"vars";a:1:{i:0;s:3:"key";}s:11:"path_prefix";s:14:"/file/progress";s:10:"path_regex";s:35:"#^/file/progress/(?P<key>[^/]++)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:3:"key";}i:1;a:2:{i:0;s:4:"text";i:1;s:14:"/file/progress";}}s:9:"path_vars";a:1:{i:0;s:3:"key";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:6;s:14:"patternOutline";s:16:"/file/progress/%";s:8:"numParts";i:3;}}}}	3
filter.tips_all	/filter/tips	/filter/tips	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1187:{a:9:{s:4:"path";s:12:"/filter/tips";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:54:"\\\\Drupal\\\\filter\\\\Controller\\\\FilterController::filterTips";s:6:"_title";s:12:"Compose tips";}s:12:"requirements";a:2:{s:7:"_access";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:13:"filter_format";a:2:{s:4:"type";s:20:"entity:filter_format";s:9:"converter";s:21:"paramconverter.entity";}}s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:20:"access_check.default";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":344:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:12:"/filter/tips";s:10:"path_regex";s:17:"#^/filter/tips$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:12:"/filter/tips";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:12:"/filter/tips";s:8:"numParts";i:2;}}}}	2
system.admin	/admin	/admin	1	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1090:{a:9:{s:4:"path";s:6:"/admin";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:68:"\\\\Drupal\\\\system\\\\Controller\\\\SystemController::systemAdminMenuBlockPage";s:6:"_title";s:14:"Administration";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"access administration pages";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":317:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:6:"/admin";s:10:"path_regex";s:11:"#^/admin$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:6:"/admin";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:1;s:14:"patternOutline";s:6:"/admin";s:8:"numParts";i:1;}}}}	1
filter.tips	/filter/tips/{filter_format}	/filter/tips/%	6	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1385:{a:9:{s:4:"path";s:28:"/filter/tips/{filter_format}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:54:"\\\\Drupal\\\\filter\\\\Controller\\\\FilterController::filterTips";s:6:"_title";s:12:"Compose tips";}s:12:"requirements";a:2:{s:14:"_entity_access";s:17:"filter_format.use";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:13:"filter_format";a:2:{s:4:"type";s:20:"entity:filter_format";s:9:"converter";s:21:"paramconverter.entity";}}s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":505:{a:11:{s:4:"vars";a:1:{i:0;s:13:"filter_format";}s:11:"path_prefix";s:12:"/filter/tips";s:10:"path_regex";s:43:"#^/filter/tips/(?P<filter_format>[^/]++)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:13:"filter_format";}i:1;a:2:{i:0;s:4:"text";i:1;s:12:"/filter/tips";}}s:9:"path_vars";a:1:{i:0;s:13:"filter_format";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:6;s:14:"patternOutline";s:14:"/filter/tips/%";s:8:"numParts";i:3;}}}}	3
filter.admin_overview	/admin/config/content/formats	/admin/config/content/formats	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1190:{a:9:{s:4:"path";s:29:"/admin/config/content/formats";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_list";s:13:"filter_format";s:6:"_title";s:24:"Text formats and editors";}s:12:"requirements";a:2:{s:11:"_permission";s:18:"administer filters";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":413:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:29:"/admin/config/content/formats";s:10:"path_regex";s:34:"#^/admin/config/content/formats$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:29:"/admin/config/content/formats";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:29:"/admin/config/content/formats";s:8:"numParts";i:4;}}}}	4
filter.format_add	/admin/config/content/formats/add	/admin/config/content/formats/add	31	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1390:{a:9:{s:4:"path";s:33:"/admin/config/content/formats/add";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:17:"filter_format.add";s:6:"_title";s:15:"Add text format";}s:12:"requirements";a:2:{s:21:"_entity_create_access";s:13:"filter_format";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:13:"filter_format";a:2:{s:4:"type";s:20:"entity:filter_format";s:9:"converter";s:63:"drupal.proxy_original_service.paramconverter.configentity_admin";}}s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:26:"access_check.entity_create";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":429:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:33:"/admin/config/content/formats/add";s:10:"path_regex";s:38:"#^/admin/config/content/formats/add$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:33:"/admin/config/content/formats/add";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:31;s:14:"patternOutline";s:33:"/admin/config/content/formats/add";s:8:"numParts";i:5;}}}}	5
entity.filter_format.edit_form	/admin/config/content/formats/manage/{filter_format}	/admin/config/content/formats/manage/%	62	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1623:{a:9:{s:4:"path";s:52:"/admin/config/content/formats/manage/{filter_format}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:18:"filter_format.edit";s:15:"_title_callback";s:52:"\\\\Drupal\\\\filter\\\\Controller\\\\FilterController::getLabel";}s:12:"requirements";a:2:{s:14:"_entity_access";s:20:"filter_format.update";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:13:"filter_format";a:2:{s:4:"type";s:20:"entity:filter_format";s:9:"converter";s:63:"drupal.proxy_original_service.paramconverter.configentity_admin";}}s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":602:{a:11:{s:4:"vars";a:1:{i:0;s:13:"filter_format";}s:11:"path_prefix";s:36:"/admin/config/content/formats/manage";s:10:"path_regex";s:67:"#^/admin/config/content/formats/manage/(?P<filter_format>[^/]++)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:13:"filter_format";}i:1;a:2:{i:0;s:4:"text";i:1;s:36:"/admin/config/content/formats/manage";}}s:9:"path_vars";a:1:{i:0;s:13:"filter_format";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:62;s:14:"patternOutline";s:38:"/admin/config/content/formats/manage/%";s:8:"numParts";i:6;}}}}	6
entity.node.version_history	/node/{node}/revisions	/node/%/revisions	5	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1404:{a:9:{s:4:"path";s:22:"/node/{node}/revisions";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:6:"_title";s:9:"Revisions";s:11:"_controller";s:56:"\\\\Drupal\\\\node\\\\Controller\\\\NodeController::revisionOverview";}s:12:"requirements";a:3:{s:21:"_access_node_revision";s:4:"view";s:4:"node";s:3:"\\\\d+";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:21:"_node_operation_route";b:1;s:10:"parameters";a:1:{s:4:"node";a:2:{s:4:"type";s:11:"entity:node";s:9:"converter";s:21:"paramconverter.entity";}}s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:26:"access_check.node.revision";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":497:{a:11:{s:4:"vars";a:1:{i:0;s:4:"node";}s:11:"path_prefix";s:5:"/node";s:10:"path_regex";s:34:"#^/node/(?P<node>\\\\d+)/revisions$#s";s:11:"path_tokens";a:3:{i:0;a:2:{i:0;s:4:"text";i:1;s:10:"/revisions";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:3:"\\\\d+";i:3;s:4:"node";}i:2;a:2:{i:0;s:4:"text";i:1;s:5:"/node";}}s:9:"path_vars";a:1:{i:0;s:4:"node";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:5;s:14:"patternOutline";s:17:"/node/%/revisions";s:8:"numParts";i:3;}}}}	3
entity.filter_format.disable	/admin/config/content/formats/manage/{filter_format}/disable	/admin/config/content/formats/manage/%/disable	125	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1653:{a:9:{s:4:"path";s:60:"/admin/config/content/formats/manage/{filter_format}/disable";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:21:"filter_format.disable";s:6:"_title";s:19:"Disable text format";}s:12:"requirements";a:2:{s:14:"_entity_access";s:21:"filter_format.disable";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:13:"filter_format";a:2:{s:4:"type";s:20:"entity:filter_format";s:9:"converter";s:63:"drupal.proxy_original_service.paramconverter.configentity_admin";}}s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":663:{a:11:{s:4:"vars";a:1:{i:0;s:13:"filter_format";}s:11:"path_prefix";s:36:"/admin/config/content/formats/manage";s:10:"path_regex";s:75:"#^/admin/config/content/formats/manage/(?P<filter_format>[^/]++)/disable$#s";s:11:"path_tokens";a:3:{i:0;a:2:{i:0;s:4:"text";i:1;s:8:"/disable";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:13:"filter_format";}i:2;a:2:{i:0;s:4:"text";i:1;s:36:"/admin/config/content/formats/manage";}}s:9:"path_vars";a:1:{i:0;s:13:"filter_format";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:125;s:14:"patternOutline";s:46:"/admin/config/content/formats/manage/%/disable";s:8:"numParts";i:7;}}}}	7
node.multiple_delete_confirm	/admin/content/node/delete	/admin/content/node/delete	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1137:{a:9:{s:4:"path";s:26:"/admin/content/node/delete";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:5:"_form";s:32:"\\\\Drupal\\\\node\\\\Form\\\\DeleteMultiple";}s:12:"requirements";a:2:{s:11:"_permission";s:16:"administer nodes";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":401:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:26:"/admin/content/node/delete";s:10:"path_regex";s:31:"#^/admin/content/node/delete$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:26:"/admin/content/node/delete";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:26:"/admin/content/node/delete";s:8:"numParts";i:4;}}}}	4
node.add_page	/node/add	/node/add	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1069:{a:9:{s:4:"path";s:9:"/node/add";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:6:"_title";s:11:"Add content";s:11:"_controller";s:47:"\\\\Drupal\\\\node\\\\Controller\\\\NodeController::addPage";}s:12:"requirements";a:2:{s:16:"_node_add_access";s:4:"node";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:21:"_node_operation_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:21:"access_check.node.add";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":329:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:9:"/node/add";s:10:"path_regex";s:14:"#^/node/add$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:9:"/node/add";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:9:"/node/add";s:8:"numParts";i:2;}}}}	2
node.add	/node/add/{node_type}	/node/add/%	6	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1444:{a:9:{s:4:"path";s:21:"/node/add/{node_type}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:43:"\\\\Drupal\\\\node\\\\Controller\\\\NodeController::add";s:15:"_title_callback";s:52:"\\\\Drupal\\\\node\\\\Controller\\\\NodeController::addPageTitle";}s:12:"requirements";a:2:{s:16:"_node_add_access";s:16:"node:{node_type}";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:21:"_node_operation_route";b:1;s:10:"parameters";a:1:{s:9:"node_type";a:3:{s:21:"with_config_overrides";b:1;s:4:"type";s:16:"entity:node_type";s:9:"converter";s:21:"paramconverter.entity";}}s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:21:"access_check.node.add";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":472:{a:11:{s:4:"vars";a:1:{i:0;s:9:"node_type";}s:11:"path_prefix";s:9:"/node/add";s:10:"path_regex";s:36:"#^/node/add/(?P<node_type>[^/]++)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:9:"node_type";}i:1;a:2:{i:0;s:4:"text";i:1;s:9:"/node/add";}}s:9:"path_vars";a:1:{i:0;s:9:"node_type";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:6;s:14:"patternOutline";s:11:"/node/add/%";s:8:"numParts";i:3;}}}}	3
entity.node.preview	/node/preview/{node_preview}/{view_mode_id}	/node/preview/%/%	12	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1626:{a:9:{s:4:"path";s:43:"/node/preview/{node_preview}/{view_mode_id}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:51:"\\\\Drupal\\\\node\\\\Controller\\\\NodePreviewController::view";s:15:"_title_callback";s:52:"\\\\Drupal\\\\node\\\\Controller\\\\NodePreviewController::title";}s:12:"requirements";a:2:{s:20:"_node_preview_access";s:14:"{node_preview}";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:12:"node_preview";a:2:{s:4:"type";s:12:"node_preview";s:9:"converter";s:42:"drupal.proxy_original_service.node_preview";}}s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:25:"access_check.node.preview";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":663:{a:11:{s:4:"vars";a:2:{i:0;s:12:"node_preview";i:1;s:12:"view_mode_id";}s:11:"path_prefix";s:13:"/node/preview";s:10:"path_regex";s:68:"#^/node/preview/(?P<node_preview>[^/]++)/(?P<view_mode_id>[^/]++)$#s";s:11:"path_tokens";a:3:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:12:"view_mode_id";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:12:"node_preview";}i:2;a:2:{i:0;s:4:"text";i:1;s:13:"/node/preview";}}s:9:"path_vars";a:2:{i:0;s:12:"node_preview";i:1;s:12:"view_mode_id";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:12;s:14:"patternOutline";s:17:"/node/preview/%/%";s:8:"numParts";i:4;}}}}	4
entity.node.revision	/node/{node}/revisions/{node_revision}/view	/node/%/revisions/%/view	21	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1544:{a:9:{s:4:"path";s:43:"/node/{node}/revisions/{node_revision}/view";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:52:"\\\\Drupal\\\\node\\\\Controller\\\\NodeController::revisionShow";s:15:"_title_callback";s:57:"\\\\Drupal\\\\node\\\\Controller\\\\NodeController::revisionPageTitle";}s:12:"requirements";a:3:{s:21:"_access_node_revision";s:4:"view";s:4:"node";s:3:"\\\\d+";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:4:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:26:"access_check.node.revision";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":710:{a:11:{s:4:"vars";a:2:{i:0;s:4:"node";i:1;s:13:"node_revision";}s:11:"path_prefix";s:5:"/node";s:10:"path_regex";s:65:"#^/node/(?P<node>\\\\d+)/revisions/(?P<node_revision>[^/]++)/view$#s";s:11:"path_tokens";a:5:{i:0;a:2:{i:0;s:4:"text";i:1;s:5:"/view";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:13:"node_revision";}i:2;a:2:{i:0;s:4:"text";i:1;s:10:"/revisions";}i:3;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:3:"\\\\d+";i:3;s:4:"node";}i:4;a:2:{i:0;s:4:"text";i:1;s:5:"/node";}}s:9:"path_vars";a:2:{i:0;s:4:"node";i:1;s:13:"node_revision";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:21;s:14:"patternOutline";s:24:"/node/%/revisions/%/view";s:8:"numParts";i:5;}}}}	5
node.revision_revert_confirm	/node/{node}/revisions/{node_revision}/revert	/node/%/revisions/%/revert	21	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1558:{a:9:{s:4:"path";s:45:"/node/{node}/revisions/{node_revision}/revert";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:40:"\\\\Drupal\\\\node\\\\Form\\\\NodeRevisionRevertForm";s:6:"_title";s:26:"Revert to earlier revision";}s:12:"requirements";a:3:{s:21:"_access_node_revision";s:6:"update";s:4:"node";s:3:"\\\\d+";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:21:"_node_operation_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:26:"access_check.node.revision";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":716:{a:11:{s:4:"vars";a:2:{i:0;s:4:"node";i:1;s:13:"node_revision";}s:11:"path_prefix";s:5:"/node";s:10:"path_regex";s:67:"#^/node/(?P<node>\\\\d+)/revisions/(?P<node_revision>[^/]++)/revert$#s";s:11:"path_tokens";a:5:{i:0;a:2:{i:0;s:4:"text";i:1;s:7:"/revert";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:13:"node_revision";}i:2;a:2:{i:0;s:4:"text";i:1;s:10:"/revisions";}i:3;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:3:"\\\\d+";i:3;s:4:"node";}i:4;a:2:{i:0;s:4:"text";i:1;s:5:"/node";}}s:9:"path_vars";a:2:{i:0;s:4:"node";i:1;s:13:"node_revision";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:21;s:14:"patternOutline";s:26:"/node/%/revisions/%/revert";s:8:"numParts";i:5;}}}}	5
node.revision_revert_translation_confirm	/node/{node}/revisions/{node_revision}/revert/{langcode}	/node/%/revisions/%/revert/%	42	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1735:{a:9:{s:4:"path";s:56:"/node/{node}/revisions/{node_revision}/revert/{langcode}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:51:"\\\\Drupal\\\\node\\\\Form\\\\NodeRevisionRevertTranslationForm";s:6:"_title";s:43:"Revert to earlier revision of a translation";}s:12:"requirements";a:3:{s:21:"_access_node_revision";s:6:"update";s:4:"node";s:3:"\\\\d+";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:21:"_node_operation_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:26:"access_check.node.revision";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":854:{a:11:{s:4:"vars";a:3:{i:0;s:4:"node";i:1;s:13:"node_revision";i:2;s:8:"langcode";}s:11:"path_prefix";s:5:"/node";s:10:"path_regex";s:88:"#^/node/(?P<node>\\\\d+)/revisions/(?P<node_revision>[^/]++)/revert/(?P<langcode>[^/]++)$#s";s:11:"path_tokens";a:6:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:8:"langcode";}i:1;a:2:{i:0;s:4:"text";i:1;s:7:"/revert";}i:2;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:13:"node_revision";}i:3;a:2:{i:0;s:4:"text";i:1;s:10:"/revisions";}i:4;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:3:"\\\\d+";i:3;s:4:"node";}i:5;a:2:{i:0;s:4:"text";i:1;s:5:"/node";}}s:9:"path_vars";a:3:{i:0;s:4:"node";i:1;s:13:"node_revision";i:2;s:8:"langcode";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:42;s:14:"patternOutline";s:28:"/node/%/revisions/%/revert/%";s:8:"numParts";i:6;}}}}	6
node.revision_delete_confirm	/node/{node}/revisions/{node_revision}/delete	/node/%/revisions/%/delete	21	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1555:{a:9:{s:4:"path";s:45:"/node/{node}/revisions/{node_revision}/delete";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:40:"\\\\Drupal\\\\node\\\\Form\\\\NodeRevisionDeleteForm";s:6:"_title";s:23:"Delete earlier revision";}s:12:"requirements";a:3:{s:21:"_access_node_revision";s:6:"delete";s:4:"node";s:3:"\\\\d+";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:21:"_node_operation_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:26:"access_check.node.revision";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":716:{a:11:{s:4:"vars";a:2:{i:0;s:4:"node";i:1;s:13:"node_revision";}s:11:"path_prefix";s:5:"/node";s:10:"path_regex";s:67:"#^/node/(?P<node>\\\\d+)/revisions/(?P<node_revision>[^/]++)/delete$#s";s:11:"path_tokens";a:5:{i:0;a:2:{i:0;s:4:"text";i:1;s:7:"/delete";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:13:"node_revision";}i:2;a:2:{i:0;s:4:"text";i:1;s:10:"/revisions";}i:3;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:3:"\\\\d+";i:3;s:4:"node";}i:4;a:2:{i:0;s:4:"text";i:1;s:5:"/node";}}s:9:"path_vars";a:2:{i:0;s:4:"node";i:1;s:13:"node_revision";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:21;s:14:"patternOutline";s:26:"/node/%/revisions/%/delete";s:8:"numParts";i:5;}}}}	5
entity.node_type.collection	/admin/structure/types	/admin/structure/types	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1144:{a:9:{s:4:"path";s:22:"/admin/structure/types";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_list";s:9:"node_type";s:6:"_title";s:13:"Content types";}s:12:"requirements";a:2:{s:11:"_permission";s:24:"administer content types";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":384:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:22:"/admin/structure/types";s:10:"path_regex";s:27:"#^/admin/structure/types$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:22:"/admin/structure/types";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:22:"/admin/structure/types";s:8:"numParts";i:3;}}}}	3
node.type_add	/admin/structure/types/add	/admin/structure/types/add	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1341:{a:9:{s:4:"path";s:26:"/admin/structure/types/add";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:13:"node_type.add";s:6:"_title";s:16:"Add content type";}s:12:"requirements";a:2:{s:11:"_permission";s:24:"administer content types";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:9:"node_type";a:2:{s:4:"type";s:16:"entity:node_type";s:9:"converter";s:63:"drupal.proxy_original_service.paramconverter.configentity_admin";}}s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":401:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:26:"/admin/structure/types/add";s:10:"path_regex";s:31:"#^/admin/structure/types/add$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:26:"/admin/structure/types/add";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:26:"/admin/structure/types/add";s:8:"numParts";i:4;}}}}	4
entity.node_type.edit_form	/admin/structure/types/manage/{node_type}	/admin/structure/types/manage/%	30	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1474:{a:9:{s:4:"path";s:41:"/admin/structure/types/manage/{node_type}";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:12:"_entity_form";s:14:"node_type.edit";}s:12:"requirements";a:2:{s:11:"_permission";s:24:"administer content types";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:9:"node_type";a:2:{s:4:"type";s:16:"entity:node_type";s:9:"converter";s:63:"drupal.proxy_original_service.paramconverter.configentity_admin";}}s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":555:{a:11:{s:4:"vars";a:1:{i:0;s:9:"node_type";}s:11:"path_prefix";s:29:"/admin/structure/types/manage";s:10:"path_regex";s:56:"#^/admin/structure/types/manage/(?P<node_type>[^/]++)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:9:"node_type";}i:1;a:2:{i:0;s:4:"text";i:1;s:29:"/admin/structure/types/manage";}}s:9:"path_vars";a:1:{i:0;s:9:"node_type";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:30;s:14:"patternOutline";s:31:"/admin/structure/types/manage/%";s:8:"numParts";i:5;}}}}	5
entity.node_type.delete_form	/admin/structure/types/manage/{node_type}/delete	/admin/structure/types/manage/%/delete	61	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1557:{a:9:{s:4:"path";s:48:"/admin/structure/types/manage/{node_type}/delete";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:16:"node_type.delete";s:6:"_title";s:6:"Delete";}s:12:"requirements";a:2:{s:14:"_entity_access";s:16:"node_type.delete";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:9:"node_type";a:2:{s:4:"type";s:16:"entity:node_type";s:9:"converter";s:63:"drupal.proxy_original_service.paramconverter.configentity_admin";}}s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":612:{a:11:{s:4:"vars";a:1:{i:0;s:9:"node_type";}s:11:"path_prefix";s:29:"/admin/structure/types/manage";s:10:"path_regex";s:63:"#^/admin/structure/types/manage/(?P<node_type>[^/]++)/delete$#s";s:11:"path_tokens";a:3:{i:0;a:2:{i:0;s:4:"text";i:1;s:7:"/delete";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:9:"node_type";}i:2;a:2:{i:0;s:4:"text";i:1;s:29:"/admin/structure/types/manage";}}s:9:"path_vars";a:1:{i:0;s:9:"node_type";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:61;s:14:"patternOutline";s:38:"/admin/structure/types/manage/%/delete";s:8:"numParts";i:6;}}}}	6
node.configure_rebuild_confirm	/admin/reports/status/rebuild	/admin/reports/status/rebuild	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1170:{a:9:{s:4:"path";s:29:"/admin/reports/status/rebuild";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:5:"_form";s:39:"Drupal\\\\node\\\\Form\\\\RebuildPermissionsForm";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"access administration pages";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":413:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:29:"/admin/reports/status/rebuild";s:10:"path_regex";s:34:"#^/admin/reports/status/rebuild$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:29:"/admin/reports/status/rebuild";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:29:"/admin/reports/status/rebuild";s:8:"numParts";i:4;}}}}	4
system.admin_structure	/admin/structure	/admin/structure	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1138:{a:9:{s:4:"path";s:16:"/admin/structure";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:68:"\\\\Drupal\\\\system\\\\Controller\\\\SystemController::systemAdminMenuBlockPage";s:6:"_title";s:9:"Structure";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"access administration pages";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":360:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:16:"/admin/structure";s:10:"path_regex";s:21:"#^/admin/structure$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:16:"/admin/structure";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:16:"/admin/structure";s:8:"numParts";i:2;}}}}	2
system.admin_reports	/admin/reports	/admin/reports	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1118:{a:9:{s:4:"path";s:14:"/admin/reports";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:68:"\\\\Drupal\\\\system\\\\Controller\\\\SystemController::systemAdminMenuBlockPage";s:6:"_title";s:7:"Reports";}s:12:"requirements";a:2:{s:11:"_permission";s:19:"access site reports";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":352:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:14:"/admin/reports";s:10:"path_regex";s:19:"#^/admin/reports$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:14:"/admin/reports";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:14:"/admin/reports";s:8:"numParts";i:2;}}}}	2
system.admin_config_media	/admin/config/media	/admin/config/media	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1149:{a:9:{s:4:"path";s:19:"/admin/config/media";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:68:"\\\\Drupal\\\\system\\\\Controller\\\\SystemController::systemAdminMenuBlockPage";s:6:"_title";s:5:"Media";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"access administration pages";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":372:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:19:"/admin/config/media";s:10:"path_regex";s:24:"#^/admin/config/media$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:19:"/admin/config/media";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:19:"/admin/config/media";s:8:"numParts";i:3;}}}}	3
system.admin_config_services	/admin/config/services	/admin/config/services	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1172:{a:9:{s:4:"path";s:22:"/admin/config/services";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:68:"\\\\Drupal\\\\system\\\\Controller\\\\SystemController::systemAdminMenuBlockPage";s:6:"_title";s:12:"Web services";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"access administration pages";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":384:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:22:"/admin/config/services";s:10:"path_regex";s:27:"#^/admin/config/services$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:22:"/admin/config/services";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:22:"/admin/config/services";s:8:"numParts";i:3;}}}}	3
system.admin_config_development	/admin/config/development	/admin/config/development	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1186:{a:9:{s:4:"path";s:25:"/admin/config/development";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:68:"\\\\Drupal\\\\system\\\\Controller\\\\SystemController::systemAdminMenuBlockPage";s:6:"_title";s:11:"Development";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"access administration pages";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":396:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:25:"/admin/config/development";s:10:"path_regex";s:30:"#^/admin/config/development$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:25:"/admin/config/development";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:25:"/admin/config/development";s:8:"numParts";i:3;}}}}	3
system.admin_config_regional	/admin/config/regional	/admin/config/regional	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1181:{a:9:{s:4:"path";s:22:"/admin/config/regional";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:68:"\\\\Drupal\\\\system\\\\Controller\\\\SystemController::systemAdminMenuBlockPage";s:6:"_title";s:21:"Regional and language";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"access administration pages";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":384:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:22:"/admin/config/regional";s:10:"path_regex";s:27:"#^/admin/config/regional$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:22:"/admin/config/regional";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:22:"/admin/config/regional";s:8:"numParts";i:3;}}}}	3
system.admin_config_search	/admin/config/search	/admin/config/search	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1169:{a:9:{s:4:"path";s:20:"/admin/config/search";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:68:"\\\\Drupal\\\\system\\\\Controller\\\\SystemController::systemAdminMenuBlockPage";s:6:"_title";s:19:"Search and metadata";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"access administration pages";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":376:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:20:"/admin/config/search";s:10:"path_regex";s:25:"#^/admin/config/search$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:20:"/admin/config/search";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:20:"/admin/config/search";s:8:"numParts";i:3;}}}}	3
system.admin_config_system	/admin/config/system	/admin/config/system	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1155:{a:9:{s:4:"path";s:20:"/admin/config/system";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:68:"\\\\Drupal\\\\system\\\\Controller\\\\SystemController::systemAdminMenuBlockPage";s:6:"_title";s:6:"System";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"access administration pages";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":376:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:20:"/admin/config/system";s:10:"path_regex";s:25:"#^/admin/config/system$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:20:"/admin/config/system";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:20:"/admin/config/system";s:8:"numParts";i:3;}}}}	3
system.admin_config_ui	/admin/config/user-interface	/admin/config/user-interface	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1205:{a:9:{s:4:"path";s:28:"/admin/config/user-interface";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:68:"\\\\Drupal\\\\system\\\\Controller\\\\SystemController::systemAdminMenuBlockPage";s:6:"_title";s:14:"User interface";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"access administration pages";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":409:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:28:"/admin/config/user-interface";s:10:"path_regex";s:34:"#^/admin/config/user\\\\-interface$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:28:"/admin/config/user-interface";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:28:"/admin/config/user-interface";s:8:"numParts";i:3;}}}}	3
system.admin_config_workflow	/admin/config/workflow	/admin/config/workflow	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1167:{a:9:{s:4:"path";s:22:"/admin/config/workflow";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:68:"\\\\Drupal\\\\system\\\\Controller\\\\SystemController::systemAdminMenuBlockPage";s:6:"_title";s:8:"Workflow";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"access administration pages";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":384:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:22:"/admin/config/workflow";s:10:"path_regex";s:27:"#^/admin/config/workflow$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:22:"/admin/config/workflow";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:22:"/admin/config/workflow";s:8:"numParts";i:3;}}}}	3
system.admin_config_content	/admin/config/content	/admin/config/content	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1172:{a:9:{s:4:"path";s:21:"/admin/config/content";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:68:"\\\\Drupal\\\\system\\\\Controller\\\\SystemController::systemAdminMenuBlockPage";s:6:"_title";s:17:"Content authoring";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"access administration pages";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":380:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:21:"/admin/config/content";s:10:"path_regex";s:26:"#^/admin/config/content$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:21:"/admin/config/content";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:21:"/admin/config/content";s:8:"numParts";i:3;}}}}	3
system.cron	/cron/{key}	/cron/%	2	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1114:{a:9:{s:4:"path";s:11:"/cron/{key}";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:11:"_controller";s:34:"\\\\Drupal\\\\system\\\\CronController::run";}s:12:"requirements";a:2:{s:19:"_access_system_cron";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:8:"no_cache";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:17:"access_check.cron";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":431:{a:11:{s:4:"vars";a:1:{i:0;s:3:"key";}s:11:"path_prefix";s:5:"/cron";s:10:"path_regex";s:26:"#^/cron/(?P<key>[^/]++)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:3:"key";}i:1;a:2:{i:0;s:4:"text";i:1;s:5:"/cron";}}s:9:"path_vars";a:1:{i:0;s:3:"key";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:2;s:14:"patternOutline";s:7:"/cron/%";s:8:"numParts";i:2;}}}}	2
system.admin_compact_page	/admin/compact/{mode}	/admin/compact	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1238:{a:9:{s:4:"path";s:21:"/admin/compact/{mode}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:54:"Drupal\\\\system\\\\Controller\\\\SystemController::compactPage";s:4:"mode";s:3:"off";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"access administration pages";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":477:{a:11:{s:4:"vars";a:1:{i:0;s:4:"mode";}s:11:"path_prefix";s:14:"/admin/compact";s:10:"path_regex";s:41:"#^/admin/compact(?:/(?P<mode>[^/]++))?$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:4:"mode";}i:1;a:2:{i:0;s:4:"text";i:1;s:14:"/admin/compact";}}s:9:"path_vars";a:1:{i:0;s:4:"mode";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:14:"/admin/compact";s:8:"numParts";i:3;}}}}	3
system.machine_name_transliterate	/machine_name/transliterate	/machine_name/transliterate	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1110:{a:9:{s:4:"path";s:27:"/machine_name/transliterate";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:11:"_controller";s:51:"\\\\Drupal\\\\system\\\\MachineNameController::transliterate";}s:12:"requirements";a:2:{s:11:"_permission";s:14:"access content";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:4:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":404:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:27:"/machine_name/transliterate";s:10:"path_regex";s:32:"#^/machine_name/transliterate$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:27:"/machine_name/transliterate";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:27:"/machine_name/transliterate";s:8:"numParts";i:2;}}}}	2
system.site_information_settings	/admin/config/system/site-information	/admin/config/system/site-information	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1252:{a:9:{s:4:"path";s:37:"/admin/config/system/site-information";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:38:"Drupal\\\\system\\\\Form\\\\SiteInformationForm";s:6:"_title";s:19:"Basic site settings";}s:12:"requirements";a:2:{s:11:"_permission";s:29:"administer site configuration";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":446:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:37:"/admin/config/system/site-information";s:10:"path_regex";s:43:"#^/admin/config/system/site\\\\-information$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:37:"/admin/config/system/site-information";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:37:"/admin/config/system/site-information";s:8:"numParts";i:4;}}}}	4
system.cron_settings	/admin/config/system/cron	/admin/config/system/cron	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1164:{a:9:{s:4:"path";s:25:"/admin/config/system/cron";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:27:"Drupal\\\\system\\\\Form\\\\CronForm";s:6:"_title";s:4:"Cron";}s:12:"requirements";a:2:{s:11:"_permission";s:29:"administer site configuration";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":397:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:25:"/admin/config/system/cron";s:10:"path_regex";s:30:"#^/admin/config/system/cron$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:25:"/admin/config/system/cron";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:25:"/admin/config/system/cron";s:8:"numParts";i:4;}}}}	4
system.logging_settings	/admin/config/development/logging	/admin/config/development/logging	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1222:{a:9:{s:4:"path";s:33:"/admin/config/development/logging";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:30:"Drupal\\\\system\\\\Form\\\\LoggingForm";s:6:"_title";s:18:"Logging and errors";}s:12:"requirements";a:2:{s:11:"_permission";s:29:"administer site configuration";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":429:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:33:"/admin/config/development/logging";s:10:"path_regex";s:38:"#^/admin/config/development/logging$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:33:"/admin/config/development/logging";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:33:"/admin/config/development/logging";s:8:"numParts";i:4;}}}}	4
system.temporary	/system/temporary	/system/temporary	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1066:{a:9:{s:4:"path";s:17:"/system/temporary";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:47:"\\\\Drupal\\\\system\\\\FileDownloadController::download";s:6:"scheme";s:9:"temporary";}s:12:"requirements";a:2:{s:7:"_access";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:4:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:20:"access_check.default";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":364:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:17:"/system/temporary";s:10:"path_regex";s:22:"#^/system/temporary$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:17:"/system/temporary";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:17:"/system/temporary";s:8:"numParts";i:2;}}}}	2
system.performance_settings	/admin/config/development/performance	/admin/config/development/performance	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1239:{a:9:{s:4:"path";s:37:"/admin/config/development/performance";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:34:"Drupal\\\\system\\\\Form\\\\PerformanceForm";s:6:"_title";s:11:"Performance";}s:12:"requirements";a:2:{s:11:"_permission";s:29:"administer site configuration";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":445:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:37:"/admin/config/development/performance";s:10:"path_regex";s:42:"#^/admin/config/development/performance$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:37:"/admin/config/development/performance";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:37:"/admin/config/development/performance";s:8:"numParts";i:4;}}}}	4
system.file_system_settings	/admin/config/media/file-system	/admin/config/media/file-system	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1209:{a:9:{s:4:"path";s:31:"/admin/config/media/file-system";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:33:"Drupal\\\\system\\\\Form\\\\FileSystemForm";s:6:"_title";s:11:"File system";}s:12:"requirements";a:2:{s:11:"_permission";s:29:"administer site configuration";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":422:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:31:"/admin/config/media/file-system";s:10:"path_regex";s:37:"#^/admin/config/media/file\\\\-system$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:31:"/admin/config/media/file-system";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:31:"/admin/config/media/file-system";s:8:"numParts";i:4;}}}}	4
system.rss_feeds_settings	/admin/config/services/rss-publishing	/admin/config/services/rss-publishing	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1240:{a:9:{s:4:"path";s:37:"/admin/config/services/rss-publishing";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:31:"Drupal\\\\system\\\\Form\\\\RssFeedsForm";s:6:"_title";s:14:"RSS publishing";}s:12:"requirements";a:2:{s:11:"_permission";s:29:"administer site configuration";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":446:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:37:"/admin/config/services/rss-publishing";s:10:"path_regex";s:43:"#^/admin/config/services/rss\\\\-publishing$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:37:"/admin/config/services/rss-publishing";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:37:"/admin/config/services/rss-publishing";s:8:"numParts";i:4;}}}}	4
system.regional_settings	/admin/config/regional/settings	/admin/config/regional/settings	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1212:{a:9:{s:4:"path";s:31:"/admin/config/regional/settings";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:31:"Drupal\\\\system\\\\Form\\\\RegionalForm";s:6:"_title";s:17:"Regional settings";}s:12:"requirements";a:2:{s:11:"_permission";s:29:"administer site configuration";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":421:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:31:"/admin/config/regional/settings";s:10:"path_regex";s:36:"#^/admin/config/regional/settings$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:31:"/admin/config/regional/settings";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:31:"/admin/config/regional/settings";s:8:"numParts";i:4;}}}}	4
system.image_toolkit_settings	/admin/config/media/image-toolkit	/admin/config/media/image-toolkit	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1223:{a:9:{s:4:"path";s:33:"/admin/config/media/image-toolkit";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:35:"Drupal\\\\system\\\\Form\\\\ImageToolkitForm";s:6:"_title";s:13:"Image toolkit";}s:12:"requirements";a:2:{s:11:"_permission";s:29:"administer site configuration";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":430:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:33:"/admin/config/media/image-toolkit";s:10:"path_regex";s:39:"#^/admin/config/media/image\\\\-toolkit$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:33:"/admin/config/media/image-toolkit";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:33:"/admin/config/media/image-toolkit";s:8:"numParts";i:4;}}}}	4
<current>	/<current>	/<current>	1	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":845:{a:9:{s:4:"path";s:10:"/<current>";s:4:"host";s:0:"";s:8:"defaults";a:0:{}s:12:"requirements";a:1:{s:7:"_method";s:8:"GET|POST";}s:7:"options";a:3:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":338:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:10:"/<current>";s:10:"path_regex";s:17:"#^/\\\\<current\\\\>$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:10:"/<current>";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:1;s:14:"patternOutline";s:10:"/<current>";s:8:"numParts";i:1;}}}}	1
system.site_maintenance_mode	/admin/config/development/maintenance	/admin/config/development/maintenance	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1252:{a:9:{s:4:"path";s:37:"/admin/config/development/maintenance";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:42:"Drupal\\\\system\\\\Form\\\\SiteMaintenanceModeForm";s:6:"_title";s:16:"Maintenance mode";}s:12:"requirements";a:2:{s:11:"_permission";s:29:"administer site configuration";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":445:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:37:"/admin/config/development/maintenance";s:10:"path_regex";s:42:"#^/admin/config/development/maintenance$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:37:"/admin/config/development/maintenance";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:37:"/admin/config/development/maintenance";s:8:"numParts";i:4;}}}}	4
system.run_cron	/admin/reports/status/run-cron	/admin/reports/status/run-cron	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1235:{a:9:{s:4:"path";s:30:"/admin/reports/status/run-cron";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:11:"_controller";s:42:"\\\\Drupal\\\\system\\\\CronController::runManually";}s:12:"requirements";a:3:{s:11:"_permission";s:29:"administer site configuration";s:11:"_csrf_token";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:8:"no_cache";b:1;s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:2:{i:0;s:23:"access_check.permission";i:1;s:17:"access_check.csrf";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":418:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:30:"/admin/reports/status/run-cron";s:10:"path_regex";s:36:"#^/admin/reports/status/run\\\\-cron$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:30:"/admin/reports/status/run-cron";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:30:"/admin/reports/status/run-cron";s:8:"numParts";i:4;}}}}	4
entity.date_format.collection	/admin/config/regional/date-time	/admin/config/regional/date-time	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1212:{a:9:{s:4:"path";s:32:"/admin/config/regional/date-time";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_list";s:11:"date_format";s:6:"_title";s:21:"Date and time formats";}s:12:"requirements";a:2:{s:11:"_permission";s:29:"administer site configuration";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":426:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:32:"/admin/config/regional/date-time";s:10:"path_regex";s:38:"#^/admin/config/regional/date\\\\-time$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:32:"/admin/config/regional/date-time";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:32:"/admin/config/regional/date-time";s:8:"numParts";i:4;}}}}	4
system.date_format_add	/admin/config/regional/date-time/formats/add	/admin/config/regional/date-time/formats/add	63	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1443:{a:9:{s:4:"path";s:44:"/admin/config/regional/date-time/formats/add";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:15:"date_format.add";s:6:"_title";s:15:"Add date format";}s:12:"requirements";a:2:{s:11:"_permission";s:29:"administer site configuration";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:11:"date_format";a:2:{s:4:"type";s:18:"entity:date_format";s:9:"converter";s:63:"drupal.proxy_original_service.paramconverter.configentity_admin";}}s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":474:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:44:"/admin/config/regional/date-time/formats/add";s:10:"path_regex";s:50:"#^/admin/config/regional/date\\\\-time/formats/add$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:44:"/admin/config/regional/date-time/formats/add";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:63;s:14:"patternOutline";s:44:"/admin/config/regional/date-time/formats/add";s:8:"numParts";i:6;}}}}	6
entity.date_format.edit_form	/admin/config/regional/date-time/formats/manage/{date_format}	/admin/config/regional/date-time/formats/manage/%	126	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1616:{a:9:{s:4:"path";s:61:"/admin/config/regional/date-time/formats/manage/{date_format}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:16:"date_format.edit";s:6:"_title";s:16:"Edit date format";}s:12:"requirements";a:2:{s:14:"_entity_access";s:18:"date_format.update";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:11:"date_format";a:2:{s:4:"type";s:18:"entity:date_format";s:9:"converter";s:63:"drupal.proxy_original_service.paramconverter.configentity_admin";}}s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":640:{a:11:{s:4:"vars";a:1:{i:0;s:11:"date_format";}s:11:"path_prefix";s:47:"/admin/config/regional/date-time/formats/manage";s:10:"path_regex";s:77:"#^/admin/config/regional/date\\\\-time/formats/manage/(?P<date_format>[^/]++)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:11:"date_format";}i:1;a:2:{i:0;s:4:"text";i:1;s:47:"/admin/config/regional/date-time/formats/manage";}}s:9:"path_vars";a:1:{i:0;s:11:"date_format";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:126;s:14:"patternOutline";s:49:"/admin/config/regional/date-time/formats/manage/%";s:8:"numParts";i:7;}}}}	7
entity.date_format.delete_form	/admin/config/regional/date-time/formats/manage/{date_format}/delete	/admin/config/regional/date-time/formats/manage/%/delete	253	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1684:{a:9:{s:4:"path";s:68:"/admin/config/regional/date-time/formats/manage/{date_format}/delete";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:18:"date_format.delete";s:6:"_title";s:18:"Delete date format";}s:12:"requirements";a:2:{s:14:"_entity_access";s:18:"date_format.delete";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:11:"date_format";a:2:{s:4:"type";s:18:"entity:date_format";s:9:"converter";s:63:"drupal.proxy_original_service.paramconverter.configentity_admin";}}s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":697:{a:11:{s:4:"vars";a:1:{i:0;s:11:"date_format";}s:11:"path_prefix";s:47:"/admin/config/regional/date-time/formats/manage";s:10:"path_regex";s:84:"#^/admin/config/regional/date\\\\-time/formats/manage/(?P<date_format>[^/]++)/delete$#s";s:11:"path_tokens";a:3:{i:0;a:2:{i:0;s:4:"text";i:1;s:7:"/delete";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:11:"date_format";}i:2;a:2:{i:0;s:4:"text";i:1;s:47:"/admin/config/regional/date-time/formats/manage";}}s:9:"path_vars";a:1:{i:0;s:11:"date_format";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:253;s:14:"patternOutline";s:56:"/admin/config/regional/date-time/formats/manage/%/delete";s:8:"numParts";i:8;}}}}	8
system.modules_list	/admin/modules	/admin/modules	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1151:{a:9:{s:4:"path";s:14:"/admin/modules";s:4:"host";s:0:"";s:8:"defaults";a:3:{s:6:"_title";s:6:"Extend";s:14:"_title_context";s:15:"With components";s:5:"_form";s:34:"Drupal\\\\system\\\\Form\\\\ModulesListForm";}s:12:"requirements";a:2:{s:11:"_permission";s:18:"administer modules";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":352:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:14:"/admin/modules";s:10:"path_regex";s:19:"#^/admin/modules$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:14:"/admin/modules";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:14:"/admin/modules";s:8:"numParts";i:2;}}}}	2
system.modules_list_confirm	/admin/modules/list/confirm	/admin/modules/list/confirm	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1211:{a:9:{s:4:"path";s:27:"/admin/modules/list/confirm";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:41:"Drupal\\\\system\\\\Form\\\\ModulesListConfirmForm";s:6:"_title";s:37:"Some required modules must be enabled";}s:12:"requirements";a:2:{s:11:"_permission";s:18:"administer modules";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":405:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:27:"/admin/modules/list/confirm";s:10:"path_regex";s:32:"#^/admin/modules/list/confirm$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:27:"/admin/modules/list/confirm";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:27:"/admin/modules/list/confirm";s:8:"numParts";i:4;}}}}	4
system.modules_list_experimental_confirm	/admin/modules/list/confirm-experimental	/admin/modules/list/confirm-experimental	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1272:{a:9:{s:4:"path";s:40:"/admin/modules/list/confirm-experimental";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:53:"Drupal\\\\system\\\\Form\\\\ModulesListExperimentalConfirmForm";s:6:"_title";s:20:"Experimental modules";}s:12:"requirements";a:2:{s:11:"_permission";s:18:"administer modules";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":458:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:40:"/admin/modules/list/confirm-experimental";s:10:"path_regex";s:46:"#^/admin/modules/list/confirm\\\\-experimental$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:40:"/admin/modules/list/confirm-experimental";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:40:"/admin/modules/list/confirm-experimental";s:8:"numParts";i:4;}}}}	4
system.theme_uninstall	/admin/appearance/uninstall	/admin/appearance/uninstall	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1196:{a:9:{s:4:"path";s:27:"/admin/appearance/uninstall";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:11:"_controller";s:51:"Drupal\\\\system\\\\Controller\\\\ThemeController::uninstall";}s:12:"requirements";a:3:{s:11:"_permission";s:17:"administer themes";s:11:"_csrf_token";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:2:{i:0;s:23:"access_check.permission";i:1;s:17:"access_check.csrf";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":404:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:27:"/admin/appearance/uninstall";s:10:"path_regex";s:32:"#^/admin/appearance/uninstall$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:27:"/admin/appearance/uninstall";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:27:"/admin/appearance/uninstall";s:8:"numParts";i:3;}}}}	3
system.theme_install	/admin/appearance/install	/admin/appearance/install	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1184:{a:9:{s:4:"path";s:25:"/admin/appearance/install";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:11:"_controller";s:49:"Drupal\\\\system\\\\Controller\\\\ThemeController::install";}s:12:"requirements";a:3:{s:11:"_permission";s:17:"administer themes";s:11:"_csrf_token";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:2:{i:0;s:23:"access_check.permission";i:1;s:17:"access_check.csrf";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":396:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:25:"/admin/appearance/install";s:10:"path_regex";s:30:"#^/admin/appearance/install$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:25:"/admin/appearance/install";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:25:"/admin/appearance/install";s:8:"numParts";i:3;}}}}	3
system.status	/admin/reports/status	/admin/reports/status	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1156:{a:9:{s:4:"path";s:21:"/admin/reports/status";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:54:"\\\\Drupal\\\\system\\\\Controller\\\\SystemInfoController::status";s:6:"_title";s:13:"Status report";}s:12:"requirements";a:2:{s:11:"_permission";s:29:"administer site configuration";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":380:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:21:"/admin/reports/status";s:10:"path_regex";s:26:"#^/admin/reports/status$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:21:"/admin/reports/status";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:21:"/admin/reports/status";s:8:"numParts";i:3;}}}}	3
system.php	/admin/reports/status/php	/admin/reports/status/php	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1139:{a:9:{s:4:"path";s:25:"/admin/reports/status/php";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:11:"_controller";s:50:"Drupal\\\\system\\\\Controller\\\\SystemInfoController::php";}s:12:"requirements";a:2:{s:11:"_permission";s:29:"administer site configuration";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:0;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":397:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:25:"/admin/reports/status/php";s:10:"path_regex";s:30:"#^/admin/reports/status/php$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:25:"/admin/reports/status/php";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:25:"/admin/reports/status/php";s:8:"numParts";i:4;}}}}	4
system.admin_index	/admin/index	/admin/index	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1104:{a:9:{s:4:"path";s:12:"/admin/index";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:48:"\\\\Drupal\\\\system\\\\Controller\\\\AdminController::index";s:6:"_title";s:14:"Administration";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"access administration pages";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":344:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:12:"/admin/index";s:10:"path_regex";s:17:"#^/admin/index$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:12:"/admin/index";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:12:"/admin/index";s:8:"numParts";i:2;}}}}	2
system.files	/system/files/{scheme}	/system/files	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1185:{a:9:{s:4:"path";s:22:"/system/files/{scheme}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:46:"Drupal\\\\system\\\\FileDownloadController::download";s:6:"scheme";s:7:"private";}s:12:"requirements";a:2:{s:7:"_access";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:4:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:20:"access_check.default";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":481:{a:11:{s:4:"vars";a:1:{i:0;s:6:"scheme";}s:11:"path_prefix";s:13:"/system/files";s:10:"path_regex";s:42:"#^/system/files(?:/(?P<scheme>[^/]++))?$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:6:"scheme";}i:1;a:2:{i:0;s:4:"text";i:1;s:13:"/system/files";}}s:9:"path_vars";a:1:{i:0;s:6:"scheme";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:13:"/system/files";s:8:"numParts";i:3;}}}}	3
system.private_file_download	/system/files/{filepath}	/system/files/%	6	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1181:{a:9:{s:4:"path";s:24:"/system/files/{filepath}";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:11:"_controller";s:46:"Drupal\\\\system\\\\FileDownloadController::download";}s:12:"requirements";a:3:{s:8:"filepath";s:2:".+";s:7:"_access";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:4:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:20:"access_check.default";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":478:{a:11:{s:4:"vars";a:1:{i:0;s:8:"filepath";}s:11:"path_prefix";s:13:"/system/files";s:10:"path_regex";s:35:"#^/system/files/(?P<filepath>.+)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:2:".+";i:3;s:8:"filepath";}i:1;a:2:{i:0;s:4:"text";i:1;s:13:"/system/files";}}s:9:"path_vars";a:1:{i:0;s:8:"filepath";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:6;s:14:"patternOutline";s:15:"/system/files/%";s:8:"numParts";i:3;}}}}	3
system.themes_page	/admin/appearance	/admin/appearance	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1121:{a:9:{s:4:"path";s:17:"/admin/appearance";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:6:"_title";s:10:"Appearance";s:11:"_controller";s:54:"\\\\Drupal\\\\system\\\\Controller\\\\SystemController::themesPage";}s:12:"requirements";a:2:{s:11:"_permission";s:17:"administer themes";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":364:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:17:"/admin/appearance";s:10:"path_regex";s:22:"#^/admin/appearance$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:17:"/admin/appearance";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:17:"/admin/appearance";s:8:"numParts";i:2;}}}}	2
system.theme_set_default	/admin/appearance/default	/admin/appearance/default	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1234:{a:9:{s:4:"path";s:25:"/admin/appearance/default";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:6:"_title";s:20:"Set as default theme";s:11:"_controller";s:58:"\\\\Drupal\\\\system\\\\Controller\\\\ThemeController::setDefaultTheme";}s:12:"requirements";a:3:{s:11:"_permission";s:17:"administer themes";s:11:"_csrf_token";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:2:{i:0;s:23:"access_check.permission";i:1;s:17:"access_check.csrf";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":396:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:25:"/admin/appearance/default";s:10:"path_regex";s:30:"#^/admin/appearance/default$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:25:"/admin/appearance/default";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:25:"/admin/appearance/default";s:8:"numParts";i:3;}}}}	3
system.theme_settings	/admin/appearance/settings	/admin/appearance/settings	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1182:{a:9:{s:4:"path";s:26:"/admin/appearance/settings";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:37:"\\\\Drupal\\\\system\\\\Form\\\\ThemeSettingsForm";s:6:"_title";s:19:"Appearance settings";}s:12:"requirements";a:2:{s:11:"_permission";s:17:"administer themes";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":400:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:26:"/admin/appearance/settings";s:10:"path_regex";s:31:"#^/admin/appearance/settings$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:26:"/admin/appearance/settings";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:26:"/admin/appearance/settings";s:8:"numParts";i:3;}}}}	3
system.theme_settings_theme	/admin/appearance/settings/{theme}	/admin/appearance/settings/%	14	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1329:{a:9:{s:4:"path";s:34:"/admin/appearance/settings/{theme}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:37:"\\\\Drupal\\\\system\\\\Form\\\\ThemeSettingsForm";s:15:"_title_callback";s:21:"theme_handler:getName";}s:12:"requirements";a:2:{s:11:"_permission";s:17:"administer themes";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":527:{a:11:{s:4:"vars";a:1:{i:0;s:5:"theme";}s:11:"path_prefix";s:26:"/admin/appearance/settings";s:10:"path_regex";s:49:"#^/admin/appearance/settings/(?P<theme>[^/]++)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:5:"theme";}i:1;a:2:{i:0;s:4:"text";i:1;s:26:"/admin/appearance/settings";}}s:9:"path_vars";a:1:{i:0;s:5:"theme";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:14;s:14:"patternOutline";s:28:"/admin/appearance/settings/%";s:8:"numParts";i:4;}}}}	4
<front>	/	/	1	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":902:{a:9:{s:4:"path";s:1:"/";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:6:"_title";s:4:"Home";}s:12:"requirements";a:2:{s:7:"_access";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:4:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:20:"access_check.default";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":296:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:1:"/";s:10:"path_regex";s:6:"#^/$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:1:"/";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:1;s:14:"patternOutline";s:1:"/";s:8:"numParts";i:1;}}}}	1
<none>	/	/	1	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":897:{a:9:{s:4:"path";s:1:"/";s:4:"host";s:0:"";s:8:"defaults";a:0:{}s:12:"requirements";a:2:{s:7:"_access";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:8:"_no_path";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:20:"access_check.default";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":296:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:1:"/";s:10:"path_regex";s:6:"#^/$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:1:"/";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:1;s:14:"patternOutline";s:1:"/";s:8:"numParts";i:1;}}}}	1
system.modules_uninstall	/admin/modules/uninstall	/admin/modules/uninstall	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1164:{a:9:{s:4:"path";s:24:"/admin/modules/uninstall";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:39:"Drupal\\\\system\\\\Form\\\\ModulesUninstallForm";s:6:"_title";s:9:"Uninstall";}s:12:"requirements";a:2:{s:11:"_permission";s:18:"administer modules";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":392:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:24:"/admin/modules/uninstall";s:10:"path_regex";s:29:"#^/admin/modules/uninstall$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:24:"/admin/modules/uninstall";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:24:"/admin/modules/uninstall";s:8:"numParts";i:3;}}}}	3
system.modules_uninstall_confirm	/admin/modules/uninstall/confirm	/admin/modules/uninstall/confirm	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1221:{a:9:{s:4:"path";s:32:"/admin/modules/uninstall/confirm";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:46:"Drupal\\\\system\\\\Form\\\\ModulesUninstallConfirmForm";s:6:"_title";s:17:"Confirm uninstall";}s:12:"requirements";a:2:{s:11:"_permission";s:18:"administer modules";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":425:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:32:"/admin/modules/uninstall/confirm";s:10:"path_regex";s:37:"#^/admin/modules/uninstall/confirm$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:32:"/admin/modules/uninstall/confirm";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:32:"/admin/modules/uninstall/confirm";s:8:"numParts";i:4;}}}}	4
system.timezone	/system/timezone/{abbreviation}/{offset}/{is_daylight_saving_time}	/system/timezone	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1668:{a:9:{s:4:"path";s:66:"/system/timezone/{abbreviation}/{offset}/{is_daylight_saving_time}";s:4:"host";s:0:"";s:8:"defaults";a:4:{s:11:"_controller";s:57:"\\\\Drupal\\\\system\\\\Controller\\\\TimezoneController::getTimezone";s:12:"abbreviation";s:0:"";s:6:"offset";i:-1;s:23:"is_daylight_saving_time";N;}s:12:"requirements";a:2:{s:7:"_access";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:4:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:20:"access_check.default";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":858:{a:11:{s:4:"vars";a:3:{i:0;s:12:"abbreviation";i:1;s:6:"offset";i:2;s:23:"is_daylight_saving_time";}s:11:"path_prefix";s:16:"/system/timezone";s:10:"path_regex";s:116:"#^/system/timezone(?:/(?P<abbreviation>[^/]++)(?:/(?P<offset>[^/]++)(?:/(?P<is_daylight_saving_time>[^/]++))?)?)?$#s";s:11:"path_tokens";a:4:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:23:"is_daylight_saving_time";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:6:"offset";}i:2;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:12:"abbreviation";}i:3;a:2:{i:0;s:4:"text";i:1;s:16:"/system/timezone";}}s:9:"path_vars";a:3:{i:0;s:12:"abbreviation";i:1;s:6:"offset";i:2;s:23:"is_daylight_saving_time";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:16:"/system/timezone";s:8:"numParts";i:5;}}}}	5
system.admin_config	/admin/config	/admin/config	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1153:{a:9:{s:4:"path";s:13:"/admin/config";s:4:"host";s:0:"";s:8:"defaults";a:3:{s:11:"_controller";s:52:"\\\\Drupal\\\\system\\\\Controller\\\\SystemController::overview";s:7:"link_id";s:19:"system.admin_config";s:6:"_title";s:13:"Configuration";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"access administration pages";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":348:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:13:"/admin/config";s:10:"path_regex";s:18:"#^/admin/config$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:13:"/admin/config";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:13:"/admin/config";s:8:"numParts";i:2;}}}}	2
system.batch_page.html	/batch	/batch	1	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1183:{a:9:{s:4:"path";s:6:"/batch";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:52:"\\\\Drupal\\\\system\\\\Controller\\\\BatchController::batchPage";s:15:"_title_callback";s:57:"\\\\Drupal\\\\system\\\\Controller\\\\BatchController::batchPageTitle";}s:12:"requirements";a:3:{s:7:"_access";s:4:"TRUE";s:7:"_format";s:4:"html";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:12:"_no_big_pipe";b:1;s:14:"_route_filters";a:2:{i:0;s:27:"request_format_route_filter";i:1;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:20:"access_check.default";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":317:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:6:"/batch";s:10:"path_regex";s:11:"#^/batch$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:6:"/batch";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:1;s:14:"patternOutline";s:6:"/batch";s:8:"numParts";i:1;}}}}	1
system.batch_page.json	/batch	/batch	1	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1071:{a:9:{s:4:"path";s:6:"/batch";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:11:"_controller";s:52:"\\\\Drupal\\\\system\\\\Controller\\\\BatchController::batchPage";}s:12:"requirements";a:3:{s:7:"_access";s:4:"TRUE";s:7:"_format";s:4:"json";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:2:{i:0;s:27:"request_format_route_filter";i:1;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:20:"access_check.default";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":317:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:6:"/batch";s:10:"path_regex";s:11:"#^/batch$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:6:"/batch";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:1;s:14:"patternOutline";s:6:"/batch";s:8:"numParts";i:1;}}}}	1
system.db_update	/update.php/{op}	/update.php	1	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1153:{a:9:{s:4:"path";s:16:"/update.php/{op}";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:2:"op";s:4:"info";}s:12:"requirements";a:2:{s:21:"_access_system_update";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:19:"default_url_options";a:1:{s:15:"path_processing";b:0;}s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:22:"access_check.db_update";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":458:{a:11:{s:4:"vars";a:1:{i:0;s:2:"op";}s:11:"path_prefix";s:11:"/update.php";s:10:"path_regex";s:37:"#^/update\\\\.php(?:/(?P<op>[^/]++))?$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:2:"op";}i:1;a:2:{i:0;s:4:"text";i:1;s:11:"/update.php";}}s:9:"path_vars";a:1:{i:0;s:2:"op";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:1;s:14:"patternOutline";s:11:"/update.php";s:8:"numParts";i:2;}}}}	2
system.admin_content	/admin/content	/admin/content	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1062:{a:9:{s:4:"path";s:14:"/admin/content";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:6:"_title";s:7:"Content";s:12:"_entity_list";s:4:"node";}s:12:"requirements";a:1:{s:11:"_permission";s:23:"access content overview";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":352:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:14:"/admin/content";s:10:"path_regex";s:19:"#^/admin/content$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:14:"/admin/content";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:14:"/admin/content";s:8:"numParts";i:2;}}}}	2
system.entity_autocomplete	/entity_reference_autocomplete/{target_type}/{selection_handler}/{selection_settings_key}	/entity_reference_autocomplete/%/%/%	8	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1716:{a:9:{s:4:"path";s:89:"/entity_reference_autocomplete/{target_type}/{selection_handler}/{selection_settings_key}";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:11:"_controller";s:74:"\\\\Drupal\\\\system\\\\Controller\\\\EntityAutocompleteController::handleAutocomplete";}s:12:"requirements";a:2:{s:7:"_access";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:4:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:20:"access_check.default";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":944:{a:11:{s:4:"vars";a:3:{i:0;s:11:"target_type";i:1;s:17:"selection_handler";i:2;s:22:"selection_settings_key";}s:11:"path_prefix";s:30:"/entity_reference_autocomplete";s:10:"path_regex";s:124:"#^/entity_reference_autocomplete/(?P<target_type>[^/]++)/(?P<selection_handler>[^/]++)/(?P<selection_settings_key>[^/]++)$#s";s:11:"path_tokens";a:4:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:22:"selection_settings_key";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:17:"selection_handler";}i:2;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:11:"target_type";}i:3;a:2:{i:0;s:4:"text";i:1;s:30:"/entity_reference_autocomplete";}}s:9:"path_vars";a:3:{i:0;s:11:"target_type";i:1;s:17:"selection_handler";i:2;s:22:"selection_settings_key";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:8;s:14:"patternOutline";s:36:"/entity_reference_autocomplete/%/%/%";s:8:"numParts";i:4;}}}}	4
update.settings	/admin/reports/updates/settings	/admin/reports/updates/settings	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1220:{a:9:{s:4:"path";s:31:"/admin/reports/updates/settings";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:33:"\\\\Drupal\\\\update\\\\UpdateSettingsForm";s:6:"_title";s:23:"Update Manager settings";}s:12:"requirements";a:2:{s:11:"_permission";s:29:"administer site configuration";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":421:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:31:"/admin/reports/updates/settings";s:10:"path_regex";s:36:"#^/admin/reports/updates/settings$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:31:"/admin/reports/updates/settings";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:31:"/admin/reports/updates/settings";s:8:"numParts";i:4;}}}}	4
update.status	/admin/reports/updates	/admin/reports/updates	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1167:{a:9:{s:4:"path";s:22:"/admin/reports/updates";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:56:"\\\\Drupal\\\\update\\\\Controller\\\\UpdateController::updateStatus";s:6:"_title";s:17:"Available updates";}s:12:"requirements";a:2:{s:11:"_permission";s:29:"administer site configuration";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":384:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:22:"/admin/reports/updates";s:10:"path_regex";s:27:"#^/admin/reports/updates$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:22:"/admin/reports/updates";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:22:"/admin/reports/updates";s:8:"numParts";i:3;}}}}	3
update.manual_status	/admin/reports/updates/check	/admin/reports/updates/check	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1267:{a:9:{s:4:"path";s:28:"/admin/reports/updates/check";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:6:"_title";s:19:"Manual update check";s:11:"_controller";s:64:"\\\\Drupal\\\\update\\\\Controller\\\\UpdateController::updateStatusManually";}s:12:"requirements";a:3:{s:11:"_permission";s:29:"administer site configuration";s:11:"_csrf_token";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:2:{i:0;s:23:"access_check.permission";i:1;s:17:"access_check.csrf";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":409:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:28:"/admin/reports/updates/check";s:10:"path_regex";s:33:"#^/admin/reports/updates/check$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:28:"/admin/reports/updates/check";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:28:"/admin/reports/updates/check";s:8:"numParts";i:4;}}}}	4
update.report_install	/admin/reports/updates/install	/admin/reports/updates/install	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1290:{a:9:{s:4:"path";s:30:"/admin/reports/updates/install";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:40:"\\\\Drupal\\\\update\\\\Form\\\\UpdateManagerInstall";s:6:"_title";s:7:"Install";}s:12:"requirements";a:3:{s:11:"_permission";s:27:"administer software updates";s:22:"_access_update_manager";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:2:{i:0;s:23:"access_check.permission";i:1;s:34:"access_check.update.manager_access";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":417:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:30:"/admin/reports/updates/install";s:10:"path_regex";s:35:"#^/admin/reports/updates/install$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:30:"/admin/reports/updates/install";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:30:"/admin/reports/updates/install";s:8:"numParts";i:4;}}}}	4
update.report_update	/admin/reports/updates/update	/admin/reports/updates/update	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1283:{a:9:{s:4:"path";s:29:"/admin/reports/updates/update";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:39:"\\\\Drupal\\\\update\\\\Form\\\\UpdateManagerUpdate";s:6:"_title";s:6:"Update";}s:12:"requirements";a:3:{s:11:"_permission";s:27:"administer software updates";s:22:"_access_update_manager";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:2:{i:0;s:23:"access_check.permission";i:1;s:34:"access_check.update.manager_access";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":413:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:29:"/admin/reports/updates/update";s:10:"path_regex";s:34:"#^/admin/reports/updates/update$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:29:"/admin/reports/updates/update";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:29:"/admin/reports/updates/update";s:8:"numParts";i:4;}}}}	4
update.module_install	/admin/modules/install	/admin/modules/install	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1261:{a:9:{s:4:"path";s:22:"/admin/modules/install";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:40:"\\\\Drupal\\\\update\\\\Form\\\\UpdateManagerInstall";s:6:"_title";s:18:"Install new module";}s:12:"requirements";a:3:{s:11:"_permission";s:27:"administer software updates";s:22:"_access_update_manager";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:2:{i:0;s:23:"access_check.permission";i:1;s:34:"access_check.update.manager_access";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":384:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:22:"/admin/modules/install";s:10:"path_regex";s:27:"#^/admin/modules/install$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:22:"/admin/modules/install";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:22:"/admin/modules/install";s:8:"numParts";i:3;}}}}	3
update.module_update	/admin/modules/update	/admin/modules/update	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1242:{a:9:{s:4:"path";s:21:"/admin/modules/update";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:39:"\\\\Drupal\\\\update\\\\Form\\\\UpdateManagerUpdate";s:6:"_title";s:6:"Update";}s:12:"requirements";a:3:{s:11:"_permission";s:27:"administer software updates";s:22:"_access_update_manager";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:2:{i:0;s:23:"access_check.permission";i:1;s:34:"access_check.update.manager_access";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":380:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:21:"/admin/modules/update";s:10:"path_regex";s:26:"#^/admin/modules/update$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:21:"/admin/modules/update";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:21:"/admin/modules/update";s:8:"numParts";i:3;}}}}	3
update.theme_install	/admin/theme/install	/admin/theme/install	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1250:{a:9:{s:4:"path";s:20:"/admin/theme/install";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:40:"\\\\Drupal\\\\update\\\\Form\\\\UpdateManagerInstall";s:6:"_title";s:17:"Install new theme";}s:12:"requirements";a:3:{s:11:"_permission";s:27:"administer software updates";s:22:"_access_update_manager";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:2:{i:0;s:23:"access_check.permission";i:1;s:34:"access_check.update.manager_access";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":376:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:20:"/admin/theme/install";s:10:"path_regex";s:25:"#^/admin/theme/install$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:20:"/admin/theme/install";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:20:"/admin/theme/install";s:8:"numParts";i:3;}}}}	3
update.theme_update	/admin/theme/update	/admin/theme/update	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1232:{a:9:{s:4:"path";s:19:"/admin/theme/update";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:39:"\\\\Drupal\\\\update\\\\Form\\\\UpdateManagerUpdate";s:6:"_title";s:6:"Update";}s:12:"requirements";a:3:{s:11:"_permission";s:27:"administer software updates";s:22:"_access_update_manager";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:2:{i:0;s:23:"access_check.permission";i:1;s:34:"access_check.update.manager_access";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":372:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:19:"/admin/theme/update";s:10:"path_regex";s:24:"#^/admin/theme/update$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:19:"/admin/theme/update";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:19:"/admin/theme/update";s:8:"numParts";i:3;}}}}	3
update.confirmation_page	/admin/update/ready	/admin/update/ready	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1234:{a:9:{s:4:"path";s:19:"/admin/update/ready";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:31:"\\\\Drupal\\\\update\\\\Form\\\\UpdateReady";s:6:"_title";s:15:"Ready to update";}s:12:"requirements";a:3:{s:11:"_permission";s:27:"administer software updates";s:22:"_access_update_manager";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:2:{i:0;s:23:"access_check.permission";i:1;s:34:"access_check.update.manager_access";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":372:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:19:"/admin/update/ready";s:10:"path_regex";s:24:"#^/admin/update/ready$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:19:"/admin/update/ready";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:19:"/admin/update/ready";s:8:"numParts";i:3;}}}}	3
user.register	/user/register	/user/register	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1198:{a:9:{s:4:"path";s:14:"/user/register";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:13:"user.register";s:6:"_title";s:18:"Create new account";}s:12:"requirements";a:2:{s:21:"_access_user_register";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:4:"user";a:2:{s:4:"type";s:11:"entity:user";s:9:"converter";s:21:"paramconverter.entity";}}s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:26:"access_check.user.register";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":352:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:14:"/user/register";s:10:"path_regex";s:19:"#^/user/register$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:14:"/user/register";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:14:"/user/register";s:8:"numParts";i:2;}}}}	2
user.logout	/user/logout	/user/logout	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1033:{a:9:{s:4:"path";s:12:"/user/logout";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:11:"_controller";s:46:"\\\\Drupal\\\\user\\\\Controller\\\\UserController::logout";}s:12:"requirements";a:2:{s:18:"_user_is_logged_in";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:4:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:30:"access_check.user.login_status";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":344:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:12:"/user/logout";s:10:"path_regex";s:17:"#^/user/logout$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:12:"/user/logout";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:12:"/user/logout";s:8:"numParts";i:2;}}}}	2
user.admin_index	/admin/config/people	/admin/config/people	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1155:{a:9:{s:4:"path";s:20:"/admin/config/people";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:68:"\\\\Drupal\\\\system\\\\Controller\\\\SystemController::systemAdminMenuBlockPage";s:6:"_title";s:6:"People";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"access administration pages";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":376:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:20:"/admin/config/people";s:10:"path_regex";s:25:"#^/admin/config/people$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:20:"/admin/config/people";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:20:"/admin/config/people";s:8:"numParts";i:3;}}}}	3
entity.user.admin_form	/admin/config/people/accounts	/admin/config/people/accounts	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1200:{a:9:{s:4:"path";s:29:"/admin/config/people/accounts";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:32:"\\\\Drupal\\\\user\\\\AccountSettingsForm";s:6:"_title";s:16:"Account settings";}s:12:"requirements";a:2:{s:11:"_permission";s:27:"administer account settings";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":413:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:29:"/admin/config/people/accounts";s:10:"path_regex";s:34:"#^/admin/config/people/accounts$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:29:"/admin/config/people/accounts";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:29:"/admin/config/people/accounts";s:8:"numParts";i:4;}}}}	4
entity.user.collection	/admin/people	/admin/people	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1078:{a:9:{s:4:"path";s:13:"/admin/people";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_list";s:4:"user";s:6:"_title";s:6:"People";}s:12:"requirements";a:2:{s:11:"_permission";s:16:"administer users";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":348:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:13:"/admin/people";s:10:"path_regex";s:18:"#^/admin/people$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:13:"/admin/people";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:13:"/admin/people";s:8:"numParts";i:2;}}}}	2
user.admin_create	/admin/people/create	/admin/people/create	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1241:{a:9:{s:4:"path";s:20:"/admin/people/create";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:13:"user.register";s:6:"_title";s:8:"Add user";}s:12:"requirements";a:2:{s:11:"_permission";s:16:"administer users";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:4:"user";a:2:{s:4:"type";s:11:"entity:user";s:9:"converter";s:21:"paramconverter.entity";}}s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":376:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:20:"/admin/people/create";s:10:"path_regex";s:25:"#^/admin/people/create$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:20:"/admin/people/create";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:20:"/admin/people/create";s:8:"numParts";i:3;}}}}	3
user.admin_permissions	/admin/people/permissions	/admin/people/permissions	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1174:{a:9:{s:4:"path";s:25:"/admin/people/permissions";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:37:"\\\\Drupal\\\\user\\\\Form\\\\UserPermissionsForm";s:6:"_title";s:11:"Permissions";}s:12:"requirements";a:2:{s:11:"_permission";s:22:"administer permissions";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":396:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:25:"/admin/people/permissions";s:10:"path_regex";s:30:"#^/admin/people/permissions$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:25:"/admin/people/permissions";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:25:"/admin/people/permissions";s:8:"numParts";i:3;}}}}	3
entity.user_role.edit_permissions_form	/admin/people/permissions/{user_role}	/admin/people/permissions/%	14	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1499:{a:9:{s:4:"path";s:37:"/admin/people/permissions/{user_role}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:49:"\\\\Drupal\\\\user\\\\Form\\\\UserPermissionsRoleSpecificForm";s:6:"_title";s:9:"Edit role";}s:12:"requirements";a:2:{s:14:"_entity_access";s:16:"user_role.update";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:9:"user_role";a:2:{s:4:"type";s:16:"entity:user_role";s:9:"converter";s:63:"drupal.proxy_original_service.paramconverter.configentity_admin";}}s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":539:{a:11:{s:4:"vars";a:1:{i:0;s:9:"user_role";}s:11:"path_prefix";s:25:"/admin/people/permissions";s:10:"path_regex";s:52:"#^/admin/people/permissions/(?P<user_role>[^/]++)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:9:"user_role";}i:1;a:2:{i:0;s:4:"text";i:1;s:25:"/admin/people/permissions";}}s:9:"path_vars";a:1:{i:0;s:9:"user_role";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:14;s:14:"patternOutline";s:27:"/admin/people/permissions/%";s:8:"numParts";i:4;}}}}	4
user.multiple_cancel_confirm	/admin/people/cancel	/admin/people/cancel	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1149:{a:9:{s:4:"path";s:20:"/admin/people/cancel";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:43:"\\\\Drupal\\\\user\\\\Form\\\\UserMultipleCancelConfirm";s:6:"_title";s:11:"Cancel user";}s:12:"requirements";a:2:{s:11:"_permission";s:16:"administer users";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":376:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:20:"/admin/people/cancel";s:10:"path_regex";s:25:"#^/admin/people/cancel$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:20:"/admin/people/cancel";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:20:"/admin/people/cancel";s:8:"numParts";i:3;}}}}	3
entity.user_role.collection	/admin/people/roles	/admin/people/roles	7	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1118:{a:9:{s:4:"path";s:19:"/admin/people/roles";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_list";s:9:"user_role";s:6:"_title";s:5:"Roles";}s:12:"requirements";a:2:{s:11:"_permission";s:22:"administer permissions";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":372:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:19:"/admin/people/roles";s:10:"path_regex";s:24:"#^/admin/people/roles$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:19:"/admin/people/roles";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:7;s:14:"patternOutline";s:19:"/admin/people/roles";s:8:"numParts";i:3;}}}}	3
user.role_add	/admin/people/roles/add	/admin/people/roles/add	15	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1319:{a:9:{s:4:"path";s:23:"/admin/people/roles/add";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:17:"user_role.default";s:6:"_title";s:8:"Add role";}s:12:"requirements";a:2:{s:11:"_permission";s:22:"administer permissions";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:9:"user_role";a:2:{s:4:"type";s:16:"entity:user_role";s:9:"converter";s:63:"drupal.proxy_original_service.paramconverter.configentity_admin";}}s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:23:"access_check.permission";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":389:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:23:"/admin/people/roles/add";s:10:"path_regex";s:28:"#^/admin/people/roles/add$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:23:"/admin/people/roles/add";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:15;s:14:"patternOutline";s:23:"/admin/people/roles/add";s:8:"numParts";i:4;}}}}	4
entity.user_role.edit_form	/admin/people/roles/manage/{user_role}	/admin/people/roles/manage/%	30	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1482:{a:9:{s:4:"path";s:38:"/admin/people/roles/manage/{user_role}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:17:"user_role.default";s:6:"_title";s:9:"Edit role";}s:12:"requirements";a:2:{s:14:"_entity_access";s:16:"user_role.update";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:9:"user_role";a:2:{s:4:"type";s:16:"entity:user_role";s:9:"converter";s:63:"drupal.proxy_original_service.paramconverter.configentity_admin";}}s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":543:{a:11:{s:4:"vars";a:1:{i:0;s:9:"user_role";}s:11:"path_prefix";s:26:"/admin/people/roles/manage";s:10:"path_regex";s:53:"#^/admin/people/roles/manage/(?P<user_role>[^/]++)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:9:"user_role";}i:1;a:2:{i:0;s:4:"text";i:1;s:26:"/admin/people/roles/manage";}}s:9:"path_vars";a:1:{i:0;s:9:"user_role";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:30;s:14:"patternOutline";s:28:"/admin/people/roles/manage/%";s:8:"numParts";i:5;}}}}	5
entity.user_role.delete_form	/admin/people/roles/manage/{user_role}/delete	/admin/people/roles/manage/%/delete	61	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1548:{a:9:{s:4:"path";s:45:"/admin/people/roles/manage/{user_role}/delete";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:16:"user_role.delete";s:6:"_title";s:11:"Delete role";}s:12:"requirements";a:2:{s:14:"_entity_access";s:16:"user_role.delete";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:9:"user_role";a:2:{s:4:"type";s:16:"entity:user_role";s:9:"converter";s:63:"drupal.proxy_original_service.paramconverter.configentity_admin";}}s:12:"_admin_route";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":600:{a:11:{s:4:"vars";a:1:{i:0;s:9:"user_role";}s:11:"path_prefix";s:26:"/admin/people/roles/manage";s:10:"path_regex";s:60:"#^/admin/people/roles/manage/(?P<user_role>[^/]++)/delete$#s";s:11:"path_tokens";a:3:{i:0;a:2:{i:0;s:4:"text";i:1;s:7:"/delete";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:9:"user_role";}i:2;a:2:{i:0;s:4:"text";i:1;s:26:"/admin/people/roles/manage";}}s:9:"path_vars";a:1:{i:0;s:9:"user_role";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:61;s:14:"patternOutline";s:35:"/admin/people/roles/manage/%/delete";s:8:"numParts";i:6;}}}}	6
user.pass	/user/password	/user/password	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1104:{a:9:{s:4:"path";s:14:"/user/password";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:34:"\\\\Drupal\\\\user\\\\Form\\\\UserPasswordForm";s:6:"_title";s:19:"Reset your password";}s:12:"requirements";a:2:{s:7:"_access";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:19:"_maintenance_access";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:20:"access_check.default";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":352:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:14:"/user/password";s:10:"path_regex";s:19:"#^/user/password$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:14:"/user/password";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:14:"/user/password";s:8:"numParts";i:2;}}}}	2
user.page	/user	/user	1	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1027:{a:9:{s:4:"path";s:5:"/user";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:48:"\\\\Drupal\\\\user\\\\Controller\\\\UserController::userPage";s:6:"_title";s:10:"My account";}s:12:"requirements";a:2:{s:18:"_user_is_logged_in";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:4:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:30:"access_check.user.login_status";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":313:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:5:"/user";s:10:"path_regex";s:10:"#^/user$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:5:"/user";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:1;s:14:"patternOutline";s:5:"/user";s:8:"numParts";i:1;}}}}	1
user.login	/user/login	/user/login	3	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1095:{a:9:{s:4:"path";s:11:"/user/login";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:5:"_form";s:31:"\\\\Drupal\\\\user\\\\Form\\\\UserLoginForm";s:6:"_title";s:6:"Log in";}s:12:"requirements";a:2:{s:18:"_user_is_logged_in";s:5:"FALSE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:19:"_maintenance_access";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:19:"route_enhancer.form";}s:14:"_access_checks";a:1:{i:0;s:30:"access_check.user.login_status";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":340:{a:11:{s:4:"vars";a:0:{}s:11:"path_prefix";s:11:"/user/login";s:10:"path_regex";s:16:"#^/user/login$#s";s:11:"path_tokens";a:1:{i:0;a:2:{i:0;s:4:"text";i:1;s:11:"/user/login";}}s:9:"path_vars";a:0:{}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:3;s:14:"patternOutline";s:11:"/user/login";s:8:"numParts";i:2;}}}}	2
user.cancel_confirm	/user/{user}/cancel/confirm/{timestamp}/{hashed_pass}	/user/%/cancel/confirm	11	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1776:{a:9:{s:4:"path";s:53:"/user/{user}/cancel/confirm/{timestamp}/{hashed_pass}";s:4:"host";s:0:"";s:8:"defaults";a:4:{s:6:"_title";s:28:"Confirm account cancellation";s:11:"_controller";s:53:"\\\\Drupal\\\\user\\\\Controller\\\\UserController::confirmCancel";s:9:"timestamp";i:0;s:11:"hashed_pass";s:0:"";}s:12:"requirements";a:3:{s:14:"_entity_access";s:11:"user.delete";s:4:"user";s:3:"\\\\d+";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:4:"user";a:2:{s:4:"type";s:11:"entity:user";s:9:"converter";s:21:"paramconverter.entity";}}s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":814:{a:11:{s:4:"vars";a:3:{i:0;s:4:"user";i:1;s:9:"timestamp";i:2;s:11:"hashed_pass";}s:11:"path_prefix";s:5:"/user";s:10:"path_regex";s:95:"#^/user/(?P<user>\\\\d+)/cancel/confirm(?:/(?P<timestamp>[^/]++)(?:/(?P<hashed_pass>[^/]++))?)?$#s";s:11:"path_tokens";a:5:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:11:"hashed_pass";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:9:"timestamp";}i:2;a:2:{i:0;s:4:"text";i:1;s:15:"/cancel/confirm";}i:3;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:3:"\\\\d+";i:3;s:4:"user";}i:4;a:2:{i:0;s:4:"text";i:1;s:5:"/user";}}s:9:"path_vars";a:3:{i:0;s:4:"user";i:1;s:9:"timestamp";i:2;s:11:"hashed_pass";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:11;s:14:"patternOutline";s:22:"/user/%/cancel/confirm";s:8:"numParts";i:6;}}}}	6
user.reset	/user/reset/{uid}/{timestamp}/{hash}	/user/reset/%/%/%	24	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1502:{a:9:{s:4:"path";s:36:"/user/reset/{uid}/{timestamp}/{hash}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:49:"\\\\Drupal\\\\user\\\\Controller\\\\UserController::resetPass";s:6:"_title";s:14:"Reset password";}s:12:"requirements";a:2:{s:7:"_access";s:4:"TRUE";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:19:"_maintenance_access";b:1;s:8:"no_cache";b:1;s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:20:"access_check.default";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":723:{a:11:{s:4:"vars";a:3:{i:0;s:3:"uid";i:1;s:9:"timestamp";i:2;s:4:"hash";}s:11:"path_prefix";s:11:"/user/reset";s:10:"path_regex";s:71:"#^/user/reset/(?P<uid>[^/]++)/(?P<timestamp>[^/]++)/(?P<hash>[^/]++)$#s";s:11:"path_tokens";a:4:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:4:"hash";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:9:"timestamp";}i:2;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:6:"[^/]++";i:3;s:3:"uid";}i:3;a:2:{i:0;s:4:"text";i:1;s:11:"/user/reset";}}s:9:"path_vars";a:3:{i:0;s:3:"uid";i:1;s:9:"timestamp";i:2;s:4:"hash";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:24;s:14:"patternOutline";s:17:"/user/reset/%/%/%";s:8:"numParts";i:5;}}}}	5
entity.node.canonical	/node/{node}	/node/%	2	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1327:{a:9:{s:4:"path";s:12:"/node/{node}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:11:"_controller";s:48:"\\\\Drupal\\\\node\\\\Controller\\\\NodeViewController::view";s:15:"_title_callback";s:49:"\\\\Drupal\\\\node\\\\Controller\\\\NodeViewController::title";}s:12:"requirements";a:3:{s:4:"node";s:3:"\\\\d+";s:14:"_entity_access";s:9:"node.view";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:4:"node";a:2:{s:4:"type";s:11:"entity:node";s:9:"converter";s:21:"paramconverter.entity";}}s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:1:{i:0;s:31:"route_enhancer.param_conversion";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":429:{a:11:{s:4:"vars";a:1:{i:0;s:4:"node";}s:11:"path_prefix";s:5:"/node";s:10:"path_regex";s:24:"#^/node/(?P<node>\\\\d+)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:3:"\\\\d+";i:3;s:4:"node";}i:1;a:2:{i:0;s:4:"text";i:1;s:5:"/node";}}s:9:"path_vars";a:1:{i:0;s:4:"node";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:2;s:14:"patternOutline";s:7:"/node/%";s:8:"numParts";i:2;}}}}	2
entity.node.delete_form	/node/{node}/delete	/node/%/delete	5	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1371:{a:9:{s:4:"path";s:19:"/node/{node}/delete";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:11:"node.delete";s:6:"_title";s:6:"Delete";}s:12:"requirements";a:3:{s:4:"node";s:3:"\\\\d+";s:14:"_entity_access";s:11:"node.delete";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:21:"_node_operation_route";b:1;s:10:"parameters";a:1:{s:4:"node";a:2:{s:4:"type";s:11:"entity:node";s:9:"converter";s:21:"paramconverter.entity";}}s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":487:{a:11:{s:4:"vars";a:1:{i:0;s:4:"node";}s:11:"path_prefix";s:5:"/node";s:10:"path_regex";s:31:"#^/node/(?P<node>\\\\d+)/delete$#s";s:11:"path_tokens";a:3:{i:0;a:2:{i:0;s:4:"text";i:1;s:7:"/delete";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:3:"\\\\d+";i:3;s:4:"node";}i:2;a:2:{i:0;s:4:"text";i:1;s:5:"/node";}}s:9:"path_vars";a:1:{i:0;s:4:"node";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:5;s:14:"patternOutline";s:14:"/node/%/delete";s:8:"numParts";i:3;}}}}	3
entity.node.edit_form	/node/{node}/edit	/node/%/edit	5	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1334:{a:9:{s:4:"path";s:17:"/node/{node}/edit";s:4:"host";s:0:"";s:8:"defaults";a:1:{s:12:"_entity_form";s:9:"node.edit";}s:12:"requirements";a:3:{s:14:"_entity_access";s:11:"node.update";s:4:"node";s:3:"\\\\d+";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:21:"_node_operation_route";b:1;s:10:"parameters";a:1:{s:4:"node";a:2:{s:4:"type";s:11:"entity:node";s:9:"converter";s:21:"paramconverter.entity";}}s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":481:{a:11:{s:4:"vars";a:1:{i:0;s:4:"node";}s:11:"path_prefix";s:5:"/node";s:10:"path_regex";s:29:"#^/node/(?P<node>\\\\d+)/edit$#s";s:11:"path_tokens";a:3:{i:0;a:2:{i:0;s:4:"text";i:1;s:5:"/edit";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:3:"\\\\d+";i:3;s:4:"node";}i:2;a:2:{i:0;s:4:"text";i:1;s:5:"/node";}}s:9:"path_vars";a:1:{i:0;s:4:"node";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:5;s:14:"patternOutline";s:12:"/node/%/edit";s:8:"numParts";i:3;}}}}	3
entity.user.canonical	/user/{user}	/user/%	2	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1320:{a:9:{s:4:"path";s:12:"/user/{user}";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_view";s:9:"user.full";s:15:"_title_callback";s:48:"Drupal\\\\user\\\\Controller\\\\UserController::userTitle";}s:12:"requirements";a:3:{s:4:"user";s:3:"\\\\d+";s:14:"_entity_access";s:9:"user.view";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:5:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:10:"parameters";a:1:{s:4:"user";a:2:{s:4:"type";s:11:"entity:user";s:9:"converter";s:21:"paramconverter.entity";}}s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":429:{a:11:{s:4:"vars";a:1:{i:0;s:4:"user";}s:11:"path_prefix";s:5:"/user";s:10:"path_regex";s:24:"#^/user/(?P<user>\\\\d+)$#s";s:11:"path_tokens";a:2:{i:0;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:3:"\\\\d+";i:3;s:4:"user";}i:1;a:2:{i:0;s:4:"text";i:1;s:5:"/user";}}s:9:"path_vars";a:1:{i:0;s:4:"user";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:2;s:14:"patternOutline";s:7:"/user/%";s:8:"numParts";i:2;}}}}	2
entity.user.edit_form	/user/{user}/edit	/user/%/edit	5	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1408:{a:9:{s:4:"path";s:17:"/user/{user}/edit";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:12:"_entity_form";s:12:"user.default";s:15:"_title_callback";s:48:"Drupal\\\\user\\\\Controller\\\\UserController::userTitle";}s:12:"requirements";a:3:{s:4:"user";s:3:"\\\\d+";s:14:"_entity_access";s:11:"user.update";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:10:"parameters";a:1:{s:4:"user";a:2:{s:4:"type";s:11:"entity:user";s:9:"converter";s:21:"paramconverter.entity";}}s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":481:{a:11:{s:4:"vars";a:1:{i:0;s:4:"user";}s:11:"path_prefix";s:5:"/user";s:10:"path_regex";s:29:"#^/user/(?P<user>\\\\d+)/edit$#s";s:11:"path_tokens";a:3:{i:0;a:2:{i:0;s:4:"text";i:1;s:5:"/edit";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:3:"\\\\d+";i:3;s:4:"user";}i:2;a:2:{i:0;s:4:"text";i:1;s:5:"/user";}}s:9:"path_vars";a:1:{i:0;s:4:"user";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:5;s:14:"patternOutline";s:12:"/user/%/edit";s:8:"numParts";i:3;}}}}	3
entity.user.cancel_form	/user/{user}/cancel	/user/%/cancel	5	C:31:"Symfony\\\\Component\\\\Routing\\\\Route":1371:{a:9:{s:4:"path";s:19:"/user/{user}/cancel";s:4:"host";s:0:"";s:8:"defaults";a:2:{s:6:"_title";s:14:"Cancel account";s:12:"_entity_form";s:11:"user.cancel";}s:12:"requirements";a:3:{s:4:"user";s:3:"\\\\d+";s:14:"_entity_access";s:11:"user.delete";s:7:"_method";s:8:"GET|POST";}s:7:"options";a:6:{s:14:"compiler_class";s:34:"\\\\Drupal\\\\Core\\\\Routing\\\\RouteCompiler";s:12:"_admin_route";b:1;s:10:"parameters";a:1:{s:4:"user";a:2:{s:4:"type";s:11:"entity:user";s:9:"converter";s:21:"paramconverter.entity";}}s:14:"_route_filters";a:1:{i:0;s:27:"content_type_header_matcher";}s:16:"_route_enhancers";a:2:{i:0;s:31:"route_enhancer.param_conversion";i:1;s:21:"route_enhancer.entity";}s:14:"_access_checks";a:1:{i:0;s:19:"access_check.entity";}}s:7:"schemes";a:0:{}s:7:"methods";a:2:{i:0;s:3:"GET";i:1;s:4:"POST";}s:9:"condition";s:0:"";s:8:"compiled";C:33:"Drupal\\\\Core\\\\Routing\\\\CompiledRoute":487:{a:11:{s:4:"vars";a:1:{i:0;s:4:"user";}s:11:"path_prefix";s:5:"/user";s:10:"path_regex";s:31:"#^/user/(?P<user>\\\\d+)/cancel$#s";s:11:"path_tokens";a:3:{i:0;a:2:{i:0;s:4:"text";i:1;s:7:"/cancel";}i:1;a:4:{i:0;s:8:"variable";i:1;s:1:"/";i:2;s:3:"\\\\d+";i:3;s:4:"user";}i:2;a:2:{i:0;s:4:"text";i:1;s:5:"/user";}}s:9:"path_vars";a:1:{i:0;s:4:"user";}s:10:"host_regex";N;s:11:"host_tokens";a:0:{}s:9:"host_vars";a:0:{}s:3:"fit";i:5;s:14:"patternOutline";s:14:"/user/%/cancel";s:8:"numParts";i:3;}}}}	3
\.


--
-- Data for Name: semaphore; Type: TABLE DATA; Schema: public; Owner: -
--

COPY semaphore (name, value, expire) FROM stdin;
\.


--
-- Data for Name: sequences; Type: TABLE DATA; Schema: public; Owner: -
--

COPY sequences (value) FROM stdin;
\.


--
-- Name: sequences_value_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sequences_value_seq', 1, true);


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY sessions (uid, sid, hostname, "timestamp", session) FROM stdin;
\.


--
-- Data for Name: url_alias; Type: TABLE DATA; Schema: public; Owner: -
--

COPY url_alias (pid, source, alias, langcode) FROM stdin;
\.


--
-- Name: url_alias_pid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('url_alias_pid_seq', 1, false);


--
-- Data for Name: user__roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY user__roles (bundle, deleted, entity_id, revision_id, langcode, delta, roles_target_id) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY users (uid, uuid, langcode) FROM stdin;
0	daf961fc-598e-4617-930a-53e0d1f4cb13	en
1	66405a3b-1ffc-44b7-89bd-bc771d8bae54	en
\.


--
-- Data for Name: users_data; Type: TABLE DATA; Schema: public; Owner: -
--

COPY users_data (uid, module, name, value, serialized) FROM stdin;
\.


--
-- Data for Name: users_field_data; Type: TABLE DATA; Schema: public; Owner: -
--

COPY users_field_data (uid, langcode, preferred_langcode, preferred_admin_langcode, name, pass, mail, timezone, status, created, changed, access, login, init, default_langcode) FROM stdin;
0	en	en	\N		\N	\N		0	1469959104	1469959104	0	0	\N	1
1	en	en	\N	admin	$S$EhejxFLDt8EkO2I4WiG7abTcnZWyIO71unzGw6kvvIDieuZvNRnv	adrian.webb@gsa.gov	America/New_York	1	1469959104	1469959318	1469959516	1469959318	adrian.webb@gsa.gov	1
\.


--
-- Data for Name: watchdog; Type: TABLE DATA; Schema: public; Owner: -
--

COPY watchdog (wid, uid, type, message, variables, severity, link, location, referer, hostname, "timestamp") FROM stdin;
\.


--
-- Name: watchdog_wid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('watchdog_wid_seq', 16, true);


--
-- Name: batch____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY batch
    ADD CONSTRAINT batch____pkey PRIMARY KEY (bid);


--
-- Name: cache_bootstrap____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_bootstrap
    ADD CONSTRAINT cache_bootstrap____pkey PRIMARY KEY (cid);


--
-- Name: cache_config____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_config
    ADD CONSTRAINT cache_config____pkey PRIMARY KEY (cid);


--
-- Name: cache_container____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_container
    ADD CONSTRAINT cache_container____pkey PRIMARY KEY (cid);


--
-- Name: cache_data____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_data
    ADD CONSTRAINT cache_data____pkey PRIMARY KEY (cid);


--
-- Name: cache_default____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_default
    ADD CONSTRAINT cache_default____pkey PRIMARY KEY (cid);


--
-- Name: cache_discovery____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_discovery
    ADD CONSTRAINT cache_discovery____pkey PRIMARY KEY (cid);


--
-- Name: cache_dynamic_page_cache____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_dynamic_page_cache
    ADD CONSTRAINT cache_dynamic_page_cache____pkey PRIMARY KEY (cid);


--
-- Name: cache_entity____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_entity
    ADD CONSTRAINT cache_entity____pkey PRIMARY KEY (cid);


--
-- Name: cache_menu____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_menu
    ADD CONSTRAINT cache_menu____pkey PRIMARY KEY (cid);


--
-- Name: cache_render____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_render
    ADD CONSTRAINT cache_render____pkey PRIMARY KEY (cid);


--
-- Name: cachetags____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cachetags
    ADD CONSTRAINT cachetags____pkey PRIMARY KEY (tag);


--
-- Name: config____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY config
    ADD CONSTRAINT config____pkey PRIMARY KEY (collection, name);


--
-- Name: file_managed____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY file_managed
    ADD CONSTRAINT file_managed____pkey PRIMARY KEY (fid);


--
-- Name: file_managed__file_field__uuid__value__key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY file_managed
    ADD CONSTRAINT file_managed__file_field__uuid__value__key UNIQUE (uuid);


--
-- Name: file_usage____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY file_usage
    ADD CONSTRAINT file_usage____pkey PRIMARY KEY (fid, type, id, module);


--
-- Name: key_value____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY key_value
    ADD CONSTRAINT key_value____pkey PRIMARY KEY (collection, name);


--
-- Name: key_value_expire____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY key_value_expire
    ADD CONSTRAINT key_value_expire____pkey PRIMARY KEY (collection, name);


--
-- Name: menu_tree____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY menu_tree
    ADD CONSTRAINT menu_tree____pkey PRIMARY KEY (mlid);


--
-- Name: menu_tree__id__key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY menu_tree
    ADD CONSTRAINT menu_tree__id__key UNIQUE (id);


--
-- Name: node____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node____pkey PRIMARY KEY (nid);


--
-- Name: node__body____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY node__body
    ADD CONSTRAINT node__body____pkey PRIMARY KEY (entity_id, deleted, delta, langcode);


--
-- Name: node__node__vid__key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node__node__vid__key UNIQUE (vid);


--
-- Name: node__node_field__uuid__value__key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node__node_field__uuid__value__key UNIQUE (uuid);


--
-- Name: node_access____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY node_access
    ADD CONSTRAINT node_access____pkey PRIMARY KEY (nid, gid, realm, langcode);


--
-- Name: node_field_data____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY node_field_data
    ADD CONSTRAINT node_field_data____pkey PRIMARY KEY (nid, langcode);


--
-- Name: node_field_revision____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY node_field_revision
    ADD CONSTRAINT node_field_revision____pkey PRIMARY KEY (vid, langcode);


--
-- Name: node_revision____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY node_revision
    ADD CONSTRAINT node_revision____pkey PRIMARY KEY (vid);


--
-- Name: node_revision__body____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY node_revision__body
    ADD CONSTRAINT node_revision__body____pkey PRIMARY KEY (entity_id, revision_id, deleted, delta, langcode);


--
-- Name: queue____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY queue
    ADD CONSTRAINT queue____pkey PRIMARY KEY (item_id);


--
-- Name: router____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY router
    ADD CONSTRAINT router____pkey PRIMARY KEY (name);


--
-- Name: semaphore____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY semaphore
    ADD CONSTRAINT semaphore____pkey PRIMARY KEY (name);


--
-- Name: sequences____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sequences
    ADD CONSTRAINT sequences____pkey PRIMARY KEY (value);


--
-- Name: sessions____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions____pkey PRIMARY KEY (sid);


--
-- Name: url_alias____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY url_alias
    ADD CONSTRAINT url_alias____pkey PRIMARY KEY (pid);


--
-- Name: user__roles____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user__roles
    ADD CONSTRAINT user__roles____pkey PRIMARY KEY (entity_id, deleted, delta, langcode);


--
-- Name: users____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users____pkey PRIMARY KEY (uid);


--
-- Name: users__user_field__uuid__value__key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users__user_field__uuid__value__key UNIQUE (uuid);


--
-- Name: users_data____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_data
    ADD CONSTRAINT users_data____pkey PRIMARY KEY (uid, module, name);


--
-- Name: users_field_data____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_field_data
    ADD CONSTRAINT users_field_data____pkey PRIMARY KEY (uid, langcode);


--
-- Name: users_field_data__user__name__key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_field_data
    ADD CONSTRAINT users_field_data__user__name__key UNIQUE (name, langcode);


--
-- Name: watchdog____pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY watchdog
    ADD CONSTRAINT watchdog____pkey PRIMARY KEY (wid);


--
-- Name: batch__token__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX batch__token__idx ON batch USING btree (token);


--
-- Name: cache_bootstrap__expire__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cache_bootstrap__expire__idx ON cache_bootstrap USING btree (expire);


--
-- Name: cache_config__expire__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cache_config__expire__idx ON cache_config USING btree (expire);


--
-- Name: cache_container__expire__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cache_container__expire__idx ON cache_container USING btree (expire);


--
-- Name: cache_data__expire__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cache_data__expire__idx ON cache_data USING btree (expire);


--
-- Name: cache_default__expire__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cache_default__expire__idx ON cache_default USING btree (expire);


--
-- Name: cache_discovery__expire__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cache_discovery__expire__idx ON cache_discovery USING btree (expire);


--
-- Name: cache_dynamic_page_cache__expire__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cache_dynamic_page_cache__expire__idx ON cache_dynamic_page_cache USING btree (expire);


--
-- Name: cache_entity__expire__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cache_entity__expire__idx ON cache_entity USING btree (expire);


--
-- Name: cache_menu__expire__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cache_menu__expire__idx ON cache_menu USING btree (expire);


--
-- Name: cache_render__expire__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cache_render__expire__idx ON cache_render USING btree (expire);


--
-- Name: file_managed__file_field__changed__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX file_managed__file_field__changed__idx ON file_managed USING btree (changed);


--
-- Name: file_managed__file_field__status__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX file_managed__file_field__status__idx ON file_managed USING btree (status);


--
-- Name: file_managed__file_field__uid__target_id__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX file_managed__file_field__uid__target_id__idx ON file_managed USING btree (uid);


--
-- Name: file_managed__file_field__uri__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX file_managed__file_field__uri__idx ON file_managed USING btree (uri);


--
-- Name: file_usage__fid_count__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX file_usage__fid_count__idx ON file_usage USING btree (fid, count);


--
-- Name: file_usage__fid_module__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX file_usage__fid_module__idx ON file_usage USING btree (fid, module);


--
-- Name: file_usage__type_id__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX file_usage__type_id__idx ON file_usage USING btree (type, id);


--
-- Name: key_value_expire__all__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX key_value_expire__all__idx ON key_value_expire USING btree (name, collection, expire);


--
-- Name: key_value_expire__expire__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX key_value_expire__expire__idx ON key_value_expire USING btree (expire);


--
-- Name: menu_tree__menu_parent_expand_child__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX menu_tree__menu_parent_expand_child__idx ON menu_tree USING btree (menu_name, expanded, has_children, substr((parent)::text, 1, 16));


--
-- Name: menu_tree__menu_parents__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX menu_tree__menu_parents__idx ON menu_tree USING btree (menu_name, p1, p2, p3, p4, p5, p6, p7, p8, p9);


--
-- Name: menu_tree__route_values__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX menu_tree__route_values__idx ON menu_tree USING btree (substr((route_name)::text, 1, 32), substr((route_param_key)::text, 1, 16));


--
-- Name: node__body__body_format__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node__body__body_format__idx ON node__body USING btree (body_format);


--
-- Name: node__body__bundle__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node__body__bundle__idx ON node__body USING btree (bundle);


--
-- Name: node__body__revision_id__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node__body__revision_id__idx ON node__body USING btree (revision_id);


--
-- Name: node__node_field__type__target_id__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node__node_field__type__target_id__idx ON node USING btree (type);


--
-- Name: node_field_data__node__frontpage__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_field_data__node__frontpage__idx ON node_field_data USING btree (promote, status, sticky, created);


--
-- Name: node_field_data__node__id__default_langcode__langcode__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_field_data__node__id__default_langcode__langcode__idx ON node_field_data USING btree (nid, default_langcode, langcode);


--
-- Name: node_field_data__node__status_type__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_field_data__node__status_type__idx ON node_field_data USING btree (status, type, nid);


--
-- Name: node_field_data__node__title_type__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_field_data__node__title_type__idx ON node_field_data USING btree (title, substr((type)::text, 1, 4));


--
-- Name: node_field_data__node__vid__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_field_data__node__vid__idx ON node_field_data USING btree (vid);


--
-- Name: node_field_data__node_field__changed__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_field_data__node_field__changed__idx ON node_field_data USING btree (changed);


--
-- Name: node_field_data__node_field__created__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_field_data__node_field__created__idx ON node_field_data USING btree (created);


--
-- Name: node_field_data__node_field__type__target_id__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_field_data__node_field__type__target_id__idx ON node_field_data USING btree (type);


--
-- Name: node_field_data__node_field__uid__target_id__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_field_data__node_field__uid__target_id__idx ON node_field_data USING btree (uid);


--
-- Name: node_field_revision__node__id__default_langcode__langcode__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_field_revision__node__id__default_langcode__langcode__idx ON node_field_revision USING btree (nid, default_langcode, langcode);


--
-- Name: node_field_revision__node_field__uid__target_id__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_field_revision__node_field__uid__target_id__idx ON node_field_revision USING btree (uid);


--
-- Name: node_revision__body__body_format__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_revision__body__body_format__idx ON node_revision__body USING btree (body_format);


--
-- Name: node_revision__body__bundle__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_revision__body__bundle__idx ON node_revision__body USING btree (bundle);


--
-- Name: node_revision__body__revision_id__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_revision__body__revision_id__idx ON node_revision__body USING btree (revision_id);


--
-- Name: node_revision__node__nid__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_revision__node__nid__idx ON node_revision USING btree (nid);


--
-- Name: node_revision__node_field__langcode__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_revision__node_field__langcode__idx ON node_revision USING btree (langcode);


--
-- Name: node_revision__node_field__revision_uid__target_id__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX node_revision__node_field__revision_uid__target_id__idx ON node_revision USING btree (revision_uid);


--
-- Name: queue__expire__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX queue__expire__idx ON queue USING btree (expire);


--
-- Name: queue__name_created__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX queue__name_created__idx ON queue USING btree (name, created);


--
-- Name: router__pattern_outline_parts__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX router__pattern_outline_parts__idx ON router USING btree (pattern_outline, number_parts);


--
-- Name: semaphore__expire__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX semaphore__expire__idx ON semaphore USING btree (expire);


--
-- Name: semaphore__value__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX semaphore__value__idx ON semaphore USING btree (value);


--
-- Name: sessions__timestamp__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sessions__timestamp__idx ON sessions USING btree ("timestamp");


--
-- Name: sessions__uid__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sessions__uid__idx ON sessions USING btree (uid);


--
-- Name: url_alias__alias_langcode_pid__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX url_alias__alias_langcode_pid__idx ON url_alias USING btree (alias, langcode, pid);


--
-- Name: url_alias__source_langcode_pid__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX url_alias__source_langcode_pid__idx ON url_alias USING btree (source, langcode, pid);


--
-- Name: user__roles__bundle__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user__roles__bundle__idx ON user__roles USING btree (bundle);


--
-- Name: user__roles__revision_id__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user__roles__revision_id__idx ON user__roles USING btree (revision_id);


--
-- Name: user__roles__roles_target_id__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user__roles__roles_target_id__idx ON user__roles USING btree (roles_target_id);


--
-- Name: users_data__module__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_data__module__idx ON users_data USING btree (module);


--
-- Name: users_data__name__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_data__name__idx ON users_data USING btree (name);


--
-- Name: users_field_data__user__id__default_langcode__langcode__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_field_data__user__id__default_langcode__langcode__idx ON users_field_data USING btree (uid, default_langcode, langcode);


--
-- Name: users_field_data__user_field__access__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_field_data__user_field__access__idx ON users_field_data USING btree (access);


--
-- Name: users_field_data__user_field__created__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_field_data__user_field__created__idx ON users_field_data USING btree (created);


--
-- Name: users_field_data__user_field__mail__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_field_data__user_field__mail__idx ON users_field_data USING btree (mail);


--
-- Name: watchdog__severity__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX watchdog__severity__idx ON watchdog USING btree (severity);


--
-- Name: watchdog__type__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX watchdog__type__idx ON watchdog USING btree (type);


--
-- Name: watchdog__uid__idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX watchdog__uid__idx ON watchdog USING btree (uid);


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

