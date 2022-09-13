#!/bin/bash
[ -z "${TAG_NAME}" ] && exit 1
[ ! -z "${CREDENTIALS_FILE}" ] && source ${CREDENTIALS_FILE}
liquibase --url="jdbc:postgresql://${ip}:5432/postgres" --username="${username}" --password="${password}" --classpath=/liquibase/db/changelog --changeLogFile=changelog.yaml rollback ${TAG_NAME}
