# Como ler os diagramas da infraestrutura

Esta pasta documenta a infraestrutura self-hosted em **camadas**: um diagrama
geral (visão de "helicóptero") e vários diagramas de fluxo, cada um focado em
**um único serviço ou jornada do usuário**. Isso existe porque a infra é
grande demais para caber de forma legível em um diagrama só — tentar mostrar
tudo de uma vez vira um "prato de espaguete" impossível de seguir.

## Estrutura dos arquivos

```
docs/
├── LEIA-ME.md                              este arquivo
├── diagrama-visao-geral.puml               mapa de todos os serviços
├── diagrama-fluxo-filme-serie.puml         jornada: pedir → baixar → assistir
├── diagrama-fluxo-adguard.puml             DNS / bloqueio de anúncios
├── diagrama-fluxo-immich.puml              fotos e vídeos
├── diagrama-fluxo-nextcloud.puml           nuvem, Talk e edição de documentos
├── diagrama-fluxo-rustdesk.puml            acesso remoto
├── diagrama-fluxo-searxng.puml             meta-buscador privado
├── diagrama-fluxo-vaultwarden.puml         gerenciador de senhas
├── diagrama-fluxo-wikijs.puml              wiki interna
└── images/
    ├── diagrama-visao-geral.png
    ├── diagrama-fluxo-filme-serie.png
    ├── diagrama-fluxo-adguard.png
    ├── diagrama-fluxo-immich.png
    ├── diagrama-fluxo-nextcloud.png
    ├── diagrama-fluxo-rustdesk.png
    ├── diagrama-fluxo-searxng.png
    └── diagrama-fluxo-vaultwarden.png
```

**Quando usar cada um:**

- Quer entender **o que existe** e como as peças se encaixam? → `diagrama-visao-geral.puml`
- Quer entender **como um serviço específico funciona passo a passo**, do
  clique do usuário até a resposta? → o `.puml` correspondente

> Observação: o antigo `diagrama-fluxo-independentes.puml` (que juntava os 7
> serviços independentes em um único arquivo) foi descontinuado e substituído
> pelos arquivos individuais acima — mesmo motivo: um fluxo por diagrama.

## Os dois tipos de diagrama usados

### 1. Visão geral — diagrama de componentes (`diagrama-visao-geral.puml`)

Mostra **o quê** existe e **quem se conecta com quem**, sem se importar com a
ordem temporal.

| Elemento | O que significa |
|---|---|
| `actor` (bonequinho) | Uma pessoa: o usuário |
| `cloud` | Algo externo, fora do seu controle (a Internet) |
| `node` | Um serviço/container rodando na sua infra |
| `database` | Um banco de dados |
| `package` (retângulo grande) | Um agrupamento lógico (ex: "Arr Stack") |
| Seta `A --> B : "texto"` | A se conecta com/depende de B, com o motivo escrito |

As cores dos pacotes seguem a legenda no rodapé do próprio diagrama (laranja
= infra compartilhada, roxo = Arr Stack, verde = serviços independentes,
azul claro = sidecar Tailscale).

### 2. Fluxos — diagrama de sequência

Mostra **a ordem em que as coisas acontecem**, de cima para baixo, como uma
linha do tempo. É o tipo certo para responder "o que acontece quando eu
clico em X?".

| Elemento | O que significa |
|---|---|
| Coluna vertical (`participant`/`actor`) | Um "ator" da história: usuário, serviço, banco, etc. As colunas ficam na ordem em que aparecem no fluxo, da esquerda (quem inicia) para a direita |
| Seta sólida `->` | Uma chamada/requisição indo de um participante a outro |
| Seta tracejada `-->` | Uma resposta voltando |
| `group Passo N: ...` | Agrupa as setas de uma etapa lógica do fluxo, numeradas na ordem em que acontecem |
| `note right` | Um comentário explicando um detalhe técnico importante daquele trecho |
| `box "Nome" #cor` (só no fluxo de filme/série) | Agrupa participantes por camada (ex: "Download", "Streaming") só para organizar visualmente |

**Como ler na prática:** comece no topo, siga as setas de cima para baixo,
uma por uma. Cada `group` é uma etapa; leia o texto da seta para saber *o
que* está sendo pedido ou enviado. As `note` explicam o "porquê" por trás de
uma decisão técnica (ex: por que o Nextcloud não usa sidecar Tailscale).

## Como visualizar os arquivos `.puml`

Estes são arquivos de **texto-fonte** do PlantUML — não são imagens. Para
renderizar:

- **VS Code**: instale a extensão "PlantUML" (jebbs.plantuml) e abra o
  arquivo com `Alt+D` para pré-visualizar.
- **Online**: cole o conteúdo em [plantuml.com/plantuml](https://www.plantuml.com/plantuml/uml/).
- **Linha de comando**: `plantuml diagrama-visao-geral.puml` (requer Java +
  o `plantuml.jar`) gera um `.png` ao lado do arquivo.

## Nota sobre o SearXNG

O SearXNG segue **dois padrões ao mesmo tempo**, cada um documentado onde faz
mais sentido:

- **Exposição**: como o Nextcloud, não usa sidecar Tailscale — é exposto via
  `tailscale serve` direto no host, na porta 9000.
- **Saída de rede**: usa o **proxy HTTP** do Gluetun (`:8888`), então toda
  consulta sai pelo túnel WireGuard da ProtonVPN (diferente do qBittorrent,
  que compartilha a rede do Gluetun via `network_mode: container:gluetun`).

Isso está refletido tanto no `diagrama-visao-geral.puml` quanto no
`diagrama-fluxo-searxng.puml`.
