-- Start of IDN Tables --
IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_BASE_TABLE]') AND TYPE IN (N'U'))
CREATE TABLE IDN_BASE_TABLE (
            PRODUCT_NAME VARCHAR(20),
            PRIMARY KEY (PRODUCT_NAME)
);

INSERT INTO IDN_BASE_TABLE values ('WSO2 Identity Server');

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_OAUTH_CONSUMER_APPS]') AND TYPE IN (N'U'))
CREATE TABLE IDN_OAUTH_CONSUMER_APPS (
            CONSUMER_KEY VARCHAR(512),
            CONSUMER_SECRET VARCHAR(512),
            USERNAME VARCHAR(255),
            TENANT_ID INTEGER DEFAULT 0,
            APP_NAME VARCHAR(255),
            OAUTH_VERSION VARCHAR(128),
            CALLBACK_URL VARCHAR(1024),
	        GRANT_TYPES VARCHAR(1024),
            PRIMARY KEY (CONSUMER_KEY)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_OAUTH1A_REQUEST_TOKEN]') AND TYPE IN (N'U'))
CREATE TABLE IDN_OAUTH1A_REQUEST_TOKEN (
            REQUEST_TOKEN VARCHAR(512),
            REQUEST_TOKEN_SECRET VARCHAR(512),
            CONSUMER_KEY VARCHAR(512),
            CALLBACK_URL VARCHAR(1024),
            SCOPE VARCHAR(2048),
            AUTHORIZED VARCHAR(128),
            OAUTH_VERIFIER VARCHAR(512),
            AUTHZ_USER VARCHAR(512),
            PRIMARY KEY (REQUEST_TOKEN),
            FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_OAUTH1A_ACCESS_TOKEN]') AND TYPE IN (N'U'))
CREATE TABLE IDN_OAUTH1A_ACCESS_TOKEN (
            ACCESS_TOKEN VARCHAR(512),
            ACCESS_TOKEN_SECRET VARCHAR(512),
            CONSUMER_KEY VARCHAR(512),
            SCOPE VARCHAR(2048),
            AUTHZ_USER VARCHAR(512),
            PRIMARY KEY (ACCESS_TOKEN),
            FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_OAUTH2_AUTHORIZATION_CODE]') AND TYPE IN (N'U'))
CREATE TABLE IDN_OAUTH2_AUTHORIZATION_CODE (
            AUTHORIZATION_CODE VARCHAR(512),
            CONSUMER_KEY VARCHAR(512),
	        CALLBACK_URL VARCHAR(1024),
            SCOPE VARCHAR(2048),
            AUTHZ_USER VARCHAR(512),
	        TIME_CREATED DATETIME,
	        VALIDITY_PERIOD BIGINT,
            PRIMARY KEY (AUTHORIZATION_CODE),
            FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_OAUTH2_ACCESS_TOKEN]') AND TYPE IN (N'U'))
CREATE TABLE IDN_OAUTH2_ACCESS_TOKEN (
			ACCESS_TOKEN VARCHAR(255),
			REFRESH_TOKEN VARCHAR(255),
			CONSUMER_KEY VARCHAR(512),
			AUTHZ_USER VARCHAR(255),
			USER_TYPE VARCHAR (25),
			TIME_CREATED DATETIME,
			VALIDITY_PERIOD BIGINT,
			TOKEN_SCOPE VARCHAR(2048),
			TOKEN_STATE VARCHAR(25) DEFAULT 'ACTIVE',
			TOKEN_STATE_ID VARCHAR (256) DEFAULT 'NONE',
			PRIMARY KEY (ACCESS_TOKEN),
            FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE,
            CONSTRAINT CON_APP_KEY UNIQUE (CONSUMER_KEY, AUTHZ_USER,USER_TYPE,TOKEN_STATE,TOKEN_STATE_ID, TOKEN_SCOPE)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_OAUTH2_SCOPE]') AND TYPE IN (N'U'))
CREATE TABLE IDN_OAUTH2_SCOPE (
  			SCOPE_ID INTEGER IDENTITY,
  			SCOPE_KEY VARCHAR(100) NOT NULL,
  			NAME VARCHAR(255) NULL,
  			DESCRIPTION VARCHAR(512) NULL,
  			TENANT_ID INTEGER NOT NULL DEFAULT 0,
			ROLES VARCHAR (500) NULL,
  			PRIMARY KEY (SCOPE_ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_OAUTH2_RESOURCE_SCOPE]') AND TYPE IN (N'U'))
CREATE TABLE IDN_OAUTH2_RESOURCE_SCOPE (
  			RESOURCE_PATH VARCHAR(255) NOT NULL,
  			SCOPE_ID INTEGER NOT NULL,
  			PRIMARY KEY (RESOURCE_PATH),
  			FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_SCOPE (SCOPE_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_SCIM_GROUP]') AND TYPE IN (N'U'))
CREATE TABLE IDN_SCIM_GROUP (
			ID INTEGER IDENTITY,
			TENANT_ID INTEGER NOT NULL,
			ROLE_NAME VARCHAR(255) NOT NULL,
            ATTR_NAME VARCHAR(1024) NOT NULL,
			ATTR_VALUE VARCHAR(1024),
            PRIMARY KEY (ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_SCIM_PROVIDER]') AND TYPE IN (N'U'))
CREATE TABLE IDN_SCIM_PROVIDER (
            CONSUMER_ID VARCHAR(255) NOT NULL,
            PROVIDER_ID VARCHAR(255) NOT NULL,
            USER_NAME VARCHAR(255) NOT NULL,
            USER_PASSWORD VARCHAR(255) NOT NULL,
            USER_URL VARCHAR(1024) NOT NULL,
	        GROUP_URL VARCHAR(1024),
	        BULK_URL VARCHAR(1024),
            PRIMARY KEY (CONSUMER_ID,PROVIDER_ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_OPENID_REMEMBER_ME]') AND TYPE IN (N'U'))
CREATE TABLE IDN_OPENID_REMEMBER_ME (
            USER_NAME VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER DEFAULT 0,
            COOKIE_VALUE VARCHAR(1024),
            CREATED_TIME DATETIME,
            PRIMARY KEY (USER_NAME, TENANT_ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_OPENID_USER_RPS]') AND TYPE IN (N'U'))
CREATE TABLE IDN_OPENID_USER_RPS (
			USER_NAME VARCHAR(255) NOT NULL,
			TENANT_ID INTEGER DEFAULT 0,
			RP_URL VARCHAR(255) NOT NULL,
			TRUSTED_ALWAYS VARCHAR(128) DEFAULT 'FALSE',
			LAST_VISIT DATE NOT NULL,
			VISIT_COUNT INTEGER DEFAULT 0,
			DEFAULT_PROFILE_NAME VARCHAR(255) DEFAULT 'DEFAULT',
			PRIMARY KEY (USER_NAME, TENANT_ID, RP_URL)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_OPENID_ASSOCIATIONS]') AND TYPE IN (N'U'))
CREATE TABLE IDN_OPENID_ASSOCIATIONS (
			HANDLE VARCHAR(255) NOT NULL,
			ASSOC_TYPE VARCHAR(255) NOT NULL,
			EXPIRE_IN DATETIME NOT NULL,
			MAC_KEY VARCHAR(255) NOT NULL,
			ASSOC_STORE VARCHAR(128) DEFAULT 'SHARED',
			PRIMARY KEY (HANDLE)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_STS_STORE]') AND TYPE IN (N'U'))
CREATE TABLE IDN_STS_STORE (
            ID INTEGER IDENTITY,
            TOKEN_ID VARCHAR(255) NOT NULL,
            TOKEN_CONTENT VARBINARY(MAX) NOT NULL,
            CREATE_DATE DATETIME NOT NULL,
            EXPIRE_DATE DATETIME NOT NULL,
            STATE INTEGER DEFAULT 0,
            PRIMARY KEY (ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_IDENTITY_USER_DATA]') AND TYPE IN (N'U'))
CREATE TABLE IDN_IDENTITY_USER_DATA (
            TENANT_ID INTEGER DEFAULT -1234,
            USER_NAME VARCHAR(255) NOT NULL,
            DATA_KEY VARCHAR(255) NOT NULL,
            DATA_VALUE VARCHAR(255) NOT NULL,
            PRIMARY KEY (TENANT_ID, USER_NAME, DATA_KEY)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_IDENTITY_META_DATA]') AND TYPE IN (N'U'))
CREATE TABLE IDN_IDENTITY_META_DATA (
            USER_NAME VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER DEFAULT -1234,
            METADATA_TYPE VARCHAR(255) NOT NULL,
            METADATA VARCHAR(255) NOT NULL,
            VALID VARCHAR(255) NOT NULL,
            PRIMARY KEY (TENANT_ID, USER_NAME, METADATA_TYPE,METADATA)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_THRIFT_SESSION]') AND TYPE IN (N'U'))
CREATE TABLE IDN_THRIFT_SESSION (
       		SESSION_ID VARCHAR(255) NOT NULL,
       		USER_NAME VARCHAR(255) NOT NULL,
       		CREATED_TIME VARCHAR(255) NOT NULL,
       		LAST_MODIFIED_TIME VARCHAR(255) NOT NULL,
       		PRIMARY KEY (SESSION_ID)
);

-- End of IDN Tables --


-- Start of IDN-APPLICATION-MGT Tables--
IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[SP_APP]') AND TYPE IN (N'U'))
CREATE TABLE SP_APP (
            ID INTEGER NOT NULL IDENTITY,
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
            PRIMARY KEY (ID));

ALTER TABLE SP_APP ADD CONSTRAINT APPLICATION_NAME_CONSTRAINT UNIQUE(APP_NAME, TENANT_ID);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[SP_INBOUND_AUTH]') AND TYPE IN (N'U'))
CREATE TABLE SP_INBOUND_AUTH (
            ID INTEGER NOT NULL IDENTITY,
	     	TENANT_ID INTEGER NOT NULL,
	     	INBOUND_AUTH_KEY VARCHAR (255) NOT NULL,
            INBOUND_AUTH_TYPE VARCHAR (255) NOT NULL, 
            PROP_NAME VARCHAR (255),
            PROP_VALUE VARCHAR (1024) ,
	     	APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID));

ALTER TABLE SP_INBOUND_AUTH ADD CONSTRAINT APPLICATION_ID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[SP_AUTH_STEP]') AND TYPE IN (N'U'))
CREATE TABLE SP_AUTH_STEP (
            ID INTEGER NOT NULL IDENTITY,
            TENANT_ID INTEGER NOT NULL,
	     	STEP_ORDER INTEGER DEFAULT 1,
            APP_ID INTEGER NOT NULL,
            IS_SUBJECT_STEP CHAR(1) DEFAULT '0',
            IS_ATTRIBUTE_STEP CHAR(1) DEFAULT '0',
            PRIMARY KEY (ID));

ALTER TABLE SP_AUTH_STEP ADD CONSTRAINT APPLICATION_ID_CONSTRAINT_STEP FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[SP_FEDERATED_IDP]') AND TYPE IN (N'U'))
CREATE TABLE SP_FEDERATED_IDP (
            ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            AUTHENTICATOR_ID INTEGER NOT NULL,
            PRIMARY KEY (ID, AUTHENTICATOR_ID));

ALTER TABLE SP_FEDERATED_IDP ADD CONSTRAINT STEP_ID_CONSTRAINT FOREIGN KEY (ID) REFERENCES SP_AUTH_STEP (ID) ON DELETE CASCADE;

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[SP_CLAIM_MAPPING]') AND TYPE IN (N'U'))
CREATE TABLE SP_CLAIM_MAPPING (
	    	ID INTEGER NOT NULL IDENTITY,
	    	TENANT_ID INTEGER NOT NULL,
	    	IDP_CLAIM VARCHAR (512) NOT NULL ,
            SP_CLAIM VARCHAR (512) NOT NULL ,
	   		APP_ID INTEGER NOT NULL,
	    	IS_REQUESTED VARCHAR(128) DEFAULT '0',
	    	DEFAULT_VALUE VARCHAR(255),
            PRIMARY KEY (ID));

ALTER TABLE SP_CLAIM_MAPPING ADD CONSTRAINT CLAIMID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[SP_ROLE_MAPPING]') AND TYPE IN (N'U'))
CREATE TABLE SP_ROLE_MAPPING (
	    	ID INTEGER NOT NULL IDENTITY,
	    	TENANT_ID INTEGER NOT NULL,
	    	IDP_ROLE VARCHAR (255) NOT NULL ,
            SP_ROLE VARCHAR (255) NOT NULL ,
	    	APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID));

ALTER TABLE SP_ROLE_MAPPING ADD CONSTRAINT ROLEID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[SP_REQ_PATH_AUTHENTICATOR]') AND TYPE IN (N'U'))
CREATE TABLE SP_REQ_PATH_AUTHENTICATOR (
	    	ID INTEGER NOT NULL IDENTITY,
	    	TENANT_ID INTEGER NOT NULL,
	    	AUTHENTICATOR_NAME VARCHAR (255) NOT NULL ,
	    	APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID));

ALTER TABLE SP_REQ_PATH_AUTHENTICATOR ADD CONSTRAINT REQ_AUTH_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[SP_PROVISIONING_CONNECTOR]') AND TYPE IN (N'U'))
CREATE TABLE SP_PROVISIONING_CONNECTOR (
	    	ID INTEGER NOT NULL IDENTITY,
	    	TENANT_ID INTEGER NOT NULL,
            IDP_NAME VARCHAR (255) NOT NULL ,
	    	CONNECTOR_NAME VARCHAR (255) NOT NULL ,
	    	APP_ID INTEGER NOT NULL,
	    	IS_JIT_ENABLED CHAR(1) NOT NULL DEFAULT '0',
		BLOCKING CHAR(1) NOT NULL DEFAULT '0',
            PRIMARY KEY (ID));

ALTER TABLE SP_PROVISIONING_CONNECTOR ADD CONSTRAINT PRO_CONNECTOR_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDP]') AND TYPE IN (N'U'))
CREATE TABLE IDP (
			ID INTEGER IDENTITY,
			TENANT_ID INTEGER,
			NAME VARCHAR(254) NOT NULL,
			IS_ENABLED CHAR(1) NOT NULL DEFAULT '1',
			IS_PRIMARY CHAR(1) NOT NULL DEFAULT '0',
			HOME_REALM_ID VARCHAR(254),
			IMAGE VARBINARY(MAX),
			CERTIFICATE VARBINARY(MAX),
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
			PRIMARY KEY (ID),
	                DISPLAY_NAME VARCHAR(254),
			UNIQUE (TENANT_ID, NAME));

INSERT INTO IDP (TENANT_ID, NAME, HOME_REALM_ID) VALUES (-1234, 'LOCAL', 'localhost');

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDP_ROLE]') AND TYPE IN (N'U'))
CREATE TABLE IDP_ROLE (
			ID INTEGER IDENTITY,
			IDP_ID INTEGER,
			TENANT_ID INTEGER,
			ROLE VARCHAR(254),
			PRIMARY KEY (ID),
			UNIQUE (IDP_ID, ROLE),
			FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDP_ROLE_MAPPING]') AND TYPE IN (N'U'))
CREATE TABLE IDP_ROLE_MAPPING (
			ID INTEGER IDENTITY,
			IDP_ROLE_ID INTEGER,
			TENANT_ID INTEGER,
			USER_STORE_ID VARCHAR (253),
			LOCAL_ROLE VARCHAR(253),	
			PRIMARY KEY (ID),
			UNIQUE (IDP_ROLE_ID, TENANT_ID, USER_STORE_ID, LOCAL_ROLE),
			FOREIGN KEY (IDP_ROLE_ID) REFERENCES IDP_ROLE(ID) ON DELETE CASCADE);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDP_CLAIM]') AND TYPE IN (N'U'))
CREATE TABLE IDP_CLAIM (
			ID INTEGER IDENTITY,
			IDP_ID INTEGER,
			TENANT_ID INTEGER,
			CLAIM VARCHAR(254),
			PRIMARY KEY (ID),
			UNIQUE (IDP_ID, CLAIM),
			FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDP_CLAIM_MAPPING]') AND TYPE IN (N'U'))
CREATE TABLE IDP_CLAIM_MAPPING (
			ID INTEGER IDENTITY,
			IDP_CLAIM_ID INTEGER,
			TENANT_ID INTEGER,			
			LOCAL_CLAIM VARCHAR(253),
			DEFAULT_VALUE VARCHAR(255),
	    	IS_REQUESTED VARCHAR(128) DEFAULT '0',	
			PRIMARY KEY (ID),
			UNIQUE (IDP_CLAIM_ID, TENANT_ID, LOCAL_CLAIM),
			FOREIGN KEY (IDP_CLAIM_ID) REFERENCES IDP_CLAIM(ID) ON DELETE CASCADE);		

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDP_AUTHENTICATOR]') AND TYPE IN (N'U'))
CREATE TABLE IDP_AUTHENTICATOR (
            ID INTEGER IDENTITY,
            TENANT_ID INTEGER,
            IDP_ID INTEGER,
            NAME VARCHAR(255) NOT NULL,
            IS_ENABLED CHAR (1) DEFAULT '1',
            DISPLAY_NAME VARCHAR(255),
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, NAME),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

INSERT INTO IDP_AUTHENTICATOR (TENANT_ID, IDP_ID, NAME) VALUES (-1234, 1, 'saml2sso');

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDP_AUTHENTICATOR_PROPERTY]') AND TYPE IN (N'U'))
CREATE TABLE IDP_AUTHENTICATOR_PROPERTY (
            ID INTEGER IDENTITY,
            TENANT_ID INTEGER,
            AUTHENTICATOR_ID INTEGER,
            PROPERTY_KEY VARCHAR(255) NOT NULL,
            PROPERTY_VALUE VARCHAR(2047),
            IS_SECRET CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, AUTHENTICATOR_ID, PROPERTY_KEY),
            FOREIGN KEY (AUTHENTICATOR_ID) REFERENCES IDP_AUTHENTICATOR(ID) ON DELETE CASCADE);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDP_PROVISIONING_CONFIG]') AND TYPE IN (N'U'))
CREATE TABLE IDP_PROVISIONING_CONFIG (
            ID INTEGER IDENTITY,
            TENANT_ID INTEGER,
            IDP_ID INTEGER,
            PROVISIONING_CONNECTOR_TYPE VARCHAR(255) NOT NULL,
            IS_ENABLED CHAR (1) DEFAULT '0',
            IS_BLOCKING CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, PROVISIONING_CONNECTOR_TYPE),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDP_PROV_CONFIG_PROPERTY]') AND TYPE IN (N'U'))
CREATE TABLE IDP_PROV_CONFIG_PROPERTY (
            ID INTEGER IDENTITY,
            TENANT_ID INTEGER,
            PROVISIONING_CONFIG_ID INTEGER,
            PROPERTY_KEY VARCHAR(255) NOT NULL,
            PROPERTY_VALUE VARCHAR(2048),
            PROPERTY_BLOB_VALUE VARBINARY(MAX),
            PROPERTY_TYPE CHAR(32) NOT NULL,
            IS_SECRET CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, PROVISIONING_CONFIG_ID, PROPERTY_KEY),
            FOREIGN KEY (PROVISIONING_CONFIG_ID) REFERENCES IDP_PROVISIONING_CONFIG(ID) ON DELETE CASCADE);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDP_PROVISIONING_ENTITY]') AND TYPE IN (N'U'))
CREATE TABLE IDP_PROVISIONING_ENTITY (
            ID INTEGER IDENTITY,
            PROVISIONING_CONFIG_ID INTEGER,
            ENTITY_TYPE VARCHAR(255) NOT NULL,
            ENTITY_LOCAL_USERSTORE VARCHAR(255) NOT NULL,
            ENTITY_NAME VARCHAR(255) NOT NULL,
            ENTITY_VALUE VARCHAR(255),
            TENANT_ID INTEGER,
            PRIMARY KEY (ID),
            UNIQUE (ENTITY_TYPE, TENANT_ID, ENTITY_LOCAL_USERSTORE, ENTITY_NAME),
            UNIQUE (PROVISIONING_CONFIG_ID, ENTITY_TYPE, ENTITY_VALUE),
            FOREIGN KEY (PROVISIONING_CONFIG_ID) REFERENCES IDP_PROVISIONING_CONFIG(ID) ON DELETE CASCADE);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDP_LOCAL_CLAIM]') AND TYPE IN (N'U'))
CREATE TABLE IDP_LOCAL_CLAIM (
            ID INTEGER IDENTITY,
            TENANT_ID INTEGER,
            IDP_ID INTEGER,
            CLAIM_URI VARCHAR(255) NOT NULL,
            DEFAULT_VALUE VARCHAR(255),
    	    IS_REQUESTED VARCHAR(128) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, CLAIM_URI),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

-- End of IDN-APPLICATION-MGT Tables--



-- Start of API-Mgt Tables --

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_SUBSCRIBER]') AND TYPE IN (N'U'))

CREATE TABLE AM_SUBSCRIBER (
    SUBSCRIBER_ID INTEGER IDENTITY(1,1),
    USER_ID VARCHAR(50) NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    EMAIL_ADDRESS VARCHAR(256) NULL,
    DATE_SUBSCRIBED DATETIME NOT NULL,
    PRIMARY KEY (SUBSCRIBER_ID),
    UNIQUE (TENANT_ID,USER_ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_APPLICATION]') AND TYPE IN (N'U'))

CREATE TABLE AM_APPLICATION (
    APPLICATION_ID INTEGER IDENTITY(1,1),
    NAME VARCHAR(100),
    SUBSCRIBER_ID INTEGER,
    APPLICATION_TIER VARCHAR(50) DEFAULT 'Unlimited',
    CALLBACK_URL VARCHAR(512),
    DESCRIPTION VARCHAR(512),
	APPLICATION_STATUS VARCHAR(50) DEFAULT 'APPROVED',
    FOREIGN KEY(SUBSCRIBER_ID) REFERENCES AM_SUBSCRIBER(SUBSCRIBER_ID) ON UPDATE CASCADE,
    PRIMARY KEY(APPLICATION_ID),
    UNIQUE (NAME,SUBSCRIBER_ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_API]') AND TYPE IN (N'U'))

CREATE TABLE AM_API (
    API_ID INTEGER IDENTITY(1,1),
    API_PROVIDER VARCHAR(200),
    API_NAME VARCHAR(200),
    API_VERSION VARCHAR(30),
    CONTEXT VARCHAR(256),
    PRIMARY KEY(API_ID),
    UNIQUE (API_PROVIDER,API_NAME,API_VERSION)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_API_URL_MAPPING]') AND TYPE IN (N'U'))

CREATE TABLE AM_API_URL_MAPPING (
    URL_MAPPING_ID INTEGER IDENTITY(1,1),
    API_ID INTEGER NOT NULL,
    HTTP_METHOD VARCHAR(20) NULL,
    AUTH_SCHEME VARCHAR(50) NULL,
    URL_PATTERN VARCHAR(512) NULL,
    THROTTLING_TIER varchar(512) DEFAULT NULL,
    MEDIATION_SCRIPT VARBINARY(MAX),
    PRIMARY KEY (URL_MAPPING_ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_SUBSCRIPTION]') AND TYPE IN (N'U'))

CREATE TABLE AM_SUBSCRIPTION (
    SUBSCRIPTION_ID INTEGER IDENTITY(1,1),
    TIER_ID VARCHAR(50),
    API_ID INTEGER,
    LAST_ACCESSED DATETIME NULL,
    APPLICATION_ID INTEGER,
    SUB_STATUS VARCHAR(50),
    FOREIGN KEY(APPLICATION_ID) REFERENCES AM_APPLICATION(APPLICATION_ID) ON UPDATE CASCADE,
    FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON UPDATE CASCADE,
    PRIMARY KEY (SUBSCRIPTION_ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_SUBSCRIPTION_KEY_MAPPING]') AND TYPE IN (N'U'))

CREATE TABLE AM_SUBSCRIPTION_KEY_MAPPING (
    SUBSCRIPTION_ID INTEGER,
    ACCESS_TOKEN VARCHAR(255),
    KEY_TYPE VARCHAR(512) NOT NULL,
    FOREIGN KEY(SUBSCRIPTION_ID) REFERENCES AM_SUBSCRIPTION(SUBSCRIPTION_ID) ON UPDATE CASCADE,
    PRIMARY KEY(SUBSCRIPTION_ID,ACCESS_TOKEN)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_APPLICATION_KEY_MAPPING]') AND TYPE IN (N'U'))

CREATE TABLE AM_APPLICATION_KEY_MAPPING (
    APPLICATION_ID INTEGER,
    CONSUMER_KEY VARCHAR(512),
    KEY_TYPE VARCHAR(512) NOT NULL,
    STATE VARCHAR(30) NOT NULL,
    FOREIGN KEY(APPLICATION_ID) REFERENCES AM_APPLICATION(APPLICATION_ID) ON UPDATE CASCADE,
    PRIMARY KEY(APPLICATION_ID,KEY_TYPE)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_APPLICATION_REGISTRATION]') AND TYPE IN (N'U'))

CREATE TABLE AM_APPLICATION_REGISTRATION (
    REG_ID INTEGER IDENTITY(1,1),
    SUBSCRIBER_ID INTEGER,
    WF_REF VARCHAR(255) NOT NULL,
    APP_ID INTEGER,
    TOKEN_TYPE VARCHAR(30),
    ALLOWED_DOMAINS VARCHAR(256),
    VALIDITY_PERIOD BIGINT,
    UNIQUE (SUBSCRIBER_ID,APP_ID,TOKEN_TYPE),
    FOREIGN KEY(SUBSCRIBER_ID) REFERENCES AM_SUBSCRIBER(SUBSCRIBER_ID) ON DELETE NO ACTION,
    FOREIGN KEY(APP_ID) REFERENCES AM_APPLICATION(APPLICATION_ID) ON UPDATE CASCADE ON DELETE NO ACTION,
    PRIMARY KEY (REG_ID)
);


IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_API_LC_EVENT]') AND TYPE IN (N'U'))

CREATE TABLE AM_API_LC_EVENT (
    EVENT_ID INTEGER IDENTITY(1,1),
    API_ID INTEGER NOT NULL,
    PREVIOUS_STATE VARCHAR(50),
    NEW_STATE VARCHAR(50) NOT NULL,
    USER_ID VARCHAR(50) NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    EVENT_DATE DATETIME NOT NULL,
    FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON UPDATE CASCADE,
    PRIMARY KEY (EVENT_ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_APP_KEY_DOMAIN_MAPPING]') AND TYPE IN (N'U'))

CREATE TABLE AM_APP_KEY_DOMAIN_MAPPING (
   CONSUMER_KEY VARCHAR(512),
   AUTHZ_DOMAIN VARCHAR(255) DEFAULT 'ALL',
   PRIMARY KEY (CONSUMER_KEY,AUTHZ_DOMAIN),
   FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_API_COMMENTS]') AND TYPE IN (N'U'))

CREATE TABLE AM_API_COMMENTS (
    COMMENT_ID INTEGER IDENTITY(1,1),
    COMMENT_TEXT VARCHAR(512),
    COMMENTED_USER VARCHAR(255),
    DATE_COMMENTED DATETIME NOT NULL,
    API_ID INTEGER NOT NULL,
    FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON UPDATE CASCADE,
    PRIMARY KEY (COMMENT_ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_API_RATINGS]') AND TYPE IN (N'U'))

CREATE TABLE AM_API_RATINGS (
    RATING_ID INTEGER IDENTITY(1,1),
    API_ID INTEGER,
    RATING INTEGER,
    SUBSCRIBER_ID INTEGER,
    FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON UPDATE CASCADE,
    FOREIGN KEY(SUBSCRIBER_ID) REFERENCES AM_SUBSCRIBER(SUBSCRIBER_ID) ON UPDATE CASCADE,
    PRIMARY KEY (RATING_ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_TIER_PERMISSIONS]') AND TYPE IN (N'U'))

CREATE TABLE AM_TIER_PERMISSIONS (
    TIER_PERMISSIONS_ID INTEGER IDENTITY(1,1),
    TIER VARCHAR(50) NOT NULL,
    PERMISSIONS_TYPE VARCHAR(50) NOT NULL,
    ROLES VARCHAR(512) NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    PRIMARY KEY(TIER_PERMISSIONS_ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_EXTERNAL_STORES]') AND TYPE IN (N'U'))

CREATE TABLE AM_EXTERNAL_STORES (
    APISTORE_ID INTEGER IDENTITY(1,1),
    API_ID INTEGER,
    STORE_ID VARCHAR(255) NOT NULL,
    STORE_DISPLAY_NAME VARCHAR(255) NOT NULL,
    STORE_ENDPOINT VARCHAR(255) NOT NULL,
    STORE_TYPE VARCHAR(255) NOT NULL,
    FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON UPDATE CASCADE,
    PRIMARY KEY (API_ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_WORKFLOWS]') AND TYPE IN (N'U'))

CREATE TABLE AM_WORKFLOWS(
    WF_ID INTEGER IDENTITY(1,1),
    WF_REFERENCE VARCHAR(255) NOT NULL,
    WF_TYPE VARCHAR(255) NOT NULL,
    WF_STATUS VARCHAR(255) NOT NULL,
    WF_CREATED_TIME DATETIME,
    WF_UPDATED_TIME DATETIME,
    WF_STATUS_DESC VARCHAR(1000),
    TENANT_ID INTEGER,
    TENANT_DOMAIN VARCHAR(255),
    WF_EXTERNAL_REFERENCE VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (WF_ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_API_SCOPES]') AND TYPE IN (N'U'))

CREATE TABLE AM_API_SCOPES (
   API_ID  INTEGER NOT NULL,
   SCOPE_ID  INTEGER NOT NULL,
   FOREIGN KEY (API_ID) REFERENCES AM_API (API_ID) ON DELETE CASCADE ON UPDATE CASCADE,
   FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_SCOPE (SCOPE_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_API_DEFAULT_VERSION]') AND TYPE IN (N'U'))

CREATE TABLE AM_API_DEFAULT_VERSION (
            DEFAULT_VERSION_ID INTEGER NOT NULL IDENTITY, 
            API_NAME VARCHAR(256) NOT NULL ,
            API_PROVIDER VARCHAR(256) NOT NULL , 
            DEFAULT_API_VERSION VARCHAR(30) , 
            PUBLISHED_DEFAULT_API_VERSION VARCHAR(30) ,
            PRIMARY KEY (DEFAULT_VERSION_ID)
);


CREATE INDEX IDX_SUB_APP_ID ON AM_SUBSCRIPTION (APPLICATION_ID, SUBSCRIPTION_ID);
