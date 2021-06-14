# Desafio_gb_luiz

- Criei uma imagem no DockerHub com a Api.
    - Está na pasta "app" onde tem o Dockerfile, a Api no arquivo "api.py" e tem o script de "comentarios.sh" que criei para incluir os comentarios automaticamente para ser validado na URL http://ip_server/api/comment/list/2 e http://ip_server/api/comment/list/1

    * Criando e listando comentários por matéria
    # matéria 1
    ```
    curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"alice@example.com","comment":"first post!","content_id":1}'
    curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"alice@example.com","comment":"ok, now I am gonna say something more useful","content_id":1}'
    curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"bob@example.com","comment":"I agree","content_id":1}'
    ```
    # matéria 2
    ```
    curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"bob@example.com","comment":"I guess this is a good thing","content_id":2}'
    curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"charlie@example.com","comment":"Indeed, dear Bob, I believe so as well","content_id":2}'
    curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"eve@example.com","comment":"Nah, you both are wrong","content_id":2}'
    
    ```
    # listagem matéria 1
    ```
    curl -sv ip_server/api/comment/list/1
    ```
    # listagem matéria 2
    ```
    curl -sv ip_server/api/comment/list/2
    ```

- Com o terraform, criei os provissionamentos na AWS do ambiente para a API com o EC2 (main.tf) e dentro do EC2 (com o script "user-data.sh" é realizado o processo de:
    - instalação/start do docker
    - pull da imagem que foi criada/disponibilizada no DockerHub
    - start da imagem
    ``` 
                "sudo docker run --name desafio_gb -d -it -p 80:8000 thecalifornia16/desafio_gb"
    ```
    - execução do script "comentarios.sh" para inclusão dos comentarios 
    ```
                "sudo docker container exec desafio_gb sh /app/comentarios.sh"
    ```
- Criado no GitHub Action todo o processo automatizado com Terraform CI do deploy do Ambiente AWS (EC2, VPC, Docker/Imagem e etc...)
    - GitHub Action está configurado para quando houver alteração dentro da pasta "ec2" criado o pull request e aprovado, inicia o merge automaticamente (o processo de deploy com o Terraform CI via Workflow do Action)

    - Processos Git: 
        ```
        git checkout -b fix20
        git add .
        git commit -m "Atualizando README.md"
        git push -u origin fix20
        ```