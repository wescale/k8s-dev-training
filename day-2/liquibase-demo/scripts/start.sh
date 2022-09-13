#!/bin/bash
[ ! -z "${CREDENTIALS_FILE}" ] && source ${CREDENTIALS_FILE}
liquibase --url="jdbc:postgresql://${ip}:5432/postgres" --username="${username}" --password="${password}" --classpath=/liquibase/db/changelog --changeLogFile=changelog.yaml update
