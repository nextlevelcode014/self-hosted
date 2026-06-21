# Nextcloud AIO atrás do Tailscale (sem container) — Guia e Solução de Problemas

> Baseado na discussão [Easy setup: Container-less Tailscale as reverse proxy #6817](https://github.com/nextcloud/all-in-one/discussions/6817), criada por [Perseus333](https://github.com/Perseus333) no repositório `nextcloud/all-in-one`.

## Sobre

Este guia mostra como rodar o **Nextcloud All-in-One (AIO)** em Docker e expô-lo na internet/tailnet usando o **Tailscale instalado diretamente no host** (não dentro de um container), evitando a complexidade de containerizar o Tailscale e/ou usar um sidecar como o Caddy. É uma alternativa mais simples ao método mais antigo e referenciado anteriormente na documentação oficial.

---

## 1. Pré-requisitos: configurar a conta Tailscale

- Ter uma Tailnet já criada, com o Tailscale instalado e rodando tanto no servidor quanto no(s) cliente(s) que vão acessar o Nextcloud.
- No [painel de DNS do Tailscale](https://login.tailscale.com/admin/dns), habilitar:
  1. **Magic DNS**
  2. **HTTPS Certificates**

---

## 2. Instalar o Nextcloud AIO

1. Copie o `compose.yaml` oficial: `https://raw.githubusercontent.com/nextcloud/all-in-one/refs/heads/main/compose.yaml`
2. No servidor, crie uma pasta para o projeto (ex.: `~/docker/nextcloud/`) e salve o arquivo ali.
3. No `compose.yaml`, descomente e ajuste a seção de ambiente:

```yaml
services:
  nextcloud-aio-mastercontainer:
    environment:
      APACHE_PORT: 11000
      APACHE_IP_BINDING: 127.0.0.1
```

> ⚠️ Adicionar uma seção `dns` logo de cara **não é necessário na maioria dos casos** — isso só costuma ser preciso se aparecerem erros de validação de domínio (veja Troubleshooting).

4. Suba o container:

```bash
docker compose up -d
```

---

## 3. Servir o domínio via Tailscale

No servidor, exponha a porta interna do Apache (11000) através do Tailscale:

```bash
tailscale serve --bg http://127.0.0.1:11000
```

### Rodar como serviço systemd (recomendado)

Crie `/etc/systemd/system/tailscale-serve-nextcloud.service`:

```ini
[Unit]
Description=Serve Nextcloud backend through Tailscale
After=network.target

[Service]
ExecStart=tailscale serve http://127.0.0.1:11000
Type=simple

[Install]
WantedBy=multi-user.target
```

Habilite e confira o status:

```bash
systemctl enable --now tailscale-serve-nextcloud.service
tailscale serve status
```

---

## 4. Assistente de configuração do Nextcloud

1. No cliente (que precisa estar na mesma tailnet, com DNS apontando para `100.100.100.100`), abra no navegador o **IP Tailscale do servidor na porta 8080**, com `https://`, por exemplo: `https://100.123.145.67:8080`.
   - O IP pode ser encontrado no [painel de máquinas do Tailscale](https://login.tailscale.com/admin/machines).
2. Copie a senha gerada e faça login com ela.
3. Quando pedir o domínio, informe o domínio Tailscale da máquina (formato `nome.tailXXXXX.ts.net`), também disponível em `tailscale serve status` ou no painel de máquinas.
   - Se quiser usar um nome de tailnet customizado, troque-o **antes** de enviar o domínio no Nextcloud (pode ser alterado em "Rename Tailnet" no painel de DNS); mudar depois pode quebrar a instalação.
4. Continue o assistente: selecione os apps desejados, configure fuso horário, local de backup e clique em "Download and start containers".
5. Ao final, acesse o domínio configurado no navegador — deve aparecer a tela de login do Nextcloud.

---

## Solução de problemas (Troubleshooting)

### Diagnóstico geral
- `docker logs CONTAINER` — verificar erros nos containers.
- `docker ps` — checar portas expostas.
- `ss -tlnp` — ver quais portas estão em uso no host.
- `tailscale status` (cliente e servidor).
- `tailscale serve status` (servidor).
- `dig DOMINIO` — confirmar resolução DNS.
- `curl -v ENDEREÇO` (use `-k` se houver problemas de HTTPS).

### "DNS config is not set for this domain" ao enviar o domínio
Geralmente ocorre porque o comando `tailscale serve` ainda não foi executado **antes** de submeter o domínio no assistente. Rode primeiro:

```bash
tailscale serve --bg http://127.0.0.1:11000
```

Se o problema persistir, adicionar resolução de DNS explícita no compose pode ajudar — mas atenção: a posição da seção `dns` no YAML importa para alguns usuários (funcionou melhor entre `ports` e `environment` do que no topo do arquivo):

```yaml
dns:
  - 100.100.100.100  # Tailscale Magic DNS
  - 127.0.0.53        # DNS do host
  - 1.1.1.1            # DNS de fallback
```

### "Domain is not reachable on Port 443"
Costuma significar que a porta 443 já está em uso por outro serviço, ou que `tailscale serve` ainda não rodou. Soluções reportadas pelos usuários:

- Executar `tailscale serve --bg http://127.0.0.1:11000` antes de validar o domínio no wizard resolveu para a maioria.
- Verificar se não há **containers antigos/"fantasmas"** ocupando a porta 443 (rode `docker ps -a`, remova containers obsoletos com `docker rm`, e reinicie o compose).
- Como último recurso, alguns usuários liberaram a porta 11000 no firewall (`sudo ufw allow 11000`) em vez de pular a validação.

### Erro de SSL "packet length too long" / certificado autoassinado
Normalmente indica que algo está tentando se conectar via HTTP enquanto o outro lado espera HTTPS, ou que há um container antigo escutando na mesma porta. Passos sugeridos:

1. Rodar `curl -vk https://seu-dominio` para inspecionar a resposta.
2. Confirmar que HTTPS Certificates está habilitado no Tailscale.
3. Garantir que o `tailscale serve` foi iniciado com `http://` e que o acesso é feito via `https://`.
4. Procurar containers antigos ocupando a porta com `docker ps -a` e removê-los.

### "BAD REQUEST: You're speaking plain HTTP to an SSL-enabled server port"
Acontece ao acessar a porta 8080 via HTTP em vez de HTTPS. Acesse explicitamente com `https://IP:8080` e aceite o aviso de certificado autoassinado no navegador.

### Último recurso: pular a validação de domínio
Se nada mais funcionar, é possível desativar a validação (use com cautela, é uma solução paliativa):

```yaml
ports:
  # - 80:80
  # - 8443:8443
environment:
  APACHE_IP_BINDING: 0.0.0.0
  SKIP_DOMAIN_VALIDATION: true
```

### Collabora Online / edição de documentos (.docx, .odt) falhando
Se o Collabora apresentar erros de conexão de socket ou falhas ao abrir documentos, tente desabilitar as portas 80 e 8443 explícitas no compose (deixá-las comentadas). Isso resolveu o problema para vários usuários.

### Navegador não consegue acessar mesmo com `curl` funcionando
Verifique se o navegador não está sobrescrevendo o DNS do sistema (ex.: DNS-over-HTTPS embutido no navegador) — use o DNS padrão do sistema.

---

## Cenários com múltiplos containers/serviços na mesma máquina

O guia original cobria uma alternativa usando **TsDProxy** para rodar vários serviços Docker na mesma tailnet com domínios próprios, mas essa opção foi **removida do guia oficial** por instabilidade (o Apache do Nextcloud AIO é criado pelo mastercontainer e não aceita labels/variáveis customizadas diretamente, o que causa conflitos).

Para quem precisa rodar múltiplos serviços (Nextcloud + Immich, Emby etc.) na mesma tailnet, alguns usuários relataram sucesso com abordagens mais avançadas, entre elas:

- **TsDProxy + rede Docker compartilhada**: colocar o container `nextcloud-aio-apache` na mesma rede do TsDProxy manualmente (via `docker network connect`) e configurar um `services.yaml` apontando para ele, combinado com `SKIP_DOMAIN_VALIDATION: true`.
- **TsDProxy + Caddy como intermediário**: o TsDProxy expõe um container Caddy, que por sua vez faz proxy reverso para a porta 11000 do Nextcloud no host. Essa abordagem evita precisar pular a validação de domínio.
- Para um cenário mais robusto e nativamente multi-container, a [discussão #5439](https://github.com/nextcloud/all-in-one/discussions/5439) (que usa Tailscale containerizado + Caddy como sidecar) continua sendo a opção mais "oficial", embora mais complexa.

> Essas variações com TsDProxy não são suportadas oficialmente pelo guia e exigem acesso total ao socket do Docker, o que tem implicações de segurança a se considerar.

---

## Resumo rápido (cheat sheet)

| Etapa | Comando/Ação |
|---|---|
| Habilitar Magic DNS + HTTPS | Painel de DNS do Tailscale |
| Configurar compose | `APACHE_PORT: 11000` + `APACHE_IP_BINDING: 127.0.0.1` |
| Subir containers | `docker compose up -d` |
| Expor via Tailscale | `tailscale serve --bg http://127.0.0.1:11000` |
| Acessar wizard | `https://<tailscale-ip>:8080` |
| Domínio no wizard | `nome.tailXXXXX.ts.net` |
| Debug DNS | `dig dominio.tailXXXXX.ts.net` |
| Debug conexão | `curl -vk https://dominio` |
| Último recurso | `SKIP_DOMAIN_VALIDATION: true` + `APACHE_IP_BINDING: 0.0.0.0` |

---

## Fonte

Discussão original e comentários da comunidade: [github.com/nextcloud/all-in-one/discussions/6817](https://github.com/nextcloud/all-in-one/discussions/6817)
