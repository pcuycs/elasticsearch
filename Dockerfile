version: '2.2'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.6.0
    container_name: elasticsearch
    environment:
      - http.host=0.0.0.0
      - transport.host=127.0.0.1
      - node.name=elasticsearch
      - cluster.name=es-docker-cluster
      - cluster.initial_master_nodes=elasticsearch
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    volumes:
      - data01:/usr/share/elasticsearch/data
    ports:
      - 9200:9200
    #Healthcheck to confirm availability of ES. Other containers wait on this.
    healthcheck:
      test: ["CMD", "curl","-s" ,"-f", "-u", "elastic:${ES_PASSWORD}", "http://localhost:9200/_cat/health"]
    networks: ['stack']
    
  # kibana:
    # container_name: kibana
    # hostname: kibana
    # image: "docker.elastic.co/kibana/kibana:7.6.0"
    # volumes:
      # - .\config\kibana\kibana.yml:/usr/share/kibana/kibana.yml
    # #port 5601 accessible on the host
    # ports: ['5601:5601']
    # networks: ['stack']
    # #we don't start kibana until the es instance is ready
    # depends_on: ['elasticsearch']
    # environment:
      # - "elasticsearch_password=${es_password}"
    # healthcheck:
      # test: ["cmd", "curl", "-s", "-f", "http://localhost:5601/login"]
      # retries: 6 

volumes:
  data01:
    driver: local

networks: {stack: {}}