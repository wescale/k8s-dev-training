FROM liquibase/liquibase:4.15.0

ADD changelog /liquibase/db/changelog
ADD scripts /liquibase/scripts

USER root

RUN chmod -R +x /liquibase/scripts

USER liquibase

ENTRYPOINT ["/bin/bash"]

CMD ["/liquibase/scripts/start.sh"]

