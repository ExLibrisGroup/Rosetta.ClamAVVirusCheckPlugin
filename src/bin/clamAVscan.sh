#!/bin/sh

CLAMSCAN=clamscan
SCANOPTS="--stdout --no-summary"

STATUS=255
CONTENT="ERROR"
AGENT="REG_SA_VC_CLAMAV"

TARGET=$1

EchoAndExit()
{
	echo STATUS=${STATUS}
	echo CONTENT=${CONTENT}
	echo AGENT=${AGENT}
	exit ${STATUS}
}

# Check is file exist

if [ ! -f ${TARGET} ] 
then
   CONTENT="File not found"
   EchoAndExit
fi


# Check file size is less than 2GB

file_size=`ls -Ll ${TARGET} | awk '{print $5}'`
file_size_tb=`echo "$file_size / 1024 / 1024 / 2048" | bc`
if [ $file_size_tb -ne 0 ]
then
    STATUS=0
	CONTENT="Virus Check is limited to a 2GB file size and thus has been ignored"
	AGENT="REG_SA_DPS"
    EchoAndExit
fi

# Scan file

CONTENT=`${CLAMSCAN} ${SCANOPTS} ${TARGET}`
STATUS=$?
EchoAndExit
