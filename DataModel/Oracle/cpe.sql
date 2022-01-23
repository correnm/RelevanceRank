DROP table RESEARCH.cpe;

CREATE TABLE RESEARCH.CPE
(
CPE_ID 					VARCHAR2(200 CHAR),
PART					VARCHAR2(1 CHAR),
vendor					varchar2(200 char),
product					varchar2(200 char),
edition					varchar2(200 char),
language				varchar2(200 char),
official				varchar2(5 char),
other					varchar2(200 char),
product_update			varchar2(200 char),
sw_edition				varchar2(200 char),
target_hw				varchar2(200 char),
target_sw				varchar2(200 char),
title		 			varchar2(200 char),
version					varchar2(200 char)
);
