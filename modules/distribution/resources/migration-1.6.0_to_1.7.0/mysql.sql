ALTER TABLE IDN_OAUTH_CONSUMER_APPS DROP LOGIN_PAGE_URL;
ALTER TABLE IDN_OAUTH_CONSUMER_APPS DROP ERROR_PAGE_URL;
ALTER TABLE IDN_OAUTH_CONSUMER_APPS DROP CONSENT_PAGE_URL;

ALTER TABLE AM_API_URL_MAPPING ADD MEDIATION_SCRIPT BLOB DEFAULT NULL;

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_SCOPE (
            SCOPE_ID INT(11) NOT NULL AUTO_INCREMENT,
            SCOPE_KEY VARCHAR(100) NOT NULL,
            NAME VARCHAR(255) NULL,
            DESCRIPTION VARCHAR(512) NULL,
            TENANT_ID INT(11) NOT NULL DEFAULT 0,
	    ROLES VARCHAR (500) NULL,
            PRIMARY KEY (SCOPE_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_RESOURCE_SCOPE (
            RESOURCE_PATH VARCHAR(255) NOT NULL,
            SCOPE_ID INTEGER (11) NOT NULL,
            PRIMARY KEY (RESOURCE_PATH),
            FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_SCOPE (SCOPE_ID)
)ENGINE INNODB;

CREATE TABLE IDN_SCIM_GROUP (
			ID INTEGER AUTO_INCREMENT,
			TENANT_ID INTEGER NOT NULL,
			ROLE_NAME VARCHAR(255) NOT NULL,
            ATTR_NAME VARCHAR(1024) NOT NULL,
			ATTR_VALUE VARCHAR(1024),
            PRIMARY KEY (ID)
)ENGINE INNODB;

CREATE TABLE IDN_SCIM_PROVIDER (
            CONSUMER_ID VARCHAR(255) NOT NULL,
            PROVIDER_ID VARCHAR(255) NOT NULL,
            USER_NAME VARCHAR(255) NOT NULL,
            USER_PASSWORD VARCHAR(255) NOT NULL,
            USER_URL VARCHAR(1024) NOT NULL,
			GROUP_URL VARCHAR(1024),
			BULK_URL VARCHAR(1024),
            PRIMARY KEY (CONSUMER_ID,PROVIDER_ID)
)ENGINE INNODB;

CREATE TABLE IDN_OPENID_REMEMBER_ME (
            USER_NAME VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER DEFAULT 0,
            COOKIE_VALUE VARCHAR(1024),
            CREATED_TIME TIMESTAMP,
            PRIMARY KEY (USER_NAME, TENANT_ID)
)ENGINE INNODB;

CREATE TABLE IDN_OPENID_ASSOCIATIONS (
			HANDLE VARCHAR(255) NOT NULL,
			ASSOC_TYPE VARCHAR(255) NOT NULL,
			EXPIRE_IN TIMESTAMP NOT NULL,
			MAC_KEY VARCHAR(255) NOT NULL,
			ASSOC_STORE VARCHAR(128) DEFAULT 'SHARED',
			PRIMARY KEY (HANDLE)
)ENGINE INNODB;

CREATE TABLE IDN_STS_STORE (
            ID INTEGER AUTO_INCREMENT,
            TOKEN_ID VARCHAR(255) NOT NULL,
            TOKEN_CONTENT BLOB(1024) NOT NULL,
            CREATE_DATE TIMESTAMP NOT NULL,
            EXPIRE_DATE TIMESTAMP NOT NULL,
            STATE INTEGER DEFAULT 0,
            PRIMARY KEY (ID)
)ENGINE INNODB;

CREATE TABLE IDN_IDENTITY_USER_DATA (
            TENANT_ID INTEGER DEFAULT -1234,
            USER_NAME VARCHAR(255) NOT NULL,
            DATA_KEY VARCHAR(255) NOT NULL,
            DATA_VALUE VARCHAR(255) NOT NULL,
            PRIMARY KEY (TENANT_ID, USER_NAME, DATA_KEY)
)ENGINE INNODB;

CREATE TABLE IDN_IDENTITY_META_DATA (
            USER_NAME VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER DEFAULT -1234,
            METADATA_TYPE VARCHAR(255) NOT NULL,
            METADATA VARCHAR(255) NOT NULL,
            VALID VARCHAR(255) NOT NULL,
            PRIMARY KEY (TENANT_ID, USER_NAME, METADATA_TYPE,METADATA)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_THRIFT_SESSION (
            SESSION_ID VARCHAR(255) NOT NULL,
            USER_NAME VARCHAR(255) NOT NULL,
            CREATED_TIME VARCHAR(255) NOT NULL,
            LAST_MODIFIED_TIME VARCHAR(255) NOT NULL,
            PRIMARY KEY (SESSION_ID)
)ENGINE INNODB;

-- End of IDN Tables --


-- Start of IDN-APPLICATION-MGT Tables--

CREATE TABLE IF NOT EXISTS SP_APP (
            ID INTEGER NOT NULL AUTO_INCREMENT,
            TENANT_ID INTEGER NOT NULL,
	    	APP_NAME VARCHAR (255) NOT NULL ,
	    	USER_STORE VARCHAR (255) NOT NULL,
            USERNAME VARCHAR (255) NOT NULL ,
            DESCRIPTION VARCHAR (1024),
	    	ROLE_CLAIM VARCHAR (512),
            AUTH_TYPE VARCHAR (255) NOT NULL,
	    	PROVISIONING_USERSTORE_DOMAIN VARCHAR (512),
	    	IS_LOCAL_CLAIM_DIALECT CHAR(1) DEFAULT '1',
	    	IS_SEND_LOCAL_SUBJECT_ID CHAR(1) DEFAULT '0',
	    	IS_SEND_AUTH_LIST_OF_IDPS CHAR(1) DEFAULT '0',
	    	SUBJECT_CLAIM_URI VARCHAR (512),
	    	IS_SAAS_APP CHAR(1) DEFAULT '0',
            PRIMARY KEY (ID)
)ENGINE INNODB;

ALTER TABLE SP_APP ADD CONSTRAINT APPLICATION_NAME_CONSTRAINT UNIQUE(APP_NAME, TENANT_ID);

CREATE TABLE IF NOT EXISTS SP_INBOUND_AUTH (
            ID INTEGER NOT NULL AUTO_INCREMENT,
	     	TENANT_ID INTEGER NOT NULL,
	     	INBOUND_AUTH_KEY VARCHAR (255) NOT NULL,
            INBOUND_AUTH_TYPE VARCHAR (255) NOT NULL,
            PROP_NAME VARCHAR (255),
            PROP_VALUE VARCHAR (1024) ,
	     	APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID)
)ENGINE INNODB;

ALTER TABLE SP_INBOUND_AUTH ADD CONSTRAINT APPLICATION_ID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS SP_AUTH_STEP (
            ID INTEGER NOT NULL AUTO_INCREMENT,
            TENANT_ID INTEGER NOT NULL,
	     	STEP_ORDER INTEGER DEFAULT 1,
            APP_ID INTEGER NOT NULL ,
            IS_SUBJECT_STEP CHAR(1) DEFAULT '0',
            IS_ATTRIBUTE_STEP CHAR(1) DEFAULT '0',
            PRIMARY KEY (ID)
)ENGINE INNODB;

ALTER TABLE SP_AUTH_STEP ADD CONSTRAINT APPLICATION_ID_CONSTRAINT_STEP FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS SP_FEDERATED_IDP (
            ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            AUTHENTICATOR_ID INTEGER NOT NULL,
            PRIMARY KEY (ID, AUTHENTICATOR_ID)
)ENGINE INNODB;

ALTER TABLE SP_FEDERATED_IDP ADD CONSTRAINT STEP_ID_CONSTRAINT FOREIGN KEY (ID) REFERENCES SP_AUTH_STEP (ID) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS SP_CLAIM_MAPPING (
	    	ID INTEGER NOT NULL AUTO_INCREMENT,
	    	TENANT_ID INTEGER NOT NULL,
	    	IDP_CLAIM VARCHAR (512) NOT NULL ,
            SP_CLAIM VARCHAR (512) NOT NULL ,
	   		APP_ID INTEGER NOT NULL,
	    	IS_REQUESTED VARCHAR(128) DEFAULT '0',
			DEFAULT_VALUE VARCHAR(255),
            PRIMARY KEY (ID)
)ENGINE INNODB;

ALTER TABLE SP_CLAIM_MAPPING ADD CONSTRAINT CLAIMID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS SP_ROLE_MAPPING (
	    	ID INTEGER NOT NULL AUTO_INCREMENT,
	    	TENANT_ID INTEGER NOT NULL,
	    	IDP_ROLE VARCHAR (255) NOT NULL ,
            SP_ROLE VARCHAR (255) NOT NULL ,
	    	APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID)
)ENGINE INNODB;

ALTER TABLE SP_ROLE_MAPPING ADD CONSTRAINT ROLEID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS SP_REQ_PATH_AUTHENTICATOR (
	    	ID INTEGER NOT NULL AUTO_INCREMENT,
	    	TENANT_ID INTEGER NOT NULL,
	    	AUTHENTICATOR_NAME VARCHAR (255) NOT NULL ,
	    	APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID)
)ENGINE INNODB;

ALTER TABLE SP_REQ_PATH_AUTHENTICATOR ADD CONSTRAINT REQ_AUTH_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS SP_PROVISIONING_CONNECTOR (
	    	ID INTEGER NOT NULL AUTO_INCREMENT,
	    	TENANT_ID INTEGER NOT NULL,
            IDP_NAME VARCHAR (255) NOT NULL ,
	    	CONNECTOR_NAME VARCHAR (255) NOT NULL ,
	    	APP_ID INTEGER NOT NULL,
	    	IS_JIT_ENABLED CHAR(1) NOT NULL DEFAULT '0',
		BLOCKING CHAR(1) NOT NULL DEFAULT '0',
            PRIMARY KEY (ID)
)ENGINE INNODB;

ALTER TABLE SP_PROVISIONING_CONNECTOR ADD CONSTRAINT PRO_CONNECTOR_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS IDP (
			ID INTEGER AUTO_INCREMENT,
			TENANT_ID INTEGER,
			NAME VARCHAR(254) NOT NULL,
			IS_ENABLED CHAR(1) NOT NULL DEFAULT '1',
			IS_PRIMARY CHAR(1) NOT NULL DEFAULT '0',
			HOME_REALM_ID VARCHAR(254),
			IMAGE MEDIUMBLOB,
			CERTIFICATE BLOB,
			ALIAS VARCHAR(254),
			INBOUND_PROV_ENABLED CHAR (1) NOT NULL DEFAULT '0',
			INBOUND_PROV_USER_STORE_ID VARCHAR(254),
 			USER_CLAIM_URI VARCHAR(254),
 			ROLE_CLAIM_URI VARCHAR(254),
  			DESCRIPTION VARCHAR (1024),
 			DEFAULT_AUTHENTICATOR_NAME VARCHAR(254),
 			DEFAULT_PRO_CONNECTOR_NAME VARCHAR(254),
 			PROVISIONING_ROLE VARCHAR(128),
 			IS_FEDERATION_HUB CHAR(1) NOT NULL DEFAULT '0',
 			IS_LOCAL_CLAIM_DIALECT CHAR(1) NOT NULL DEFAULT '0',
	                DISPLAY_NAME VARCHAR(255),
			PRIMARY KEY (ID),
			UNIQUE (TENANT_ID, NAME)
)ENGINE INNODB;

INSERT INTO IDP (TENANT_ID, NAME, HOME_REALM_ID) VALUES (-1234, 'LOCAL', 'localhost');

CREATE TABLE IF NOT EXISTS IDP_ROLE (
			ID INTEGER AUTO_INCREMENT,
			IDP_ID INTEGER,
			TENANT_ID INTEGER,
			ROLE VARCHAR(254),
			PRIMARY KEY (ID),
			UNIQUE (IDP_ID, ROLE),
			FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_ROLE_MAPPING (
			ID INTEGER AUTO_INCREMENT,
			IDP_ROLE_ID INTEGER,
			TENANT_ID INTEGER,
			USER_STORE_ID VARCHAR (253),
			LOCAL_ROLE VARCHAR(253),
			PRIMARY KEY (ID),
			UNIQUE (IDP_ROLE_ID, TENANT_ID, USER_STORE_ID, LOCAL_ROLE),
			FOREIGN KEY (IDP_ROLE_ID) REFERENCES IDP_ROLE(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_CLAIM (
			ID INTEGER AUTO_INCREMENT,
			IDP_ID INTEGER,
			TENANT_ID INTEGER,
			CLAIM VARCHAR(254),
			PRIMARY KEY (ID),
			UNIQUE (IDP_ID, CLAIM),
			FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_CLAIM_MAPPING (
			ID INTEGER AUTO_INCREMENT,
			IDP_CLAIM_ID INTEGER,
			TENANT_ID INTEGER,
			LOCAL_CLAIM VARCHAR(253),
		    	DEFAULT_VALUE VARCHAR(255),
			IS_REQUESTED VARCHAR(128) DEFAULT '0',
			PRIMARY KEY (ID),
			UNIQUE (IDP_CLAIM_ID, TENANT_ID, LOCAL_CLAIM),
			FOREIGN KEY (IDP_CLAIM_ID) REFERENCES IDP_CLAIM(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_AUTHENTICATOR (
            ID INTEGER AUTO_INCREMENT,
            TENANT_ID INTEGER,
            IDP_ID INTEGER,
            NAME VARCHAR(255) NOT NULL,
            IS_ENABLED CHAR (1) DEFAULT '1',
            DISPLAY_NAME VARCHAR(255),
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, NAME),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)ENGINE INNODB;

INSERT INTO IDP_AUTHENTICATOR (TENANT_ID, IDP_ID, NAME) VALUES (-1234, 1, 'samlsso');

CREATE TABLE IF NOT EXISTS IDP_AUTHENTICATOR_PROPERTY (
            ID INTEGER AUTO_INCREMENT,
            TENANT_ID INTEGER,
            AUTHENTICATOR_ID INTEGER,
            PROPERTY_KEY VARCHAR(255) NOT NULL,
            PROPERTY_VALUE VARCHAR(2047),
            IS_SECRET CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, AUTHENTICATOR_ID, PROPERTY_KEY),
            FOREIGN KEY (AUTHENTICATOR_ID) REFERENCES IDP_AUTHENTICATOR(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_PROVISIONING_CONFIG (
            ID INTEGER AUTO_INCREMENT,
            TENANT_ID INTEGER,
            IDP_ID INTEGER,
            PROVISIONING_CONNECTOR_TYPE VARCHAR(255) NOT NULL,
            IS_ENABLED CHAR (1) DEFAULT '0',
            IS_BLOCKING CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, PROVISIONING_CONNECTOR_TYPE),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_PROV_CONFIG_PROPERTY (
            ID INTEGER AUTO_INCREMENT,
            TENANT_ID INTEGER,
            PROVISIONING_CONFIG_ID INTEGER,
            PROPERTY_KEY VARCHAR(255) NOT NULL,
            PROPERTY_VALUE VARCHAR(2048),
            PROPERTY_BLOB_VALUE BLOB,
            PROPERTY_TYPE CHAR(32) NOT NULL,
            IS_SECRET CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, PROVISIONING_CONFIG_ID, PROPERTY_KEY),
            FOREIGN KEY (PROVISIONING_CONFIG_ID) REFERENCES IDP_PROVISIONING_CONFIG(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_PROVISIONING_ENTITY (
            ID INTEGER AUTO_INCREMENT,
            PROVISIONING_CONFIG_ID INTEGER,
            ENTITY_TYPE VARCHAR(255) NOT NULL,
            ENTITY_LOCAL_USERSTORE VARCHAR(255) NOT NULL,
            ENTITY_NAME VARCHAR(255) NOT NULL,
            ENTITY_VALUE VARCHAR(255),
            TENANT_ID INTEGER,
            PRIMARY KEY (ID),
            UNIQUE (ENTITY_TYPE, TENANT_ID, ENTITY_LOCAL_USERSTORE, ENTITY_NAME),
            UNIQUE (PROVISIONING_CONFIG_ID, ENTITY_TYPE, ENTITY_VALUE),
            FOREIGN KEY (PROVISIONING_CONFIG_ID) REFERENCES IDP_PROVISIONING_CONFIG(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_LOCAL_CLAIM (
            ID INTEGER AUTO_INCREMENT,
            TENANT_ID INTEGER,
            IDP_ID INTEGER,
            CLAIM_URI VARCHAR(255) NOT NULL,
            DEFAULT_VALUE VARCHAR(255),
	        IS_REQUESTED VARCHAR(128) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, CLAIM_URI),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)ENGINE INNODB;
-- End of IDN-APPLICATION-MGT Tables--

ALTER TABLE AM_APPLICATION_KEY_MAPPING ADD STATE VARCHAR(30) DEFAULT 'COMPLETED',;

ALTER TABLE AM_APPLICATION_KEY_MAPPING DROP PRIMARY KEY, ADD PRIMARY KEY(APPLICATION_ID,KEY_TYPE);

CREATE TABLE IF NOT EXISTS AM_APPLICATION_REGISTRATION (
    REG_ID INT AUTO_INCREMENT,
    SUBSCRIBER_ID INT,
    WF_REF VARCHAR(255) NOT NULL,
    APP_ID INT,
    TOKEN_TYPE VARCHAR(30),
    ALLOWED_DOMAINS VARCHAR(256),
    VALIDITY_PERIOD BIGINT,
    UNIQUE (SUBSCRIBER_ID,APP_ID,TOKEN_TYPE),
    FOREIGN KEY(SUBSCRIBER_ID) REFERENCES AM_SUBSCRIBER(SUBSCRIBER_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY(APP_ID) REFERENCES AM_APPLICATION(APPLICATION_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY (REG_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_API_SCOPES (
   API_ID  INTEGER NOT NULL,
   SCOPE_ID  INTEGER NOT NULL,
   FOREIGN KEY (API_ID) REFERENCES AM_API (API_ID) ON DELETE CASCADE  ON UPDATE CASCADE,
   FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_SCOPE (SCOPE_ID) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS AM_API_DEFAULT_VERSION (
            DEFAULT_VERSION_ID INT AUTO_INCREMENT, 
            API_NAME VARCHAR(256) NOT NULL ,
            API_PROVIDER VARCHAR(256) NOT NULL , 
            DEFAULT_API_VERSION VARCHAR(30) , 
            PUBLISHED_DEFAULT_API_VERSION VARCHAR(30) ,
            PRIMARY KEY (DEFAULT_VERSION_ID)
);
